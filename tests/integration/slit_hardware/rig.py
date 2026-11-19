"""Bounded motor moves and read-only status checks for the hardware slit IOC."""
import json
import math
import time

# Numeric PV access is shared; no simulated Plant or simulation Rig is used.
from slit.rig import Client
from .operations import Operations
from slit_motion_checks import MotionExpectation


def validate_profile(profile):
    if profile['schema'] != 1 or profile['axes'] != {
            'TR_LO': 5, 'TR_HI': 6, 'CENTERY': 12, 'GAPY': 13}:
        raise ValueError('profile must describe hardware slit schema 1 and its four axis IDs')
    if set(profile['physical']) != {'TR_LO', 'TR_HI'}:
        raise ValueError('physical travel bounds required for TR_LO and TR_HI')
    for flag in ('relative_to_start', 'reference_to_zero'):
        if not isinstance(profile.get(flag, False), bool):
            raise ValueError(flag + ' must be boolean')
    for axis, limits in profile['physical'].items():
        if len(limits) != 2 or not all(math.isfinite(v) for v in limits) or limits[0] >= limits[1]:
            raise ValueError('invalid travel bounds: ' + axis)
    for key in ('step', 'velocity', 'tolerance', 'timeout'):
        if not math.isfinite(profile[key]) or profile[key] <= 0:
            raise ValueError('profile ' + key + ' must be finite and positive')
    if profile['step'] <= 2 * profile['tolerance']:
        raise ValueError('step must exceed twice the position tolerance')
    power = profile['encoder_power']
    if (power['axis'] not in profile['physical'] or power['encoder'] != 2 or power['backup'] != 1
            or not math.isfinite(power['timeout']) or power['timeout'] <= 0):
        raise ValueError('encoder-power mapping must match the hardware IOC')


