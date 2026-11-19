"""Offline SDO loader/startup checks; no installer, IOC or hardware is invoked."""
from pathlib import Path
import re
import shlex
import unittest

from test_ex72xx_opt import arguments, expand, expression

ROOT = Path(__file__).resolve().parents[1]


class Loader:
    def __init__(self, **options):
        self.env = dict(SCRIPTEXEC='iocshLoad', ECMC_CONFIG_ROOT='',
                        ECMC_P_SCRIPT='mXsXXX', ECMC_PREFIX='TEST:',
                        ECMC_EC_HWTYPE='ELM3504', ECMC_ASYN_PORT='MC_CPU1',
                        ECMC_SAMPLE_RATE_MS='100', ECMC_TSE='-2')
        self.scope = dict(SLAVE_ID='26', INDEX='0x8000', SUBINDEX='0x32',
                          DT='S32', NAME='threshold') | options
        self.commands = []
        self.records = []
        self.registrations = []
        self.run(ROOT / 'scripts/addEcSdoRT.cmd', self.scope)

    def run(self, path, scope):
        for raw in path.read_text().splitlines():
            if not raw.strip() or raw.lstrip().startswith('#'):
                continue
            line = expand(raw, self.env | scope).strip()
            if line.startswith('#'):
                continue
            condition = re.fullmatch(r'ecmcIf\("(.*)"\)', line)
            if condition:
                self.env['IF_TRUE'] = '' if expression(condition[1]) else '#-'
                continue
            if line == 'ecmcEndIf()':
                self.env.pop('IF_TRUE', None)
                continue
            if line == 'exit':
                self.env.pop('IF_TRUE', None)
                return
            if line.startswith('ecmcExit'):
                raise ValueError(line)
            match = re.fullmatch(r'(epicsEnvSet|epicsEnvUnset|ecmcEpicsEnvSetCalcTernary|ecmcEpicsEnvSetCalc)\((.*)\)', line)
            if match:
                args = arguments(match[2])
                if match[1] == 'epicsEnvSet':
                    self.env[args[0]] = args[1]
                elif match[1] == 'epicsEnvUnset':
                    self.env.pop(args[0], None)
                elif match[1] == 'ecmcEpicsEnvSetCalcTernary':
                    self.env[args[0]] = args[2] if expression(args[1]) else args[3]
                else:
                    value = expression(args[1])
                    self.env[args[0]] = args[2] % int(value) if len(args) > 2 else str(value)
                continue
            if line.startswith('ecmcFileExist('):
                continue
            if line.startswith('ecmcConfigOrDie '):
                self.commands.append(shlex.split(line)[1])
            elif line.startswith('iocshLoad '):
                words = shlex.split(line)
                params = dict(item.split('=', 1) for item in arguments(words[2]))
                self.run(ROOT / 'naming' / words[1], scope | params)
            elif line.startswith('dbLoadRecords('):
                args = arguments(line[len('dbLoadRecords('):-1])
                assert (ROOT / 'db/core' / args[0]).exists(), args[0]
                self.records.append(args[0])
            elif line.startswith('ecmcSdoRegisterRestore('):
                self.registrations.append(arguments(line[len('ecmcSdoRegisterRestore('):-1]))
            else:
                raise AssertionError(f'Unhandled loader command: {line}')


