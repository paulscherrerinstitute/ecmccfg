#!/usr/bin/env python3
"""Verify physical homing inputs and strict Busy/DMOV/MOVN/Homed verdicts.

This is a controlled boundary probe of the live harness. Real homing math is
covered separately by test_homing_sequences.py using production motion code.
"""
from pathlib import Path
import sys
import threading
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'tools/simulation'))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'integration'))
from slit.plant import Blade, Plant, HomingInputs
from slit.rig import Rig
from slit.cases.homing import HomingTests
from slit.run import DEFAULT_CONFIG, make_suite

config = dict(drive_slave=12, internal_counts_per_mm=12800,
              absolute_counts_per_mm=4096, absolute_offset_mm=-1380, absolute_bits=26)
for position, low, home, high in ((-.45, 0, 0, 1), (-.08, 1, 1, 1), (0, 1, 1, 1),
                                 (.08, 1, 1, 1), (.1, 1, 0, 1), (.45, 1, 0, 0)):
    blade = Blade(config, position)
    blade.homing_inputs = HomingInputs()
    feedback, raw, ready = blade.step(0, 0, 0)
    assert (feedback.drive_status >> 11 & 1, feedback.drive_status >> 13 & 1,
            feedback.drive_status >> 12 & 1) == (low, home, high)
    assert blade.position_mm == position
    assert feedback.position == int(position*12800) % 65536
    assert raw == round((position+1380)*4096) and ready == 4
    blade.homing_inputs = HomingInputs(cam_enabled=False)
    assert not blade.step(0, 0, 0)[0].drive_status & (1 << 13)

blade = Blade(config, .81)
blade.homing_inputs = HomingInputs()
try: blade.step(0, 0, 0)
except RuntimeError: pass
else: raise AssertionError('physical travel watchdog must not be disabled by coordinate homing')
for kwargs in (dict(low_mm=.1), dict(cam_high_mm=float('nan')), dict(travel_bound_mm=.3)):
    try: HomingInputs(**kwargs)
    except ValueError: pass
    else: raise AssertionError('invalid homing geometry accepted')
plant = Plant({}, '', None, None)
plant.blades['TR_HI'] = Blade(config)
plant.configure_homing('TR_HI', HomingInputs())
plant.clear_faults()
assert plant.blades['TR_HI'].homing_inputs is None
assert plant.physical_position('TR_HI') == 0


class Probe(Rig):
    def __init__(self):
        super().__init__({'axes': {'TR_HI': 6}, 'physical': {'TR_HI': {}}}, 'TEST:', None, None)
        self.plant = self
        self.clock = 0
        self.flags = {'-Busy': 0, '.DMOV': 1, '.MOVN': 0, '-Homed': 1,
                      '-SeqState': 0, '-ErrId': 0, '.LVIO': 0, '.SEVR': 0, '.MSTA': 0}
        self.lag = False
    def get(self, axis, suffix):
        if self.lag and self.clock < 2 and suffix in ('.DMOV', '.MOVN'):
            return 0 if suffix == '.DMOV' else 1
        return self.flags[suffix]
    def physical_position(self, axis): return .1
    def snapshot(self): return dict(self.flags)
    def _drive_stationary(self, axis): return self.flags['-Busy'] == 0
    def wait(self, predicate, description, timeout=15):
        for self.clock in range(4):
            if predicate(): return
        raise AssertionError(description)


def case():
    result = HomingTests('test_motor_sequence_01')
    result.rig, result.complete = Probe(), None
    return result

c = case(); c.rig.lag = True
c.finish_home()
assert c.rig.clock == 2, 'must allow motor flags to lag native completion'
for flag, value in (('-Busy', 1), ('.DMOV', 0), ('.MOVN', 1), ('-Homed', 0),
                    ('-ErrId', 0x14d04), ('.LVIO', 1), ('.SEVR', 2), ('-SeqState', 3)):
    c = case(); c.rig.flags[flag] = value
    try: c.finish_home()
    except AssertionError: pass
    else: raise AssertionError('homing completion missed invalid ' + flag)
c = case(); c.complete = threading.Event()
try: c.finish_home()
except AssertionError: pass
else: raise AssertionError('motor homing must wait for its own completion callback')
c.complete.set(); c.finish_home()

