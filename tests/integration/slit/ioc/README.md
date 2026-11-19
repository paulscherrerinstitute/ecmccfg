# Dedicated slit simulation acceptance configuration

This directory is separate from `../slit_matrix` and never loads its startup
script. It retains physical axes TR_LO/TR_HI (5/6), virtual CENTERY/GAPY (12/13),
slit kinematics and the master/slave state machine, while declaring only the
terminals needed by those axes. Both blades have a second EL5042 encoder and
injectable status-word hardware limits. Soft limits are +/-1 mm. Original
`slit_matrix` files are unchanged.

Run from this directory with your usual launcher:

```sh
iocsh startup.cmd
```

Defaults: IOC/PV namespace SIMSLIT:, SIM=1, ENG_MODE=1, 1000 Hz. The environment
macros TEST_IOC, ECMCCFG_TEST_VER and ECMC_TEST_VER can override IOC name/versions;
versions default to sandst_a. Use current ecmccfg/ECMC with simulation records and
the MCU-Cfg-Sim-Mode metadata PV installed. No real EtherCAT master is claimed.

In the ecmccfg repository, list or execute modular tests:

```sh
python3 tests/integration/slit/run.py --config /path/to/ecmccfg/tests/integration/slit/ioc
python3 tests/integration/slit/run.py --prefix SIMSLIT: --run --case feedback --loop closed
python3 tests/integration/slit/run.py --prefix SIMSLIT: --run --case limits
python3 tests/integration/slit/run.py --prefix SIMSLIT: --run
```

Pass --config if the two repositories are not siblings in the normal workspace.
The runner owns the drive/EL5042 model and checks this configuration's schema
marker before issuing writes. Do not run another simulator on slaves 9/12/14/20.
Full test semantics, scaling, fault injection and JSON/JUnit report instructions
are in ecmccfg `tests/integration/slit/README.md`.

The plant/testing infrastructure was checked offline; this configuration and
its acceptance scenarios still need their first live IOC run. Real distributed
clock timing and physical motor dynamics are not represented.

Brake tests are a separate selectable module:

```sh
python3 tests/integration/slit/run.py --prefix SIMSLIT: --run --case brake
```

Restart the test IOC after this configuration update. Simulated EL2008 slave 5
output 01 controls the LO brake and output 02 controls the HI brake. Output 0
means applied, 1 released. Both axis YAML files configure `drive.brake` and enable the production brake state machine;
opening delay is 250 cycles and close-ahead delay is 200 cycles at 1000 Hz.
The runner observes these native output PVs; it never writes brake values to
manufacture a pass. CA checks functional sequence windows, while the existing
ECMC C++ brake tests cover exact cycle boundaries. The plant does not model
brake mechanics or coil/armature feedback.

Configuration schema 2 adds the EL70xx drive alarm/reset links: drive status
bit 3 is alarm 0, control bit 1 is reset. A drive-fault injection is expected
to latch ERROR_DRV_HW_ALARM_0 (0x1460e). Restart this IOC after updating the
configuration; the runner rejects an older schema marker before issuing writes.

## Homing tests

Both physical-axis YAMLs declare `encoder.homing`; this is required for
ecmccfg to load `ecmcMotorRecordhome.template` and the `-HomProc.OMSL`,
`-HomPos`, speed and acceleration records. Setting Cfg homing defaults alone
does not create those PVs.

The physical-axis YAML files link drive-status bit 13 through `input.home`.
Their `encoder.homing` settings and the additional BiSS encoder YAML set
procedure 1, 0.2/0.1 mm/s, acceleration/deceleration 1, latch count 1, no
post-home move, and a 12-second sequence watchdog. EL5102 slave 22 and channel
2 of the existing EL7062 slave 20 add blade-coupled incremental encoders for
index homing: the former uses the legacy encoder latch PDOs and the latter uses
touch probe 1 configured from the secondary encoder index. Channel 1 remains
the independent probe-axis fixture. `test-marker.db` supplies
`SIM:SlitTest:HomingSchema=3`. Restart this
IOC from the updated directory before running the new module; no ECMC binary
change is required for these test additions.

```sh
python3 tests/integration/slit/run.py --prefix SIMSLIT: --run --case homing
```

Both motor home fields and native commands exercise procedures 1–10, configured
14, manual reference (native 15 / motor 25), and absolute 21/22 (closed loop).
STOP during search/reversal/cam crossing, disable, drive/encoder faults and
missing cam are also covered. Busy, DMOV, MOVN, Homed and reference geometry are
checked. Other test modules retain their existing manually injected limits;
position-based sensors are enabled only during homing cases. The plant keeps a
separate physical travel bound and restores encoder references without resetting
raw counters. See ecmccfg `tests/integration/slit/README.md` for details and limits.

