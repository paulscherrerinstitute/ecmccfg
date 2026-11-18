"""Hardware runner boundary checks; no EPICS imports, connections or physical I/O."""
from contextlib import redirect_stdout, redirect_stderr
import copy
import io
import json
import re
from pathlib import Path
import sys
import tempfile
from threading import Event
from types import SimpleNamespace
import unittest
from unittest.mock import patch
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT/'tests/integration'))
from slit_hardware import run
from slit_hardware.rig import Rig, validate_profile
from slit_hardware.cases import GROUPS, make_suite


class Clock:
    now = 0.
    def monotonic(self): return self.now
    def sleep(self, duration): self.now += duration


class HardwareBoundary:
    """Controlled CA boundary to exercise the actual hardware runner methods."""
    def __init__(self, clock):
        self.clock, self.values, self.writes, self.pending = clock, {}, [], []
        self.put_options = []
        self.timeout = 1
        self.pvt_active = None
        self.home_active = None
        self.home_power_model = False
        self.concurrent = {}
        self.values['HW:m0s005-BO05-RB'] = 0
        self.brake_phases = {}
        self.closed, self.active, self.fault_on_move = False, None, False
        self.native_settings = {a: {'MonAtTargetTol': .01, 'MonEnableAtTargetMon': 1,
            'MonEnableStallMon': 1, 'MonStallMinTimeOut': 15000, 'MonStallTimeFactor': 10, 'EncConfigIndex': 2, 'EncPwrSource': 0 if a == 'TR_LO' else 2, 'EncPwrBackup': 0 if a == 'TR_LO' else 1, 'EncMode': 0, 'HomeSeqId': 1, 'HomePosition': 0,
            'HomeVelTowardsCam': .2, 'HomeVelOffCam': .1, 'HomeAcc': 1, 'HomeDec': 1,
            'HomePostMoveEnable': 0, 'HomePostMoveTargetPosition': 0}
            for a in ('TR_LO', 'TR_HI')}
        self.stalled_pending = {}
        self.completed_at = 0
        self.interrupt_on_move, self.stall = False, False
        for axis, number in run.json.loads(run.DEFAULT_PROFILE.read_text())['axes'].items():
            fields = {'.DIR': 0, '.OFF': 0, '.SPMG': 3, '.DMOV': 1, '.MOVN': 0,
                      '.VELO': .4, '.VMAX': 5, '.SET': 0, '.FOFF': 1, '.SYNC': 0, '-Homed': 0, '.SEVR': 0, '.LVIO': 0, '-Busy': 0,
                      '-HomProc.OMSL': 1, '-HomProc': 1, '-HomPos': 0, '-VelToHom': .2, '-VelFrmHom': .1,
                      '-AccHom': 1, '-HomUseHVEL': 0, '-MtnCmd_.DISA': 0, '-MtnCmd_.DISV': 1, '-SeqState': 0, '.MSTA': 0, '.MIP': 0, '.PACT': 0, '.STAT': 0, '-BusyLocal': 0, '-InStartup': 0, '-EnaCmd-RB': 0, '-LimBwd': 1, '-LimFwd': 1, '-ErrId': 0,
                      '-WrnId': 0, '-VelAct': 0, '-AtTarget': 1, '-Id': number, '-EnaAct': 0,
                      '.LLM': -10, '.HLM': 10, '-CfgDLLM-RB': -10, '-CfgDHLM-RB': 10,
                      '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1, '-EncMode-RB': 0,
                      '-Enc02-ForceOn-RB': 0, '-EncCnt': 2 if axis == 'TR_HI' else 1,
                      '-SetEncIdCmd-RB': 2 if axis == 'TR_HI' else 1,
                      '-Enc02-PwrState': 3, '-Enc02-PwrEnable-RB': 1, '-Enc02-Ready': 1,
                      '-Enc02-PwrOn': 1, '-Enc02-Absolute': 1, '-Enc01-Absolute': 0, '-Enc01-Ready': 1,
                      '-Enc01-Homed': 0, '-Enc02-Homed': 0, '.DLLM': -10, '.DHLM': 10, '.DVAL': 0, '.ACCS': 1,
                      '-CfgSyncSftLim': 0, '-TrjSrcTyp-RB': 0, '-AutoExecuteOnTargetPos-RB': 0, '-ExeCmd-RB': 0,
                      '-MtnCmd': 3, '-MtnCmdData': 0, '-TgtVelCmd': 1, '-TgtPosCmd': 0,
                      '-PVT-UseAxis': 0, '-PVT-Positions': [], '-PVT-Readbacks': []}
            for field, value in fields.items(): self.values['HW:'+axis+field] = value
        self.values.update({'HW:MCU-Cfg-Sim-Mode': 0, 'HW:MCU-AppMode': 1,
                            'HW:m0-Stat-OK': 1, 'HW:MCU-ErrId': 0, 'HW:HardwareSlitTest:Schema': 1, 'HW:HardwareSlitTest:HomingSchema': 1,
                            'HW:m0s009-Enc01-PosAct.ESLO': 1, 'HW:m0s009-Enc01-PosAct.EOFF': 0,
                            'HW:SM00-EnaCmd': 1, 'HW:SM00-StateCmd': 0, 'HW:MCU-Cmd.TMOD': 0, 'HW:MCU-Cmd.IFMT': 0,
                            'HW:MCU-Cmd.OFMT': 0, 'HW:MCU-Cmd.SEVR': 0, 'HW:MCU-Cmd.AINP': 'OK'})
        self.values.update({'HW:PVT-'+key: value for key, value in {
            'NumPoints': 64, 'NumPulses': 0, 'StartPulses': 1, 'EndPulses': 64,
            'TimeMode': 0, 'FixedTime': 1., 'Acceleration': .5, 'MoveMode': 0, 'MaxSize': 64,
            'BuildStatus': 0, 'BuildState': 0, 'Build.SEVR': 0, 'ExecuteStatus': 0,
            'ExecuteState': 0, 'Execute.SEVR': 0, 'ReadbackState': 0, 'ReadbackStatus': 0,
            'CurrentPoint': 0, 'Times': [], 'SftTrg': 0}.items()})
        self.positions = {'TR_LO': -.15, 'TR_HI': .15}
        self.mechanical_positions = dict(self.positions)
        self.update_coordinates()
        for axis in ('TR_LO', 'TR_HI', 'CENTERY', 'GAPY'):
            self.values['HW:'+axis+'.VAL'] = self.values['HW:'+axis+'-PosAct']

    def update_coordinates(self):
        low, high = self.positions['TR_LO'], self.positions['TR_HI']
        for axis, pos in dict(self.positions, CENTERY=(low+high)/2, GAPY=high-low).items():
            for field in ('-PosAct', '-PosSet', '-Enc01-PosAct', '-Enc02-PosAct'):
                self.values['HW:'+axis+field] = pos
            sign = -1 if self.values['HW:'+axis+'.DIR'] else 1
            self.values['HW:'+axis+'.RBV'] = self.values['HW:'+axis+'.OFF']+sign*pos

    def update(self):
        self.values['HW:m0s009-Enc01-PosAct'] = 5652480+self.mechanical_positions['TR_HI']*4096
        if self.home_active is not None:
            self.update_home()
            return
        for blade, (start, destination, began) in list(self.concurrent.items()):
            fraction = min(1., (self.clock.now-began)/.5)
            old = self.positions[blade]
            self.positions[blade] = start+(destination-start)*fraction
            self.mechanical_positions[blade] += self.positions[blade]-old
            if fraction >= 1:
                for f,v in (('-Busy',0),('-VelAct',0),('.DMOV',1),('.MOVN',0)): self.values['HW:'+blade+f] = v
                del self.concurrent[blade]
            self.update_coordinates()
        if self.pvt_active:
            axis, points, started = self.pvt_active
            fraction = min(len(points)-1, max(0., (self.clock.now-started)*2.5))
            index = min(int(fraction), len(points)-2)
            blend = fraction-index
            before = self.positions[axis]
            self.positions[axis] = points[index]*(1-blend)+points[index+1]*blend
            self.mechanical_positions[axis] += self.positions[axis]-before
            self.update_coordinates()
            self.values['HW:PVT-CurrentPoint'] = int(fraction)
            count = int(self.values['HW:PVT-NumPulses'])
            if count:
                self.values['HW:PVT-SftTrg'] = sum(fraction >= i for i in (2, 3, 4))
                pulse = self.values['HW:PVT-SftTrg']
                self.values['HW:m0s005-BO05-RB'] = int(pulse > 0 and fraction < pulse+1.4)
            if self.fault_on_move: self.values['HW:'+axis+'-ErrId'] = 123
            if fraction >= len(points)-1:
                self.pvt_active = None
                self.stop()
                self.values['HW:m0s005-BO05-RB'] = 0
                self.values['HW:PVT-ExecuteState'] = 0
                self.values['HW:PVT-ExecuteStatus'] = 1
                self.completed_at = self.clock.now
            return
        if self.active:
            axis, target, end = self.active
            if self.fault_on_move: self.values['HW:TR_HI-ErrId'] = 123
            start = max(self.active_started, self.brake_phases.get(axis, (0, -1))[1])
            fraction = 0 if self.stall else max(0, min(1, (self.clock.now-start)/(end-start)))
            self.values['HW:'+axis+'-VelAct'] = .1 if fraction > 0 else 0
            previous = dict(self.positions)
            moving = (axis,) if axis in self.positions else tuple(self.positions)
            for a in moving:
                self.positions[a] = self.initial_positions[a]+(self.destination[a]-self.initial_positions[a])*fraction
            for blade in self.positions:
                self.mechanical_positions[blade] += self.positions[blade]-previous[blade]
            self.update_coordinates()
            if fraction >= 1:
                unsettled = axis in self.native_settings and self.native_settings[axis]['MonAtTargetTol'] < 1e-6
                pending = list(self.pending)
                self.stop()
                self.completed_at = self.clock.now
                if unsettled:
                    for event in pending: event.clear()
                    self.stalled_pending[axis] = pending
                    self.values['HW:'+axis+'-AtTarget'] = 0
                    self.values['HW:'+axis+'.DMOV'] = 0
                    self.values['HW:'+axis+'.MIP'] = 1
        elif self.home_power_model and self.values['HW:TR_HI-Enc02-ForceOn-RB']:
            self.values['HW:TR_HI-Enc02-PwrState'] = 3
            self.values['HW:TR_HI-Enc02-Ready'] = 1
            self.values['HW:TR_HI-Enc02-PwrOn'] = 1
            self.values['HW:TR_HI-SetEncIdCmd-RB'] = 2
        elif self.clock.now-self.completed_at > 2:
            self.values['HW:TR_HI-Enc02-PwrState'] = 1
            self.values['HW:TR_HI-SetEncIdCmd-RB'] = 1
            self.values['HW:TR_HI-Enc02-Ready'] = 0
            self.values['HW:TR_HI-Enc02-PwrOn'] = 0
            self.values['HW:TR_HI-Enc01-Homed'] = self.values['HW:TR_HI-Enc02-Homed']

    def begin_home(self, axis, notify):
        cfg = self.native_settings[axis]
        edge = -40. if cfg['HomeSeqId'] == 1 else 40.
        self.home_active = (axis, self.clock.now, self.mechanical_positions[axis], edge)
        for f,v in (('-Busy',1),('-BusyLocal',1),('-Homed',0),('-SeqState',1),('.DMOV',0),('.MOVN',1),('.MIP',1)):
            self.values['HW:'+axis+f] = v
        if notify:
            event = Event(); self.pending.append(event); return event
        return None

    def update_home(self):
        axis, began, initial, edge = self.home_active
        cfg = self.native_settings[axis]
        elapsed = self.clock.now-began
        old = self.mechanical_positions[axis]
        if elapsed < .5:
            actual = initial+(edge-initial)*elapsed/.5
            self.positions[axis] += actual-old
        elif elapsed < .8:
            actual = edge
            self.positions[axis] += actual-old
            self.values['HW:'+axis+('-LimBwd' if edge < 0 else '-LimFwd')] = 0
        else:
            self.values['HW:'+axis+'-LimBwd'] = 1
            self.values['HW:'+axis+'-LimFwd'] = 1
            release = edge+(.01 if edge < 0 else -.01)
            self.values['HW:'+axis+'-Homed'] = 1
            if cfg['HomePostMoveEnable']:
                fraction = min(1., (elapsed-.8)/.8)
                self.positions[axis] = cfg['HomePosition']+(cfg['HomePostMoveTargetPosition']-cfg['HomePosition'])*fraction
                actual = release+self.positions[axis]-cfg['HomePosition']
                self.values['HW:'+axis+'-SeqState'] = 235
            else:
                actual = release
                self.positions[axis] = cfg['HomePosition']
            if not cfg['HomePostMoveEnable'] or elapsed >= 1.6:
                self.home_active = None
                self.stop()
                self.values['HW:'+axis+'-SeqState'] = 0
        self.mechanical_positions[axis] = actual
        self.values['HW:m0s009-Enc01-PosAct'] = 5652480+actual*4096
        self.values['HW:'+axis+'-VelAct'] = .1 if self.home_active else 0
        self.update_coordinates()

    def update_stall(self):
        for axis, events in list(self.stalled_pending.items()):
            cfg = self.native_settings[axis]
            if cfg['MonEnableStallMon'] and self.clock.now-self.completed_at > cfg['MonStallMinTimeOut']/1000:
                self.values['HW:'+axis+'-ErrId'] = 0x14c19
                if self.values['HW:SM00-EnaCmd'] == 1:
                    for master in ('CENTERY', 'GAPY'):
                        self.values['HW:'+master+'-ErrId'] = 0x1432b
                self.values['HW:'+axis+'-EnaAct'] = 0
                self.values['HW:'+axis+'-EnaCmd-RB'] = 0
                self.values['HW:'+axis+'.MSTA'] = 1 << 9
                self.values['HW:'+axis+'.SEVR'] = 2
                self.values['HW:'+axis+'.DMOV'] = 1
                self.values['HW:'+axis+'.MIP'] = 0
                for event in events: event.set()
                del self.stalled_pending[axis]

    def enable_brake(self, axis, enabled):
        if axis not in self.positions: return
        self.brake_phases[axis] = (enabled, self.clock.now+(.25 if enabled else .2))
        if enabled: self.completed_at = self.clock.now

    def update_brakes(self):
        for axis, channel, slave in (('TR_LO', '01', '014'), ('TR_HI', '02', '012')):
            if (not self.active and not self.pvt_active and self.clock.now-self.completed_at > 2
                    and self.values['HW:'+axis+'-EnaAct']):
                self.values['HW:'+axis+'-EnaAct'] = 0
                self.values['HW:'+axis+'-EnaCmd-RB'] = 0
                self.enable_brake(axis, 0)
            enabled, transition = self.brake_phases.get(axis, (0, -1))
            self.values['HW:m0s005-BO'+channel+'-RB'] = int(enabled and self.clock.now >= transition)
            self.values['HW:m0s'+slave+'-Drv01-Cmd-RB'] = int(enabled or self.clock.now < transition)

    def stop(self):
        self.home_active = None
        self.concurrent.clear()
        if self.pvt_active is not None:
            self.pvt_active = None
            self.values['HW:PVT-ExecuteState'] = 0
            self.values['HW:PVT-ExecuteStatus'] = 3
            self.values['HW:m0s005-BO05-RB'] = 0
        for axis in ('TR_LO', 'TR_HI', 'CENTERY', 'GAPY'):
            for field, value in (('-Busy', 0), ('-BusyLocal', 0), ('.MIP', 0), ('.PACT', 0), ('.DMOV', 1), ('.MOVN', 0), ('-VelAct', 0), ('-ExeCmd-RB', 0)):
                self.values['HW:'+axis+field] = value
        for event in self.pending: event.set()
        self.pending = []
        self.active = None

    def request_stop(self, axis):
        coordinated = (self.active is not None and self.active[0] in ('CENTERY', 'GAPY')
                       and axis in ('TR_LO', 'TR_HI'))
        self.stop()
        if coordinated:
            # Physical STOP removes external trajectory ownership. The global
            # readback may publish before either master's axis error record.
            self.values['HW:MCU-ErrId'] = 0x14331
            for master in ('CENTERY', 'GAPY'):
                self.values['HW:'+master+'-ErrId'] = 0x14331

    def get(self, name):
        if name.endswith('.MRES'): return 10/32768
        if re.fullmatch(r'HW:TR_(LO|HI)-Enc0[12]-PosAct', name):
            return self.positions[name[3:8]]
        self.update()
        self.update_brakes()
        self.update_stall()
        return self.values[name]

    def pv(self, name):
        return SimpleNamespace(get=lambda **kwargs: self.values[name])

    def put(self, name, value, **kwargs):
        self.writes.append((name, value))
        self.put_options.append((name, dict(kwargs)))
        if name.endswith('.VAL') and kwargs.get('notify', True) and self.pending and self.active is not None and name == 'HW:'+self.active[0]+'.VAL':
            raise RuntimeError('second put-notify would queue behind active motor processing')
        self.values[name] = value
        if name.endswith('-TrjSrcTyp-Cmd'):
            self.values[name.replace('-Cmd', '-RB')] = value
            return None
        if name == 'HW:SM00-StateCmd':
            self.values[name] = 0
            return None
        if name == 'HW:SM00-EnaCmd':
            self.values['HW:SM00-StateCmd'] = 0
            return None
        if name.startswith('HW:PVT-') or '-PVT-' in name:
            if name.endswith('-PVT-Positions') or name in ('HW:PVT-Times', 'HW:PVT-NumPoints', 'HW:PVT-FixedTime'):
                self.values['HW:PVT-BuildStatus'] = 0
            if name == 'HW:PVT-Build':
                self.values['HW:PVT-BuildStatus'] = 1
                self.values['HW:PVT-BuildState'] = 0
            elif name == 'HW:PVT-Execute':
                self.values['HW:PVT-SftTrg'] = 0
                selected = [a for a in self.positions if self.values['HW:'+a+'-PVT-UseAxis']]
                assert len(selected) == 1
                axis = selected[0]
                self.pvt_active = (axis, list(self.values['HW:'+axis+'-PVT-Positions']), self.clock.now)
                self.values['HW:PVT-ExecuteState'] = 2
                self.values['HW:PVT-ExecuteStatus'] = 0
                for field, state in (('-Busy', 1), ('-BusyLocal', 1), ('.DMOV', 0), ('.MOVN', 1), ('-EnaAct', 1)):
                    self.values['HW:'+axis+field] = state
            elif name == 'HW:PVT-Readback':
                for axis in self.positions:
                    self.values['HW:'+axis+'-PVT-Readbacks'] = list(self.values['HW:'+axis+'-PVT-Positions'])[2:5] if self.values['HW:PVT-NumPulses'] else list(self.values['HW:'+axis+'-PVT-Positions'])
                self.values['HW:PVT-ReadbackState'] = 0
                self.values['HW:PVT-ReadbackStatus'] = 1
            elif name == 'HW:PVT-Abort':
                self.pvt_active = None
                self.stop()
                self.values['HW:m0s005-BO05-RB'] = 0
                self.values['HW:PVT-ExecuteState'] = 0
                self.values['HW:PVT-ExecuteStatus'] = 3
            return None
        if name == 'HW:MCU-ErrRst':
            for a in ('TR_LO', 'TR_HI', 'CENTERY', 'GAPY'):
                for f in ('-ErrId', '.MSTA', '.SEVR'): self.values['HW:'+a+f] = 0
            self.values['HW:MCU-ErrId'] = 0
            return None
        if name == 'HW:MCU-Cmd.AOUT':
            match = re.fullmatch(r'Cfg.SetAxisAutoExec\((\d+),(\d+)\)', value)
            if match:
                axis = 'TR_LO' if int(match[1]) == 5 else 'TR_HI'
                self.values['HW:'+axis+'-AutoExecuteOnTargetPos-RB'] = int(match[2])
                reply = 'OK'
            elif value.startswith('GetAxisAutoExec'):
                axis = 'TR_LO' if '(5)' in value else 'TR_HI'
                reply = str(self.values['HW:'+axis+'-AutoExecuteOnTargetPos-RB'])
            elif value.startswith('GetAxisEnableAutoEnable'): reply = '1'
            elif value.startswith('Cfg.SelectAxisEncConfig'):
                number, index = map(int, re.findall(r'\d+', value))
                self.native_settings['TR_LO' if number == 5 else 'TR_HI']['EncConfigIndex'] = index
                reply = 'OK'
            else:
                configured = re.fullmatch(r'Cfg.SetAxis([A-Za-z]+)\((\d+),([-+.0-9eE]+)\)', value)
                queried = re.fullmatch(r'GetAxis([A-Za-z]+)\((\d+)\)', value)
                if configured:
                    key, number, v = configured.groups()
                    if key == 'HomePostMvPos': key = 'HomePostMoveTargetPosition'
                    if key.startswith('Home'): self.home_power_model = True
                    a = 'TR_LO' if int(number) == 5 else 'TR_HI'
                    self.native_settings[a][key] = float(v)
                    if key == 'MonAtTargetTol': self.values['HW:'+a+'-AtTarget'] = int(float(v) >= 1e-6)
                    if key == 'MonAtTargetTol' and float(v) <= 0 and a == 'TR_HI':
                        self.values['HW:TR_HI-ErrId'] = 0x1441e
                        for master in ('CENTERY', 'GAPY'): self.values['HW:'+master+'-ErrId'] = 0x1432b
                    reply = 'OK'
                elif queried:
                    key, number = queried.groups()
                    a = 'TR_LO' if int(number) == 5 else 'TR_HI'
                    if key == 'EncScaleNum': reply = '1'
                    elif key == 'EncScaleDenom': reply = '12800' if a == 'TR_LO' else '4096'
                    else: reply = str(self.native_settings[a][key])
                else: raise AssertionError('unsupported text command: '+value)
            self.values['HW:MCU-Cmd.AINP'] = reply
            return None
        for suffix in ('-EnaCmd', '-ExeCmd', '-StpCmd', '-MtnCmd', '-MtnCmdData', '-TgtVelCmd', '-TgtPosCmd'):
            if name.endswith(suffix):
                axis = name[3:-len(suffix)]
                if suffix == '-EnaCmd':
                    if value == 0 and self.pvt_active is not None and self.pvt_active[0] == axis:
                        self.stop()
                        self.values['HW:MCU-ErrId'] = 0x242003
                    self.enable_brake(axis, value)
                    self.values['HW:'+axis+'-EnaAct'] = value
                    self.values['HW:'+axis+'-EnaCmd-RB'] = value
                    if value:
                        for name in self.positions: self.values['HW:'+name+'-TrjSrcTyp-RB'] = 0
                if suffix == '-StpCmd':
                    self.request_stop(axis)
                    return None
                if suffix == '-ExeCmd': self.values['HW:'+axis+'-ExeCmd-RB'] = value
                if ((suffix == '-ExeCmd' and value == 1) or
                    (suffix == '-TgtPosCmd' and self.values['HW:'+axis+'-AutoExecuteOnTargetPos-RB'])):
                    if self.values['HW:'+axis+'-MtnCmd'] == 10:
                        return self.begin_home(axis, False)
                    target = self.values['HW:'+axis+'-TgtPosCmd']
                    if self.values['HW:'+axis+'-MtnCmd'] == 2: target += self.positions[axis]
                    return self.begin_move(axis, target, notify=False)
                return None
        if name.endswith(('.DIR', '.OFF', '.FOFF', '-CfgSyncSftLim')):
            if name.endswith('.FOFF') and value == 'Frozen': self.values[name] = 1
            if name.endswith(('.DIR', '.OFF')):
                axis = name[3:-4]
                sign = -1 if self.values['HW:'+axis+'.DIR'] else 1
                off = self.values['HW:'+axis+'.OFF']
                limits = [off+sign*self.values['HW:'+axis+f] for f in ('.DLLM', '.DHLM')]
                self.values['HW:'+axis+'.LLM'], self.values['HW:'+axis+'.HLM'] = min(limits), max(limits)
                self.update_coordinates()
            return None
        if name.endswith('-Enc02-ForceOn'):
            self.values[name+'-RB'] = value
            return None
        for field, key in (('-HomProc', 'HomeSeqId'), ('-HomPos', 'HomePosition'), ('-VelToHom', 'HomeVelTowardsCam'), ('-VelFrmHom', 'HomeVelOffCam'), ('-AccHom', 'HomeAcc')):
            if name.endswith(field):
                a = name[3:-len(field)]
                self.native_settings[a][key] = value
                return None
        if name.endswith(('.HOMF', '.HOMR')):
            return self.begin_home(name[3:-5], kwargs.get('notify', True))
        if name.endswith('-SetEncPosCmd'):
            axis = name[3:-len('-SetEncPosCmd')]
            assert axis in ('TR_LO', 'TR_HI')
            assert self.values['HW:'+axis+'-EnaAct'] == 0
            self.positions[axis] = value  # reference only; mechanics do not move
            self.update_coordinates()
            self.values['HW:'+axis+'-Homed'] = 1
            self.values['HW:'+axis+('-Enc02-Homed' if axis == 'TR_HI' else '-Enc01-Homed')] = 1
            return None
        if name.endswith('.SYNC'):
            axis = name[3:-5]
            self.values['HW:'+axis+'.VAL'] = self.values['HW:'+axis+'.RBV']
            self.values['HW:'+axis+'.DVAL'] = self.values['HW:'+axis+'-PosAct']
            self.values[name] = 0
            return None
        if name.endswith('.STOP'):
            self.request_stop(name[3:-5])
            return None
        if not name.endswith('.VAL'): return None
        axis = name[3:-4]
        sign = -1 if self.values['HW:'+axis+'.DIR'] else 1
        target = sign*(value-self.values['HW:'+axis+'.OFF'])
        self.values['HW:'+axis+'.DVAL'] = target
        return self.begin_move(axis, target, **kwargs)

    def begin_move(self, axis, value, **kwargs):
        if self.active is not None and axis in self.positions and self.active[0] in self.positions and axis != self.active[0]:
            self.concurrent[axis] = (self.positions[axis], value, self.clock.now)
            self.values['HW:'+axis+'-Busy'] = 1
            self.values['HW:'+axis+'.DMOV'] = 0
            self.values['HW:'+axis+'.MOVN'] = 1
            self.values['HW:'+axis+'-VelAct'] = .1
            return None
        if not self.values['HW:'+axis+'-EnaAct']: self.enable_brake(axis, 1)
        self.initial_positions = dict(self.positions)
        self.destination = dict(self.positions)
        low, high = self.positions['TR_LO'], self.positions['TR_HI']
        if axis in self.positions: self.destination[axis] = value
        elif axis == 'CENTERY':
            self.destination.update(TR_LO=value-(high-low)/2, TR_HI=value+(high-low)/2)
        else:
            self.destination.update(TR_LO=(low+high)/2-value/2, TR_HI=(low+high)/2+value/2)
        if axis in ('CENTERY', 'GAPY'):
            for a in self.positions:
                for f, v in (('-EnaAct', 1), ('-TrjSrcTyp-RB', 1), ('-VelAct', .1), ('-Busy', 1), ('.DMOV', 0)):
                    self.values['HW:'+a+f] = v
        self.active_started = self.clock.now
        duration = 3. if self.values['HW:'+axis+'.VELO'] < .3 and axis in self.positions else .5
        self.active = (axis, value, self.clock.now+duration)
        for field, state in (('-Busy', 1), ('-BusyLocal', 1), ('.DMOV', 0), ('.MOVN', 1), ('-EnaAct', 1), ('-VelAct', .1)):
            self.values['HW:'+axis+field] = state
        self.values['HW:'+axis+'-VelAct'] = 0
        self.values['HW:TR_HI-Enc02-PwrState'] = 3
        self.values['HW:TR_HI-Enc02-Ready'] = 1
        self.values['HW:TR_HI-Enc02-PwrOn'] = 1
        self.values['HW:TR_HI-SetEncIdCmd-RB'] = 2
        if self.interrupt_on_move: raise KeyboardInterrupt
        if not kwargs.get('notify', True): return None
        event = Event()
        self.pending.append(event)
        return event

    def close(self): self.closed = True


