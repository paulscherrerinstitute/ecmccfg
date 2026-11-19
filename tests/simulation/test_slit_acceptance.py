#!/usr/bin/env python3
"""Offline checks for the live slit acceptance program; never execute IOC cases.

USER/DOC: standalone slit_matrix_sim_test profile, modular cases and coupled
EL5042 feedback. Arithmetic is based on 10 mm/s Q15, 12800 internal counts/mm,
4096 absolute counts/mm and -1380 mm absolute offset from the supplied YAML.
"""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import threading
import time
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/simulation'))
sys.path.insert(0, str(ROOT / 'tests/integration'))
from slit.plant import Blade, Plant
from slit.rig import Rig
from slit.run import DEFAULT_CONFIG, DEFAULT_REPORT, MODULES, make_suite, write_reports

CONFIG = {'drive_slave': 14, 'encoder_slave': 9, 'encoder_channel': '02',
          'internal_counts_per_mm': 12800, 'absolute_counts_per_mm': 4096,
          'absolute_offset_mm': -1380, 'absolute_bits': 26,
          'brake': {'slave': 5, 'channel': '01', 'open_delay_cycles': 250, 'close_ahead_cycles': 200}}
blade = Blade(CONFIG)
drive, absolute, status = blade.step(0, 0, 0)
assert absolute == 5652480 and status == 4 and drive.position == 0
blade.step(1, 0, 0)  # Observe enable before timing its acknowledgement.
blade.step(1, 0, .05)  # Complete the specified enable delay without motion.
drive, absolute, status = blade.step(1, 16384, 1)
assert blade.position_mm == 5 and drive.position == 64000
assert absolute == 5672960 and status == 4
drive, absolute, _ = blade.step(1, 16384, .1)
assert drive.position == 4864 and absolute == 5675008
blade.inject(frozen=True)
held = absolute
drive, absolute, _ = blade.step(1, 16384, .1)
assert absolute == held and drive.position == 11264  # Internal keeps counting.
blade.inject(ready=False, forward_ok=False, backward_ok=False, acknowledge_enable=False)
drive, absolute, status = blade.step(1, 0, .1)
assert status == 0 and absolute == held
assert drive.drive_status & ((1 << 12) | (1 << 11) | 2) == 0
blade.inject(drive_fault=True)
drive, _, _ = blade.step(1, 16384, .1)
assert drive.drive_status & 8 and not drive.drive_status & 3
stopped = blade.position_mm
blade.step(1, 16384, .1)
assert blade.position_mm == stopped
blade.step(3, 16384, .1)  # Persistent fault injection must survive a reset request.
assert blade.position_mm == stopped
blade.inject(drive_fault=False, frozen=False, ready=True)
_, absolute, status = blade.step(0, 0, 0)
assert absolute != held and status == 4

# STOP is not an input to the plant: an enabled drive's declining velocity
# must continue updating BOTH encoder images throughout deceleration.
ramp = Blade(CONFIG)
ramp.step(1, 0, 0)
ramp.step(1, 0, .05)
for velocity, counter, absolute in ((16384, 6400, 5654528), (8192, 9600, 5655552),
                                    (4096, 11200, 5656064), (0, 11200, 5656064)):
    feedback, raw, ready = ramp.step(1, velocity, .1)
    assert feedback.position == counter and raw == absolute and ready == 4
feedback, raw, ready = ramp.step(0, 0, .1)
assert feedback.position == 11200 and raw == 5656064

# Building/selecting test modules must not import pyepics or access a live IOC.
assert DEFAULT_REPORT == ROOT / 'test-results/slit/slit-report.json'
suite = make_suite(None, ('open', 'closed'), MODULES)
tests = list(suite)
assert len(tests) == 502
independent = list(make_suite(None, ('closed',), ('no_sm',)))
assert len(independent) == 39
assert all('.no_sm.Independent' in test.id() for test in independent)
assert not any('coordinated_motion' in test.id() or 'center_and_gap' in test.id()
               for test in independent)
ignored_cases = [test for test in tests
                 if test.id().endswith('test_ignore_disabled_motion_commands')]
assert len(ignored_cases) == 2
assert {test.loop for test in ignored_cases} == {'open', 'closed'}
assert {test.loop for test in tests} == {'open', 'closed'}
assert all(test.rig is None for test in tests)
assert len(list(make_suite(None, ('closed',), ('limits',)))) == 10
assert len(list(make_suite(None, ('closed',), ('enable',)))) == 4
assert len(list(make_suite(None, ('closed',), ('brake',)))) == 8
assert len(list(make_suite(None, ('closed',), ('feedback',)))) == 6
assert len(list(make_suite(None, ('closed',), ('noise',)))) == 2
assert len(list(make_suite(None, ('closed',), ('torque',)))) == 5
assert len(list(make_suite(None, ('closed',), ('native',)))) == 5
assert len(list(make_suite(None, ('closed',), ('softlimit_sync',)))) == 3
assert len(list(make_suite(None, ('closed',), ('homing',)))) == 47