# Reset may publish motor MOVN/DMOV later than the native stopped state.
# Exercise the real recovery predicate with delayed and permanently wrong
# motor flags, plus native faults occurring inside that settling interval.
class AbortRecoveryProbe(Probe):
    def __init__(self, bad=None):
        super().__init__()
        self.flags['-Homed'] = 0
        self.lag, self.bad, self.held = True, bad, False
    def get(self, axis, suffix):
        if self.clock == 1 and suffix == self.bad:
            return 0x1460e if suffix == '-ErrId' else 1
        if self.bad == 'motor' and suffix in ('.DMOV', '.MOVN'):
            return int(suffix == '.MOVN')
        return super().get(axis, suffix)
    def physical_position(self, axis):
        return .2 if self.bad == 'drift' and self.clock == 1 else .1
    def _drive_stationary(self, axis):
        return not (self.bad == 'velocity' and self.clock == 1)
    def assert_stays(self, predicate, description, seconds=1):
        assert self.clock == 2, 'must first wait for delayed motor flags'
        for self.clock in range(2, 6):
            assert predicate(), description
        self.held = True

for bad in (None, 'motor', '-Busy', '-SeqState', '-Homed', '-ErrId', 'drift', 'velocity'):
    c = case(); c.rig = AbortRecoveryProbe(bad)
    try: c.verify_abort_recovery(.1)
    except AssertionError:
        assert bad is not None
        assert not c.rig.held
    else:
        assert bad is None, 'abort recovery accepted ' + str(bad)
        assert c.rig.held
print('Homing recovery: delayed motor flags settle; persistent flags, native restart, false Homed and drift fail.')

for bad in (None, '-Busy', '.DMOV', '.MOVN', '-Homed'):
    c = case()
    c.rig.flags.update({'-Busy': 1, '.DMOV': 0, '.MOVN': 1, '-Homed': 0})
    if bad: c.rig.flags[bad] = int(not c.rig.flags[bad])
    assert c.moving_flags() == (bad is None)

suite = list(make_suite(None, ('closed',), ('homing',)))
# 22 motor cases, 24 native cases (including both index terminals), and the
# shared permission regression.
assert len(suite) == 47
assert sum(test.id().endswith('test_ignore_disabled_motion_commands')
           for test in suite) == 1
assert sum('test_motor_' in test.id() for test in suite) == 22
assert sum('test_native_' in test.id() for test in suite) == 24
assert any(t.id().endswith('test_native_sequence_11_el5102_index') for t in suite)
assert any(t.id().endswith('test_native_sequence_11_el7062_touch_probe_index') for t in suite)
for sequence in (1,2,3,4,5,6,7,8,9,10,14,21,22):
    for trigger in ('motor', 'native'):
        assert any(test.id().endswith(f'test_{trigger}_sequence_{sequence:02d}') for test in suite)
assert any(t.id().endswith('test_motor_sequence_25') for t in suite)
assert any(t.id().endswith('test_native_sequence_15') for t in suite)
if DEFAULT_CONFIG.exists():
    startup = (DEFAULT_CONFIG / 'startup.cmd').read_text()
    marker = (DEFAULT_CONFIG / 'test-marker.db').read_text()
    assert 'SIM:SlitTest:HomingSchema' in marker
    assert 'field(INP,"3")' in marker and 'field(VAL,"3")' in marker
    # The real Jinja template loads HomProc/OMSL, HomPos, speeds and AccHom
    # only when the axis YAML declares homing. Startup Cfg commands alone do
    # not cause these records to exist (the live setup failure).
    import yaml
    from jinja2 import Environment
    template_path = Path(__file__).resolve().parents[2] / 'scripts/jinja2/templates/epicsMotorRecord.jinja2'
    template_source = template_path.read_text()
    start = template_source.index('#- Motor record: homing')
    home_records = Environment().from_string(template_source[start:])
    for filename in ('axis_ax5_LO.yaml', 'axis_ax6_HI.yaml'):
        data = yaml.safe_load((DEFAULT_CONFIG / 'cfg' / filename).read_text())
        data['epicsName'] = data['epics']['name']
        rendered = home_records.render(**data)
        assert 'dbLoadRecords(ecmcMotorRecordhome.template' in rendered
        assert data['encoder']['homing']['type'] == 1
        assert data['encoder']['homing']['velocity'] == {'to': .2, 'from': .1}
        del data['encoder']['homing']
        assert 'dbLoadRecords(ecmcMotorRecordhome.template' not in home_records.render(**data)
    for axis, label in ((5,'LO'),(6,'HI')):
        document = yaml.safe_load((DEFAULT_CONFIG/f'cfg/axis_ax{axis}_{label}.yaml').read_text())
        assert document['input']['home'] == 'ec${M_ID=0}.s$(DRV_SLAVE).driveStatus01.13'
        assert document['input']['homePolarity'] == 0
        for encoder_file in (f'axis_ax{axis}_{label}.yaml', 'biss-c.yaml'):
            home = yaml.safe_load((DEFAULT_CONFIG/'cfg'/encoder_file).read_text())['encoder']['homing']
            assert home['type'] == 1 and home['timeout'] == 12 and home['latchCount'] == 1
    assert 'Cfg.SetAxisHome' not in startup
    assert 'ax5.mon.homesensor' not in startup and 'ax6.mon.homesensor' not in startup
