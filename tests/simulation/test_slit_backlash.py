#!/usr/bin/env python3
"""Production mechanical play operator, encoder distinction and opt-in selection."""
from pathlib import Path
import math
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[2]/'tools/simulation'))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'integration'))
from slit.plant import Blade
from slit.run import make_suite
cfg = {'internal_counts_per_mm':12800, 'absolute_counts_per_mm':4096,
       'absolute_offset_mm':-1380, 'absolute_bits':26, 'drive_slave':12}
blade = Blade(cfg)
blade.step(1, 0, .1)
blade.step(1, 0, .1)
blade.configure_backlash(.1)
blade.step(1, 3277, .1)
assert abs(blade.drive_position_mm-.1) < .0001
assert abs(blade.position_mm-.05) < .0001
counter = blade.model.position_counts
blade.step(1, -3277, .05)
assert abs(blade.position_mm-.05) < .0001 and blade.model.position_counts < counter
blade.step(1, -3277, .05)
assert abs(blade.position_mm-.05) < .0001
feedback, raw, status = blade.step(1, -3277, .05)
assert abs(blade.position_mm) < .0001
assert abs(blade.drive_position_mm+.05) < .0001
assert abs((raw/4096-1380)-blade.position_mm) < 1/4096
counter_signed = (feedback.position+32768) % 65536-32768
assert abs(counter_signed/12800-blade.drive_position_mm) < 1/12800
assert blade.backlash_peak_gap >= .049
for invalid in (-.1, math.nan, math.inf, True):
 try: blade.configure_backlash(invalid)
 except ValueError: pass
 else: raise AssertionError('invalid backlash accepted')
blade.configure_backlash(0)
blade.step(1, 3277, .1)
assert blade.position_mm == blade.drive_position_mm
assert len(list(make_suite(None, ('open','closed'), ('backlash',)))) == 8
print('Mechanical backlash play, independent counter/encoder feedback, validation, cleanup and live test selection passed.')


# Execute the live physical-fault case through the real error/terminal-state
# checker. A slave fault can propagate to idle virtual masters too.
from types import SimpleNamespace
from threading import Event
from unittest.mock import Mock, patch
from slit.cases.backlash import BacklashTests


def physical_fault_case(errors):
    lag = {'tolerance': .04}
    def text_command(command, query=False):
        if query:
            assert command == 'GetAxisMonPosLagTol(6)'
            return lag['tolerance']
        assert command.startswith('Cfg.SetAxisMonPosLagTol(6,')
        lag['tolerance'] = float(command.split(',')[1].rstrip(')'))
    complete = Event()
    complete.set()
    names = ('TR_LO', 'TR_HI', 'CENTERY', 'GAPY')
    def get(axis, suffix):
        if suffix == '-ErrId': return errors.get(axis, 0)
        if suffix == '.DMOV': return 1
        if suffix == '.MSTA': return 1 << 9 if axis == 'TR_HI' else 0
        if suffix == '.SEVR': return 2 if axis == 'TR_HI' else 0
        if suffix == '-PosAct': return .1 if axis == 'TR_HI' else 0
        return 0
    rig = SimpleNamespace(
        open_text_commands=Mock(return_value={}), close_text_commands=Mock(),
        text_command=text_command,
        names=names, prefix='SIMSLIT:',
        profile={'axes': dict(zip(names, (5, 6, 12, 13))),
                 'physical': {'TR_LO': {}, 'TR_HI': {}}},
        get=get, client=SimpleNamespace(get=lambda name: 0 if name.endswith('MCU-ErrId') else 1),
        plant=SimpleNamespace(check=Mock(), backlash_state=lambda axis: {}),
        start_move=Mock(return_value=complete), motion_expectation=None,
        trace=[], snapshot=lambda: {})
    case = BacklashTests('test_large_physical_backlash_alarms_or_exposes_open_loop_error')
    case.rig, case.loop = rig, 'closed'
    try:
        with patch.object(case, 'enable_backlash'), patch.object(case, 'recover_after_fault') as recover:
            case.test_large_physical_backlash_alarms_or_exposes_open_loop_error()
            assert lag['tolerance'] == .02
            allowed = recover.call_args.args[0]
            assert allowed['TR_HI'] == (0x14c08,)
            assert 0x1432b in allowed['CENTERY'] and 0x1432b in allowed['GAPY']
    finally:
        assert case.doCleanups()
        assert lag['tolerance'] == .04
        rig.close_text_commands.assert_called_once_with({})


