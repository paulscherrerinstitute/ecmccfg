#!/usr/bin/env python3
"""Offline checks for the relay-coupled slit plant and live test discovery.

No IOC is accessed. Production controller timers are covered separately by
encoder-power/encoder_power_checks.cpp; live CA timing is tested by the group.
"""
from itertools import product
from pathlib import Path
import sys
from unittest.mock import patch

root = Path(__file__).resolve().parents[2]
sys.path[:0] = [str(root/'tools/simulation'), str(root/'tests/integration')]
import slit.plant as module
from slit.run import make_suite

config = dict(drive_slave=12, encoder_slave=9, encoder_channel='01',
              internal_counts_per_mm=12800, absolute_counts_per_mm=4096,
              absolute_offset_mm=-1380, absolute_bits=26,
              encoder_power={'slave': 5, 'channel': '04'})
for high, off_raw in product((False, True), (0, 0xffffffff)):
    blade = module.Blade(config, .2)
    blade.encoder_power_polarity = high
    blade.encoder_power_delay = .05
    blade.encoder_power_off_raw = off_raw
    # An off supply overrides even frozen feedback, without moving mechanics.
    blade.inject(frozen=True)
    for _ in range(10):
        feedback, raw, ready = blade.step(0, 0, .01, encoder_power=not high)
        assert raw == off_raw and ready == 0 and blade.position_mm == .2
        assert feedback.position == 2560
    for _ in range(4):
        assert blade.step(0, 0, .01, encoder_power=high)[1:] == (off_raw, 0)
    feedback, raw, ready = blade.step(0, 0, .011, encoder_power=high)
    assert raw == round(1380.2*4096) and ready == 4
    blade.inject(ready=False)
    assert blade.step(0, 0, .01, encoder_power=high)[2] == 0
    blade.step(0, 0, .01, encoder_power=not high)
    assert blade.encoder_supply_seconds == 0
    assert blade.step(0, 0, .01, encoder_power=high)[1:] == (off_raw, 0)

blade = module.Blade(config, .2)
blade.inject(encoder_bias_mm=.004)
assert blade.step(0, 0, .01)[1] == round(1380.204*4096)
assert blade.position_mm == .2
for value in (float('nan'), float('inf'), True):
    try: blade.inject(encoder_bias_mm=value)
    except ValueError: pass
    else: raise AssertionError('invalid bias accepted')

# Execute the actual Plant.run I/O path with a deterministic clock and relay
# inputs. This verifies the EL5042 output PV receives zero, rather than only
# testing the Blade return value.
class Clock:
    now = 1.
    def monotonic(self): return self.now
    def advance(self, dt): self.now += dt

for high, off_raw, diagnostics in product((False, True), (0, 0xffffffff), range(4)):
    clock = Clock()
    writes = []
    class Stop:
        count = 0
        def is_set(self):
            if self.count == 0:
                plant.configure_encoder_power('TR_HI', high, .025, off_raw=off_raw)
                plant.inject('TR_HI', encoder_error=bool(diagnostics & 2),
                             encoder_warning=bool(diagnostics & 1))
            return self.count >= 5
        def set(self): self.count = 5
        def wait(self, seconds):
            clock.advance(max(.01, seconds)); self.count += 1
            return self.is_set() if self.count >= 5 else False
    class PV:
        connected = read_access = write_access = True
        def __init__(self, name, **_): self.pvname = name
        def wait_for_connection(self, **_): return True
        def get(self, **_):
            clock.advance(.001)
            if self.pvname.endswith('.RTYP'):
                return ('int64in' if '-RB.' in self.pvname else
                        'mbboDirect' if 'encoderStatus' in self.pvname else 'int64out')
            if self.pvname.endswith('binaryOutput04'):
                powered = plant.stop.count in (1, 2, 3)
                return int(high if powered else not high)
            return 5652480
        def put(self, value, **_):
            writes.append((plant.stop.count, self.pvname, value)); clock.advance(.001)
            return 1
        def disconnect(self): self.connected = False
    class IO:
        def __init__(self, *_): pass
        def connect(self): pass
        def initial_position(self): return 0
        def read(self): clock.advance(.001); return 0, 0
        def publish(self, feedback): pass
        def withdraw(self, feedback): pass
        def close(self): pass
    plant = module.Plant({'physical': {'TR_HI': config}}, 'TEST:SIM:', PV, None)
    plant.stop = Stop()
    with patch.object(module.el7041, 'EpicsIO', IO), patch.object(module.time, 'monotonic', clock.monotonic):
        plant.run()
    assert plant.error is None, plant.error
    raw = {cycle: value for cycle, name, value in writes if name.endswith('positionActual01')}
    status = {cycle: value for cycle, name, value in writes if name.endswith('encoderStatus01')}
    assert raw[0] == raw[1] == raw[4] == off_raw, raw
    assert raw[3] == 5652480 and status[3] == (4 | diagnostics)
    assert status[0] == status[4] == diagnostics

