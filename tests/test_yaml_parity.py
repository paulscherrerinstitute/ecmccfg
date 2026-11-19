"""Compare standalone ECB and Python/Jinja configuration generation."""
import copy
from decimal import Decimal
import difflib
import importlib.util
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / 'scripts/jinja2'
FIXTURES = ROOT / 'tests/fixtures/yaml_parity'


def commands(text):
    """Keep command order, quoted strings and macros; normalize numeric args."""
    result = []
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        # Only complete numeric arguments, not numbers inside PV names/macros.
        if line.startswith('ecmcConfigOrDie "Cfg.') or re.fullmatch(
                r'epicsEnvSet\(\w+,\s*[-+]?\d+(?:\.\d*)?(?:[eE][-+]?\d+)?\s*\)', line):
            line = re.sub(r'(?<=[,(])\s*([-+]?\d+(?:\.\d*)?(?:[eE][-+]?\d+)?)\s*(?=[,)])',
                          lambda m: format(Decimal(m[1]).normalize(), 'f'), line)
        result.append(line)
    return result


class YamlParityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.ecb = shutil.which(os.environ.get('ECB', 'ecb'))
        if not cls.ecb:
            raise unittest.SkipTest('ECB is not installed; set ECB to the standalone executable')
        for dependency in ['yaml', 'jinja2', 'cerberus', 'yamllint']:
            if importlib.util.find_spec(dependency) is None:
                raise unittest.SkipTest(f'Missing Python dependency: {dependency}')
        import yaml
        cls.yaml = yaml

    def render(self, source, directory, schema='axis'):
        script, template = {'axis': ('axisYamlJinja2.py', 'axis_main.jinja2'),
                            'encoder': ('encYamlJinja2.py', 'add_encoder.jinja2')}[schema]
        outputs = []
        for name, argv in [
            ('python', [sys.executable, str(SCRIPTS / script), '-D', str(source),
                        '-T', str(SCRIPTS / 'templates'), '-o']),
            ('ecb', [self.ecb, '--yaml', str(source), '--schemafile',
                     str(SCRIPTS / 'ecbSchema.json'), '--schema', schema,
                     '--template', str(SCRIPTS / 'templates' / template),
                     '--templatedir', str(SCRIPTS / 'templates'), '--output']),
        ]:
            output = directory / (name + '.cmd')
            process = subprocess.run(argv + [str(output)], cwd=directory,
                                     capture_output=True, text=True, timeout=30)
            outputs.append((name, process, output.read_text() if output.exists() else ''))
        return outputs

    def compare(self, source, schema='axis'):
        with tempfile.TemporaryDirectory() as tmp:
            outputs = self.render(source, Path(tmp), schema)
            for name, process, output in outputs:
                self.assertEqual(process.returncode, 0, f'{name}: {process.stdout}\n{process.stderr}')
                self.assertTrue(commands(output), f'{name} generated no commands')
            python, ecb = (commands(item[2]) for item in outputs)
            self.assertEqual(python, ecb, '\n'.join(difflib.unified_diff(
                python, ecb, fromfile='Python/Jinja', tofile='ECB', lineterm='')))
            return python

    def test_axis_fixtures(self):
        for source in sorted(FIXTURES.glob('*.yaml')):
            with self.subTest(fixture=source.name):
                self.compare(source)

    def test_defaults_and_explicit_homing(self):
        base = self.yaml.safe_load((FIXTURES / 'virtual_monitoring.yaml').read_text())
        minimal = {key: base[key] for key in ['axis', 'encoder', 'trajectory', 'input']}
        homing = copy.deepcopy(minimal)
        homing['homing'] = dict(type=1, position=0.0, velocity=dict(to=2.0, **{'from': 1.0}),
                                acceleration=5.0, deceleration=6.0, timeout=30)
        for name, document in [('defaults', minimal), ('homing', homing)]:
            with self.subTest(case=name), tempfile.TemporaryDirectory() as tmp:
                source = Path(tmp) / 'axis.yaml'
                source.write_text(self.yaml.safe_dump(document))
                generated = self.compare(source)
                self.assertIn('epicsEnvSet(V_DRVL,0)', generated)
                self.assertIn('epicsEnvSet(V_DRVH,0)', generated)

    def test_velocity_difference_drive_delay_without_velocity_monitor(self):
        document = self.yaml.safe_load((FIXTURES / 'virtual_monitoring.yaml').read_text())
        # Keep this generated fixture focused on monitor rendering. Re-dumping
        # integer soft limits exposes an unrelated backend formatting difference
        # (plain epicsEnvSet versus an equivalent calculated zero).
        document.pop('softlimits')
        document['monitoring'].pop('velocity')
        document['monitoring']['velocityDifference'] = {
            'enable': True, 'max': .03,
            'time': {'trajectory': 1000, 'drive': 600},
        }
        with tempfile.TemporaryDirectory() as tmp:
            source = Path(tmp) / 'velocity-difference-only.yaml'
            source.write_text(self.yaml.safe_dump(document))
            generated = self.compare(source)
            text = '\n'.join(generated)
            self.assertIn('Cfg.SetAxisMonVelDiffTrajILDelay(${ECMC_AXIS_NO},1000)', text)
            self.assertIn('Cfg.SetAxisMonVelDiffDriveILDelay(${ECMC_AXIS_NO},600)', text)
            self.assertNotIn('Cfg.SetAxisMonMaxVelDriveILDelay', text)

    def test_additional_encoder(self):
        with tempfile.TemporaryDirectory() as tmp:
            source = Path(tmp) / 'encoder.yaml'
            source.write_text(self.yaml.safe_dump(dict(encoder=dict(
                type=1, bits=32, absBits=24, numerator=360, denominator=16777216,
                position='ec$(MASTER_ID).s$(ENC_SID).positionActual01'))))
            self.compare(source, 'encoder')

    def power_document(self):
        document = self.yaml.safe_load((FIXTURES/'physical_csv.yaml').read_text())
        document['encoder'].update(type=1, bits=32, absBits=26)
        document['monitoring'] = dict(target=dict(enable=True, tolerance=.01, time=100))
        return document

    def test_encoder_power_enabled_and_command_order(self):
        for standalone in (False, True):
            for high in (False, True):
                document = self.power_document()
                document['encoder']['power'] = dict(enable=True, output='ec0.s2.BO05.0',
                    activeHigh=high, startupDelay=.01, startupTimeout=.05, idleDelay=2.0)
                if standalone:
                    document = dict(encoder=document['encoder'])
                    document['encoder']['power']['backup'] = dict(encoder=1, maxPositionDifference=.02)
                with self.subTest(standalone=standalone, high=high), tempfile.TemporaryDirectory() as tmp:
                    source = Path(tmp)/'power.yaml'
                    source.write_text(self.yaml.safe_dump(document))
                    generated = self.compare(source, 'encoder' if standalone else 'axis')
                    def index(command):
                        return next(i for i, line in enumerate(generated) if command in line)
                    self.assertLess(index('Cfg.SetAxisEncPwrDelay(${ECMC_AXIS_NO},0)'),
                                    index('Cfg.SetAxisEncPwrTimeout('))
                    self.assertLess(index('Cfg.SetAxisEncPwrTimeout('),
                                    index('Cfg.SetAxisEncPwrDelay(${ECMC_AXIS_NO},0.01)'))
                    self.assertLess(index('Cfg.SetAxisEncPwrDelay(${ECMC_AXIS_NO},0.01)'),
                                    index('Cfg.SetAxisEncPwrEnable(${ECMC_AXIS_NO},1)'))
                    self.assertIn('Cfg.SetAxisEncPwrPol(${ECMC_AXIS_NO},'+str(int(high))+')',
                                  '\n'.join(generated))
                    self.assertIn('ec0.s2.BO05.0', '\n'.join(generated))
                    if standalone:
                        self.assertLess(index('Cfg.AddAxisEnc('), index('Cfg.SetAxisEncPwrEnable('))
                        self.assertLess(index('Cfg.SetAxisEncPwrEnable('), index('Cfg.SetAxisEncPwrBackup('))
                    else:
                        self.assertLess(index('Cfg.SetAxisMonAtTargetTol('), index('Cfg.SetAxisEncPwrEnable('))
                        self.assertFalse(any('SetAxisEncPwrBackup' in line for line in generated))

    def test_encoder_power_defaults_and_opt_out(self):
        for settings in (None, {}, dict(enable=False), dict(enable=True, output='ec0.s2.BO05.0')):
            document = self.power_document()
            if settings is not None: document['encoder']['power'] = settings
            with self.subTest(settings=settings), tempfile.TemporaryDirectory() as tmp:
                source = Path(tmp)/'power.yaml'
                source.write_text(self.yaml.safe_dump(document))
                generated = self.compare(source)
                power = [line for line in generated if 'Cfg.SetAxisEncPwr' in line]
                if settings is None:
                    self.assertEqual(power, [])
                elif not settings.get('enable', False):
                    self.assertEqual(power, ['ecmcConfigOrDie "Cfg.SetAxisEncPwrEnable(${ECMC_AXIS_NO},0)"'])
                else:
                    for expected in ('PwrDelay(${ECMC_AXIS_NO},0.1)', 'PwrTimeout(${ECMC_AXIS_NO},5)',
                                     'PwrOffDelay(${ECMC_AXIS_NO},2)', 'PwrPol(${ECMC_AXIS_NO},1)'):
                        self.assertTrue(any(expected in line for line in power), expected)

    def test_encoder_power_disabled_can_link_output_without_enabling(self):
        for standalone in (False, True):
            document = self.power_document()
            document['encoder']['power'] = dict(enable=False, output='ec0.s2.BO05.0')
            if standalone: document = dict(encoder=document['encoder'])
            with self.subTest(standalone=standalone), tempfile.TemporaryDirectory() as tmp:
                source = Path(tmp)/'disabled-power.yaml'
                source.write_text(self.yaml.safe_dump(document))
                generated = self.compare(source, 'encoder' if standalone else 'axis')
                linked = next(i for i, line in enumerate(generated) if 'ax${ECMC_AXIS_NO}.enc.power' in line)
                disabled = next(i for i, line in enumerate(generated) if 'Cfg.SetAxisEncPwrEnable(' in line)
                self.assertIn('ec0.s2.BO05.0', generated[linked])
                self.assertLess(linked, disabled)
                self.assertIn('Cfg.SelectAxisEncConfig(${ECMC_AXIS_NO},${ECMC_ENC_CFG_ID})',
                              '\n'.join(generated))
                self.assertEqual([line for line in generated if 'Cfg.SetAxisEncPwr' in line],
                                 ['ecmcConfigOrDie "Cfg.SetAxisEncPwrEnable(${ECMC_AXIS_NO},0)"'])

    def test_slit_ioc_yaml_settings_replace_startup_overrides(self):
        slit = ROOT/'tests/integration/slit'
        for fixture in ('ioc', 'ioc_hardware'):
            directory = slit/fixture
            startup = (directory/'startup.cmd').read_text()
            self.assertNotIn('Cfg.SetAxisDrvBrake', startup)
            self.assertNotIn('Cfg.SetAxisHome', startup)
            self.assertNotIn('.enc.power)', startup)
            for source in sorted((directory/'cfg').glob('*.yaml')):
                with self.subTest(fixture=fixture, yaml=source.name):
                    schema = 'encoder' if source.name == 'biss-c.yaml' or source.name.startswith('enc_') else 'axis'
                    generated = self.compare(source, schema)
                    text = '\n'.join(generated)
                    if source.name.startswith('axis_ax'):
                        label = '01' if '_LO.' in source.name else '02'
                        self.assertIn(f'ec0.s5.binaryOutput{label}', text)
                        self.assertIn('Cfg.SetAxisDrvBrakeEnable(${ECMC_AXIS_NO},1)', text)
                        self.assertIn('Cfg.SetAxisDrvBrakeOpenDelayTime(${ECMC_AXIS_NO},250)', text)
                        self.assertIn('Cfg.SetAxisDrvBrakeCloseAheadTime(${ECMC_AXIS_NO},200)', text)
                        if fixture == 'ioc':
                            self.assertIn('s$(DRV_SLAVE).driveStatus01.13', text)
                            self.assertIn('Cfg.SetAxisHomeSwitchEnable(${ECMC_AXIS_NO},1)', text)
                        else:
                            self.assertNotIn('Cfg.SetAxisHomeSwitchEnable(${ECMC_AXIS_NO},1)', text)
                            self.assertNotIn('.mon.homesensor', text)
                    if fixture == 'ioc' and (source.name.startswith('axis_ax') or source.name == 'biss-c.yaml'):
                        self.assertIn('Cfg.SetAxisHomeSeqId(${ECMC_AXIS_NO},1)', text)
                        self.assertIn('Cfg.SetAxisSeqTimeout(${ECMC_AXIS_NO},12)', text)
                        self.assertIn('Cfg.SetAxisHomeLatchCountOffset(${ECMC_AXIS_NO},1)', text)
                        self.assertIn('Cfg.SetAxisHomePostMoveEnable(${ECMC_AXIS_NO},0)', text)
                    if fixture == 'ioc' and source.name == 'biss-c.yaml':
                        self.assertIn('ec0.s5.binaryOutput${ENC_PWR_CH}', text)
                        self.assertIn('Cfg.SetAxisEncPwrEnable(${ECMC_AXIS_NO},0)', text)
                        self.assertNotIn('Cfg.SetAxisEncPwrEnable(${ECMC_AXIS_NO},1)', text)
                    if fixture == 'ioc' and source.name.startswith('axis_vax'):
                        self.assertIn('Cfg.SetAxisMonSlvCtrlDbTol(${ECMC_AXIS_NO},0.005)', text)
                        self.assertIn('Cfg.SetAxisMonSlvCtrlDbTime(${ECMC_AXIS_NO},600)', text)
            if fixture == 'ioc':
                self.assertIn('ENC_CH=01,ENC_PWR_CH=04', startup)
                self.assertIn('ENC_CH=02,ENC_PWR_CH=03', startup)

    def test_encoder_power_schema_rejects_bad_values(self):
        settings = [dict(enable='not-a-boolean'), dict(startupDelay=-1), dict(startupTimeout=-1),
                    dict(idleDelay=-1), dict(activeHigh='not-a-boolean'), dict(output=17),
                    dict(backup=dict(encoder=0, maxPositionDifference=.02)),
                    dict(backup=dict(encoder=9, maxPositionDifference=.02)),
                    dict(backup=dict(encoder=1)),
                    dict(backup=dict(encoder=1, maxPositionDifference=-1))]
        for power in settings:
            document = self.power_document()
            document['encoder']['power'] = power
            with self.subTest(power=power), tempfile.TemporaryDirectory() as tmp:
                source = Path(tmp)/'bad-power.yaml'
                source.write_text(self.yaml.safe_dump(document))
                for name, result, _ in self.render(source, Path(tmp)):
                    self.assertNotEqual(result.returncode, 0, name+' accepted '+str(power))
                    self.assertIn('power', result.stdout+result.stderr)

    def test_encoder_power_startup_guards(self):
        for change, diagnostic in (({}, 'output'), (dict(startupDelay=5, startupTimeout=5), 'startupTimeout'),
                                    (dict(backup=dict(encoder=1,maxPositionDifference=0)), 'maxPositionDifference'),
                                    (dict(incremental=True), 'absolute encoder')):
            document = self.power_document()
            power = dict(enable=True, output='ec0.s2.BO05.0')
            if not change: del power['output']
            elif change.get('incremental'): document['encoder']['type'] = 0
            else: power.update(change)
            document['encoder']['power'] = power
            with self.subTest(change=change), tempfile.TemporaryDirectory() as tmp:
                source = Path(tmp)/'guard.yaml'
                source.write_text(self.yaml.safe_dump(document))
                for name, result, output in self.render(source, Path(tmp)):
                    self.assertEqual(result.returncode, 0, result.stdout+result.stderr)
                    self.assertIn('ecmcExit', output, name)
                    self.assertIn(diagnostic, output)
                    self.assertNotIn('Cfg.SetAxisEncPwrEnable(${ECMC_AXIS_NO},1)', output)

    def test_axis_plc_file_and_inline_code(self):
        document = self.yaml.safe_load((FIXTURES / 'virtual_monitoring.yaml').read_text())
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            plc = directory / 'axis.plc'
            plc.write_text('\nax$(AX_ID).enc.actpos:=ax1.enc.actpos;\n')
            document['plc'] = dict(enable=True, file=str(plc),
                                   code=['ax$(AX_ID).traj.setpos:=ax1.traj.setpos;'])
            source = directory / 'axis.yaml'
            source.write_text(self.yaml.safe_dump(document))
            generated = self.compare(source)
            expressions = [line for line in generated if 'Cfg.AppendAxisPLCExpr(' in line]
            self.assertEqual(len(expressions), 2)
            self.assertIn('enc.actpos:=ax1.enc.actpos|', expressions[0])
            self.assertIn('traj.setpos:=ax1.traj.setpos|', expressions[1])

    def test_plc_file_comment_policy_difference(self):
        # ECB 1.6.0 retains file comments; Python's readPlcFile strips them.
        document = self.yaml.safe_load((FIXTURES / 'virtual_monitoring.yaml').read_text())
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            plc = directory / 'comment.plc'
            plc.write_text('# parity comment\nax1.enc.actpos:=0;\n')
            document['plc'] = dict(enable=True, file=str(plc))
            source = directory / 'axis.yaml'
            source.write_text(self.yaml.safe_dump(document))
            outputs = self.render(source, directory)
            for name, process, _ in outputs:
                self.assertEqual(process.returncode, 0, f'{name}: {process.stderr}')
            python, ecb = (commands(item[2]) for item in outputs)
            comment = 'ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=# parity comment"'
            self.assertNotIn(comment, python)
            self.assertEqual(ecb.count(comment), 1)
            self.assertEqual(python, [line for line in ecb if line != comment])

    def test_invalid_configs_rejected_by_both(self):
        base = self.yaml.safe_load((FIXTURES / 'virtual_monitoring.yaml').read_text())
        missing = copy.deepcopy(base)
        del missing['trajectory']
        wrong_type = copy.deepcopy(base)
        wrong_type['trajectory']['axis']['velocity'] = ['not', 'a', 'number']
        for name, document, diagnostic in [('missing-trajectory', missing, 'trajectory'),
                                           ('wrong-type', wrong_type, 'velocity')]:
            with self.subTest(case=name), tempfile.TemporaryDirectory() as tmp:
                directory = Path(tmp)
                source = directory / 'invalid.yaml'
                source.write_text(self.yaml.safe_dump(document))
                for generator, process, _ in self.render(source, directory):
                    self.assertNotEqual(process.returncode, 0, f'{generator} accepted {name}')
                    # An unrelated startup crash must not count as validation.
                    self.assertIn(diagnostic, process.stdout + process.stderr,
                                  f'{generator} failed without identifying the invalid field')

    def test_unknown_key_policy_difference(self):
        # Python deliberately uses purge_unknown=True; ECB rejects typos.
        # Keep this difference visible rather than claiming full validation parity.
        document = self.yaml.safe_load((FIXTURES / 'virtual_monitoring.yaml').read_text())
        document['axis']['misspelledOption'] = True
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            source = directory / 'unknown.yaml'
            source.write_text(self.yaml.safe_dump(document))
            python, ecb = self.render(source, directory)
            self.assertEqual(python[1].returncode, 0, python[1].stderr)
            self.assertNotEqual(ecb[1].returncode, 0, 'ECB unexpectedly accepted an unknown key')
            self.assertIn('misspelledOption', ecb[1].stdout + ecb[1].stderr)