class Rig(Operations):
    def __init__(self, profile, prefix, client):
        validate_profile(profile)
        self.profile, self.prefix, self.client = profile, prefix, client
        self.origins, self.saved_velocity, self.touched, self.trace = {}, {}, set(), []
        self.authorized = False
        self.saved_state_machine, self.standalone_axis = None, None
        self.standalone_positions = {}
        self.brake_checks = False
        self.homing_session, self.homing_watch = False, None
        self.motion_expectation = None
        self.stop_requested, self.stop_errors = False, []
        self.initializing_origins, self.saved_force_on = False, None

    def get(self, axis, field): return self.client.get(self.prefix + axis + field)
    def read(self, suffix): return self.client.get(self.prefix + suffix)

    def healthy(self):
        if self.motion_expectation is not None: self.motion_expectation.check()
        if self.standalone_axis is not None:
            if self.read('SM00-EnaCmd') != 0 or self.read('SM00-StateCmd') != 0:
                raise AssertionError('state machine must remain disabled and idle during standalone moves')
            for axis in ('CENTERY', 'GAPY'):
                if self.get(axis, '-EnaAct') or self.get(axis, '-Busy'):
                    raise AssertionError(axis+': virtual axis must remain disabled and idle')
            for axis, position in self.standalone_positions.items():
                if axis != self.standalone_axis and abs(self.get(axis, '-PosAct')-position) > self.profile['tolerance']:
                    raise AssertionError(axis+': uncommanded physical axis moved')
        for suffix, expected in (('MCU-Cfg-Sim-Mode', 0), ('MCU-AppMode', 1), ('m0-Stat-OK', 1)):
            if self.read(suffix) != expected:
                raise AssertionError('IOC/bus state changed: ' + suffix)
        for axis in self.profile['axes']:
            for suffix in ('-ErrId', '-WrnId', '.SEVR'):
                if self.get(axis, suffix):
                    raise AssertionError(axis + ': unexpected ' + suffix + '=' + str(self.get(axis, suffix)))
        self.check_envelope({a: self.get(a, '-PosAct') for a in self.profile['physical']})
        return True

    def check_envelope(self, positions):
        if self.homing_session:
            if self.homing_watch is not None: self.homing_watch()
            return
        for axis, value in positions.items():
            if self.initializing_origins and self.profile.get('relative_to_start', False): continue
            low, high = self.profile['physical'][axis]
            if self.profile.get('relative_to_start', False):
                origin = self.origins[axis]
                low, high = origin+low, origin+high
            if not math.isfinite(value) or not low <= value <= high:
                raise AssertionError(f'{axis}: position {value} outside hardware test bounds [{low}, {high}]')

    def guard(self):
        # Read-only identity checks precede every possible write, including cleanup.
        if self.read('MCU-Cfg-Sim-Mode') != 0 or self.read('HardwareSlitTest:Schema') != self.profile['schema']:
            raise RuntimeError('requires the dedicated real-hardware slit IOC; no writes performed')
        for axis, number in self.profile['axes'].items():
            if self.get(axis, '-Id') != number:
                raise RuntimeError('axis identity mismatch: ' + axis)
            for suffix, expected in (('.DIR', 0), ('.OFF', 0), ('.SPMG', 3), ('.SET', 0),
                                     ('.DMOV', 1), ('.MOVN', 0), ('-Busy', 0), ('-InStartup', 0)):
                if self.get(axis, suffix) != expected:
                    raise RuntimeError(axis + ': preflight requires ' + suffix + '=' + str(expected))
            backward, forward = self.get(axis, '-LimBwd'), self.get(axis, '-LimFwd')
            if self.homing_session and axis == 'TR_HI':
                if not backward and not forward:
                    raise RuntimeError(axis+': both limit switches active before homing')
            elif not backward or not forward:
                raise RuntimeError(axis + ': active hardware limit')
            self.origins[axis] = self.get(axis, '.RBV')
            if abs(self.origins[axis] - self.get(axis, '-PosAct')) > self.profile['tolerance']:
                raise RuntimeError(axis + ': motor/native coordinate mismatch')
        for axis in self.profile['physical']:
            expected = 2 if axis == self.profile['encoder_power']['axis'] else 1
            if self.get(axis, '-EncCnt') != expected:
                raise RuntimeError(axis + ': encoder count does not match the configured hardware setup')
        if self.read('SM00-EnaCmd') != 1:
            raise RuntimeError('hardware suite requires the configured slit state machine enabled')
        self.healthy()
        self.authorized = True

    def encoder_force_suffix(self, readback=False):
        index = self.profile['encoder_power']['encoder']
        return f'-Enc{index:02d}-ForceOn'+('-RB' if readback else '')

    def initialize_origins(self):
        """Establish valid feedback and optionally reference zero without motion."""
        if not self.authorized: raise RuntimeError('identity preflight required')
        cfg = self.profile['encoder_power']
        axis, encoder = cfg['axis'], cfg['encoder']
        stem = f'-Enc0{encoder}'
        mode = self.get(axis, '-EncMode-RB')
        zero = self.profile.get('reference_to_zero', False)
        use_source = mode in (0, encoder) and self.get(axis, stem+'-PwrEnable-RB') == 1
        if zero:
            self.require_disabled_for_reference()
            if mode != 0 or self.get(axis, self.encoder_force_suffix(True)) != 0 or not use_source:
                raise RuntimeError('zero reference requires Auto power, Force ON released and encoder power enabled')
        self.initializing_origins = True
        try:
            if use_source:
                ready = lambda: (self.get(axis, stem+'-PwrState') == 3
                                 and self.get(axis, stem+'-Ready') == 1
                                 and self.get(axis, '-SetEncIdCmd-RB') == encoder)
                if zero or not ready():
                    if self.get(axis, '-EnaAct') or self.get(axis, '-EnaCmd-RB'):
                        raise RuntimeError(axis + ': disable the drive before initial encoder wake')
                    previous = self.get(axis, self.encoder_force_suffix(True))
                    if not previous:
                        self.saved_force_on = previous
                        self.client.put(self.prefix+axis+self.encoder_force_suffix(), 1)
                    self.wait(ready, 'BiSS ready and primary before capturing test origins', cfg['timeout'])
            if zero: self.reference_axes_zero()
            self.wait(lambda: self.idle() and all(
                abs(self.get(a, '.RBV')-self.get(a, '-PosAct')) <= self.profile['tolerance']
                for a in self.profile['axes']), 'motor/native coordinates agree after encoder wake')
            positions = {a: self.get(a, '-PosAct') for a in self.profile['axes']}
            self.origins = {a: 0.0 for a in positions} if zero else positions
            self.trace.append({'action': 'capture startup positions', 'origins': dict(self.origins),
                               'measured_positions': positions, 'reference_to_zero': zero,
                               'relative_to_start': self.profile.get('relative_to_start', False)})
        finally:
            self.initializing_origins = False
        self.restore_encoder_hold()
        if zero:
            self.wait(lambda: self.get(axis, stem+'-PwrState') == 1
                      and self.get(axis, '-SetEncIdCmd-RB') == cfg['backup']
                      and self.get(axis, '-Enc01-Homed') == 1
                      and abs(self.get(axis, '-Enc01-PosAct')) <= self.profile['tolerance'],
                      'tracking counter inherits zero reference before BiSS sleeps', cfg['timeout'])
        self.healthy()

    def require_disabled_for_reference(self):
        if not self.idle() or any(self.get(a, '-EnaAct') or self.get(a, '-EnaCmd-RB')
                                 or abs(self.get(a, '-VelAct')) > .005
                                 for a in self.profile['physical']):
            raise RuntimeError('disable both physical drives and wait for standstill before zero reference')

    def reference_axes_zero(self):
        self.require_disabled_for_reference()
        for axis in self.profile['physical']:
            self.require_disabled_for_reference()
            self.touched.add(axis)
            self.client.put(self.prefix+axis+'-SetEncPosCmd', 0)
            self.wait(lambda: self.idle()
                      and abs(self.get(axis, '-PosAct')) <= self.profile['tolerance']
                      and abs(self.get(axis, '.RBV')) <= self.profile['tolerance']
                      and self.get(axis, '-Homed') == 1,
                      axis + ' acknowledges the non-moving reference change')
        self.wait(lambda: self.idle() and all(
            abs(self.get(a, '-PosAct')) <= self.profile['tolerance']
            and abs(self.get(a, '.RBV')) <= self.profile['tolerance']
            for a in self.profile['axes']), 'physical/virtual feedback accepts zero reference')
        for axis in self.profile['axes']:
            self.client.put(self.prefix+axis+'.SYNC', 1)
        self.wait(lambda: all(self.get(a, '.SYNC') == 0
                  and abs(self.get(a, '.VAL')) <= self.profile['tolerance']
                  for a in self.profile['axes']), 'motor targets synchronize to zero without motion')
        self.require_disabled_for_reference()
        self.trace.append({'action': 'non-moving zero reference',
                           'axes': list(self.profile['physical']), 'snapshot': self.snapshot()})

    def restore_encoder_hold(self):
        if self.saved_force_on is not None:
            axis = self.profile['encoder_power']['axis']
            self.client.put(self.prefix+axis+self.encoder_force_suffix(), self.saved_force_on)
            self.saved_force_on = None

    def user_position(self, axis, dial):
        return self.get(axis, '.OFF') + (-1 if self.get(axis, '.DIR') else 1)*dial

    def dial_position(self, axis, user):
        return (-1 if self.get(axis, '.DIR') else 1)*(user-self.get(axis, '.OFF'))

    def validate_target(self, axis, target):
        if not math.isfinite(target): raise ValueError('non-finite target')
        for side in ('Bwd', 'Fwd'):
            if not self.get(axis, '-CfgD' + ('LLM' if side == 'Bwd' else 'HLM') + '-En-RB'):
                raise RuntimeError(axis + ': native soft limits must be enabled')
        low, high = self.get(axis, '-CfgDLLM-RB'), self.get(axis, '-CfgDHLM-RB')
        if not low < target < high:
            raise RuntimeError(f'{axis}: target {target} outside active soft limits [{low}, {high}]')
        user = self.user_position(axis, target)
        motor_low, motor_high = self.get(axis, '.LLM'), self.get(axis, '.HLM')
        if not (axis in ('CENTERY', 'GAPY') and motor_low == motor_high == 0):
            if not motor_low < user < motor_high:
                raise RuntimeError(f'{axis}: user target {user} outside motor limits [{motor_low}, {motor_high}]')
        positions = {a: self.get(a, '-PosAct') for a in self.profile['physical']}
        if axis in positions:
            positions[axis] = target
        else:
            center = target if axis == 'CENTERY' else self.get('CENTERY', '-PosSet')
            gap = target if axis == 'GAPY' else self.get('GAPY', '-PosSet')
            positions = {'TR_LO': center-gap/2, 'TR_HI': center+gap/2}
        self.check_envelope(positions)

    def preflight_moves(self, axes):
        for axis in axes:
            vmax = self.get(axis, '.VMAX')
            if vmax > 0 and self.profile['velocity'] > vmax:
                raise RuntimeError(axis + ': test velocity exceeds motor VMAX')
            for offset in (-self.profile['step'], 0, self.profile['step']):
                self.validate_target(axis, self.origins[axis] + offset)

    def put(self, axis, field, value, *, notify=True):
        if not self.authorized: raise RuntimeError('hardware writes require successful preflight')
        if axis not in self.profile['axes'] or field not in ('.VAL', '.VELO', '.STOP'):
            raise RuntimeError('hardware runner only writes motor VAL, VELO and STOP')
        if field == '.VAL':
            self.stop_requested = False
            self.healthy()
            self.validate_target(axis, self.dial_position(axis, value))
        self.touched.add(axis)
        return self.client.put(self.prefix + axis + field, value,
                               wait=field not in ('.VAL', '.STOP'), notify=notify and field != '.STOP')

    def wait(self, predicate, description, timeout=None):
        end = time.monotonic() + (timeout or self.profile['timeout'])
        while time.monotonic() < end:
            self.healthy()
            if predicate(): return
            time.sleep(.02)
        raise AssertionError('timeout: ' + description)

    def idle(self):
        return all(self.get(a, '-Busy') == 0 and self.get(a, '.DMOV') == 1
                   and self.get(a, '.MOVN') == 0 for a in self.profile['axes'])

    def start(self, axis, target, *, require_busy=True):
        self.healthy()
        if not self.idle(): raise RuntimeError('axes must be idle before a move')
        self.validate_target(axis, target)
        if axis not in self.saved_velocity:
            self.saved_velocity[axis] = self.get(axis, '.VELO')
        self.put(axis, '.VELO', self.profile['velocity'])
        self.motion_expectation = MotionExpectation(self, axis)
        complete = self.put(axis, '.VAL', self.user_position(axis, target))
        if require_busy:
            self.wait(lambda: self.get(axis, '-Busy') == 1 or self.get(axis, '.DMOV') == 0,
                      axis + ' motion starts')
        if self.get(axis, '.LVIO'): raise AssertionError(axis + ': move rejected by motor limits')
        return complete

    def move(self, axis, target):
        self.finish(axis, target, self.start(axis, target))

    def finish(self, axis, target, complete):
        observed = {}
        def arrived():
            flags = {name: {field: self.get(name, field)
                            for field in ('-Busy', '.DMOV', '.MOVN')}
                     for name in self.profile['axes']}
            observed.update(target=target, tolerance=self.profile['tolerance'],
                            put_complete=complete is None or complete.is_set(), axes=flags,
                            user_target=self.user_position(axis, target),
                            at_target=self.get(axis, '-AtTarget'),
                            motor_position=self.get(axis, '.RBV'),
                            native_position=self.get(axis, '-PosAct'))
            return (observed['put_complete']
                    and all(f['-Busy'] == 0 and f['.DMOV'] == 1 and f['.MOVN'] == 0
                            for f in flags.values())
                    and observed['at_target'] == 1
                    and abs(observed['motor_position']-observed['user_target']) <= self.profile['tolerance']
                    and abs(observed['native_position']-target) <= self.profile['tolerance'])
        try:
            self.wait(arrived, axis + ' completes commanded move')
        except AssertionError as error:
            # Preserve the conditions observed before STOP changes Busy/DMOV.
            self.trace.append({'action': 'incomplete move', 'axis': axis,
                               'completion_conditions': dict(observed)})
            raise AssertionError(str(error) + '\nCompletion conditions before STOP:\n'
                                 + json.dumps(observed, indent=2)) from error
        if self.get(axis, '.LVIO'): raise AssertionError(axis + ': motor limit violation')
        if self.motion_expectation is not None:
            expected = self.motion_expectation.finish(target)
            self.trace.append({'action': 'blade endpoints checked', 'axis': axis, 'expected': expected})
            self.motion_expectation = None
        self.kinematics()
        self.trace.append({'axis': axis, 'target': target, 'snapshot': self.snapshot()})

    def kinematics(self):
        # Separate CA reads may lag by one publication period; evaluate at rest.
        low, high = self.get('TR_LO', '-PosAct'), self.get('TR_HI', '-PosAct')
        tolerance = 2 * self.profile['tolerance']
        self.wait(lambda: abs(self.get('CENTERY', '-PosAct')-(low+high)/2) <= tolerance
                  and abs(self.get('GAPY', '-PosAct')-(high-low)) <= tolerance,
                  'virtual feedback agrees with physical blade positions')

    def snapshot(self):
        result = {}
        for axis in self.profile['axes']:
            result[axis] = {}
            for field in ('.RBV', '.VAL', '.DMOV', '.MOVN', '.SEVR', '.LVIO', '-PosAct',
                          '-PosSet', '-VelAct', '-Busy', '-EnaAct', '-AtTarget', '-ErrId', '-WrnId',
                          '-SetEncIdCmd-RB', '-Enc02-PwrState', '.DIR', '.OFF', '.DVAL',
                          '-AutoExecuteOnTargetPos-RB', '-ExeCmd-RB', '-MtnCmd', '-TgtPosCmd',
                          '.MSTA', '.MIP', '.PACT', '.STAT', '-Homed', '-SeqState', '-LimBwd', '-LimFwd'):
                if axis != self.profile['encoder_power']['axis'] and field == '-Enc02-PwrState': continue
                try: result[axis][field] = self.get(axis, field)
                except Exception as error: result[axis][field] = str(error)
        # Read-only evidence for power-cycle/encoder failures. Retain missing
        # PV errors as diagnostics rather than replacing the original fault.
        cfg = self.profile['encoder_power']
        axis, encoder = cfg['axis'], cfg['encoder']
        stem = f'-Enc{encoder:02d}'
        diagnostic = {}
        for suffix in ('-Stat', '-ErrId', '-Ready', '-PwrState', '-PwrOn', '-ForceOn-RB', '-PosAct'):
            try: diagnostic[stem+suffix] = self.get(axis, stem+suffix)
            except Exception as error: diagnostic[stem+suffix] = str(error)
        for key, pv in cfg.get('diagnostics', {}).items():
            try: diagnostic[key] = self.read(pv)
            except Exception as error: diagnostic[key] = str(error)
        if 'terminal_status' in diagnostic and isinstance(diagnostic['terminal_status'], (int, float)):
            word = int(diagnostic['terminal_status'])
            diagnostic['terminal_warning_bit0'] = bool(word & 1)
            diagnostic['terminal_error_bit1'] = bool(word & 2)
            diagnostic['terminal_ready_bit2'] = bool(word & 4)
        result[axis]['encoder_diagnostics'] = diagnostic
        if self.brake_checks:
            for axis in self.profile['physical']:
                for key, reader in (('brake_output', self.brake), ('drive_control', self.drive_control)):
                    try: result[axis][key] = reader(axis)
                    except Exception as error: result[axis][key] = str(error)
        return result

    def stop_all(self, retry=False):
        if not self.authorized or not self.touched or (self.stop_requested and not retry): return
        self.stop_requested = True
        # Request STOP before gathering diagnostic snapshots. Stop the directly
        # commanded axes first, then the remaining members of the coupled group.
        axes = sorted(self.profile['axes'], key=lambda axis: axis not in self.saved_velocity)
        for axis in axes:
            try: self.put(axis, '.STOP', 1)
            except Exception as error: self.stop_errors.append(str(error))

    def cleanup(self):
        if not self.authorized: return []
        errors = []
        self.stop_all(retry=bool(self.stop_errors))
        errors.extend(self.stop_errors)
        try: self.restore_state_machine()
        except Exception as error: errors.append('restore state machine: '+str(error))
        try: self.restore_encoder_hold()
        except Exception as error: errors.append('restore encoder inspection hold: ' + str(error))
        if not self.touched: return errors
        end = time.monotonic() + self.profile['timeout']
        try:
            while not self.idle():
                if time.monotonic() >= end: raise RuntimeError('cleanup: axes did not stop')
                time.sleep(.02)
        except Exception as error: errors.append(str(error))
        for axis, value in self.saved_velocity.items():
            try: self.put(axis, '.VELO', value)
            except Exception as error: errors.append(str(error))
        return errors