cases = list(make_suite(None, ('open', 'closed'), ('encoder_power',)))
assert len(cases) == 32 and {c.loop for c in cases} == {'open', 'closed'}
assert all(c.rig is None for c in cases)
print('Slit encoder power: zero on EL5042 PV while off, warmup, polarities, physical counter isolation, and 32 live cases pass offline checks.')

# Exercise the live fixture's actual setup/cleanup with configuration/CA
# boundaries. The production SM behavior of these flags is checked separately
# by test_master_slave_start.py, including the original failing flag value.
from types import SimpleNamespace
from slit.cases.encoder_power import EncoderPowerTests

for original_flag in (0, 1):
    settings = dict(EncConfigIndex=1, EncPwrEnable=0, EncPwrPol=1,
                    EncPwrDelay=.1, EncPwrTimeout=5, EncPwrOffDelay=2,
                    EnableAutoDisable=original_flag, AutoDisableAfterTime=2,
                    EnableAutoEnable=1, AutoEnableTimeout=2,
                    CntrlDeadband=.01, CntrlDeadbandTime=100)
    original = dict(settings)
    calls = []
    class Fixture(EncoderPowerTests):
        def query(self, key): return settings[key]
        def config(self, key, value, full=False):
            calls.append((key, value))
            if full:
                assert key == 'SelectAxisEncConfig'
                settings['EncConfigIndex'] = value
            else:
                settings[key] = value
                if key == 'AutoDisableAfterTime': settings['EnableAutoDisable'] = int(value > 0)
        def state(self): return 1
        def wait_off(self): assert settings['EncPwrEnable'] == 1
    def wait(predicate, description, timeout): assert predicate(), description
    def configure(*args, **kwargs): calls.append(('plant supply', kwargs))
    case = Fixture('test_active_low_relay')
    case.loop = 'open'
    case.rig = SimpleNamespace(
        profile={'axes': {'TR_HI': 6}, 'physical': {'TR_HI': config}},
        prepare=lambda loop: calls.append(('prepare', loop)),
        open_text_commands=lambda: {}, close_text_commands=lambda saved: None,
        get=lambda axis, field: 2 if field == '-Ctrl-Kp' else 0,
        put=lambda axis, field, value: calls.append((field, value)),
        stop_all=lambda: [], wait_drive_disabled=lambda axis: None,
        wait=wait, drive_status=lambda axis: 0, encoder_status=lambda axis: 4,
        reset=lambda: calls.append(('reset', None)),
        plant=SimpleNamespace(configure_encoder_power=configure))
    case.setUp()
    assert settings['EnableAutoDisable'] == 1
    assert settings['AutoDisableAfterTime'] >= 60 > settings['EncPwrOffDelay']
    assert settings['EncPwrEnable'] == 1
    assert case.doCleanups()
    assert settings == original, (settings, original)
print('Encoder-power fixture: long positive drive idle timeout retains SM policy; native settings and encoder selection restore independently.')