class CommandComparisonTests(unittest.TestCase):
    def test_equivalent_number_formatting(self):
        self.assertEqual(commands('# comment\n ec mc\n'), ['ec mc'])
        self.assertEqual(commands('ecmcConfigOrDie "Cfg.SetAxisHomeAcc(${AX},20)"'),
                         commands('ecmcConfigOrDie "Cfg.SetAxisHomeAcc(${AX}, 2e1)"'))
        self.assertEqual(commands('epicsEnvSet(ACC,20.0)'), commands('epicsEnvSet(ACC,20)'))

    def test_meaningful_changes_are_not_hidden(self):
        for before, after in [
            ('epicsEnvSet(ACC,20)', 'epicsEnvSet(ACC,21)'),
            ('epicsEnvSet(NAME,"motor (20.0)")', 'epicsEnvSet(NAME,"motor (20)")'),
            ('ecmcConfigOrDie "Cfg.SetAxisHomeAcc(${AX=1},20)"',
             'ecmcConfigOrDie "Cfg.SetAxisHomeAcc(${AX=2},20)"'),
            ('first\nsecond', 'second\nfirst'),
        ]:
            with self.subTest(before=before):
                self.assertNotEqual(commands(before), commands(after))


if __name__ == '__main__':
    unittest.main()