physical_fault_case({'TR_HI': 0x14c08})
physical_fault_case({'TR_HI': 0x14c08, 'CENTERY': 0x1432b, 'GAPY': 0x1432b})
for unexpected in ({'TR_HI': 0x14c08, 'CENTERY': 0xdead},
                   {'TR_HI': 0x14c08, 'TR_LO': 0x1432b}):
    try: physical_fault_case(unexpected)
    except AssertionError as error:
        assert 'unexpected error' in str(error), str(error)
    else: raise AssertionError('unrelated fault accepted by physical backlash case')
print('Physical backlash fault accepts master propagation and rejects unrelated faults.')


# Reset acknowledgements/readbacks may lag the write. Exercise the production
# helper with a virtual clock, including uncleared and newly appearing faults.
import slit_recovery


def reset_scenario(kind, managed=True):
    clock = SimpleNamespace(now=0.)
    clock.monotonic = lambda: clock.now
    def sleep(seconds): clock.now += seconds
    clock.sleep = sleep
    state = {'requested': False, 'writes': [], 'command': 0}
    def error():
        if not state['requested']: return 0xdead if kind == 'unknown_before' else 0x14c08
        if kind == 'unknown_after': return 0xdead
        return 0x14c08 if kind == 'stuck' or clock.now < .06 else 0
    def get(axis, suffix):
        if suffix == '-ErrId': return error()
        if suffix == '.DMOV': return 1
        if suffix == '-Busy' and state['requested'] and kind == 'restart': return 1
        return 0
    def client_get(name):
        if name.endswith(('MCU-AppMode', 'm0-Stat-OK')): return 1
        if name.endswith('MCU-ErrId'): return error()
        if name.endswith('SM00-EnaCmd'): return int(managed)
        if name.endswith('SM00-StateCmd'):
            return state['command'] if clock.now < .06 else 0
        raise AssertionError(name)
    def put(name, value, **kwargs):
        state['writes'].append((name, value, kwargs))
        if name.endswith('MCU-ErrRst'): state['requested'] = True
        if name.endswith('SM00-StateCmd'): state['command'] = value
    rig = SimpleNamespace(profile={'axes': {'TR_HI': 6}, 'physical': {'TR_HI': {}}},
                          prefix='SIMSLIT:', get=get, motion_expectation=None,
                          client=SimpleNamespace(get=client_get, put=put))
    with patch.object(slit_recovery, 'time', clock):
        try: slit_recovery.reset_known_errors(rig, {'TR_HI': (0x14c08,)})
        except AssertionError as exc:
            if kind == 'delayed': raise
            if kind == 'stuck': assert 'timeout:' in str(exc)
            elif kind == 'restart': assert 'restarted' in str(exc)
            else: assert 'unexpected error' in str(exc)
            if kind == 'unknown_before': assert state['writes'] == []
        else:
            assert kind == 'delayed', 'invalid reset accepted: '+kind
            assert clock.now >= .06
            assert len(state['writes']) == (3 if managed else 2)
            assert state['writes'][-1] == (
                'SIMSLIT:TR_HI.STOP', 1, {'wait': False, 'notify': False})


for managed in (False, True): reset_scenario('delayed', managed)
for kind in ('stuck', 'unknown_before', 'unknown_after', 'restart'): reset_scenario(kind)
print('Known-error reset tolerates delayed publication; uncleared/new faults and restart fail.')