print('Slit homing: sensor geometry, physical bounds, motor/native matrix and strict delayed completion flags passed.')

# Execute the real reference cleanup with deliberately inconsistent references.
# Each encoder must be re-referenced to measured physical position before the
# explicit return move; settings and disabled state must be restored afterward.
class CleanupClient:
    def __init__(self, rig): self.rig = rig
    def put(self, name, value, **kwargs):
        assert name == 'TEST:TR_HI.HOMF' and kwargs['wait'] is False
        assert self.rig.fields['-HomProc'] == 25
        self.rig.positions[self.rig.encoder] = self.rig.fields['-HomPos']
        self.rig.homed_encoders.append(self.rig.encoder)
        event = threading.Event(); event.set()
        return event

class CleanupProbe(Probe):
    def __init__(self):
        super().__init__()
        self.client = CleanupClient(self)
        self.encoder, self.positions, self.homed_encoders = 2, {1: 111., 2: -222.}, []
        self.physical_mm = .17
        self.reference_synced = False
        self.fields = {'-EnaAct': 0, '-HomProc': 7, '-HomPos': 0, '-VelAct': 0}
    def get(self, axis, suffix):
        if suffix == '-PosAct': return self.positions[self.encoder]
        return self.fields[suffix] if suffix in self.fields else super().get(axis, suffix)
    def put(self, axis, suffix, value):
        self.fields[suffix] = value
        if suffix == '-EnaCmd': self.fields['-EnaAct'] = value
        if suffix == '-SetEncIdCmd-RB': self.encoder = value
        if suffix in ('-CfgDLLM', '-CfgDHLM') and hasattr(self, 'return_target'):
            assert self.reference_synced, 'motor must acknowledge new reference before limits are restored'
        if suffix == '-CfgDLLM':
            self.fields['-CfgDLLM-RB'] = value
            if self.fields.get('-CfgSyncSftLim'): self.fields.update({'.LLM': value, '.DLLM': value})
        if suffix == '-CfgDHLM':
            self.fields['-CfgDHLM-RB'] = value
            if self.fields.get('-CfgSyncSftLim'): self.fields.update({'.HLM': value, '.DHLM': value})
        if suffix in ('-CfgDLLM-En', '-CfgDHLM-En'): self.fields[suffix+'-RB'] = value
        if suffix == '.DLLM': self.fields['.LLM'] = value
        if suffix == '.DHLM': self.fields['.HLM'] = value
        if suffix == '-ExeCmd' and value and hasattr(self, 'return_target'):
            if not getattr(self, 'ignore_return', False): self.native_move(axis, self.return_target)
    def physical_position(self, axis): return self.physical_mm
    def clear_faults(self): pass
    def stop_all(self): self.fields['-EnaAct'] = 0; return []
    def reset(self): pass
    def sync_motor_record(self, axis):
        assert abs(self.positions[self.encoder]) < .01
        self.reference_synced = True
    def encoder_status(self, axis): return 4
    def drive_status(self, axis): return 0
    def wait_drive_disabled(self, axis): assert self.fields['-EnaAct'] == 0
    def stage_native(self, axis, command, position=0):
        assert command == 3
        assert self.homed_encoders == [1, 2]
        assert all(abs(pos-self.physical_mm) < .002 for pos in self.positions.values())
        self.return_target = position
    def native_move(self, axis, target):
        assert self.homed_encoders == [1, 2]
        assert all(abs(pos-self.physical_mm) < .002 for pos in self.positions.values())
        delta = target-self.physical_mm
        self.physical_mm = target
        self.positions = {enc: pos+delta for enc, pos in self.positions.items()}

