"""Exercise identity startup scripts with mocked EtherCAT reads and real EPICS loading."""
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import tempfile
import unittest

from test_ex72xx_opt import ROOT, arguments, expand, expression


class Script:
    def __init__(self, env=None, responses=None, firmware=None):
        self.env = dict(SCRIPTEXEC='iocshLoad', ECMC_CONFIG_ROOT='', ECMC_P='TEST:',
                        ECMC_EC_SLAVE_NUM='13')
        self.env.update(env or {})
        self.responses = responses or {}
        self.firmware = firmware or ('01.23', 'Available')
        self.calls, self.records = [], []

    def run(self, source, scope=None):
        scope = scope or {}
        for raw in source.splitlines():
            if not raw.strip() or raw.lstrip().startswith('#'):
                continue
            line = expand(raw, self.env | scope).strip()
            if line.startswith('#'):
                continue
            match = re.fullmatch(r'(\w+)\((.*)\)', line)
            if match:
                command, args = match[1], arguments(match[2])
                if command == 'epicsEnvSet':
                    self.env[args[0]] = args[1]
                elif command == 'epicsEnvUnset':
                    self.env.pop(args[0], None)
                elif command == 'ecmcEpicsEnvSetCalcTernary':
                    self.env[args[0]] = args[2] if expression(args[1]) else args[3]
                elif command == 'ecmcEpicsEnvSetCalc':
                    value = int(expression(args[1]))
                    self.env[args[0]] = args[2] % (value & 0xffffffff)
                elif command == 'ecmcEpicsEnvSetSdoString':
                    self.calls.append((command, tuple(args[1:])))
                    value, status = self.firmware
                    self.env[args[0]] = value
                    self.env[args[0] + '_DB_VALUE'] = value
                    self.env[args[0] + '_STATUS'] = status
                else:
                    raise AssertionError(line)
                continue
            words = shlex.split(line)
            if words[0] == 'ecmcConfig':
                self.calls.append(words[1])
                default = '1' if words[1].startswith('EcGetSlaveSdoReadSupport(') else '0'
                result = self.responses.get(words[1], default)
                if result is not None:
                    self.env['ECMC_CONFIG_RETURN_VAL'] = result
            elif words[0] == 'iocshLoad':
                params = dict(item.split('=', 1) for item in arguments(words[2]))
                if words[1] == 'slaveIdentity.cmd':
                    self.run((ROOT / 'scripts/slaveIdentity.cmd').read_text(), scope | params)
                else:
                    assert words[1] == 'applyTemplate.cmd', line
                    lexer = shlex.shlex(params['PARAM'], posix=True)
                    lexer.whitespace, lexer.whitespace_split = ',', True
                    lexer.commenters = ''
                    self.records.append(dict(item.strip().split('=', 1) for item in lexer))
            else:
                raise AssertionError(line)