# Logical Off/raw zero/ready low can all predate a polarity change. A bounded
# wait must include the new relay output; a permanently wrong output must fail.
for relay_words, accepted in (((0, 0, 1), True), ((0, 0, 0), False)):
    relay_word = [0]
    attempts = []
    case = EncoderPowerTests('test_active_low_relay')
    case.off_raw = 0
    case.query = lambda key: 0  # active-low: physical off must be output 1
    case.state = lambda: 1
    case.raw = lambda: 0
    case.relay = lambda: relay_word[0]
    def observe(predicate, description, timeout):
        for value in relay_words:
            relay_word[0] = value
            attempts.append(value)
            if predicate(): return
        raise AssertionError('timeout: ' + description)
    case.rig = SimpleNamespace(wait=observe, check_native_error=lambda axis: None,
                               encoder_status=lambda axis: 0)
    try:
        case.wait_off()
    except AssertionError:
        assert not accepted
    else:
        assert accepted and attempts == [0, 0, 1]
print('Encoder relay polarity: stale Off/ready/raw snapshots wait for the new output; a stuck wrong output still fails.')

# Execute the actual motor case and dwell assertion with independent native
# settling/power timing and deliberately slower motor fields. A prematurely
# powered-off encoder must still fail the same dwell assertion.
from slit.rig import Rig
import slit.cases.encoder_power as power_cases

for power_off_time, accepted in ((1.0, True), (.4, False)):
    clock = Clock()
    clock.now = 0.
    observations = []
    class MotorRig:
        def get(self, axis, suffix):
            if suffix == '-Busy': return 1
            if suffix in ('-AtTarget', '-EnaAct'): return 1
            if suffix == '.DMOV': return int(clock.now >= 1.3)
            if suffix == '.MOVN': return int(clock.now < 1.3)
            raise AssertionError(suffix)
        def put(self, axis, suffix, value): assert (suffix, value) == ('.VAL', .25)
        def encoder_status(self, axis): return 4 if clock.now < power_off_time else 0
        def check_native_error(self, axis): pass
        def snapshot(self): return {'time': clock.now}
        def wait(self, predicate, description, timeout=15):
            end = clock.now + timeout
            while clock.now < end:
                if predicate():
                    observations.append((description, clock.now))
                    return
                clock.advance(.025)
            raise AssertionError('timeout: ' + description)
        assert_stays = Rig.assert_stays
    case = EncoderPowerTests('test_motor_request_auto_enables_after_encoder_ready')
    case.rig = MotorRig()
    case.off_raw = 0
    case.arrive = lambda target: observations.append(('native atTarget', clock.now))
    case.query = lambda key: 1
    case.state = lambda: 3 if clock.now < power_off_time else 1
    case.raw = lambda: 123 if clock.now < power_off_time else 0
    case.relay = lambda: int(clock.now < power_off_time)
    with patch.object(power_cases.time, 'monotonic', clock.monotonic):
        try:
            case.test_motor_request_auto_enables_after_encoder_ready()
        except AssertionError:
            assert not accepted
        else:
            assert accepted
            assert observations[-1][0] == 'motor flags settle after powered move'
            assert observations[-1][1] >= 1.3
            assert any('post-settling dwell' in name and when < 1.0
                       for name, when in observations)
print('Motor power dwell: native timing precedes delayed DMOV/MOVN; premature encoder power-off remains a failure.')


# STOP checks displacement, not proximity to an ideal zero. Exercise the real
# live-case method with the observed initial offset and with replay faults.
for initial, replay, accepted in ((-.00274, None, True), (.003, None, True),
                                  (-.00274, 'position', False),
                                  (-.00274, '-Busy', False),
                                  (-.00274, '-ExeCmd-RB', False)):
    clock = Clock()
    clock.now = 0.
    class StopRig:
        def __init__(self):
            self.stopped = False
            self.plant = SimpleNamespace(physical_position=self.position)
        def position(self, axis):
            return initial + (.02 if replay == 'position' and clock.now >= .8 else 0)
        def get(self, axis, suffix):
            assert suffix in ('-Busy', '-ExeCmd-RB')
            return int(not self.stopped or (replay == suffix and clock.now >= .8))
        def put(self, axis, suffix, value):
            assert (suffix, value) == ('-StpCmd', 1)
            self.stopped = True
        def check_native_error(self, axis): pass
        def snapshot(self): return {'time': clock.now, 'position': self.position('TR_HI')}
        def wait(self, predicate, description, timeout=15):
            end = clock.now + timeout
            while clock.now < end:
                if predicate(): return
                clock.advance(.025)
            raise AssertionError('timeout: ' + description)
        assert_stays = Rig.assert_stays
    case = EncoderPowerTests('test_stop_cancels_power_up')
    case.rig = StopRig()
    case.config = lambda key, value: None
    case.start = lambda target: None
    case.state = lambda: 2
    with patch.object(power_cases.time, 'monotonic', clock.monotonic):
        try:
            case.test_stop_cancels_power_up()
        except AssertionError:
            assert not accepted, (initial, replay)
        else:
            assert accepted, (initial, replay)
