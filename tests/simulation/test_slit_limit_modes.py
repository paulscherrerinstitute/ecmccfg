#!/usr/bin/env python3
"""Exercise actual SIM/HW case verdicts and cleanup against a controlled boundary.

This checks the test harness, not motor-record or controller implementation.
Production arithmetic/propagation is covered by ECMC's sanitized C++ fixture.
"""
from pathlib import Path
import sys
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'tools/simulation'))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'integration'))
from slit import limit_modes
from slit.cases.softlimit_modes import SoftLimitModeTests as SimCases
from slit_hardware.softlimits import SoftLimitModeTests as HardwareCases, SOFT_LIMIT_NAMES
from slit_hardware.cases import make_suite as make_hardware_suite
from slit.run import make_suite as make_sim_suite

selected = list(make_hardware_suite(None, ('softlimits',)))
assert len(selected) == 8 and all(test.motion_axes == () for test in selected)
assert len(list(make_sim_suite(None, ('open', 'closed'), ('softlimit_modes',)))) == 18


class Clock:
    now = 0.
    def monotonic(self): return self.now


class Boundary:
    """Delayed parameter delivery with switchable test defects; no plant model."""
    prefix = 'TEST:'
    profile = {'axes': {'TR_LO': 5, 'TR_HI': 6},
               'physical': {'TR_LO': {}, 'TR_HI': {}}, 'tolerance': .002}

    def __init__(self, clock, sync=0, defect=None):
        self.clock, self.defect, self.client = clock, defect, self
        self.authorized, self.touched = True, set()
        self.writes, self.pending = [], []
        self.sm = 1
        self.next_poll = clock.now + 1.0
        self.values = {a: {'.DIR': 0, '.OFF': 0, '.FOFF': 0, '.MRES': .001,
            '.MFLG': 8 | (256 if sync else 0),
            '.DLLM': -1 if sync else -.7, '.DHLM': 1 if sync else .7,
            '.LLM': -1 if sync else -.7, '.HLM': 1 if sync else .7,
            '-CfgDLLM-RB': -1, '-CfgDHLM-RB': 1,
            '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1,
            '-CfgSyncSftLim': sync, '-PosAct': 0, '-Busy': 0, '-EnaAct': 0, '-ErrId': 0}
            for a in self.profile['axes']}

    def get(self, axis, field=None):
        if field is None:
            if axis == self.prefix+'SM00-EnaCmd': return self.sm
            raise AssertionError('unexpected global read '+axis)
        return self.values[axis][field]

    def user_limits(self, values):
        low, high, off = values['.DLLM'], values['.DHLM'], values['.OFF']
        if low == high == 0:
            values['.LLM'] = values['.HLM'] = 0
        else:
            a, b = (off-high, off-low) if values['.DIR'] else (off+low, off+high)
            values['.LLM'], values['.HLM'] = a, b

    def put(self, name, value, **_kwargs):
        self.writes.append((name, value))
        if name == self.prefix+'SM00-EnaCmd': self.sm = value; return
        axis = next(a for a in self.values if name.startswith(self.prefix+a))
        field = name[len(self.prefix+axis):]
        values = self.values[axis]
        if field == '-EnaCmd': values['-EnaAct'] = value; return
        if field == '-CfgSyncSftLim':
            values[field] = value
            if self.defect != 'missing_record_flag':
                self.pending.append((axis, '.MFLG', (values['.MFLG'] & ~256) | (256 if value else 0)))
            return
        if field in ('.DIR', '.OFF', '.FOFF'):
            if field == '.DIR' and self.defect == 'ignored_DIR': return
            values[field] = value
            if field == '.OFF' and value:
                if self.defect == 'native_offset': values['-CfgDLLM-RB'] += value
                if self.defect == 'move_on_OFF': values['-PosAct'] += .01
            self.user_limits(values)
            return
        if field in ('-CfgDLLM-En', '-CfgDHLM-En'):
            if self.defect != 'ignored_flags': values[field+'-RB'] = value
            return
        if field in ('-CfgDLLM', '-CfgDHLM'):
            values[field+'-RB'] = value
            if values['-CfgSyncSftLim'] and self.defect != 'no_native_to_motor':
                self.pending.append((axis, '.DLLM' if field == '-CfgDLLM' else '.DHLM', value))
            elif (not values['-CfgSyncSftLim'] and
                  (values['-CfgDLLM-En-RB'] or values['-CfgDHLM-En-RB'])):
                # A changed unsynchronized native range is published once as
                # the motor record's RO boundary.  Its callback initially
                # installs that pair; later narrower motor edits remain local.
                values['.DLLM' if field == '-CfgDLLM' else '.DHLM'] = value
                self.user_limits(values)
            return
        if field in ('.LLM', '.HLM'):
            dial = value-values['.OFF'] if not values['.DIR'] else values['.OFF']-value
            field = ('.DLLM' if (field == '.LLM') != bool(values['.DIR']) else '.DHLM')
            value = dial
        if field in ('.DLLM', '.DHLM'):
            if self.defect == 'cannot_disable_motor' and value == 0: return
            native_enabled = (values['-CfgDLLM-En-RB'] or values['-CfgDHLM-En-RB'])
            native_defined = (values['-CfgDLLM-RB'] != 0 or values['-CfgDHLM-RB'] != 0)
            if (value != 0 and native_enabled and native_defined and
                    self.defect != 'motor_ignores_native_range'):
                value = max(values['-CfgDLLM-RB'], min(values['-CfgDHLM-RB'], value))
            values[field] = value
            self.user_limits(values)
            if ((values['-CfgSyncSftLim'] and self.defect != 'no_motor_to_native') or
                    self.defect == 'propagates_without_sync'):
                self.pending.append((axis, '-CfgDLLM-RB' if field == '.DLLM' else '-CfgDHLM-RB', value))
            return
        raise AssertionError('unexpected write '+field)

    def stop_all(self): return []

    def wait(self, predicate, description, timeout=5):
        for tick in range(300):
            self.clock.now += .05
            if self.clock.now >= self.next_poll:
                self.next_poll = self.clock.now + 1.0
                for axis, field, value in self.pending:
                    self.values[axis][field] = value
                    self.user_limits(self.values[axis])
                self.pending.clear()
            if predicate(): return
        raise AssertionError(description)
    wait_configuration = wait


