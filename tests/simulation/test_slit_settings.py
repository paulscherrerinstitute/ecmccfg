#!/usr/bin/env python3
"""Exercise new live-case verdicts with controlled feedback, without an IOC."""
from pathlib import Path
from types import SimpleNamespace
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path[:0] = [str(ROOT/'tools/simulation'), str(ROOT/'tests/integration')]
from slit.cases.settings import SettingsCase, number
from slit.cases.filters import FilterTests
from slit.cases.controller import ControllerTests
from slit.cases.monitoring import MonitoringTests
from slit.run import make_suite


class Rig:
    def __init__(self, defect=None):
        self.values, self.commands, self.trace = {}, [], []
        self.defect = defect
        self.bias, self.position = 0., 0.
        self.plant = SimpleNamespace(inject=self.inject, physical_position=lambda axis: 0.)

    def inject(self, axis, **kwargs):
        self.bias = kwargs.get('encoder_bias_mm', self.bias)

    def text_command(self, command, query=False):
        assert len(command.encode()) <= 39, command
        self.commands.append(command)
        if query:
            key = re.fullmatch(r'GetAxis(\w+)\(6\)', command)[1]
            if key == 'CntrlError': return -self.bias
            if key == 'CntrlOutPpart':
                gain = (self.values['CntrlInnerKp'] if abs(self.bias) < self.values['CntrlInnerTol']
                        else self.values['CntrlKp'])
                if self.defect == 'wrong_gain': gain = 0
                return -self.bias*gain
            value = self.values.get(key, 0.)
            return value+1 if self.defect == 'ignored_setting' else value
        key, value = re.fullmatch(r'Cfg.SetAxis(\w+)\(6,([^)]+)\)', command).groups()
        self.values[key] = float(value)
        return 'OK'

    def get(self, axis, field):
        assert field == '-Enc02-PosAct', field
        if self.values.get('EncPosFilterEnable') and self.defect != 'ignored_position_filter':
            self.position += (self.bias-self.position)*.25
        else:
            self.position = self.bias
        return self.position

    def wait(self, predicate, description, timeout=15):
        for _ in range(100):
            if predicate(): return
        raise AssertionError('timeout: '+description)

    def assert_stays(self, predicate, description, seconds=1):
        for _ in range(10):
            assert predicate(), description


def make(cls, defect=None):
    case = cls('runTest')
    case.rig, case.loop, case.number = Rig(defect), 'closed', 6
    case.saved, case.allowed = {}, {}
    case.healthy = lambda: True
    case.enable = lambda: None
    return case


def rejects(function):
    try: function()
    except AssertionError: return
    raise AssertionError('broken implementation passed a live-case verdict')


for cls, method in ((FilterTests, 'test_velocity_filter_settings'),
                    (FilterTests, 'test_position_filter_settings'),
                    (ControllerTests, 'test_controller_parameter_readback'),
                    (MonitoringTests, 'test_monitor_parameter_readback')):
    case = make(cls)
    getattr(case, method)()
    assert case.saved
    bad = make(cls, 'ignored_setting')
    rejects(lambda: getattr(bad, method)())
    # Original values, including larger counters, must fit the same transport.
    for key in case.saved:
        value = (1 if 'Enable' in key or key.endswith('AtRmp') else
                 50 if key.endswith(('Time', 'Delay', 'Size')) else -.125)
        assert len(f'Cfg.SetAxis{key}(6,{number(value)})') <= 39, key

case = make(FilterTests)
case.test_position_filter_smooths_a_step_then_bypasses()
bad = make(FilterTests, 'ignored_position_filter')
rejects(bad.test_position_filter_smooths_a_step_then_bypasses)

for defect in (None, 'ignored_velocity_filter', 'dead_noise'):
    case = make(FilterTests, defect)
    def observe(readers, seconds, minimum, case=case):
        filtered = case.rig.values.get('EncVelFilterEnable') and case.rig.defect != 'ignored_velocity_filter'
        velocity = .01 if filtered else .2
        amplitude = 0 if case.rig.defect == 'dead_noise' else .002
        return [{'velocity': velocity*(-1 if i%2 else 1),
                 'position': amplitude*(-1 if i%2 else 1)} for i in range(40)]
    case.observe = observe
    if defect: rejects(case.test_velocity_filter_attenuates_noise_and_bypass_restores_it)
    else: case.test_velocity_filter_attenuates_noise_and_bypass_restores_it()

case = make(ControllerTests)
case.test_inner_and_outer_proportional_gains()
bad = make(ControllerTests, 'wrong_gain')
rejects(bad.test_inner_and_outer_proportional_gains)

# Teardown must restore a resized filter's enable flag AFTER its size, and
# restore selected encoder and state machine even when the test changed both.
case = make(SettingsCase)
case.saved = {'EncPosFilterEnable': 0, 'EncPosFilterSize': 1, 'CntrlKp': 2}
case.restored, case.previous_encoder, case.state_machine = False, 1, 1
case.rig.plant.clear_faults = lambda: None
case.rig.names = []
case.rig.stop_all = lambda: []
case.rig.get = lambda axis, field: 0
case.rig.prefix = 'TEST:'
restores = []
case.rig.client = SimpleNamespace(put=lambda *args: restores.append(args))
case.rig.text_command = lambda cmd, **kw: restores.append(cmd)
case.restore()
assert restores.index('Cfg.SetAxisEncPosFilterSize(6,1)') < restores.index('Cfg.SetAxisEncPosFilterEnable(6,0)')
assert restores[-2:] == ['Cfg.SelectAxisEncConfig(6,1)', ('TEST:SM00-EnaCmd', 1)]
old_count = len(restores)
case.restore()
assert len(restores) == old_count

assert len(list(make_suite(None, ('closed',), ('filters','controller','monitoring')))) == 17
print('Settings cases: parameter transport/readback, restoration order, filter smoothing/noise/bypass and inner/outer P verdicts passed, including negative controls; no IOC.')
