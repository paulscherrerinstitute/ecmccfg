from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools/simulation"))
import unittest
from el5021 import EL5021


class CounterTests(unittest.TestCase):
    def test_preload_and_forward_c_reset(self):
        model = EL5021()
        self.assertEqual(model.step(-.002, 4, 1 << 30)[:2], (1 << 30, 4))
        self.assertGreater(model.step(-.001)[0], 1 << 30)
        self.assertEqual(model.step(.0001)[0], 82)

    def test_negative_counter_wrap_and_reverse_reset(self):
        model = EL5021(counts_per_degree=1000)
        self.assertEqual(model.step(-.01)[0], (1 << 32) - 10)
        model.step(.01)
        self.assertEqual(model.step(-.005)[0], (1 << 32) - 5)

    def test_latch_requires_rearming(self):
        model = EL5021(counts_per_degree=1000, c_reset=False)
        model.step(-1, 4, 100)
        model.step(-.1, 1)
        self.assertEqual(model.step(.1, 1)[1:], (1, 1100))
        model.step(-.1, 1)
        self.assertEqual(model.step(.1, 1)[2], 1100)
        self.assertEqual(model.step(.2, 0)[1], 0)

    def test_reset_disabled_keeps_preload(self):
        model = EL5021(counts_per_degree=1000, c_reset=False)
        model.step(-1, 4, 100)
        self.assertEqual(model.step(1)[0], 2100)


if __name__ == '__main__':
    unittest.main()
