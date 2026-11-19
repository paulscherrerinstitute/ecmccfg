# Motion and PLC simulation

A separate simulation IOC with two independent EL7062 DS402 CSP axes.
`CSP` is controlled through its motor record. `PLC` is controlled by a
PLC request/acknowledgement interface. Both use the existing DS402 plant
model and the same incremental encoder scale for setpoint and feedback.

From the engineering checkout, start the IOC in one terminal:

```sh
./start_motion_sim.sh
```

With PyEpics installed in the host Python environment, run the checks
from a second terminal:

```sh
python3 ecmccfg/tests/integration/motion/check.py
```

Use repeatable `--case` options to select from `csp`, `plc`,
`ethercat`, `storage`, and `group-sequence`. The checker requires
the `SIMMOTION:` namespace and simulation metadata before issuing motion.
Run it against an otherwise idle simulation.

The CSP case checks a completed motor-record move and a mid-flight stop,
including Busy, readback, and DMOV. The PLC case follows the forward/return
pattern of the PSI motion sequence example. It exercises power on/off,
reset, reference at zero, absolute and relative moves, velocity move, halt,
and rejected requests. It checks return status, axis error, Busy, Homed,
actual position, PLC first-scan and scan counters, static request/ack and
command counters, and a global target variable. It also verifies that PLC
motion leaves the other axis in place. The case also checks encoder and
hardware readiness, home state, and injection and reset of an axis error.

The EtherCAT case injects both levels into a simulated EL1008 input and
verifies the resulting PLC-driven EL2008 output. It covers the single-bit
and bit-range functions, including invalid bit index handling and error
reset. The storage case covers clear, append, size, full, cursor, element
read/write, min/max/average, buffer copy, error/reset, and waveform
publication. Both cases verify results through EPICS.

The group/sequence case enables both axes through the PLC group API and
starts a compiled sequence with two nonblocking moves and explicit wait
steps. It verifies that both axes are busy together, injects a fault into
one axis, checks the group error, then explicitly halts the group and
stops the sequence. It checks that the unaffected axis stops short of
its target, resets both the group and the sequence, then reruns the same
plan to completion. The group API is used explicitly to stop both axes.

PLC APIs are described in [the PLC function reference](../../../hugo/content/manual/plc_cfg/functions.md)
and [variable reference](../../../hugo/content/manual/plc_cfg/variables.md).
These cases do not require live EtherCAT timing, domain memory maps, or
async SDO transfers.

The simulation uses a position-following plant model. The tests cover ECMC
command and feedback paths rather than physical servo tuning.