assert len(list(make_suite(None, ('closed',), ('interfaces',)))) == 5
assert len(list(make_suite(None, ('closed',), ('motor',)))) == 8
assert len(list(make_suite(None, ('closed',), ('isolation',)))) == 4
assert len(list(make_suite(None, ('closed',), ('target_write',)))) == 6
assert len(list(make_suite(None, ('closed',), ('encoder_power',)))) == 16
assert len(list(make_suite(None, ('closed',), ('encoder_handover',)))) == 7
assert len(list(make_suite(None, ('closed',), ('pvt',)))) == 16


single = list(make_suite(None, ('open',), ('homing',), ('test_native_sequence_15',)))
assert len(single) == 1 and single[0].id().endswith('.test_native_sequence_15')
manual = list(make_suite(None, ('open','closed'), ('homing',),
                         ('test_native_sequence_15', 'test_motor_sequence_25')))
assert len(manual) == 4
assert len(list(make_suite(None, ('open',), ('homing',), ('does_not_exist',)))) == 0


class FakeClient:
    def __init__(self, mode, marker=1): self.mode, self.marker, self.puts = mode, marker, []
    def get(self, name): return self.mode if name.endswith('MCU-Cfg-Sim-Mode') else self.marker
    def put(self, name, value): self.puts.append((name, value))


client = FakeClient(0)
rig = Rig({'axes': {}}, 'REAL:', client, None)
try:
    rig.guard()
except RuntimeError as error:
    assert 'SIM=1' in str(error)
else:
    raise AssertionError('must refuse non-simulation IOC')
assert not client.puts
client = FakeClient(1, marker=1)
try:
    Rig({'schema': 2, 'axes': {}}, 'OLD:', client, None).guard()
except RuntimeError as error:
    assert 'restart' in str(error) and 'expected 2' in str(error)
else:
    raise AssertionError('outdated IOC configuration must be refused before writes')
assert not client.puts
Rig({'schema': 2, 'axes': {}}, 'NEW:', FakeClient(1, marker=2), None).guard()

# Exercise the actual background plant publication with fake native PVs. Both
# encoder images must change coherently, and readiness must be independently injectable.
class PV:
    def __init__(self, name, values):
        self.pvname, self.values = name, values
        self.connected = name in values
        self.read_access = self.write_access = True
    def wait_for_connection(self, timeout): return self.connected
    def get(self, **kwargs): return self.values.get(self.pvname) if self.connected else None
    def put(self, value, **kwargs):
        assert kwargs['wait']
        self.values[self.pvname] = value
        if self.pvname + '-RB' in self.values:
            self.values[self.pvname + '-RB'] = value
        return 1
    def disconnect(self): self.connected = False

values = {}
for base, fields in {
    'TEST:SIM:ec0:s14:': [('driveControl01','mbbiDirect',1), ('velocitySetpoint01','longin',16384),
        ('driveStatus01','mbboDirect',0), ('encoderStatus01','mbboDirect',0),
        ('positionActual01','mbboDirect',0), ('positionActual01-RB','mbbiDirect',0)],
    'TEST:SIM:ec0:s9:': [('positionActual02','int64out',5652480), ('positionActual02-RB','int64in',5652480),
        ('encoderStatus02','mbboDirect',4)]
}.items():
    for field, kind, value in fields:
        values[base + field] = value
        values[base + field + '.RTYP'] = kind
plant = Plant({'physical': {'TR_LO': CONFIG}}, 'TEST:SIM:', lambda name, **kw: PV(name, values),
              threading.Thread, timeout=.01)
try:
    plant.start()
    deadline = time.monotonic() + 1
    while values['TEST:SIM:ec0:s9:positionActual02'] <= 5652480:
        plant.check()
        assert time.monotonic() < deadline
        time.sleep(.01)
    plant.inject('TR_LO', ready=False)
    deadline = time.monotonic() + 1
    while values['TEST:SIM:ec0:s9:encoderStatus02'] != 0:
        plant.check()
        assert time.monotonic() < deadline
        time.sleep(.01)
finally:
    plant.close()
assert values['TEST:SIM:ec0:s14:driveStatus01'] & 8
assert not values['TEST:SIM:ec0:s14:driveStatus01'] & 2

