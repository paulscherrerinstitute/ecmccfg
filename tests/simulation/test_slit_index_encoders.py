"""Pure index-crossing and distinct EL5102/EL7062 latch protocol checks."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/simulation'))
sys.path.insert(0, str(ROOT / 'tests/integration'))

import touch_probe
from slit.instrumentation import IndexEncoders


model = IndexEncoders.__new__(IndexEncoders)
model.config = {'counts_per_mm': 4096, 'index_period_mm': .125}
model.probe = touch_probe.Model()
model.el5102_armed = model.el5102_stored = False
model.el5102_latch = 0
model.el5102_capture = model.el7062_capture = None
model.previous_counts = None

# Establish position, arm both protocols, then cross the first positive-going
# index after the simulated low limit (-0.375 mm = -1536 counts).
model.step((0, 0), -.4)
model.step((1, 17), -.39)
feedback = model.step((1, 17), -.37)
assert feedback['old_latch'] == feedback['new_latch'] == (-1536 & 0xffffffff)
assert feedback['old_status'] == 1
assert feedback['new_status'] == 3  # enabled plus positive position stored

# Both are single-shot and retain the first result until explicitly disarmed.
retained = model.step((1, 17), -.24)
assert retained['old_latch'] == retained['new_latch'] == (-1536 & 0xffffffff)
cleared = model.step((0, 0), -.23)
assert cleared['old_status'] == cleared['new_status'] == 0

print('EL5102 legacy latch and EL7062 touch-probe index simulation passed.')