for loop in ('open', 'closed'):
    c = case(); c.rig = CleanupProbe(); c.loop = loop
    c.saved = {field: 0 for field in ('-HomProc', '-HomPos', '-VelToHom', '-VelFrmHom', '-AccHom',
                                     '-HomUseHVEL', '-CfgSyncSftLim', '-HomProc.OMSL',
                                     '-MtnCmd_.DISA', '-MtnCmd_.DISV')}
    c.saved.update({'-CfgDLLM-RB': -1, '-CfgDHLM-RB': 1, '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1,
                    '.LLM': -1, '.HLM': 1, '.DLLM': -1, '.DHLM': 1})
    c.restore_reference()
    assert c.rig.encoder == (1 if loop == 'open' else 2)
    assert c.rig.physical_mm == 0 and c.rig.fields['-EnaAct'] == 0
    assert c.rig.fields['-CfgSyncSftLim'] == 0
print('Homing cleanup: both encoder references restored without resetting plant counters, then normal zero move and disable.')

# Real start_home(): the request PV remains 14 even while the sequencer uses
# encoder-configured procedure 1. Do not accept a changed request value.
class RequestClient:
    def __init__(self, rig): self.rig = rig
    def put(self, name, value, **kwargs):
        assert name.endswith(('.HOMF', '.HOMR')) and kwargs['wait'] is False
        self.rig.start_request(self.rig.fields['-HomProc'])
        return threading.Event()

class RequestProbe(CleanupProbe):
    def __init__(self, changed_request=False):
        super().__init__()
        self.client = RequestClient(self)
        self.changed_request = changed_request
    def start_request(self, request):
        self.fields['-MtnCmdData'] = 1 if self.changed_request else request
        self.flags.update({'-Busy': 1, '.DMOV': 0, '.MOVN': 1, '-Homed': 0})
    def put(self, axis, suffix, value):
        super().put(axis, suffix, value)
        if suffix == '-ExeCmd' and value: self.start_request(self.fields['-MtnCmdData'])

for trigger in ('motor', 'native'):
    for changed in (False, True):
        c = case(); c.rig = RequestProbe(changed)
        try:
            c.start_home(14, trigger)
        except AssertionError:
            assert changed
        else:
            assert not changed, 'changed command request must not be accepted'
print('Homing 14: actual motor/native start helpers require request 14, without confusing it with resolved status.')

# Reproduce the ordering hazard without relying on network speed: collecting
# a whole-IOC snapshot during a short search must fail this boundary probe.
# Actual moving flags remain mandatory for both trigger paths.
class ShortSearchProbe(RequestProbe):
    def snapshot(self):
        raise AssertionError('full snapshot delayed observation of the running search')

for trigger in ('motor', 'native'):
    c = case(); c.rig = ShortSearchProbe()
    c.start_home(9, trigger)
    assert c.moving_flags()
    assert c.rig.trace[-1]['action'] == 'homing triggered'
print('Homing timing: both trigger paths observe motion before any full IOC snapshot.')

# All six open-loop skips happen before any IOC access or cleanup registration.
for method in ('test_motor_sequence_21', 'test_motor_sequence_22',
               'test_native_sequence_21', 'test_native_sequence_22',
               'test_motor_abort_encoder', 'test_native_abort_encoder'):
    c = HomingTests(method)
    c.loop, c.rig = 'open', object()  # Any IOC access would fail.
    try: c.setUp()
    except unittest.SkipTest: pass
    else: raise AssertionError('inapplicable case reached setup')
    assert c._cleanups == []