class SlaveIdentityTests(unittest.TestCase):
    def startup(self, env=None, responses=None, firmware=None):
        script = Script(env, responses, firmware)
        script.run((ROOT / 'scripts/slaveIdentity.cmd').read_text())
        self.assertFalse(any(k.startswith('ECMC_TEMP_SLAVE_') for k in script.env))
        return script

    def test_existing_commands_work_without_string_reader(self):
        script = self.startup(responses={'EcGetSlaveRevisionNum(13)': '1376256',
                                        'EcGetSlaveSerialNum(13)': '4294967295'})
        self.assertEqual(script.records, [dict(HWFw='Unknown', HWRev='0x00150000',
            HWSer='4294967295', HWFwStat='Not supported', HWIdStat='Available')])
        self.assertEqual(script.calls, ['EcGetSlaveSdoReadSupport(13)',
                                       'EcGetSlaveRevisionNum(13)',
                                       'EcGetSlaveSerialNum(13)'])

    def test_string_reader_and_unsigned_values(self):
        for revision, serial in [('4294967295', '4294967295'), ('0', '0')]:
            with self.subTest(revision=revision, serial=serial):
                script = self.startup({'ECMC_SDO_STRING_SUPPORTED': '1'},
                    {'EcGetSlaveRevisionNum(13)': revision, 'EcGetSlaveSerialNum(13)': serial})
                self.assertEqual(script.records[0]['HWRev'], '0x%08x' % int(revision))
                self.assertEqual(script.records[0]['HWSer'], serial)
                self.assertEqual(script.records[0]['HWFw'], '01.23')
                self.assertEqual(script.calls[-1], ('ecmcEpicsEnvSetSdoString',
                                                  ('13', '0x100a', '0', '39')))

    def test_skipped_reads(self):
        for env, status in [({'READ_IDENTITY': '0'}, 'Disabled'),
                            ({'ECMC_READ_SLAVE_IDENTITY': '0'}, 'Disabled'),
                            ({'ECMC_SIM': '1'}, 'Simulation'),
                            ({'ECMC_DEV_MODE': '1'}, 'Development mode')]:
            with self.subTest(env=env):
                script = self.startup({'ECMC_SDO_STRING_SUPPORTED': '1'} | env)
                self.assertEqual(script.calls, [])
                self.assertEqual(script.records, [dict(HWFw='Unknown', HWRev='Unknown',
                    HWSer='Unknown', HWFwStat=status, HWIdStat=status)])
        script = self.startup({'ECMC_READ_SLAVE_IDENTITY': '0', 'READ_IDENTITY': '1'})
        self.assertEqual(len(script.calls), 3)

    def test_no_discovered_sdos_skips_firmware_only(self):
        script = self.startup({'ECMC_SDO_STRING_SUPPORTED': '1'},
            {'EcGetSlaveSdoReadSupport(13)': '0',
             'EcGetSlaveRevisionNum(13)': '1376256',
             'EcGetSlaveSerialNum(13)': '42'})
        self.assertEqual(script.records, [dict(HWFw='Unknown', HWRev='0x00150000',
            HWSer='42', HWFwStat='No discovered SDOs', HWIdStat='Available')])
        self.assertNotIn('ecmcEpicsEnvSetSdoString', [call[0] if isinstance(call, tuple)
                                                      else call for call in script.calls])

    def test_failed_reads_and_no_stale_values(self):
        for result in ['Error: 1234', None]:
            with self.subTest(result=result):
                script = self.startup({'ECMC_SDO_STRING_SUPPORTED': '1',
                                       'ECMC_CONFIG_RETURN_VAL': '4294967295'},
                    {'EcGetSlaveRevisionNum(13)': result, 'EcGetSlaveSerialNum(13)': result},
                    ('Unknown', 'Unavailable/read failed'))
                self.assertEqual(script.records, [dict(HWFw='Unknown', HWRev='Unknown',
                    HWSer='Unknown', HWFwStat='Unavailable/read failed', HWIdStat='Read failed')])
        script = self.startup({'ECMC_SDO_STRING_SUPPORTED': '1'}, firmware=('a' * 39, 'Truncated'))
        script.env.update(ECMC_SIM='1', ECMC_EC_SLAVE_NUM='14')
        script.run((ROOT / 'scripts/slaveIdentity.cmd').read_text())
        self.assertEqual(script.records[-1]['HWFw'], 'Unknown')
        self.assertEqual(script.records[-1]['HWFwStat'], 'Simulation')

    def test_no_records_means_no_read(self):
        source = (ROOT / 'scripts/addSlave.cmd').read_text()
        first = source.index('#- Read startup metadata')
        last = source.index('${DEFAULT_SLAVE_PVS}${SCRIPTEXEC}',
                            source.index('slaveIdentity.cmd', first))
        script = Script({'DEFAULT_SLAVE_PVS': 'False', 'ECMC_SDO_STRING_SUPPORTED': '1'})
        script.run(source[first:last])
        self.assertEqual(script.calls, [])
        self.assertEqual(script.records, [])

    def test_epics_static_records(self):
        msi, softioc = shutil.which('msi'), shutil.which('softIoc')
        if not msi or not softioc:
            self.skipTest('EPICS msi and softIoc are required')
        source = (ROOT / 'db/core/ecmcEcSlave.template').read_text()
        first = source.index('# Startup snapshots.')
        last = source.index('# This record is used', first)
        with tempfile.TemporaryDirectory() as temp:
            template, database = Path(temp)/'identity.template', Path(temp)/'identity.db'
            template.write_text(source[first:last])
            macro = ('ECMC_P=TEST:,ECMC_G=TEST,HWFw=01.23,HWRev=0xffffffff,'
                     'HWSer=4294967295,HWFwStat=Available,HWIdStat=Available')
            output = subprocess.run([msi, '-M', macro, str(template)],
                                    capture_output=True, text=True, check=True).stdout
            database.write_text(output)
            self.assertNotRegex(output, r'\$[({]')
            self.assertEqual(len(re.findall(r'record\(stringin,', output)), 5)
            self.assertNotIn('field(INP', output)
            commands = f'dbLoadRecords("{database}")\ndbDumpRecord(0,"stringin",2)\nexit\n'
            process = subprocess.run([softioc], input=commands, capture_output=True,
                                     text=True, timeout=15, check=True)
            for value in ['01.23', '0xffffffff', '4294967295']:
                self.assertIn(f'field(VAL,"{value}")', process.stdout)
            self.assertNotIn('ERROR', process.stdout + process.stderr)


if __name__ == '__main__':
    unittest.main()