def exercise(cls, method, sync=0, defect=None):
    clock = Clock()
    case = cls(method)
    case.rig = Boundary(clock, sync, defect)
    with patch.object(limit_modes.time, 'monotonic', clock.monotonic):
        getattr(case, method)()
    for axis, fields in case.rig.values.items():
        initial = 1 if sync else .7
        assert fields['.DLLM'] == -initial and fields['.DHLM'] == initial
        assert fields['-CfgDLLM-RB'] == -1 and fields['-CfgDHLM-RB'] == 1
        assert fields['-CfgDLLM-En-RB'] == fields['-CfgDHLM-En-RB'] == 1
        assert fields['.DIR'] == fields['.OFF'] == fields['.FOFF'] == 0
        assert fields['-CfgSyncSftLim'] == sync
    assert case.rig.sm == 1
    assert not any(name.endswith(('.VAL', '.SET', '-ExeCmd', '-TgtPosCmd'))
                   for name, _value in case.rig.writes)
    assert not any(name == case.rig.prefix+axis+'-EnaCmd' and value
                   for name, value in case.rig.writes for axis in case.rig.profile['axes'])
    return case


for cls in (SimCases, HardwareCases):
    for name in SOFT_LIMIT_NAMES:
        for sync in (0, 1): exercise(cls, name, sync)
    for name, defect in (
        ('test_nested_independent_limits_without_sync', 'propagates_without_sync'),
        ('test_native_limits_bound_unsynced_motor_limits', 'motor_ignores_native_range'),
        ('test_motor_soft_limit_callback_rate_is_bounded', 'high_soft_limit_callback_rate'),
        ('test_controller_only_limits_without_sync', 'cannot_disable_motor'),
        ('test_motor_only_limits_without_sync', 'ignored_flags'),
        ('test_synced_limits_in_both_directions', 'no_native_to_motor'),
        ('test_synced_limits_in_both_directions', 'no_motor_to_native'),
        ('test_synced_limits_in_both_directions', 'missing_record_flag'),
        ('test_offsets_and_direction_preserve_dial_and_native_limits', 'ignored_DIR'),
        ('test_offsets_and_direction_preserve_dial_and_native_limits', 'native_offset'),
        ('test_offsets_and_direction_preserve_dial_and_native_limits', 'move_on_OFF'),
    ):
        try: exercise(cls, name, defect=defect)
        except AssertionError: pass
        else: raise AssertionError('case must reject boundary defect '+defect)

print('SIM/HW slit limit cases: four modes, delayed propagation, OFF/DIR, '
      'restoration and negative controls passed; no hardware I/O performed.')