## Encoder relay power tests (schema 3)

Schema 3 links spare EL2008 output 03 to LO encoder 2 power and output 04 to HI
encoder 2 power. `cfg/biss-c.yaml` declares the relay through
`encoder.power.output`, with `enable: false`; `ENC_PWR_CH` selects channel 03
or 04 when that YAML is loaded. Encoder power control stays disabled at startup. Install the
ECMC encoder-power implementation and the ecmccfg `Enc02-PwrState` readback,
then restart this dedicated IOC with the updated configuration.

From the ecmccfg repository:

```sh
python3 tests/integration/slit/run.py --prefix SIMSLIT: --run --case encoder_power
```

The group temporarily couples the plant's EL5042 supply to its relay output.
An unpowered encoder publishes positionActual zero and ready low while the
physical position and drive counter remain unchanged. Tests cover both relay
polarities, different startup/idle delays, early/late ready, motor/native
requests, wake with the drive still enabled, timeout, STOP, and atTarget versus
tighter controller-deadband settling. Power must remain on for the configured
post-settling dwell; a loss of qualification resets the timer. Twelve cases are
planned per loop, with three feedback-change cases skipped in open loop. Cleanup
restores ordinary supply simulation and native settings before the next group.

Off-state rollover coverage alternates zero and an all-ones raw counter word.
The test verifies that the injected jump exceeds ECMC's rollover threshold,
checks retained encoder position while off, and repeats relative moves after
wake-up without rehoming or resetting between cycles. Standalone production
tests also cover a valid sample near the upper counter boundary, operation
without a ready input, and preservation of already accumulated positive and
negative turns across power cycles.

The wake-position-jump case injects positive and negative EL5042 measurement
steps while encoder power is off, each exceeding five atTarget tolerances.
Retained feedback must stay unchanged until wake-up. Relative motion must then
use the fresh shifted position, without adding physical travel to compensate
for the measurement step. The case requires closed-loop EL5042 feedback and
leaves the following-error monitor enabled.

```sh
python3 tests/integration/slit/run.py --prefix SIMSLIT: --run --case encoder_power --test wake_position_jump --loop closed
```

## Optional counter handover

With the updated ECMC handover build installed, run:

```sh
python3 tests/integration/slit/run.py --prefix SIMSLIT: --run --case encoder_handover --loop closed
```

The existing absolute encoder 2 and internal counter 1 are used. No new links
or schema change is required. Cases temporarily enable handover and verify
primary selection before/after power-off, repeated wake, positive/negative wake
mismatch faults without automatic replay, and readiness timeout. The mode stays
disabled in the normal fixture and is removed during test cleanup.


## PVT tests

The axis YAML files enable profile buffers through `epics.motorRecord.pvt`.
Restart this IOC after deploying the YAML update, then run the `pvt` group from
[the suite](../README.md#pvt-profile-coverage). The normal ecmccfg finalization
loads the shared profile controller. startup.cmd reserves EL2008 slave 5/channel
05 for active-high 400 ms PVT pulses. Trigger tests check `SIMSLIT:PVT-SftTrg`,
`SIMSLIT:m0s005-BO05-RB` and pulse-latched positions. The cases execute real profiles through the simulation backend.

## DS402 probe and position compare (schema 4)

The fixture also declares EL7062_OPT slave 20 (CSV, TP and U32 TP timestamps)
with independent axis `PROBE` (7), and EL2252 slave 21. `PROBE` uses drive type 1
(DS402), has no motor record and does not participate in the slit kinematics.
The runner owns its DS402 state machine, position feedback and probe-input model.
The runner enables probe control with `PROBE-Enc01-TP-EnableCmd`, disables
`PROBE-Enc01-TP-AutoRearmCmd` for single-shot tests, and then uses
`PROBE-Enc01-TP-ArmCmd`. These use masks 1, 4 and 2 respectively on the shared
native `ax7.enc.control1` UInt32Digital parameter. Clearing enable also disarms;
cleanup clears both arm and enable. No startup arming command is needed.
Install matching rebuilt ECMC and ecmccfg: the existing arm PV names remain,
but their native binding replaces the old separate probe arm parameters.
Use `--case touch_probe` for capture/rearm/negative controls and
`--case position_compare` for the missing-clock wait/cancel control. The current
native SIM backend has no sample-clock provider: successful timed output pulses
and reconstruction of probe absolute event time are not covered. See the parent
README for the parameter/filter/controller/monitoring modules and limits.