with tempfile.TemporaryDirectory() as directory:
    path = Path(directory) / 'nested/slit/report.json'
    assert not path.parent.exists()
    document = {'tests': [{'test': 'limits.forward', 'loop': 'closed', 'seconds': .1,
                           'status': 'failed', 'detail': 'expected limit', 'snapshot': {}}]}
    write_reports(path, document)
    assert json.loads(path.read_text()) == document
    xml = ET.parse(path.with_suffix('.xml'))
    assert xml.find('.//failure').text == 'expected limit'

if DEFAULT_CONFIG.exists():
    profile = json.loads((DEFAULT_CONFIG / 'profile.json').read_text())
    assert profile['schema'] == 4
    assert {k: v for k, v in profile['physical']['TR_LO'].items() if k != 'encoder_power'} == CONFIG
    assert profile['physical']['TR_LO']['encoder_power'] == {'slave': 5, 'channel': '03'}
    assert profile['physical']['TR_HI']['encoder_channel'] == '01'
    startup = (DEFAULT_CONFIG / 'startup.cmd').read_text()
    assert 'SIM=1' in startup and 'SIM:SlitTest:Schema' in (DEFAULT_CONFIG / 'test-marker.db').read_text()
    for axis, number in profile['axes'].items():
        if axis not in profile['physical']: continue
        yaml_path = DEFAULT_CONFIG / f'cfg/axis_ax{number}_{"LO" if axis == "TR_LO" else "HI"}.yaml'
        axis_yaml = yaml_path.read_text()
        assert 'reduceTorque: 2' in axis_yaml and 'reduceTorqueEnable: True' in axis_yaml
        brake = profile['physical'][axis]['brake']
        import yaml
        assert yaml.safe_load(axis_yaml)['drive']['brake'] == {
            'enable': True, 'output': f'ec0.s5.binaryOutput{brake["channel"]}',
            'openDelay': 250, 'closeAhead': 200}
        assert 'Cfg.SetAxisDrvBrake' not in startup
    lo = (DEFAULT_CONFIG / 'cfg/axis_ax5_LO.yaml').read_text()
    assert 's$(DRV_SLAVE).driveStatus01.12' in lo and 's$(DRV_SLAVE).ONE.1' not in lo
    # Render the actual drive template to establish that the fixture's fault
    # reaches a monitored alarm input, independently of lost-enabled feedback.
    try:
        import yaml
        from jinja2 import Environment, StrictUndefined
    except ImportError:
        print('SKIP YAML drive-template render: PyYAML/jinja2 unavailable.')
    else:
        cfg = Path(__file__).resolve().parents[2]
        template = Environment(undefined=StrictUndefined).from_string(
            (cfg / 'scripts/jinja2/templates/drive.jinja2').read_text())
        for filename in ('axis_ax5_LO.yaml', 'axis_ax6_HI.yaml'):
            data = yaml.safe_load((DEFAULT_CONFIG / 'cfg' / filename).read_text())
            rendered = template.render(**data)
            assert data['drive']['error'] == [3] and data['drive']['reset'] == 1
            assert data['drive']['status'] + '.3' in rendered and '.drv.alarm0' in rendered
            assert data['drive']['control'] + '.1' in rendered and '.drv.reset' in rendered
    subprocess.run([sys.executable, str(ROOT / 'tests/integration/slit/run.py'),
                    '--config', str(DEFAULT_CONFIG), '--case', 'limits'], check=True, stdout=subprocess.DEVNULL)
else:
    raise AssertionError('The colocated slit IOC fixture is missing.')
subprocess.run([sys.executable, str(ROOT / 'tests/integration/slit/run.py'), '--help'],
               check=True, stdout=subprocess.DEVNULL)
print('Slit acceptance infrastructure: coupled encoder arithmetic, faults, modular selection, SIM guard and report generation passed; no live tests run.')


if DEFAULT_CONFIG.exists():
    command = [sys.executable, str(ROOT/'tests/integration/slit/run.py'),
               '--config', str(DEFAULT_CONFIG), '--case', 'homing', '--loop', 'open']
    planned = subprocess.run(command + ['--test', 'test_native_sequence_15'],
                             capture_output=True, text=True, check=True)
    assert planned.stdout.count('[open]') == 1 and 'test_native_sequence_15' in planned.stdout
    assert '[closed]' not in planned.stdout
    # Invalid live filters must fail before importing EPICS/connecting/writing.
    rejected = subprocess.run(command + ['--prefix','TEST:', '--run', '--test','does_not_exist'],
                              capture_output=True, text=True)
    assert rejected.returncode == 2 and 'no tests match' in rejected.stderr
print('Slit test selection: exact-name substring, repeatable OR filters, loop selection and pre-connection empty-filter rejection passed.')
