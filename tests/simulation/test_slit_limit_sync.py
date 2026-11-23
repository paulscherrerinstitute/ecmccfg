#!/usr/bin/env python3
"""Live limit-sync verdicts with deliberately delayed or missing propagation.

Execute real case methods. This verifies asynchronous polling expectations,
exact pair/enable assertions, and restoration; the production driver sync code
is separately exercised by test_motor_softlimit_restore.py.
"""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'tools/simulation'))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'integration'))
from slit.cases.softlimit_sync import SoftLimitSyncTests


class Rig:
    profile = {'physical': {'TR_LO': {}, 'TR_HI': {}}}
    def __init__(self, defect=None, sync=1):
        self.defect = defect
        self.values = {axis: {'.LLM': -1., '.DLLM': -1., '-CfgDLLM-RB': -1.,
                              '.HLM': 1., '.DHLM': 1., '-CfgDHLM-RB': 1.,
                              '-CfgSyncSftLim': sync, '.MRES': .001, '-ErrId': 0,
                              '.VELO': .4,
                              '-SftLimBwdEna-RB': 1, '-SftLimFwdEna-RB': 1,
                              '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1}
                       for axis in self.profile['physical']}
        self.pending, self.writes, self.waits = [], [], 0
    def get(self, axis, suffix): return self.values[axis][suffix]
    def put(self, axis, suffix, value):
        self.writes.append((axis, suffix, value))
        values = self.values[axis]
        if suffix == '-CfgSyncSftLim':
            if self.defect != 'no_sync': values[suffix] = value
            return
        if suffix in ('.LLM', '.HLM', '-CfgDLLM', '-CfgDHLM'):
            low = suffix in ('.LLM', '-CfgDLLM')
            motor = suffix.startswith('.')
            fields = ('.LLM', '.DLLM', '-CfgDLLM-RB') if low else ('.HLM', '.DHLM', '-CfgDHLM-RB')
            for field in fields:
                if motor and field.startswith('.'):
                    values[field] = value
                else:
                    if motor and self.defect == 'no_motor_to_ecmc': continue
                    if not motor and field.startswith('.') and self.defect == 'no_ecmc_to_motor': continue
                    self.pending.append((axis, field, value))
        elif suffix == '.VELO':
            values[suffix] = value
        else:
            low = suffix in ('-SftLimBwdEna', '-CfgDLLM-En')
            assert suffix in ('-SftLimBwdEna', '-SftLimFwdEna', '-CfgDLLM-En', '-CfgDHLM-En')
            fields = ('-SftLimBwdEna-RB', '-CfgDLLM-En-RB') if low else ('-SftLimFwdEna-RB', '-CfgDHLM-En-RB')
            if self.defect != 'no_flags':
                for field in fields: self.pending.append((axis, field, value))
    def wait(self, predicate, description, timeout=15):
        self.waits += 1
        for tick in range(4):
            if tick == 2:
                for axis, field, value in self.pending: self.values[axis][field] = value
                self.pending.clear()
            if predicate(): return
        raise AssertionError(description)
    def native_move(self, axis, target, velocity=.4):
        assert velocity == .2
        assert self.values[axis]['-CfgDLLM-RB'] <= target <= self.values[axis]['-CfgDHLM-RB']
    def move(self, axis, target):
        assert self.values[axis]['.LLM'] <= target <= self.values[axis]['.HLM']


cases = ('test_motor_limit_changes_reach_ecmc', 'test_ecmc_config_limit_changes_reach_motor',
         'test_soft_limit_enable_flags_sync_both_interfaces')
for method in cases:
    case = SoftLimitSyncTests(method)
    case.rig = Rig()
    getattr(case, method)()
    assert case.doCleanups()
    assert case.rig.waits > 0
    for axis in case.rig.profile['physical']:
        assert (case.rig.get(axis, '.LLM'), case.rig.get(axis, '.HLM')) == (-1, 1)
        assert (case.rig.get(axis, '-CfgDLLM-RB'), case.rig.get(axis, '-CfgDHLM-RB')) == (-1, 1)
        assert case.rig.get(axis, '-SftLimBwdEna-RB') == case.rig.get(axis, '-SftLimFwdEna-RB') == 1
for method, defect in zip(cases, ('no_motor_to_ecmc', 'no_ecmc_to_motor', 'no_flags')):
    case = SoftLimitSyncTests(method)
    case.rig = Rig(defect)
    try:
        getattr(case, method)()
    except AssertionError:
        pass
    else:
        raise AssertionError(method + ' must fail when propagation is missing')
print('Slit limit sync: delayed updates pass, missing propagation fails, original pairs/flags restored.')

# Live snapshot had synchronization disabled. Enable it only for the test and
# restore the original setting, even after an assertion interrupts the body.
for method in cases:
    case = SoftLimitSyncTests(method)
    case.rig = Rig(sync=0)
    getattr(case, method)()
    assert case.doCleanups()
    assert all(case.rig.get(axis, '-CfgSyncSftLim') == 0 for axis in case.rig.profile['physical'])
case = SoftLimitSyncTests(cases[0])
case.rig = Rig('no_sync', sync=0)
try:
    getattr(case, cases[0])()
except AssertionError:
    pass
else:
    raise AssertionError('missing sync enable acknowledgement must fail')
assert case.doCleanups()
assert case.rig.get('TR_LO', '-CfgSyncSftLim') == 0

case = SoftLimitSyncTests(cases[0])
case.rig = Rig(sync=0)
case.original('TR_LO')
assert case.rig.get('TR_LO', '-CfgSyncSftLim') == 1
assert case.doCleanups()  # Same cleanup path used if an assertion interrupts the body.
assert case.rig.get('TR_LO', '-CfgSyncSftLim') == 0