print('STOP during encoder warmup: initial position offsets pass; displacement, Busy or Execute replay still fail.')

# Late-ready gating must hold the pre-command position, including ordinary
# setup offsets. Keep the original 2 um displacement bound and require the
# drive to remain disabled throughout the post-minimum-delay observation.
for initial, defect, accepted in ((-.002112001, None, True), (.003, None, True),
                                  (0, None, True),
                                  (-.002112001, 'position', False),
                                  (-.002112001, 'start_motion', False),
                                  (-.002112001, 'enabled', False),
                                  (-.002112001, 'ready_early', False),
                                  (-.002112001, 'fault', False)):
    clock = Clock()
    clock.now = 0.
    class LateReadyRig:
        def __init__(self):
            self.requested = False
            self.arrived = False
            self.plant = SimpleNamespace(physical_position=self.position,
                                         configure_encoder_power=self.configure)
        def configure(self, axis, active_high, startup_delay):
            assert active_high and startup_delay == .8
        def position(self, axis):
            premature = (self.requested and defect == 'start_motion' or
                         defect == 'position' and clock.now >= .35)
            return initial + (.003 if premature else 0)
        def get(self, axis, suffix):
            assert suffix == '-EnaAct'
            return int(defect == 'enabled' and clock.now >= .35)
        def check_native_error(self, axis):
            if defect == 'fault' and clock.now >= .35:
                raise AssertionError('unexpected native axis error')
        def snapshot(self): return {'time': clock.now, 'position': self.position('TR_HI')}
        def wait(self, predicate, description, timeout=15):
            end = clock.now + timeout
            while clock.now < end:
                if predicate(): return
                clock.advance(.025)
            raise AssertionError('timeout: ' + description)
        assert_stays = Rig.assert_stays
    case = EncoderPowerTests('test_late_ready_holds_motion_after_minimum_delay')
    case.rig = LateReadyRig()
    case.start = lambda target: setattr(case.rig, 'requested', True)
    case.arrive = lambda target: setattr(case.rig, 'arrived', True)
    case.state = lambda: 3 if defect == 'ready_early' and clock.now >= .35 else 2
    with patch.object(power_cases.time, 'monotonic', clock.monotonic):
        try:
            case.test_late_ready_holds_motion_after_minimum_delay()
        except AssertionError:
            assert not accepted, (initial, defect)
            assert not case.rig.arrived
        else:
            assert accepted and case.rig.arrived and clock.now >= .45, (initial, defect)
print('Late readiness: initial offsets pass; motion before/during the hold, early enable/readiness and faults fail.')

# Off-state diagnostics use the same pre-motion hold requirement. A position
# that is valid under arrive()'s tolerance must not be compared with the exact
# nominal target, while real displacement during warm-up must still fail.
source = (root/'tests/integration/slit/cases/encoder_power.py').read_text()
diagnostics = source[source.index('    def off_state_diagnostics'):
                     source.index('    def test_encoder_error_while_powered_off')]
assert 'before = self.rig.plant.physical_position(self.axis)' in diagnostics
assert 'physical_position(self.axis)-before' in diagnostics
assert 'physical_position(self.axis)-.15' not in diagnostics
print('Off-state diagnostics: warm-up motion is measured from the actual settled position.')