class HardwareRunnerTests(unittest.TestCase):
    def setUp(self):
        self.profile = json.loads(run.DEFAULT_PROFILE.read_text())
        self.profile['encoder_power']['axis'] = 'TR_HI'
        self.clock = Clock()
        self.client = HardwareBoundary(self.clock)
        self.rig = Rig(self.profile, 'HW:', self.client)

    def test_lo_encoder_assignment_checks_counts_and_routes_power_tests(self):
        self.profile['encoder_power']['axis'] = 'TR_LO'
        self.client.values['HW:TR_LO-EncCnt'] = 2
        self.client.values['HW:TR_HI-EncCnt'] = 1
        self.rig.guard()
        snapshot = self.rig.snapshot()
        self.assertIn('encoder_diagnostics', snapshot['TR_LO'])
        self.assertIn('-Enc02-PwrState', snapshot['TR_LO'])
        self.assertNotIn('-Enc02-PwrState', snapshot['TR_HI'])
        for test in make_suite(self.rig, ['encoder_power']):
            self.assertEqual(test.motion_axes, ('TR_LO',))

    def test_lo_encoder_assignment_blocks_hi_homing_before_writes(self):
        from slit_hardware.homing import check_homing_support
        self.profile['encoder_power']['axis'] = 'TR_LO'
        with self.assertRaisesRegex(ValueError, 'currently assigned to TR_LO'):
            check_homing_support(self.rig)
        self.assertEqual(self.client.writes, [])

    def test_stationary_hold_preserves_each_failure_condition_and_records_evidence(self):
        for field, value, reason in (('-Busy', 1, 'Busy'), ('-VelAct', .006, 'velocity'),
                                     ('-PosAct', .016, 'position drift')):
            with self.subTest(field=field):
                values = {'-Busy': 0, '-VelAct': 0, '-PosAct': 0}
                values[field] = value
                with patch.object(self.rig, 'get', side_effect=lambda axis, key: values[key]), \
                     patch.object(self.rig, 'wait', side_effect=lambda predicate, *args: predicate()):
                    with self.assertRaisesRegex(AssertionError, reason):
                        self.rig.holds_position('TR_HI', 0, context='post-STOP hold')
                entry = self.rig.trace[-1]
                self.assertEqual(entry['action'], 'stationary hold failed')
                self.assertEqual(entry['context'], 'post-STOP hold')
                self.assertEqual(entry['readbacks'][field], value)
        self.assertEqual(self.client.writes, [])

    def test_post_stop_velocity_tail_settles_without_changing_reference(self):
        values = {'-Busy': 0, '.DMOV': 1, '.MOVN': 0, '-PosAct': .04640625, '-VelAct': .015625}
        def wait(predicate, description, timeout):
            self.assertEqual(timeout, 1)
            self.assertFalse(predicate())
            values['-VelAct'] = 0
            self.assertTrue(predicate())
        with patch.object(self.rig, 'get', side_effect=lambda axis, key: values[key]), \
             patch.object(self.rig, 'wait', side_effect=wait):
            self.rig.settle_after_stop('TR_HI', .04640625)
        self.assertEqual(self.client.writes, [])

    def test_post_stop_settling_rejects_restart_flags_and_position_drift(self):
        for field, value in (('-Busy', 1), ('.DMOV', 0), ('.MOVN', 1), ('-PosAct', .02)):
            with self.subTest(field=field):
                values = {'-Busy': 0, '.DMOV': 1, '.MOVN': 0, '-PosAct': 0, '-VelAct': .015625}
                values[field] = value
                with patch.object(self.rig, 'get', side_effect=lambda axis, key: values[key]), \
                     patch.object(self.rig, 'wait', side_effect=lambda predicate, *args: predicate()):
                    with self.assertRaisesRegex(AssertionError, 'restarted or position drifted'):
                        self.rig.settle_after_stop('TR_HI', 0)
        self.assertEqual(self.client.writes, [])

    def test_post_stop_persistent_velocity_still_times_out(self):
        values = {'-Busy': 0, '.DMOV': 1, '.MOVN': 0, '-PosAct': 0, '-VelAct': .015625}
        def wait(predicate, description, timeout):
            self.assertEqual(timeout, 1)
            for _ in range(3): self.assertFalse(predicate())
            raise AssertionError('timeout: '+description)
        with patch.object(self.rig, 'get', side_effect=lambda axis, key: values[key]), \
             patch.object(self.rig, 'wait', side_effect=wait):
            with self.assertRaisesRegex(AssertionError, 'timeout:'):
                self.rig.settle_after_stop('TR_HI', 0)
        self.assertEqual(self.rig.trace[-1]['readbacks']['-VelAct'], .015625)
        self.assertEqual(self.client.writes, [])

    def test_plan_never_imports_epics_or_connects(self):
        with patch.object(run, 'Client', side_effect=AssertionError('connection attempted')):
            with redirect_stdout(io.StringIO()):
                self.assertEqual(run.main([]), 0)
        self.assertEqual(make_suite(None, GROUPS).countTestCases(), 107)
        self.assertEqual(make_suite(None, GROUPS, ('motor_stop',)).countTestCases(), 2)

    def test_bad_identity_modes_and_statuses_never_write(self):
        for field, value in (('MCU-Cfg-Sim-Mode', 1), ('HardwareSlitTest:Schema', 7),
                             ('TR_HI-Id', 5), ('TR_LO.OFF', .1), ('TR_LO.DIR', 1),
                             ('TR_LO.SPMG', 1), ('TR_LO-Busy', 1), ('TR_HI-EncCnt', 1),
                             ('TR_LO-ErrId', 123), ('TR_HI-LimFwd', 0), ('m0-Stat-OK', 0)):
            with self.subTest(field=field):
                client = HardwareBoundary(self.clock)
                client.values['HW:'+field] = value
                rig = Rig(self.profile, 'HW:', client)
                with self.assertRaises((RuntimeError, AssertionError)): rig.guard()
                self.assertEqual(rig.cleanup(), [])
                self.assertEqual(client.writes, [])

    def test_targets_and_virtual_projection_are_checked_before_writes(self):
        # Exercise a deliberately tighter custom envelope independently of IOC limits.
        self.profile["physical"] = {axis: [-.5, .5] for axis in self.profile["physical"]}
        self.rig.guard()
        for axis, target in (('TR_LO', .6), ('TR_HI', -2), ('CENTERY', .6), ('GAPY', 1.4)):
            with self.subTest(axis=axis):
                with self.assertRaises((RuntimeError, AssertionError)):
                    self.rig.start(axis, target)
                self.assertEqual(self.client.writes, [])
        self.client.values['HW:TR_LO-CfgDLLM-En-RB'] = 0
        with self.assertRaises(RuntimeError): self.rig.start('TR_LO', -.1)
        self.assertEqual(self.client.writes, [])

    def test_profile_rejects_invalid_motion_settings(self):
        for key, value in (('step', .01), ('step', float('nan')), ('velocity', 0), ('timeout', -1)):
            bad = copy.deepcopy(self.profile)
            bad[key] = value
            with self.assertRaises(ValueError): validate_profile(bad)

    def run_live_boundary(self, extra=()):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        report = Path(temporary.name)/'hardware.json'
        profile_path = Path(temporary.name)/'profile.json'
        profile_path.write_text(json.dumps(self.profile))
        with patch.dict(sys.modules, {'epics': SimpleNamespace(PV=object())}), \
                patch.object(run, 'Client', return_value=self.client), \
                patch('slit_hardware.rig.time.monotonic', self.clock.monotonic), \
                patch('slit_hardware.rig.time.sleep', self.clock.sleep), \
                redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            code = run.main(['--prefix', 'HW:', '--run', '--report', str(report),
                             '--profile', str(profile_path), *extra])
        return code, json.loads(report.read_text()), ET.parse(report.with_suffix('.xml')).getroot()

    def test_all_cases_reference_zero_restore_velocities_and_use_expected_fields(self):
        code, report, xml = self.run_live_boundary()
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 93)
        self.assertTrue(all(t['status'] == 'passed' for t in report['tests']), report)
        self.assertEqual(xml.attrib['errors'], '0')
        self.assertTrue(self.client.closed)
        self.assertAlmostEqual(self.client.positions['TR_LO'], 0)
        self.assertAlmostEqual(self.client.positions['TR_HI'], 0)
        for axis in self.profile['axes']:
            self.assertEqual(self.client.values['HW:'+axis+'.VELO'], .4)
        self.assertTrue(self.client.writes)
        self.assertTrue(all(n.endswith(('.VAL', '.VELO', '.STOP', '-SetEncPosCmd', '.DIR', '.OFF', '.FOFF',
                                       '.SYNC', '-Enc02-ForceOn', '-CfgSyncSftLim', '-EnaCmd', '-ExeCmd',
                                       '-MtnCmd', '-MtnCmdData', '-TgtVelCmd', '-TgtPosCmd', '-TrjSrcTyp-Cmd', '-StpCmd', 'SM00-EnaCmd', 'SM00-StateCmd'))
                            or n == 'HW:MCU-ErrRst' or n.startswith(('HW:MCU-Cmd.', 'HW:PVT-')) or '-PVT-' in n
                            for n, _ in self.client.writes))
        self.assertAlmostEqual(self.client.mechanical_positions['TR_LO'], -.15)
        self.assertAlmostEqual(self.client.mechanical_positions['TR_HI'], .15)
        self.assertEqual(report['origins'], {a: 0 for a in self.profile['axes']})
        for axis in self.profile['physical']:
            self.assertEqual(self.client.values['HW:'+axis+'.SET'], 0)
            self.assertEqual(self.client.values['HW:'+axis+'.FOFF'], 1)
            self.assertEqual(self.client.values['HW:'+axis+'-Enc01-Homed'], 1)

    def test_dmov_lifecycle_rejects_a_stuck_done_flag_while_busy(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if name.endswith('.DMOV'):
                axis = name[3:-len('.DMOV')]
                if self.client.values.get('HW:'+axis+'-Busy') == 1:
                    return 1
            return value
        self.client.get = get
        code, report, _ = self.run_live_boundary(('--case', 'dmov'))
        self.assertEqual(code, 1)
        self.assertIn('DMOV=0', json.dumps(report['tests'][0]))

    def test_no_sm_cases_disable_management_for_every_motion_and_restore_sources(self):
        for axis in self.profile['physical']:
            self.client.values['HW:'+axis+'-TrjSrcTyp-RB'] = 1
        original_move = self.client.begin_move
        def begin(*args, **kwargs):
            self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 0)
            for axis in self.profile['physical']:
                self.assertEqual(self.client.values['HW:'+axis+'-TrjSrcTyp-RB'], 0)
            return original_move(*args, **kwargs)
        original_put = self.client.put
        def put(name, value, **kwargs):
            if name == 'HW:PVT-Execute':
                self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 0)
            return original_put(name, value, **kwargs)
        with patch.object(self.client, 'begin_move', begin), patch.object(self.client, 'put', put):
            code, report, _ = self.run_live_boundary(('--case', 'no_sm'))
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 39)
        self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 1)
        for axis in self.profile['physical']:
            self.assertEqual(self.client.values['HW:'+axis+'-TrjSrcTyp-RB'], 1)
            self.assertEqual(self.client.values['HW:'+axis+'-EnaAct'], 0)
        self.assertEqual(len([x for x in report['trace'] if x.get('action') == 'disable state machine']), 39)

    def test_no_sm_fault_restores_state_machine_without_return_move(self):
        self.client.fault_on_move = True
        code, report, _ = self.run_live_boundary(('--case', 'no_sm'))
        self.assertEqual(code, 1)
        self.assertEqual(len(report['tests']), 1)
        self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 1)
        self.assertIsNone(self.client.active)
        self.assertEqual(len([n for n, _ in self.client.writes if n.endswith('.VAL')]), 1)

    def test_no_sm_restoration_failure_is_retried_by_runner_cleanup(self):
        original = self.client.put
        failed = []
        def put(name, value, **kwargs):
            if name == 'HW:SM00-EnaCmd' and value == 1 and not failed:
                failed.append(True)
                raise RuntimeError('temporary enable restore failure')
            return original(name, value, **kwargs)
        with patch.object(self.client, 'put', put):
            code, report, _ = self.run_live_boundary(('--case', 'no_sm', '--test', 'physical_lo'))
        self.assertEqual(code, 1)
        self.assertIn('temporary enable restore failure', report['tests'][0]['detail'])
        self.assertEqual(report['cleanup_errors'], [])
        self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 1)

    def test_no_sm_detects_unexpected_state_machine_enable(self):
        original = self.client.begin_move
        def begin(*args, **kwargs):
            event = original(*args, **kwargs)
            self.client.values['HW:SM00-EnaCmd'] = 1
            return event
        with patch.object(self.client, 'begin_move', begin):
            code, report, _ = self.run_live_boundary(('--case', 'no_sm', '--test', 'physical_lo'))
        self.assertEqual(code, 1)
        self.assertIn('must remain disabled', report['tests'][0]['detail'])
        self.assertIsNone(self.client.active)
        self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 1)

    def test_no_sm_interrupt_stops_and_restores_management(self):
        self.client.interrupt_on_move = True
        code, report, _ = self.run_live_boundary(('--case', 'no_sm', '--test', 'physical_lo'))
        self.assertEqual(code, 130, report)
        self.assertIsNone(self.client.active)
        self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 1)
        self.assertEqual(report['cleanup_errors'], [])

    def test_no_sm_pvt_support_is_checked_before_any_writes(self):
        del self.client.values['HW:PVT-MaxSize']
        code, report, _ = self.run_live_boundary(('--case', 'no_sm', '--test', 'pvt'))
        self.assertEqual(code, 1)
        self.assertIn('PVT preflight failed', report['error'])
        self.assertEqual(self.client.writes, [])

    def test_brake_outputs_are_observed_and_never_written_directly(self):
        code, report, _ = self.run_live_boundary(('--case', 'brake'))
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 6)
        actions = [t.get('action') for t in report['trace']]
        self.assertEqual(actions.count('brake opening phase'), 2)
        self.assertEqual(actions.count('brake closing phase'), 2)
        self.assertEqual(actions.count('brake applied after move'), 2)
        self.assertEqual(actions.count('brake applied after STOP'), 2)
        self.assertFalse(any('m0s005-BO' in n or '-Drv01-' in n for n, _ in self.client.writes))

    def test_stuck_closed_brake_fails_release_and_stops(self):
        original = self.client.get
        def get(name):
            value = original(name)
            return 0 if name == 'HW:m0s005-BO01-RB' else value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'brake', '--test', 'lo_release'))
        self.assertEqual(code, 1)
        self.assertIn('brake released', report['tests'][0]['detail'])
        self.assertIsNone(self.client.active)

    def test_brake_application_during_motion_fails(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if (name == 'HW:m0s005-BO01-RB' and self.client.active
                    and self.clock.now > self.client.active[2]-.15): return 0
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'brake', '--test', 'lo_motion'))
        self.assertEqual(code, 1)
        self.assertIn('brake applied during movement', report['tests'][0]['detail'])
        self.assertIsNone(self.client.active)

    def test_missing_brake_readback_prevents_setup_writes(self):
        original = self.client.get
        def get(name):
            if name == 'HW:m0s005-BO01-RB': raise RuntimeError('brake readback unavailable')
            return original(name)
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'no_sm', '--test', 'brake'))
        self.assertEqual(code, 1)
        self.assertIn('brake readback unavailable', report['error'])
        self.assertEqual(self.client.writes, [])

    def test_pvt_triggers_count_and_latched_samples_in_both_management_modes(self):
        code, report, _ = self.run_live_boundary(('--case', 'pvt', '--case', 'no_sm', '--test', 'triggers'))
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 4)
        profiles = [x for x in report['trace'] if x.get('action') == 'PVT completed']
        self.assertEqual(len(profiles), 4)
        for trace in profiles:
            self.assertEqual(trace['trigger_counts'], [0, 1, 2, 3])
            self.assertEqual(trace['verdict']['pulses'], 3)
            self.assertEqual(trace['readbacks'], trace['geometry']['positions'][2:5])
            self.assertEqual([e['level'] for e in trace['output_edges']], [1, 0, 1, 0, 1, 0])
        self.assertEqual(self.client.values['HW:PVT-NumPulses'], 0)
        self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 1)

    def test_pvt_extra_trigger_aborts_and_restores_configuration(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if name == 'HW:PVT-SftTrg' and value > 0: return 4
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_triggers'))
        self.assertEqual(code, 1)
        self.assertIn('unexpected software trigger count', report['tests'][0]['detail'])
        self.assertIn(('HW:PVT-Abort', 1), self.client.writes)
        self.assertEqual(self.client.values['HW:PVT-NumPulses'], 0)

    def test_pvt_missing_trigger_is_detected(self):
        original = self.client.get
        def get(name):
            value = original(name)
            return min(value, 2) if name == 'HW:PVT-SftTrg' else value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_triggers'))
        self.assertEqual(code, 1)
        self.assertIn('matches requested pulses', report['tests'][0]['detail'])
        self.assertIn(('HW:PVT-Abort', 1), self.client.writes)

    def test_pvt_wrong_trigger_sample_is_detected(self):
        original = self.client.pv
        def pv(name):
            if name.endswith('-PVT-Readbacks'):
                return SimpleNamespace(get=lambda **kwargs: [0, 0, 0])
            return original(name)
        with patch.object(self.client, 'pv', pv):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_triggers'))
        self.assertEqual(code, 1)
        self.assertIn('PVT trigger sample', report['tests'][0]['detail'])

    def test_pvt_unlinked_output_fails_even_when_software_triggers_pass(self):
        original = self.client.get
        def get(name):
            value = original(name)
            return 0 if name == 'HW:m0s005-BO05-RB' else value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_triggers'))
        self.assertEqual(code, 1)
        self.assertIn('expected three output pulses', report['tests'][0]['detail'])
        self.assertIn(('HW:PVT-Abort', 1), self.client.writes)

    def test_pvt_abort_lowers_output_after_a_pulse(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if name == 'HW:PVT-SftTrg' and value > 0: return 4
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'no_sm', '--test', 'lo_triggers'))
        self.assertEqual(code, 1)
        self.assertEqual(self.client.values['HW:m0s005-BO05-RB'], 0)
        self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 1)
        self.assertFalse(any('BO05' in n for n, _ in self.client.writes))

    def test_untriggered_pvt_rejects_an_unexpected_output_pulse(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if name == 'HW:m0s005-BO05-RB' and self.client.pvt_active: return 1
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_round_trip'))
        self.assertEqual(code, 1)
        self.assertIn('output pulsed with triggers disabled', report['tests'][0]['detail'])
        self.assertIn(('HW:PVT-Abort', 1), self.client.writes)

    def test_high_pvt_output_prevents_setup_writes(self):
        original = self.client.get
        def get(name):
            value = original(name)
            return 1 if name == 'HW:m0s005-BO05-RB' else value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'pvt'))
        self.assertEqual(code, 1)
        self.assertIn('output must be low', report['error'])
        self.assertEqual(self.client.writes, [])

    def test_all_live_pvt_interruption_paths_recover_in_both_sm_modes(self):
        code, report, _ = self.run_live_boundary(('--case', 'pvt', '--case', 'no_sm', '--test', 'before_first_pulse', '--test', 'pulse_high'))
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 24)
        stopped = [x for x in report['trace'] if x.get('action') == 'PVT interrupted']
        recovered = [x for x in report['trace'] if x.get('action') == 'PVT interruption recovery completed']
        self.assertEqual(len(stopped), 24)
        self.assertEqual(len(recovered), 24)
        for item in stopped:
            self.assertEqual(item['request']['output'], int(item['phase'] == 'pulse_high'))
            self.assertNotEqual(item['status'], 1)
        self.assertEqual(self.client.values['HW:MCU-ErrId'], 0)
        self.assertEqual(self.client.values['HW:SM00-EnaCmd'], 1)
        for axis in self.profile['physical']: self.assertAlmostEqual(self.client.positions[axis], 0)

    def test_pvt_motor_stop_must_work_without_fallback_abort(self):
        original = self.client.put
        def put(name, value, **kwargs):
            if name.endswith('.STOP') and self.client.pvt_active is not None: return None
            return original(name, value, **kwargs)
        with patch.object(self.client, 'put', put):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_stop_pulse_high'))
        self.assertEqual(code, 1)
        self.assertRegex(report['tests'][0]['detail'], 'exceeded allowed travel|incorrectly reported as successful|reaches standstill')
        self.assertIn(('HW:PVT-Abort', 1), self.client.writes)  # Failure cleanup only.
        self.assertFalse(any(t.get('action') == 'PVT interruption recovery completed' for t in report['trace']))

    def test_pvt_replay_after_reenable_is_detected(self):
        original = self.client.put
        cancelled = []
        def put(name, value, **kwargs):
            was_active = self.client.pvt_active is not None
            result = original(name, value, **kwargs)
            if name == 'HW:PVT-Abort' and was_active: cancelled.append(True)
            if name == 'HW:TR_LO-EnaCmd' and value == 1 and cancelled:
                self.client.positions['TR_LO'] += .1
                self.client.update_coordinates()
            return result
        with patch.object(self.client, 'put', put):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_abort_pulse_high'))
        self.assertEqual(code, 1)
        self.assertIn('moved after standstill', report['tests'][0]['detail'])

    def test_managed_physical_move_rejects_uncommanded_blade_motion(self):
        original = self.client.begin_move
        def begin(axis, target, **kwargs):
            result = original(axis, target, **kwargs)
            self.client.concurrent['TR_HI'] = (self.client.positions['TR_HI'], self.client.positions['TR_HI']+.1, self.clock.now)
            return result
        with patch.object(self.client, 'begin_move', begin):
            code, report, _ = self.run_live_boundary(('--case', 'motion', '--test', 'lo_both'))
        self.assertEqual(code, 1)
        self.assertIn('uncommanded physical axis moved', report['tests'][0]['detail'])
        self.assertIsNone(self.client.active)

    def test_center_move_rejects_wrong_blade_split_even_with_correct_center(self):
        original = self.client.begin_move
        def begin(axis, target, **kwargs):
            result = original(axis, target, **kwargs)
            self.client.destination['TR_LO'] += .1
            self.client.destination['TR_HI'] -= .1
            return result
        with patch.object(self.client, 'begin_move', begin):
            code, report, _ = self.run_live_boundary(('--case', 'virtual', '--test', 'center_both'))
        self.assertEqual(code, 1)
        self.assertIn('center move changed the uncommanded gap', report['tests'][0]['detail'])

    def test_pvt_rejects_uncommanded_blade_motion(self):
        original = self.client.update
        def update():
            original()
            if self.client.pvt_active is not None:
                self.client.positions['TR_HI'] += .02
                self.client.update_coordinates()
        with patch.object(self.client, 'update', update):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_round_trip'))
        self.assertEqual(code, 1)
        self.assertIn('uncommanded physical axis moved', report['tests'][0]['detail'])
        self.assertIn(('HW:PVT-Abort', 1), self.client.writes)

    def test_simulation_rig_runs_the_shared_live_interruption_matrix(self):
        from slit.rig import Rig as SimulationRig
        from slit_pvt import run_interrupted_profile
        for axis in ('TR_LO', 'TR_HI'):
            for method in ('abort', 'stop', 'disable'):
                for phase in ('before_first_pulse', 'pulse_high'):
                    with self.subTest(axis=axis, method=method, phase=phase):
                        clock = Clock()
                        client = HardwareBoundary(clock)
                        profile = copy.deepcopy(self.profile)
                        profile['physical'] = {'TR_LO': {'drive_slave': 14}, 'TR_HI': {'drive_slave': 12}}
                        rig = SimulationRig(profile, 'HW:', client, SimpleNamespace(check=lambda: None))
                        def validate(name, value): self.assertLess(abs(value), .7)
                        with patch('slit.rig.time.monotonic', clock.monotonic), patch('slit.rig.time.sleep', clock.sleep):
                            run_interrupted_profile(rig, axis, .15, .2, validate, method, phase)
                        self.assertTrue(any(t.get('action') == 'PVT interruption recovery completed' for t in rig.trace))
                        self.assertEqual(client.values['HW:m0s005-BO05-RB'], 0)
                        self.assertIsNone(rig.motion_expectation)

    def test_simulation_motor_move_rejects_peer_drift(self):
        from slit.rig import Rig as SimulationRig
        profile = copy.deepcopy(self.profile)
        profile['physical'] = {'TR_LO': {'drive_slave': 14}, 'TR_HI': {'drive_slave': 12}}
        rig = SimulationRig(profile, 'HW:', self.client, SimpleNamespace(check=lambda: None))
        original = self.client.begin_move
        def begin(axis, target, **kwargs):
            result = original(axis, target, **kwargs)
            self.client.concurrent['TR_HI'] = (self.client.positions['TR_HI'], self.client.positions['TR_HI']+.1, self.clock.now)
            return result
        with patch.object(self.client, 'begin_move', begin), \
                patch('slit.rig.time.monotonic', self.clock.monotonic), patch('slit.rig.time.sleep', self.clock.sleep):
            with self.assertRaisesRegex(AssertionError, 'uncommanded physical axis moved'):
                rig.move('TR_LO', .3)
        self.assertIsNone(rig.motion_expectation)

    def test_gap_move_rejects_wrong_center_even_with_correct_gap(self):
        original = self.client.begin_move
        def begin(axis, target, **kwargs):
            result = original(axis, target, **kwargs)
            self.client.destination['TR_LO'] += .1
            self.client.destination['TR_HI'] += .1
            return result
        with patch.object(self.client, 'begin_move', begin):
            code, report, _ = self.run_live_boundary(('--case', 'virtual', '--test', 'gap_both'))
        self.assertEqual(code, 1)
        self.assertIn('gap move changed the uncommanded center', report['tests'][0]['detail'])

    def test_pvt_unknown_controller_error_is_not_reset(self):
        original = self.client.put
        def put(name, value, **kwargs):
            result = original(name, value, **kwargs)
            if name == 'HW:PVT-Abort': self.client.values['HW:MCU-ErrId'] = 0x123456
            return result
        with patch.object(self.client, 'put', put):
            code, report, _ = self.run_live_boundary(('--case', 'pvt', '--test', 'lo_abort_pulse_high'))
        self.assertEqual(code, 1)
        self.assertIn('unexpected controller error', report['tests'][0]['detail'])
        self.assertFalse(any(n == 'HW:MCU-ErrRst' for n, _ in self.client.writes))

    def test_stall_target_is_between_encoder_counts_with_valid_tolerance(self):
        from slit_recovery import unrepresentable_stall_target
        for quantum in (1/12800, 1/4096):
            for reference in (0., .00048828125, -.002578125):
                for step in (.2, 5., -5.):
                    for resolution in (None, 10/32768):
                        target, tol = unrepresentable_stall_target(reference+step, reference, quantum, .0015, resolution)
                        self.assertGreater(tol, 0)
                        self.assertLess(tol, quantum/100)
                        counts = (target-reference)/quantum
                        self.assertGreater(abs(counts-round(counts))*quantum, 10*tol)
                        self.assertLessEqual(abs(target-reference-step), .0015)
                        self.assertLessEqual(len(f'Cfg.SetAxisMonAtTargetTol(6,{tol:.12g})'), 39)
                        if resolution: self.assertAlmostEqual(target/resolution, round(target/resolution), places=7)
        with self.assertRaisesRegex(AssertionError, 'no nearby'):
            unrepresentable_stall_target(5., 0., .001, .0015, .001)

    def test_live_stall_monitor_reports_alarm_and_completes_motor_record(self):
        code, report, _ = self.run_live_boundary(('--case', 'stall'))
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 4)
        alarms = [t for t in report['trace'] if t.get('action') == 'AtTarget stall alarm terminates motor record']
        self.assertEqual(len(alarms), 4)
        configured = [t for t in report['trace'] if t.get('action') == 'stall target between encoder counts']
        self.assertEqual(len(configured), 4)
        self.assertTrue(all(t['at_target_tolerance'] > 0 for t in configured))
        self.assertFalse(any(name == 'HW:MCU-Cmd.AOUT' and value.endswith(',0)') and
                             'SetAxisMonAtTargetTol' in value for name, value in self.client.writes))

        for alarm in alarms:
            data = alarm['snapshot'][alarm['axis']]
            self.assertEqual(data['-AtTarget'], 0)
            self.assertEqual(data['-ErrId'], 0x14c19)
            self.assertEqual(data['.DMOV'], 1)
            for master in ('CENTERY', 'GAPY'):
                self.assertEqual(alarm['snapshot'][master]['-ErrId'], 0x1432b)
        for axis in self.profile['physical']:
            self.assertEqual(self.client.native_settings[axis]['MonAtTargetTol'], .01)
            self.assertEqual(self.client.values['HW:'+axis+'.MSTA'], 0)

    def test_physical_stop_ends_each_virtual_move_and_recovers(self):
        code, report, _ = self.run_live_boundary(('--case', 'coupled_stop'))
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 8)
        self.assertEqual(len([t for t in report['trace'] if t.get('action') == 'physical STOP interrupts virtual motion and recovers']), 8)
        stopped = [t for t in report['trace'] if t.get('action') == 'physical STOP terminated virtual group']
        self.assertEqual(len(stopped), 8)
        for trace in stopped:
            for master in ('CENTERY', 'GAPY'):
                self.assertEqual(trace['snapshot'][master]['-ErrId'], 0x14331)


    def test_limit_homing_and_post_move_use_el7031_and_complete_outside_limits(self):
        code, report, _ = self.run_live_boundary(('--case', 'homing'))
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 6)
        homes = [t for t in report['trace'] if t.get('action') == 'real limit homing completed']
        self.assertEqual(len(homes), 6)
        self.assertEqual(sum(t['post_move'] for t in homes), 2)
        self.assertEqual({t['sequence'] for t in homes}, {1, 2})
        self.assertTrue(all(t['axis'] == 'TR_HI' and t['home_position'] == -20 for t in homes))
        for t in homes:
            self.assertEqual(t['snapshot']['TR_HI']['.DMOV'], 1)
        self.assertFalse(any(n.endswith('.VAL') for n, _ in self.client.writes))
        self.assertEqual(self.client.native_settings['TR_HI']['HomePostMoveEnable'], 0)
        self.assertEqual(self.client.values['HW:TR_HI-Enc02-ForceOn-RB'], 0)

    def test_homing_is_opt_in_and_cannot_mix_with_normal_groups(self):
        with redirect_stdout(io.StringIO()):
            self.assertEqual(run.main([]), 0)
        with redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
            run.main(['--case', 'homing', '--case', 'motion'])
        self.assertEqual(self.client.writes, [])

    def test_missing_homing_marker_refuses_before_any_setup_writes(self):
        del self.client.values['HW:HardwareSlitTest:HomingSchema']
        code, report, _ = self.run_live_boundary(('--case', 'homing'))
        self.assertEqual(code, 1)
        self.assertEqual(self.client.writes, [])

    def test_physical_homing_travel_guard_uses_raw_counts_not_reset_coordinate(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if name == 'HW:m0s009-Enc01-PosAct' and self.client.home_active is not None:
                return value+110*4096
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'homing', '--test', 'low_limit_native'))
        self.assertEqual(code, 1)
        self.assertIn('measured travel budget', report['tests'][0]['detail'])
        self.assertIsNone(self.client.home_active)

    def test_post_home_move_must_not_complete_motor_record_early(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if (name == 'HW:TR_HI.DMOV' and self.client.home_active is not None
                    and self.client.values['HW:TR_HI-Homed'] and self.client.positions['TR_HI'] > -19): return 1
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'homing', '--test', 'postmove_motor'))
        self.assertEqual(code, 1)
        self.assertIn('completed before the post-home move ended', report['tests'][0]['detail'])
        self.assertIsNone(self.client.home_active)

    def test_homing_allows_one_active_hi_limit_but_not_both(self):
        self.rig.homing_session = True
        self.client.values['HW:TR_HI-LimBwd'] = 0
        self.rig.guard()
        self.assertTrue(self.rig.authorized)
        self.client.values['HW:TR_HI-LimFwd'] = 0
        with self.assertRaisesRegex(RuntimeError, 'both limit switches active'):
            self.rig.guard()

    def test_standalone_stall_does_not_accept_master_propagation(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if name == 'HW:CENTERY-ErrId' and self.client.values['HW:TR_HI-ErrId'] == 0x14c19:
                return 0x1432b
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'no_sm', '--test', 'stall_hi_motor'))
        self.assertEqual(code, 1)
        self.assertIn('CENTERY: unexpected error 0x1432b', report['tests'][0]['detail'])

    def test_recovery_encoder_alarm_is_not_accepted_or_automatically_reset(self):
        original_put, original_get = self.client.put, self.client.get
        state = {'recovery': False, 'reset_count_at_fault': None}
        def put(name, value, **kwargs):
            result = original_put(name, value, **kwargs)
            if name == 'HW:TR_HI.VAL' and value == 0:
                state['recovery'] = True
            return result
        def get(name):
            value = original_get(name)
            if (state['recovery'] and self.client.active is not None
                    and self.clock.now > self.client.active_started):
                if state['reset_count_at_fault'] is None:
                    state['reset_count_at_fault'] = sum(n == 'HW:MCU-ErrRst' for n,v in self.client.writes)
                self.client.values['HW:TR_HI-ErrId'] = 0x14410
                self.client.values['HW:TR_HI-Enc02-ErrId'] = 0x14410
                self.client.values['HW:m0s009-Enc01-Stat'] = 6
                self.client.values['HW:m0s025-BO01-RB'] = 1
                if name == 'HW:TR_HI-ErrId': return 0x14410
            return value
        with patch.object(self.client, 'put', put), patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'stall', '--test', 'hi_motor'))
        self.assertEqual(code, 1)
        self.assertIsNotNone(state['reset_count_at_fault'])
        failure = next(t for t in report['trace'] if t.get('action') == 'stall failure before cleanup')
        self.assertEqual(failure['stage'], 'fresh recovery move')
        self.assertEqual(failure['snapshot']['TR_HI']['-ErrId'], 0x14410)
        diag = failure['snapshot']['TR_HI']['encoder_diagnostics']
        self.assertEqual(diag['-Enc02-ErrId'], 0x14410)
        self.assertEqual(diag['terminal_status'], 6)
        self.assertTrue(diag['terminal_error_bit1'])
        self.assertTrue(diag['terminal_ready_bit2'])
        self.assertEqual(diag['power_output'], 1)
        self.assertEqual(sum(n == 'HW:MCU-ErrRst' for n,v in self.client.writes), state['reset_count_at_fault'])
        self.assertFalse(any(t.get('action') == 'stall recovery completed' for t in report['trace']))

    def test_native_stall_accepts_at_target_only_after_verified_power_handover(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if self.client.values['HW:TR_HI-ErrId'] == 0x14c19:
                changes = {'HW:TR_HI-AtTarget': 1, 'HW:TR_HI-SetEncIdCmd-RB': 1,
                           'HW:TR_HI-Enc02-PwrState': 1, 'HW:TR_HI-Enc02-PwrOn': 0,
                           'HW:TR_HI-PosSet': self.client.positions['TR_HI']}
                return changes.get(name, value)
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'stall', '--test', 'hi_native'))
        self.assertEqual(code, 0, report)
        before = [t for t in report['trace'] if t.get('action') == 'AtTarget false before stall alarm']
        after = [t for t in report['trace'] if t.get('action') == 'AtTarget stall alarm terminates motor record']
        self.assertEqual(before[0]['snapshot']['TR_HI']['-AtTarget'], 0)
        self.assertEqual(after[0]['snapshot']['TR_HI']['-AtTarget'], 1)
        self.assertEqual(after[0]['snapshot']['TR_HI']['-ErrId'], 0x14c19)
        self.assertTrue(any(t.get('action') == 'stall recovery completed' for t in report['trace']))

    def test_stall_rejects_at_target_without_power_handover(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if self.client.values['HW:TR_HI-ErrId'] == 0x14c19:
                changes = {'HW:TR_HI-AtTarget': 1, 'HW:TR_HI-SetEncIdCmd-RB': 2,
                           'HW:TR_HI-Enc02-PwrState': 3, 'HW:TR_HI-Enc02-PwrOn': 1}
                return changes.get(name, value)
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'stall', '--test', 'hi_native'))
        self.assertEqual(code, 1)
        self.assertIn('stall alarm terminates motor processing', report['tests'][0]['detail'])
        self.assertFalse(any(t.get('action') == 'stall recovery completed' for t in report['trace']))

    def test_stall_setup_fault_is_preserved_and_not_accepted_as_test_alarm(self):
        original = self.client.put
        injected = False
        def put(name, value, **kwargs):
            nonlocal injected
            result = original(name, value, **kwargs)
            if name == 'HW:MCU-Cmd.AOUT' and value.startswith('Cfg.SetAxisMonAtTargetTol(6,') and float(value.split(',')[1][:-1]) < 1e-6 and not injected:
                injected = True
                self.client.values['HW:TR_HI-ErrId'] = 0x14c19
                self.client.values['HW:GAPY-ErrId'] = 0x1432b
            return result
        with patch.object(self.client, 'put', put):
            code, report, _ = self.run_live_boundary(('--case', 'stall', '--test', 'hi_motor'))
        self.assertEqual(code, 1)
        self.assertTrue(injected)
        failures = [t for t in report['trace'] if t.get('action') == 'stall failure before cleanup']
        self.assertEqual(len(failures), 1)
        failure = failures[0]
        self.assertEqual(failure['stage'], 'requesting test move')
        self.assertEqual(failure['snapshot']['TR_HI']['-ErrId'], 0x14c19)
        self.assertEqual(failure['snapshot']['GAPY']['-ErrId'], 0x1432b)
        self.assertEqual(failure['saved_monitor']['MonAtTargetTol'], .01)
        self.assertFalse(any(t.get('action') == 'stall recovery completed' for t in report['trace']))

    def test_stall_alarm_must_clear_busy_processing_not_just_set_error(self):
        original = self.client.get
        def get(name):
            value = original(name)
            if name == 'HW:TR_LO.PACT' and self.client.values['HW:TR_LO-ErrId'] == 0x14c19: return 1
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'stall', '--test', 'lo_motor'))
        self.assertEqual(code, 1)
        self.assertIn('stall alarm terminates motor processing', report['tests'][0]['detail'])
        self.assertFalse(any(t.get('action') == 'stall recovery completed' for t in report['trace']))

    def test_coupled_stop_rejects_unrelated_controller_fault(self):
        original = self.client.request_stop
        def stop(axis):
            coordinated = self.client.active is not None and self.client.active[0] == 'CENTERY'
            original(axis)
            if coordinated: self.client.values['HW:MCU-ErrId'] = 0xdead
        with patch.object(self.client, 'request_stop', stop):
            code, report, _ = self.run_live_boundary(('--case', 'coupled_stop', '--test', 'center_stop_hi_motor'))
        self.assertEqual(code, 1)
        self.assertIn('unexpected controller error 0xdead', report['tests'][0]['detail'])

    def test_coupled_stop_rejects_source_error_on_physical_axis(self):
        original = self.client.request_stop
        def stop(axis):
            coordinated = self.client.active is not None and self.client.active[0] == 'CENTERY'
            original(axis)
            if coordinated: self.client.values['HW:'+axis+'-ErrId'] = 0x14331
        with patch.object(self.client, 'request_stop', stop):
            code, report, _ = self.run_live_boundary(('--case', 'coupled_stop', '--test', 'center_stop_hi_motor'))
        self.assertEqual(code, 1)
        self.assertIn('TR_HI: unexpected error 0x14331', report['tests'][0]['detail'])

    def test_ignored_physical_stop_during_virtual_motion_fails(self):
        original = self.client.put
        def put(name, value, **kwargs):
            if name == 'HW:TR_HI.STOP' and self.client.active is not None and self.client.active[0] == 'CENTERY':
                return None
            return original(name, value, **kwargs)
        with patch.object(self.client, 'put', put):
            code, report, _ = self.run_live_boundary(('--case', 'coupled_stop', '--test', 'center_stop_hi_motor'))
        self.assertEqual(code, 1)
        self.assertIn('physical STOP was ignored', report['tests'][0]['detail'])

    def test_post_home_reference_change_cannot_substitute_for_physical_move(self):
        original = self.client.get
        held = []
        def get(name):
            value = original(name)
            if (name == 'HW:m0s009-Enc01-PosAct' and self.client.home_active is not None
                    and self.client.values['HW:TR_HI-Homed']):
                if not held: held.append(value)
                return held[0]
            if name == 'HW:m0s009-Enc01-PosAct' and held: return held[0]
            return value
        with patch.object(self.client, 'get', get):
            code, report, _ = self.run_live_boundary(('--case', 'homing', '--test', 'postmove_native'))
        self.assertEqual(code, 1)
        self.assertIn('raw counts did not confirm', report['tests'][0]['detail'])

    def test_status_only_is_read_only(self):
        code, report, _ = self.run_live_boundary(('--case', 'status'))
        self.assertEqual(code, 0, report)
        self.assertEqual(self.client.writes, [])

    def test_guard_failure_is_reported_without_cleanup_writes(self):
        self.client.values['HW:MCU-Cfg-Sim-Mode'] = 1
        code, report, xml = self.run_live_boundary()
        self.assertEqual(code, 1)
        self.assertIn('error', report)
        self.assertEqual(xml.attrib['errors'], '1')
        self.assertEqual(self.client.writes, [])
        self.assertTrue(self.client.closed)

    def test_motion_fault_stops_suite_and_restores_velocity_without_return_move(self):
        self.client.fault_on_move = True
        original_snapshot = Rig.snapshot
        def snapshot(rig):
            self.assertIsNone(self.client.active, 'STOP must precede failure diagnostics')
            return original_snapshot(rig)
        with patch.object(Rig, 'snapshot', snapshot):
            code, report, xml = self.run_live_boundary(('--case', 'motion'))
        self.assertEqual(code, 1)
        self.assertEqual(len(report['tests']), 1)
        self.assertEqual(xml.attrib['failures'], '1')
        self.assertEqual(len([n for n, _ in self.client.writes if n.endswith('.VAL')]), 1)
        self.assertEqual(len([n for n, _ in self.client.writes if n.endswith('.STOP')]), 4)
        self.assertEqual(self.client.values['HW:TR_LO.VELO'], .4)
        self.assertTrue(self.client.closed)


    def test_interrupt_stops_active_hardware_request_and_reports_it(self):
        self.client.interrupt_on_move = True
        code, report, xml = self.run_live_boundary(('--case', 'motion'))
        self.assertEqual(code, 130)
        self.assertIn('Interrupted', report['error'])
        self.assertEqual(xml.attrib['errors'], '1')
        self.assertEqual(len([n for n, _ in self.client.writes if n.endswith('.STOP')]), 4)
        self.assertEqual(self.client.values['HW:TR_LO.VELO'], .4)
        self.assertTrue(self.client.closed)

    def test_motion_timeout_stops_and_restores_velocity(self):
        self.client.stall = True
        code, report, _ = self.run_live_boundary(('--case', 'motion'))
        self.assertEqual(code, 1)
        self.assertIn('timeout:', report['tests'][0]['detail'])
        self.assertEqual(len([n for n, _ in self.client.writes if n.endswith('.STOP')]), 4)
        self.assertEqual(self.client.values['HW:TR_LO.VELO'], .4)

    def test_cleanup_error_is_reported_and_fails_the_run(self):
        original = self.client.put
        def put(name, value, **kwargs):
            if name.endswith('.STOP'): raise RuntimeError('STOP write failed')
            return original(name, value, **kwargs)
        self.client.put = put
        code, report, xml = self.run_live_boundary(('--case', 'motion', '--test', 'lo_both'))
        self.assertEqual(code, 1)
        self.assertEqual(len(report['cleanup_errors']), 4)
        self.assertEqual(xml.attrib['errors'], '1')
        self.assertTrue(self.client.closed)


    def test_larger_moves_reject_narrow_ioc_limits(self):
        self.assertEqual(self.profile['step'], 5.0)
        self.assertEqual(self.profile['velocity'], 1.0)
        for axis in self.profile['axes']:
            for field, value in (('.LLM', -1), ('.HLM', 1),
                                 ('-CfgDLLM-RB', -1), ('-CfgDHLM-RB', 1)):
                self.client.values['HW:'+axis+field] = value
        self.rig.guard()
        with self.assertRaisesRegex(RuntimeError, 'outside active soft limits'):
            self.rig.preflight_moves(('TR_LO', 'TR_HI'))
        self.assertEqual(self.client.writes, [])

    def test_timeout_preserves_actual_completion_conditions(self):
        self.client.positions['TR_HI'] = .900634765625
        self.client.update_coordinates()
        self.client.values['HW:TR_HI-AtTarget'] = 0
        self.rig.guard()
        complete = Event()
        complete.set()
        with patch('slit_hardware.rig.time.monotonic', self.clock.monotonic), \
                patch('slit_hardware.rig.time.sleep', self.clock.sleep):
            with self.assertRaisesRegex(AssertionError, 'Completion conditions before STOP'):
                self.rig.finish('TR_HI', .05, complete)
        observed = self.rig.trace[-1]['completion_conditions']
        self.assertEqual(observed['target'], .05)
        self.assertEqual(observed['native_position'], .900634765625)
        self.assertEqual(observed['motor_position'], .900634765625)
        self.assertEqual(observed['at_target'], 0)
        self.assertTrue(observed['put_complete'])
        self.assertEqual(observed['axes']['TR_HI'], {'-Busy': 0, '.DMOV': 1, '.MOVN': 0})


    def test_relative_window_uses_fresh_encoder_position_outside_absolute_ten_mm(self):
        self.profile['reference_to_zero'] = False
        self.client.positions.update(TR_LO=35, TR_HI=0)  # startup counter is not yet referenced
        self.client.update_coordinates()
        for axis in self.profile['axes']:
            for field, value in (('.LLM', -100), ('.HLM', 100), ('.DLLM', -100), ('.DHLM', 100),
                                 ('-CfgDLLM-RB', -100), ('-CfgDHLM-RB', 100)):
                self.client.values['HW:'+axis+field] = value
        self.client.values['HW:TR_HI-Enc02-PwrState'] = 1
        self.client.values['HW:TR_HI-Enc02-Ready'] = 0
        self.client.values['HW:TR_HI-SetEncIdCmd-RB'] = 1
        original = self.client.put
        def put(name, value, **kwargs):
            result = original(name, value, **kwargs)
            if name == 'HW:TR_HI-Enc02-ForceOn':
                self.client.values[name+'-RB'] = value
                if value:
                    self.client.positions['TR_HI'] = 40  # first real BiSS sample
                    self.client.update_coordinates()
                    self.client.values['HW:TR_HI-Enc02-PwrState'] = 3
                    self.client.values['HW:TR_HI-Enc02-Ready'] = 1
                    self.client.values['HW:TR_HI-SetEncIdCmd-RB'] = 2
            return result
        self.client.put = put
        code, report, _ = self.run_live_boundary()
        self.assertEqual(code, 0, report)
        self.assertEqual(report['origins']['TR_LO'], 35)
        self.assertEqual(report['origins']['TR_HI'], 40)
        holds = [(name, value) for name, value in self.client.writes if name.endswith('-Enc02-ForceOn')]
        self.assertEqual(holds, [('HW:TR_HI-Enc02-ForceOn', 1), ('HW:TR_HI-Enc02-ForceOn', 0)])
        self.assertEqual(self.client.writes[:2], holds)
        self.assertAlmostEqual(self.client.positions['TR_LO'], 35)
        self.assertAlmostEqual(self.client.positions['TR_HI'], 40)
        self.assertIn(('HW:TR_LO.VAL', 40), self.client.writes)
        self.assertIn(('HW:TR_HI.VAL', 45), self.client.writes)

    def test_failed_startup_wake_restores_hold_without_motor_writes(self):
        self.client.values['HW:TR_HI-Enc02-PwrState'] = 1
        self.client.values['HW:TR_HI-Enc02-Ready'] = 0
        self.client.values['HW:TR_HI-SetEncIdCmd-RB'] = 1
        code, report, _ = self.run_live_boundary(('--case', 'motion'))
        self.assertEqual(code, 1)
        self.assertIn('BiSS ready', report['error'])
        self.assertEqual(self.client.writes, [('HW:TR_HI-Enc02-ForceOn', 1), ('HW:TR_HI-Enc02-ForceOn', 0)])
        self.assertEqual(report['cleanup_errors'], [])
        self.assertTrue(self.client.closed)

    def test_sleeping_source_is_not_woken_with_drive_enabled(self):
        self.client.values['HW:TR_HI-Enc02-PwrState'] = 1
        self.client.values['HW:TR_HI-SetEncIdCmd-RB'] = 1
        self.client.values['HW:TR_HI-EnaAct'] = 1
        code, report, _ = self.run_live_boundary(('--case', 'motion'))
        self.assertEqual(code, 1)
        self.assertIn('disable', report['error'])
        self.assertEqual(self.client.writes, [])

    def test_existing_absolute_profile_keeps_absolute_envelope(self):
        del self.profile['relative_to_start']
        self.client.positions['TR_HI'] = 35
        self.client.update_coordinates()
        with self.assertRaisesRegex(AssertionError, 'outside hardware test bounds'):
            self.rig.guard()
        self.assertEqual(self.client.writes, [])


    def test_zero_reference_after_wake_preserves_physical_position(self):
        self.client.positions.update(TR_LO=35, TR_HI=40)
        self.client.mechanical_positions = dict(self.client.positions)
        self.client.update_coordinates()
        self.rig.guard()
        with patch('slit_hardware.rig.time.monotonic', self.clock.monotonic), \
                patch('slit_hardware.rig.time.sleep', self.clock.sleep):
            self.rig.initialize_origins()
        self.assertEqual(self.client.positions, {'TR_LO': 0, 'TR_HI': 0})
        self.assertEqual(self.client.mechanical_positions, {'TR_LO': 35, 'TR_HI': 40})
        self.assertFalse(any(n.endswith('.VAL') for n, _ in self.client.writes))
        self.assertEqual(self.rig.origins, {a: 0 for a in self.profile['axes']})
        self.assertEqual([(n, v) for n, v in self.client.writes if n.endswith('-SetEncPosCmd')],
                         [('HW:TR_LO-SetEncPosCmd', 0), ('HW:TR_HI-SetEncPosCmd', 0)])
        self.assertFalse(any(n.endswith(('.SET', '.FOFF', '.DVAL')) for n, _ in self.client.writes))
        self.assertEqual(self.client.values['HW:TR_HI-Enc01-Homed'], 1)
        self.assertEqual(self.client.values['HW:TR_HI-Enc02-Homed'], 1)
        self.rig.preflight_moves(self.profile['axes'])

    def test_zero_reference_failure_restores_encoder_hold(self):
        original = self.client.put
        def put(name, value, **kwargs):
            if name.endswith('-SetEncPosCmd'): raise RuntimeError('reference write failed')
            return original(name, value, **kwargs)
        self.client.put = put
        code, report, _ = self.run_live_boundary(('--case', 'motion'))
        self.assertEqual(code, 1)
        self.assertIn('reference write failed', report['error'])
        self.assertEqual(self.client.values['HW:TR_LO.SET'], 0)
        self.assertEqual(self.client.values['HW:TR_LO.FOFF'], 1)
        self.assertEqual(self.client.values['HW:TR_HI-Enc02-ForceOn-RB'], 0)
        self.assertFalse(any(n.endswith('.VAL') for n, _ in self.client.writes))
        self.assertTrue(self.client.closed)


    def test_zero_reference_waits_for_motor_acknowledgement(self):
        original_put, original_get = self.client.put, self.client.get
        acknowledgements = {}
        def put(name, value, **kwargs):
            result = original_put(name, value, **kwargs)
            if name.endswith('-SetEncPosCmd'):
                axis = name[3:-len('-SetEncPosCmd')]
                self.client.values['HW:'+axis+'.DMOV'] = 0
                acknowledgements['HW:'+axis+'.DMOV'] = self.clock.now+.2
            return result
        def get(name):
            if name in acknowledgements and self.clock.now >= acknowledgements[name]:
                self.client.values[name] = 1
                del acknowledgements[name]
            return original_get(name)
        self.client.put, self.client.get = put, get
        self.rig.guard()
        with patch('slit_hardware.rig.time.monotonic', self.clock.monotonic), \
                patch('slit_hardware.rig.time.sleep', self.clock.sleep):
            self.rig.initialize_origins()
        self.assertFalse(acknowledgements)
        self.assertEqual(self.client.values['HW:TR_LO.SET'], 0)
        self.assertEqual(self.client.values['HW:TR_HI.SET'], 0)
        self.assertFalse(any(n.endswith('.VAL') for n, _ in self.client.writes))


    def test_repeated_targets_use_one_completion_request_and_ordinary_burst(self):
        code, report, _ = self.run_live_boundary(('--case', 'motion', '--test', 'repeated_motor_targets'))
        self.assertEqual(code, 0, report)
        flags = [options for name, options in self.client.put_options if name.endswith('.VAL')]
        self.assertEqual([options['notify'] for options in flags], [True, False, False, False, True])
        self.assertTrue(all(options['wait'] is False for options in flags))
        self.assertEqual(report['tests'][0]['status'], 'passed')
        self.assertTrue(self.client.closed)


    def test_target_write_moves_do_not_write_execute_high_and_restore_mode(self):
        code, report, _ = self.run_live_boundary(('--case', 'target_write'))
        self.assertEqual(code, 0, report)
        self.assertEqual(len(report['tests']), 4)
        self.assertFalse(any(n.endswith('-ExeCmd') and v == 1 for n, v in self.client.writes))
        for axis in self.profile['physical']:
            self.assertEqual(self.client.values['HW:'+axis+'-AutoExecuteOnTargetPos-RB'], 0)
            self.assertEqual(self.client.values['HW:'+axis+'-EnaAct'], 0)
        self.assertEqual(self.client.values['HW:MCU-Cmd.TMOD'], 0)

    def test_native_failure_restores_mode_and_staged_parameters(self):
        self.client.fault_on_move = True
        code, report, _ = self.run_live_boundary(('--case', 'target_write'))
        self.assertEqual(code, 1)
        self.assertEqual(len(report['tests']), 1)
        self.assertEqual(self.client.values['HW:TR_LO-AutoExecuteOnTargetPos-RB'], 0)
        self.assertEqual(self.client.values['HW:TR_LO-TgtPosCmd'], 0)
        self.assertEqual(self.client.values['HW:TR_LO-MtnCmd'], 3)
        self.assertEqual(self.client.values['HW:MCU-Cmd.TMOD'], 0)
        self.assertEqual(self.client.values['HW:MCU-Cmd.OFMT'], 0)

    def test_motor_offset_direction_checks_native_travel_and_restores_fields(self):
        code, report, _ = self.run_live_boundary(('--case', 'motor'))
        self.assertEqual(code, 0, report)
        for axis in self.profile['physical']:
            for field, expected in (('.DIR', 0), ('.OFF', 0), ('.FOFF', 1),
                                    ('-CfgSyncSftLim', 0), ('-CfgDLLM-RB', -10), ('-CfgDHLM-RB', 10)):
                self.assertEqual(self.client.values['HW:'+axis+field], expected)
            targets = [v for n, v in self.client.writes if n == 'HW:'+axis+'.VAL']
            self.assertIn(7.5, targets)
            self.assertIn(-7.5, targets)

    def test_motor_mapping_cannot_bypass_native_or_physical_bounds(self):
        self.rig.guard()
        self.client.put('HW:TR_LO.DIR', 1)
        self.client.put('HW:TR_LO.OFF', 25)
        self.rig.validate_target('TR_LO', 5)  # user coordinate 20 is within transformed motor limits
        self.assertEqual(self.rig.user_position('TR_LO', 5), 20)
        self.assertEqual(self.rig.dial_position('TR_LO', 20), 5)
        self.client.values['HW:TR_LO.LLM'] = -100
        self.client.values['HW:TR_LO.HLM'] = 100
        with self.assertRaisesRegex(RuntimeError, 'outside active soft limits'):
            self.rig.put('TR_LO', '.VAL', 40)  # dial -15, even though user target looks valid
        self.assertFalse(any(n.endswith('.VAL') for n, _ in self.client.writes))

    def test_pvt_restores_controller_selection_and_requires_measured_motion(self):
        original = self.client.put
        def put(name, value, **kwargs):
            result = original(name, value, **kwargs)
            if name == 'HW:PVT-Execute':
                axis, points, started = self.client.pvt_active
                self.client.pvt_active = (axis, [points[0]]*len(points), started)
            return result
        self.client.put = put
        code, report, _ = self.run_live_boundary(('--case', 'pvt'))
        self.assertEqual(code, 1)
        self.assertIn('physically traverse both sides', report['tests'][0]['detail'])
        self.assertTrue(any(n == 'HW:PVT-Abort' for n, _ in self.client.writes))
        self.assertEqual(self.client.values['HW:PVT-NumPoints'], 64)
        self.assertEqual(self.client.values['HW:PVT-FixedTime'], 1)
        for axis in self.profile['axes']:
            self.assertEqual(self.client.values['HW:'+axis+'-PVT-UseAxis'], 0)
        self.assertEqual(self.client.values['HW:TR_LO-EnaAct'], 0)


    def test_coordinate_failure_restores_dir_off_and_soft_limit_policy(self):
        self.client.fault_on_move = True
        code, report, _ = self.run_live_boundary(('--case', 'motor'))
        self.assertEqual(code, 1)
        self.assertEqual(len(report['tests']), 1)
        self.assertEqual(self.client.values['HW:TR_LO.DIR'], 0)
        self.assertEqual(self.client.values['HW:TR_LO.OFF'], 0)
        self.assertEqual(self.client.values['HW:TR_LO.FOFF'], 1)
        self.assertEqual(self.client.values['HW:TR_LO-CfgSyncSftLim'], 0)
        self.assertEqual(self.client.values['HW:TR_LO-CfgDLLM-RB'], -10)

    def test_missing_pvt_support_refuses_before_zero_reference_writes(self):
        del self.client.values['HW:PVT-MaxSize']
        code, report, _ = self.run_live_boundary(('--case', 'pvt'))
        self.assertEqual(code, 1)
        self.assertIn('PVT preflight failed', report['error'])
        self.assertEqual(self.client.writes, [])


    def test_target_write_can_prepare_after_virtual_axis_ownership(self):
        for axis in self.profile['physical']:
            self.client.values['HW:'+axis+'-TrjSrcTyp-RB'] = 1
        code, report, _ = self.run_live_boundary(('--test', 'test_target_write_lo_auto_enable'))
        self.assertEqual(code, 0, report)
        self.assertEqual(self.client.values['HW:TR_LO-TrjSrcTyp-RB'], 0)
        self.assertFalse(any(n.endswith('-ExeCmd') and v == 1 for n, v in self.client.writes))


if __name__ == '__main__': unittest.main()
