"""Backend selection and read semantics without a live IOC."""
import importlib.util
from pathlib import Path
import sys
from types import SimpleNamespace
import unittest
from unittest.mock import MagicMock, patch

HELPER = Path(__file__).resolve().parents[1] / 'qt/ecmc_ca_compat.py'


def load():
    spec = importlib.util.spec_from_file_location('compat_test', HELPER)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class BackendTests(unittest.TestCase):
    def test_legacy_modules_used_unchanged(self):
        ca, pv = SimpleNamespace(), SimpleNamespace()
        with patch.dict(sys.modules, ca=ca, epicsPV=pv, epics=None):
            helper = load()
        self.assertIs(helper.ca, ca)
        self.assertIs(helper.epicsPV, pv)

    def test_fallback_reads_numbers_strings_and_long_strings(self):
        for kind, count, value, string in [('double', 1, 9, False),
                                            ('string', 1, 'TR_LO', False),
                                            ('char', 40, 'DEVICE', True)]:
            pv = MagicMock()
            pv.type, pv.count = kind, count
            pv.get.return_value = value
            factory = MagicMock(return_value=pv)
            with patch.dict(sys.modules, ca=None, epicsPV=None, epics=SimpleNamespace(PV=factory)):
                helper = load()
                self.assertEqual(helper.epicsPV.epicsPV('TEST').getw(), value)
            pv.get.assert_called_once_with(timeout=3, use_monitor=False, as_string=string)
            pv.disconnect.assert_called_once()

    def test_missing_pv_uses_legacy_compatible_exception(self):
        pv = MagicMock()
        pv.wait_for_connection.return_value = False
        with patch.dict(sys.modules, ca=None, epicsPV=None, epics=SimpleNamespace(PV=lambda name: pv)):
            helper = load()
            with self.assertRaises(helper.ca.ca_nothing):
                helper.epicsPV.epicsPV('MISSING').getw()
        pv.disconnect.assert_called_once()


if __name__ == '__main__':
    unittest.main()