class SdoStartupTests(unittest.TestCase):
    def test_simulation_skips_async_sdo_configuration_and_pvs(self):
        for options in ({}, {'BYTE_SIZE': '256'}):
            with self.subTest(options=options):
                loader = Loader(ECMC_SIM='1', **options)
                self.assertEqual(loader.commands, [])
                self.assertEqual(loader.records, [])
                self.assertEqual(loader.registrations, [])

    def test_default_scalar_needs_no_queue_restore_flags(self):
        loader = Loader()
        self.assertIn('Cfg.EcConfigureSdoQueue(26,threshold,0,0)', loader.commands)
        self.assertIn('ecmcSDOAsyncInt.template', loader.records)
        self.assertIn('ecmcSDOQueuedReadback.template', loader.records)
        self.assertIn('ecmcSDOQueuedStartup.template', loader.records)
        self.assertEqual(loader.registrations, [['26', 'threshold', 'TEST:m0s026-SDO-threshold-StartupData_']])
        self.assertEqual(loader.env['ECMC_SDO_QUEUE_IN_USE'], '1')
        self.assertFalse(any('Request' in command for command in loader.commands))

    def test_value_write_option_is_independent_of_preop_restriction(self):
        for auto in ('0', '1'):
            for preop in ('0', '1'):
                with self.subTest(auto=auto, preop=preop):
                    loader = Loader(WRITE_ON_VAL=auto, PREOP_ONLY=preop)
                    self.assertIn(f'Cfg.EcConfigureSdoQueue(26,threshold,{auto},{preop})', loader.commands)
                    self.assertEqual(len(loader.registrations), 1)

    def test_scalar_types_load_one_staging_and_one_readback_record(self):
        for datatype, staging, readback in [
            ('F64', 'ecmcSDOAsyncFloat.template', 'ecmcSDOQueuedReadback.template'),
            ('U64', 'ecmcSDOAsyncInt64.template', 'ecmcSDOQueuedReadbackInt64.template'),
            ('S64', 'ecmcSDOAsyncInt64.template', 'ecmcSDOQueuedReadbackInt64.template'),
        ]:
            with self.subTest(datatype=datatype):
                loader = Loader(DT=datatype)
                self.assertIn(staging, loader.records)
                self.assertIn(readback, loader.records)
                self.assertNotIn('ecmcSDOAsyncInt.template', loader.records)

    def test_arrays_keep_the_existing_interface(self):
        loader = Loader(BYTE_SIZE='256', DT='')
        self.assertEqual(loader.commands, ['Cfg.EcAddSdoAsyncArray(26,0x8000,0x32,256,threshold)'])
        self.assertEqual(loader.records, ['ecmcSDOAsyncArray.template'])
        self.assertEqual(loader.registrations, [])
        self.assertNotIn('ECMC_SDO_QUEUE_IN_USE', loader.env)
        with self.assertRaises(ValueError):
            Loader(BYTE_SIZE='256', WRITE_ON_VAL='1')

    def test_invalid_scalar_options_fail_before_configuration(self):
        for option in ('WRITE_ON_VAL', 'PREOP_ONLY'):
            with self.subTest(option=option), self.assertRaises(ValueError):
                Loader(**{option: '2'})

    def test_activation_defers_automatically_for_scalar_objects(self):
        text = (ROOT / 'scripts/setAppMode.cmd').read_text()
        for queued in (0, 1):
            for epics_first in (0, 1):
                env = dict(ECMC_SDO_QUEUE_IN_USE=queued, ECMC_START_EPICS_FIRST=epics_first)
                for line in text.splitlines():
                    if line.startswith('ecmcEpicsEnvSetCalcTernary(ECMC_START_'):
                        args = arguments(expand(line, env).split('(', 1)[1][:-1])
                        env[args[0]] = args[2] if expression(args[1]) else args[3]
                self.assertEqual(env['ECMC_START_EPICS_FIRST_CMD'] == '', bool(queued or epics_first))
                self.assertEqual(env['ECMC_START_ECMC_FIRST_CMD'] == '', not bool(queued or epics_first))
        self.assertIn('${ECMC_START_EPICS_FIRST_CMD}afterIocRunning "ecmcStartAppModeAsync(', text)
        self.assertNotIn('SDO_AUTO_START', text)

    def test_elm3504_example_saves_exactly_the_eight_configured_endpoints(self):
        example = ROOT / 'examples/PSI/lab_setup/asr/analog'
        startup = (example / 'MTEST04-EC-ASR_startup.script').read_text()
        request = (example / 'cfg/MTEST04-EC-ASR_sdo_set.req').read_text()
        self.assertIn('#ENABLE-PASS=1', request)
        saved = [line for line in request.splitlines() if line and not line.startswith('#')]
        expected = []
        calls = re.findall(r'addEcSdoRT.cmd "([^"]+)"', startup)
        self.assertEqual(len(calls), 8)
        defaults = re.findall(r'Cfg\.EcAddSdoDT\((26,0x[0-9A-F]+,0x3[23],-?\d+,S32)\)', startup)
        self.assertEqual(len(defaults), 8)
        for params in calls:
            args = dict(item.split('=', 1) for item in params.split(','))
            channel = int(args['NAME'][2:4])
            self.assertEqual(int(args['INDEX'], 16), 0x8000 + 16 * (channel - 1))
            self.assertEqual(int(args['SUBINDEX'], 16), 0x32 if 'Low' in args['NAME'] else 0x33)
            self.assertEqual(args['SLAVE_ID'], '26')
            self.assertEqual(args['DT'], 'S32')
            baseline = '-8388608' if 'Low' in args['NAME'] else '8388607'
            self.assertIn(f"26,{args['INDEX']},{args['SUBINDEX']},{baseline},S32", defaults)
            Loader(**args)
            expected.append(f"MTEST04-EC-ASR:m0s026-SDO-{args['NAME']}-StartupData_")
        self.assertCountEqual(saved, expected)
        self.assertNotIn('QUEUE=', startup)
        self.assertNotIn('RESTORE=', startup)
        self.assertNotIn('SDO_AUTO_START', startup)


if __name__ == '__main__':
    unittest.main()