# Cleanup can start essentially at zero, with no externally observable Busy
# pulse. It must still fail an ignored return when meaningfully displaced.
for position, ignored in ((0, False), (4.4e-6, False), (.17, True)):
    c = case(); c.rig = CleanupProbe(); c.loop = 'open'
    c.rig.physical_mm, c.rig.ignore_return = position, ignored
    c.saved = {field: 0 for field in ('-HomProc', '-HomPos', '-VelToHom', '-VelFrmHom', '-AccHom',
                                     '-HomUseHVEL', '-CfgSyncSftLim', '-HomProc.OMSL',
                                     '-MtnCmd_.DISA', '-MtnCmd_.DISV')}
    c.saved.update({'-CfgDLLM-RB': -1, '-CfgDHLM-RB': 1, '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1,
                    '.LLM': -1, '.HLM': 1, '.DLLM': -1, '.DHLM': 1})
    try: c.restore_reference()
    except AssertionError: assert ignored
    else: assert not ignored, 'cleanup accepted an ignored nonzero return'
print('Homing applicability/cleanup: skips touch no IOC state; zero-distance completion passes; ignored displaced return fails.')

# Independent motor 0/0 limits are valid with sync off. Restore them without
# touching the enabled -1/+1 controller pair; reject broken sync isolation.
for broken in (False, True):
    c = case(); c.rig = CleanupProbe()
    c.saved = {'-CfgSyncSftLim': 0, '.LLM': 0, '.HLM': 0, '.DLLM': 0, '.DHLM': 0,
               '-CfgDLLM-RB': -1, '-CfgDHLM-RB': 1, '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1}
    c.rig.fields.update(c.saved)
    original_put = c.rig.put
    def put(axis, field, value):
        original_put(axis, field, value)
        if field in ('.DLLM', '.DHLM'):
            assert c.rig.fields['-CfgSyncSftLim'] == 0
            if broken: c.rig.fields['-CfgDLLM-RB'] = 0
    c.rig.put = put
    try: c.restore_independent_motor_limits()
    except AssertionError: assert broken
    else: assert not broken
print('Homing limit restore: independent motor 0/0 accepted; controller overwrite with sync off rejected.')

# Run the full cleanup with no config-to-motor propagation while sync is off.
# Turning sync on would fail immediately; independent motor 0/0 must survive.
class IndependentCleanupProbe(CleanupProbe):
    def put(self, axis, field, value):
        if field == '-CfgSyncSftLim': assert value == 0, 'cleanup must not enable sync'
        super().put(axis, field, value)

c = case(); c.loop = 'open'; c.rig = IndependentCleanupProbe()
c.saved = {field: 0 for field in ('-HomProc', '-HomPos', '-VelToHom', '-VelFrmHom', '-AccHom',
                                 '-HomUseHVEL', '-CfgSyncSftLim', '-HomProc.OMSL',
                                 '-MtnCmd_.DISA', '-MtnCmd_.DISV', '.LLM', '.HLM', '.DLLM', '.DHLM')}
c.saved.update({'-CfgDLLM-RB': -1, '-CfgDHLM-RB': 1, '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1})
c.restore_reference()
assert all(c.rig.get(c.axis, field) == 0 for field in ('.LLM', '.HLM', '.DLLM', '.DHLM'))
assert c.rig.get(c.axis, '-CfgDLLM-RB') == -1 and c.rig.get(c.axis, '-CfgDHLM-RB') == 1
print('Full homing cleanup: sync remains disabled throughout; independent pairs restored without implicit propagation.')

# The public status2 holds the low byte of the internal sequencer state.
for bad in (None, '-SeqState', '-Homed', '-Busy', '.DMOV', '.MOVN'):
    c = case()
    c.rig.flags.update({'-SeqState': 1003 & 0xff, '-Homed': 1, '-Busy': 1, '.DMOV': 0, '.MOVN': 1})
    if bad: c.rig.flags[bad] = 1003 if bad == '-SeqState' else 1-c.rig.flags[bad]
    assert c.post_move_flags() == (bad is None)

# Run the actual post-home helper's registered cleanup after simulated teardown
# has cleared the switch scene. The cleanup search must rearm it first.
class PostRig(Probe):
    profile = {'axes': {'TR_HI': 6}}
    def __init__(self):
        super().__init__()
        self.selection, self.post_enabled, self.target = 2, 0, 0
        self.scene, self.reloaded, self.closed = None, False, False
    def open_text_commands(self): return {}
    def close_text_commands(self, saved): self.closed = True
    def text_command(self, text, query=False):
        name, args = text.rstrip(')').split('(')
        if query:
            return {'GetAxisEncConfigIndex': self.selection,
                    'GetAxisHomePostMoveEnable': self.post_enabled,
                    'GetAxisHomePostMoveTargetPosition': self.target}[name]
        value = float(args.split(',')[1])
        if name.endswith('SelectAxisEncConfig'): self.selection = int(value)
        elif name.endswith('SetAxisHomePostMoveEnable'): self.post_enabled = int(value)
        elif name.endswith('SetAxisHomePostMvPos'): self.target = value
        else: raise AssertionError(text)
    def stop_all(self): return []
    def reset(self): pass
    def configure_homing(self, axis, scene): self.scene = scene
    def physical_position(self, axis): return -.2
    def get(self, axis, field):
        if field == '-PosAct': return .2
        return super().get(axis, field)

c = case(); c.rig = PostRig(); c.loop = 'open'
c.configure_sensors = lambda: c.rig.configure_homing(c.axis, HomingInputs())
def start_home(sequence, trigger):
    assert sequence == 14 and c.rig.scene is not None, 'cleanup search needs live position-based switches'
    c.rig.flags.update({'-SeqState': 1003 & 0xff, '-Homed': 1, '-Busy': 1, '.DMOV': 0, '.MOVN': 1})
    if not c.rig.post_enabled: c.rig.reloaded = True
c.start_home, c.finish_home = start_home, lambda: None
c.post_home_move('motor')
c.rig.scene = None  # SlitCase.tearDown clears the optional scene.
assert c.doCleanups()
assert c.rig.reloaded and c.rig.closed and c.rig.selection == 2
assert c.rig.post_enabled == 0 and c.rig.target == 0
print('Post-home: packed phase 235 plus moving/Homed flags checked; cleanup rearms sensors after teardown before rehoming.')

# Completion/Homed can precede the new position PV. The physical edge and
# ramp-down correction must stay exact: only publication timing may settle.
class ReferenceProbe(Probe):
    def __init__(self, wrong=False, restarted=False):
        super().__init__()
        self.wrong, self.restarted = wrong, restarted
    def get(self, axis, field):
        if field == '-PosAct':
            return -.394 if self.wrong or self.clock < 2 else .006
        if field == '-Busy' and self.restarted: return 1
        return super().get(axis, field)
    def physical_position(self, axis): return -.394  # Stopped 6 um past the -0.4 edge.

for wrong, restarted in ((False, False), (True, False), (False, True)):
    c = case(); c.rig = ReferenceProbe(wrong, restarted)
    try: actual, physical = c.verify_switch_reference(1)
    except AssertionError: assert wrong or restarted
    else:
        assert not wrong and not restarted and c.rig.clock == 2
        assert abs(physical-actual+.4) < 1e-12
    assert c.rig.trace[-1]['expected_offset'] == -.4
print('Reference publication: delayed position settles; persistent 0.4 mm reference error and resumed motion fail.')


# Exercise the actual motor synchronization method within the full reference
# cleanup. Controller position is already zero while motor RBV is still 1380.
class DelayedReferenceCleanup(CleanupProbe):
    def __init__(self, stale=False):
        super().__init__()
        self.stale = stale
        self.fields.update({'.SYNC': 0, '.VAL': 1380})
    def get(self, axis, field):
        if field == '.RBV': return 1380 if self.stale or self.clock < 2 else self.positions[self.encoder]
        return super().get(axis, field)
    def put(self, axis, field, value):
        if field == '.SYNC':
            assert self.get(axis, '.RBV') < .002, 'SYNC must wait for actual motor readback'
            self.fields.update({'.SYNC': 0, '.VAL': self.get(axis, '.RBV')})
        else: super().put(axis, field, value)
    def sync_motor_record(self, axis):
        Rig.sync_motor_record(self, axis)
        self.reference_synced = True

for stale in (False, True):
    c = case(); c.loop = 'closed'; c.rig = DelayedReferenceCleanup(stale)
    c.saved = {field: 0 for field in ('-HomProc', '-HomPos', '-VelToHom', '-VelFrmHom', '-AccHom',
                                     '-HomUseHVEL', '-CfgSyncSftLim', '-HomProc.OMSL',
                                     '-MtnCmd_.DISA', '-MtnCmd_.DISV', '.LLM', '.HLM', '.DLLM', '.DHLM')}
    c.saved.update({'-CfgDLLM-RB': -1, '-CfgDHLM-RB': 1, '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1})
    try: c.restore_reference()
    except AssertionError:
        assert stale and not c.rig.reference_synced
        assert '-CfgDLLM-RB' not in c.rig.fields, 'stale readback must block limit restoration'
    else: assert not stale and c.rig.reference_synced
print('Absolute-home cleanup: delayed motor readback must acknowledge reference before narrow limits; stale readback blocks restoration.')


# Native manual 15 may start with all completion flags already true. Require
# the new coordinate too, rather than returning on those pre-command flags.
class ManualReferenceProbe(Probe):
    def __init__(self, ignored=False, drift=False):
        super().__init__()
        self.ignored, self.drift = ignored, drift
    def get(self, axis, field):
        if field == '-PosAct': return .2001 if self.ignored or self.clock < 2 else 0
        return super().get(axis, field)
    def physical_position(self, axis):
        return .204 if self.drift and self.clock == 1 else .2

for ignored, drift in ((False, False), (True, False), (False, True)):
    c = case(); c.rig = ManualReferenceProbe(ignored, drift)
    try: c.finish_home(expected_position=0, stationary_at=.2)
    except AssertionError: assert ignored or drift
    else:
        assert not ignored and not drift
        assert c.rig.clock == 2, 'old Homed/idle flags cannot acknowledge a manual reference'
print('Manual reference: pre-existing Homed/idle flags wait for position acknowledgement; ignored reference and physical movement fail.')

# Waiting for an abort phase must report a real controller fault immediately,
# rather than time out waiting for a sequence state that can no longer occur.
c = case()
c.rig.flags['-ErrId'] = 0x14c08
try:
    c.wait_home_phase(lambda: False, 'reverse search', 8)
except AssertionError as error:
    assert 'native motion fault 0x14c08' in str(error), error
    assert c.rig.clock == 0
else:
    raise AssertionError('homing phase wait ignored a following-error trip')
c = case()
c.wait_home_phase(lambda: c.rig.clock >= 2, 'observed search phase', 8)
assert c.rig.clock == 2

# A normal return can stop anywhere inside the fixture's 10 um atTarget window.
# Keep the tighter 2 um coordinate-reference checks; never alter the plant to
# make a final return pass. Physical and encoder residuals are checked separately.
class ResidualReturnCleanup(CleanupProbe):
    def __init__(self, physical_residual, encoder_residual):
        super().__init__()
        self.physical_residual, self.encoder_residual = physical_residual, encoder_residual
    def native_move(self, axis, target):
        super().native_move(axis, target)
        self.physical_mm += self.physical_residual
        self.positions = {enc: pos+self.encoder_residual for enc, pos in self.positions.items()}

for physical, encoder, accepted in ((.002611, .002588, True), (-.009, -.009, True),
                                     (.0101, 0, False), (0, -.0101, False)):
    c = case(); c.loop = 'closed'; c.rig = ResidualReturnCleanup(physical, encoder)
    c.saved = {field: 0 for field in ('-HomProc', '-HomPos', '-VelToHom', '-VelFrmHom', '-AccHom',
                                     '-HomUseHVEL', '-CfgSyncSftLim', '-HomProc.OMSL',
                                     '-MtnCmd_.DISA', '-MtnCmd_.DISV', '.LLM', '.HLM', '.DLLM', '.DHLM')}
    c.saved.update({'-CfgDLLM-RB': -1, '-CfgDHLM-RB': 1, '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1})
    try: c.restore_reference()
    except AssertionError:
        assert not accepted
        assert not c.rig.reference_synced
    else:
        assert accepted
        assert c.rig.reference_synced
        assert abs(c.rig.physical_mm-physical) < 1e-12
        assert abs(c.rig.positions[c.rig.encoder]-encoder) < 1e-12
print('Homing return cleanup: 10 um positioning tolerance; physical/encoder excesses fail without zeroing residuals.')
