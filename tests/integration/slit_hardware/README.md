# Real slit hardware acceptance tests

This suite uses the [hardware IOC](../slit/ioc_hardware/README.md), with TR_LO
using BiSS plus counter auto-power handover and TR_HI using its drive counter.
It does not run a simulated plant or write EtherCAT input images. Python 3 and
`pyepics` are required on the client for live runs.

From the ecmccfg root, list the tests without connecting:

```sh
python3 tests/integration/slit_hardware/run.py
```

Review `profile.json` against the commissioned mechanics and coordinate system.
By default, `reference_to_zero: true` references the current physical positions
to zero before motion tests. This sets encoder coordinates without seeking a
switch or moving the motors. Both drives must be disabled and stationary.
The suite powers and validates BiSS, writes zero to the physical axes' native
`TR_LO-SetEncPosCmd` and `TR_HI-SetEncPosCmd` PVs, synchronizes motor targets,
and verifies the tracking counter inherits zero
before BiSS powers down. Set `reference_to_zero: false` to retain existing
coordinates instead. The status-only group never changes references.
The initial defaults are **5 mm excursions around the zero reference (or captured starting
position when zero referencing is disabled)**, **1 mm/s**, **0.015 mm completion tolerance**, and a test
window of **−10…+10 mm relative to each blade's measured startup position**. Copy the profile and use
`--profile /path/to/profile.json` for different bounds/settings. Incremental
coordinates alone do not establish the physical travel range; verify the actual
positions and scaling before running motion tests.
For example, a physical axis starting at 35 mm gets a test window of 25…45 mm.
Each normal round trip commands origin +5 mm, origin −5 mm, then origin; the
middle leg therefore travels 10 mm. The move timeout is 30 seconds.

The IOC's absolute soft limits remain separate and are checked before every
motor target. The supplied hardware YAML currently sets −10…+10 mm; configure
these for the machine's actual absolute travel if its starting coordinate lies
elsewhere. The runner does not shift, disable or expand these limits. Zero referencing changes
encoder coordinates; it does not change the numerical soft-limit settings. An invalid
planned target fails preflight without a motor write. Existing custom profiles
without `relative_to_start: true` retain absolute-envelope interpretation.

Start with read-only status checks:

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case status
```

Then run physical moves, or all groups:

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case motion
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run
```

Use `--case virtual`, `--case encoder_power`, or `--test motor_stop` to narrow
execution. Multiple `--case` and `--test` arguments are supported. The suite
runs each case once in the configured feedback mode; it does not switch the
hardware to simulated open/closed-loop variants.

| Group | What is checked |
| --- | --- |
| `status` | Real backend, fixture identity, bus/application state, axis IDs, stopped motor/native status, no faults/warnings, coordinate agreement, virtual feedback kinematics |
| `motion` | Each physical axis moves both directions and returns; repeated motor targets; STOP while busy and no subsequent movement; motor/native completion, atTarget and faults |
| `dmov` | Full `DMOV/MOVN` lifecycle for physical and virtual motor moves plus a physical native move; put-notify remains incomplete while `DMOV=0` |
| `virtual` | Center and gap move both directions and return; predicted blade targets stay in the test envelope; physical/virtual feedback agrees |
| `encoder_power` | A normal move of the configured encoder-power axis settles, BiSS powers off and counter becomes primary; the next move restores power/readiness/BiSS primary and completes |
| `native` | LO and HI native absolute and relative moves using the execute PV, with native parameters restored |
| `target_write` | LO and HI absolute and repeated identical relative target writes; staging and mode selection do not move; direct writes auto-enable a disabled drive without an execute pulse |
| `motor` | LO and HI positive/negative OFF and both DIR values; user/dial/native positions and unchanged native limits; original fields and limit-sync policy restored |
| `brake` | LO/HI EL2008 brake outputs: amplifier/brake opening and closing order, release during motion and STOP deceleration, application after auto-disable |
| `no_sm` | Physical motor moves/STOP, native, target-write, OFF/DIR, encoder sleep/wake and PVT repeated with the master/slave state machine disabled; virtual axes remain disabled, uncommanded physical axes stay stationary |
| `pvt` | LO and HI profile Build/Execute/Readback, measured excursions both ways and return to start, controller success and fault checks |
| `stall` | Four motor/native LO/HI cases: a target between encoder counts keeps AtTarget false, stall alarm appears, motor processing terminates, reset and fresh move recover; also repeated in `no_sm` |
| `coupled_stop` | Eight center/gap × LO/HI × motor/native STOP cases: stopping one physical slave stops coordinated motion and completes all records |
| `concurrent` | Two independent physical moves with small commanded excursions on the other axis, whose peer must continue to its original target |
| `homing` | Six opt-in TR_HI EL7031 limit-switch searches using native/motor interfaces, including backward-limit post moves |

Repeated targets use ordinary asynchronous writes while the first move
completion request remains active; the runner still checks motor/native idle,
atTarget and final position. It does not queue extra put-notify requests on
the same active motor record.

The hardware IOC must include `hardware-test.db` from this change. Restart that
IOC after updating its startup file so `HWSLIT:HardwareSlitTest:Schema` exists.
The runner rejects SIM IOCs, missing fixture identity, wrong axis counts/IDs,
active faults/limits, moving axes, nonzero motor OFF/DIR, and SPMG other than Go
before writing. Physical and virtual targets must respect native soft limits and
the profile's physical envelope. Native soft limits must be enabled. The state
machine must already be enabled. Zero-reference preparation and the encoder-power group require Auto power
mode with Force ON released and encoder power control enabled.

The default run contains 93 live hardware cases (53 with state-machine management and 40 standalone repeats). Six full-stroke homing cases are available separately, for 99 selectable cases excluding the opt-in soft-limit reconfiguration group. Select the added groups independently:

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case native --case target_write --case motor
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case pvt
```

The native groups use the axis command/target/enable PVs. `target_write` selects
`Cfg.SetAxisAutoExec`, checks its status bit, and triggers by writing the target
alone. Both native groups restore the original command fields, target-write mode
and MCU-Cmd transport settings, leaving their axes disabled on exit. Native
moves explicitly synchronize motor targets afterwards.

The motor coordinate cases treat requested positions and travel envelopes as
native dial coordinates. They derive user targets from `user = OFF + sign* dial`
and independently check user RBV/DVAL and native feedback. They temporarily turn
off motor/native soft-limit synchronization, then restore DIR, OFF, FOFF and that
policy after STOP; they do not alter numerical native soft limits.

PVT uses the existing asyn profile interface and requires the updated axis YAML
with `epics.motorRecord.pvt` on all four axes. **Restart the hardware IOC after
deploying those YAML files.** The shared controller is configured automatically
by the normal ecmccfg finalization path. Each test moves one physical axis through
a six-point, fixed-time profile with repeated endpoints, then reads the profile
back. Its default excursion is half the normal step (2.5 mm), with duration
chosen to respect configured velocity and motor ACCS. Cubic interpolation
extrema are checked against native/motor/travel limits before Build, not just the
supplied points. Trigger cases also check the linked EL2008 output. PVT selection, timing,
command fields and previously populated arrays are restored; empty input arrays
remain scratch buffers. Failures request profile Abort and motor STOP. Missing
PVT records are detected before zero-reference/setup writes.

The original `motion` and `virtual` groups use motor VAL, VELO and STOP. Before motion preflight, a sleeping
BiSS encoder is temporarily woken using the configured encoder’s `Enc02-ForceOn` inspection hold,
with the drive disabled. The runner waits for ready/primary selection and
motor/native coordinate agreement, captures all starting positions, then restores
the previous hold. With zero referencing disabled, fixed counter-only feedback mode is respected. The read-only
`status` group does not wake the encoder or write any PVs. The suite uses the IOC's normal
auto-enable and brake policy. Tests do not reset unexpected faults or change numerical soft
limits or feedback selection, or power relays directly. Native target-write mode
and motor coordinate changes are confined to their cases and restored. The optional zero-reference preparation also writes the two physical
`-SetEncPosCmd` PVs and motor SYNC, and intentionally keeps the new references.
It does not write zero to the virtual axes; their feedback follows the PLC
kinematics, and their motor targets are synchronized afterwards.
Zero-reference preparation never starts a homing search or enables a drive. The separate opt-in `homing` group does perform searches and intentionally changes references. Successful
motion cases return to their captured origins; on failure/interruption it stops
all coupled axes and restores changed motor velocities without commanding a
return move. Amplifier disable and encoder power-off follow the existing IOC
configuration. A failed check stops the suite.

JSON and JUnit XML reports are written to `test-results/slit-hardware/` by
default; use `--report /path/report.json` to choose another location. Reports
include per-test status snapshots, failure details, completed move traces and
cleanup errors. These are client-side checks through EPICS; they cannot prove
real-time timing or independently measure physical motion of the counter-only
axis. They have not yet been run against the physical rack.


Run only the standalone cases with:

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case no_sm
```

`no_sm` is included in the default full run. Use `--test pvt`, `--test native`,
`--test target_write`, or another name substring to narrow that group.
Each standalone case stops and disables all four axes, saves and disables
`SM00-EnaCmd`, and selects internal trajectories for both physical axes before
motion. During execution it verifies that management remains disabled/idle,
virtual axes remain disabled/idle, and the other physical axis stays stationary.
The PLC continues to calculate virtual feedback, which is checked as usual;
virtual motion is only tested with management enabled. On success, failure or
interruption, STOP and drive disable precede restoration of the physical
trajectory sources and state-machine enable. Failed restoration is retried by
runner cleanup and reported if it still fails. No automatic return move is made
after a failure. The suite still requires the state machine enabled at entry.


Brake output tests:

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case brake
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case no_sm --test brake
```

Six cases run in each state-machine mode. They read `m0s005-BO01-RB` (LO)
and `m0s005-BO02-RB` (HI), where 1 releases the brake, together with the
EL7041/EL7031 amplifier command readbacks at slaves 14/12. These are the
existing hardware YAML mappings with 250-cycle opening and 200-cycle
close-ahead delays at 1 kHz. Enable-only cases observe amplifier-on/brake-applied
before release, and brake-applied/amplifier-on before switch-off. Motion and
STOP cases verify release while moving, normal auto-disable application and a
return to the origin. Missing output readbacks fail preflight before setup writes.
Tests command the axis enable, motor move and STOP interfaces; they never write
to brake output PVs directly. The checks verify commanded process-image outputs;
there is no independent mechanical brake or relay-contact feedback configured.


PVT trigger cases run on LO and HI, with and without state-machine management:

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case pvt --test triggers
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case no_sm --test triggers
```

These request three pulses at profile points 3, 4 and 5 and check
`PVT-SftTrg` resets to zero, increases without decreasing or exceeding the
request, and finishes at three. Profile readback must contain exactly three
pulse-latched encoder samples near the positive excursion, negative excursion
and return coordinate. Trigger parameters are restored on exit. Both fixtures
link `ec0.s5.binaryOutput05.0` (EL2008 slave 5, channel 05), active high with
400 ms pulses. The tests require `m0s005-BO05-RB` low before execution, observe
three high/low pulse pairs, and require low after completion or abort. Untriggered
profiles must keep it low. Edge observations are included in the JSON trace.
No direct output writes are made. These checks observe the EtherCAT output
process image; electrical pulse timing requires independent input/counter or
oscilloscope feedback. Brake channels 01/02 and simulation encoder supply
channels 03/04 retain their assignments.
Deploy the corrected `ecmcPVTTrigger.template` and restart the IOC for its
software-trigger forward link fix (`FLNK`, previously incorrectly written to `TSE`).


Motion isolation and PVT interruption coverage
--------------------------------------------

Normal motor/native moves and PVT runs check measured blade positions while
waiting. A physical-axis move must leave the other blade stationary. Center
moves must preserve the gap; gap moves must preserve the center. Completed
motor/native moves also verify both independently calculated blade endpoints.
These checks apply with state-machine management enabled as well as `no_sm`.

The PVT group includes twelve interruption cases: LO/HI × Abort/motor STOP/axis
disable × before the first pulse/while a pulse is high. The `no_sm` group repeats
all twelve. Select these without running the entire suite:

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case pvt --test before_first_pulse --test pulse_high
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case no_sm --test before_first_pulse --test pulse_high
```

Each case sends only the selected interruption command. A fallback Abort is
reserved for failure cleanup, so it cannot mask an ignored STOP/disable. The
controller must finish at standstill, lower the trigger output and report an
interruption rather than successful completion. During a bounded dwell, and
again after enable, the cancelled profile must neither move nor emit another
software trigger. A fresh triggered Build/Execute/Readback must then succeed;
the axis returns normally to its original coordinate after successful recovery.
Failures never cause an automatic return move.

STOP/disable can latch the native PVT `AXIS_INTERLOCK` error (`0x242003`). Only
that known controller error may be acknowledged at standstill using `MCU-ErrRst`,
after checking the axes have no native errors. Unexpected controller errors are
reported and left intact. No fault injection, additional sensors or wiring is
required. Position checks use existing feedback; output checks use the EtherCAT
process image and do not independently verify motor mechanics or relay contacts.

Interruption stopping-time/travel checks use the profile's bounded peak speed
and the fixture's equal acceleration/deceleration setting (`.ACCS`), with
publication/command latency margins. They prevent an ignored interruption that
simply runs to the normal endpoint from passing as a stop. The measured bounds
and interruption phase are included in the JSON report; they are test verdicts,
not independent measurements of electrical or mechanical safety performance.


### Recovery and independent-axis motion

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case stall --case coupled_stop --case concurrent
```

Stall cases retain enabled AtTarget monitoring and temporarily set its tolerance
to a positive value below encoder quantization. After the trajectory ends, they require AtTarget=0 and an incomplete
motor request, followed by `ERROR_MON_STALL` (0x14c19), motor problem/alarm and
Busy=0, DMOV=1, MOVN=0, MIP=0 and PACT=0. Known test faults are reset only at
standstill; fresh motion proves the record is usable again. Monitor settings are
restored. Coordinated STOP tests send only the selected physical-axis STOP,
check no cancelled target replays, then verify fresh center/gap motion.

Concurrent cases use commanded second-axis movements. They do not simulate an
external force on real hardware. Encoder-bias and mechanical-backlash injection
are confined to the simulation suite; neither requires additional wiring.

### Explicit full-stroke limit homing

Deploy the updated hardware fixture YAML and `hardware-test.db`, then restart
the hardware IOC. The homing group requires its `HardwareSlitTest:HomingSchema`
marker and must run separately from other groups. It is excluded from the
default run:

```sh
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case homing
python3 tests/integration/slit_hardware/run.py --prefix HWSLIT: --run --case homing --test postmove
```

Only TR_HI (EL7031, slave 12) is searched. Sequence 1 uses the backward limit;
sequence 2 uses the forward limit. Native and motor-record interfaces are both
covered. There is no home sensor on this rig, so cam/index routines are omitted.
Search speed is 3 mm/s, edge speed 0.2 mm/s, acceleration/deceleration 10 mm/s²,
and each operation is bounded by 60 seconds. These are the agreed rig settings;
switch-to-stop clearance has not been independently measured by the suite.

The home reference is −20 mm, outside the normal −10…+10 mm soft limits. The
backward-limit post-move cases then physically move to 0 mm. They check Homed,
limit activation/release, sequencer state and motor/native completion, and
require the motor request to remain busy through the post move. Raw EL5042
channel-1 counts verify actual post-move travel, independently of the coordinate
reset. A reference change alone cannot satisfy that check.

During this explicit group, a separate raw-counter travel guard replaces the
normal ±10 mm test window: at most 100 mm displacement and 125 mm accumulated
travel, including switch release/post movement. Numerical machine soft limits
remain configured. One already-active HI end limit is allowed at entry; both
active limits fail. LO must stay stationary. BiSS feedback remains powered
through the search. Changed homing settings and inspection hold are restored
after stopping/disabling the axis.

Homing intentionally leaves the new reference in place. A limit-only case can
finish near the end switch at −20 mm, outside the normal soft limits; no return
move is issued after failure. The complete six-case group ends with a backward
post move to 0 mm. Do not combine these coordinate-changing searches with the
normal motion groups in the same invocation.


The stall cases named `at_target_zero` require **AtTarget status = 0**, not a
zero configured tolerance. A zero tolerance violates encoder auto-power's
configuration requirements (`ERROR_ENC_POWER_CONFIG`, 0x1441e). The test reads
the selected motion encoder's scale and chooses a nearby target between its
integer counts, using a small positive tolerance. For motor requests the target
also lies on the motor record's resolution grid. The target adjustment is
bounded to one tenth of the profile position tolerance and rechecked against
travel limits. A rig whose encoder and motor grids cannot provide such a target
fails setup explicitly instead of silently claiming to test a stall.

After the stall alarm, auto-power may shut down the absolute encoder and switch
to its configured counter backup, rebasing the holding setpoint. AtTarget can
then return to 1 while the stall fault remains latched. The test requires
AtTarget=0 before the alarm; afterwards it accepts 1 only with the configured
backup selected, source power Off, and rebased PosSet/PosAct agreement. The stall
error, amplifier-off state, motor alarm/completion and fresh recovery move are
still required.


Encoder fault snapshots include the configured encoder's status, error, ready,
power state, logical power and Force ON readbacks, plus optional diagnostic PVs
from `encoder_power.diagnostics`. This fixture reads EL5042 channel 1's raw
status (`m0s009-Enc01-Stat`) and the EL2794 power output (`m0s025-BO01-RB`). Raw
bits 0/1/2 are also decoded as warning/error/ready. These are asynchronous
readbacks, not a measurement of supply voltage or an atomic history of the fault.
A hardware encoder alarm during recovery remains an unexpected test failure;
it is not automatically reset or added to the expected-stall allowlist.

The current profile assigns BiSS and auto-power to TR_LO for the encoder
alignment comparison. Full-stroke TR_HI homing is blocked for this wiring;
its raw EL5042 travel guard must follow the axis being homed.

After the brake STOP cases observe terminal native/motor flags, they allow up to
one second for filtered/published actual velocity to fall below 0.005 mm/s.
Busy/motor motion restarting or position drifting beyond the existing tolerance
fails immediately during this wait. The stopped position remains the reference;
the subsequent 250 ms stationary hold still checks all original conditions.
Persistent reported velocity fails rather than being ignored.


## Independent soft-limit modes and motor offsets

The `softlimit_modes` simulator module and explicit `softlimits` hardware group
share eight live configuration cases: motor-only limits, ECMC-only limits,
nested independent limits, unsynced motor limits bounded by enabled ECMC limits,
synchronization in both directions, OFF/DIR changes, and user-limit edits under
nonzero OFF with sync enabled, plus an idle CA callback-rate bound for physical
and virtual motor soft limits. Both physical axes are
checked. DIR=Pos/Neg and OFF=0/+10/-10 are exercised; these are motor coordinate
offsets, not physical travel or encoder-reference changes. Live cases require
positive MRES. The standalone ECMC fixture additionally covers negative MRES
writes/restoration using real ESS motor source.

From the ecmccfg repository root:

```sh
python3 tests/integration/slit/run.py --case softlimit_modes
python3 tests/integration/slit/run.py --case softlimit_modes --prefix SIMSLIT: --run
python3 tests/integration/slit_hardware/run.py --case softlimits
python3 tests/integration/slit_hardware/run.py --case softlimits --prefix HWSLIT: --run
python3 tests/run_simulation_checks.py --pattern test_slit_limit_modes.py
```

Commands without `--run` only list tests. Hardware `softlimits` is excluded from
the default motion run because it temporarily disables individual limit layers.
All new live cases keep drives disabled, hold the state machine, bound temporary
native ranges inside the saved range, and reject any native-position change.
They issue no VAL, SET, homing or native execute commands. Original independent
motor/native pairs, enable flags, DIR/OFF/FOFF and state-machine enable are
restored and acknowledged. Native values and flags are checked over multiple
polls while sync is off. Hardware motion guards remain unchanged.

DOC: `user = direction * dial + OFF`, so changing OFF shifts LLM/HLM while
DLLM/DHLM and ECMC limits stay fixed. USER/INFERRED: no-sync permits independent
pairs; sync propagates edits. COMPAT: enabled ECMC limits bound motor fields even
without synchronization, while narrower nested motor ranges remain independent.
The effective motion constraints belong to both layers. Existing simulator
`limits` cases and standalone ECMC monitor tests exercise motion rejection;
these new hardware cases establish configuration propagation, not travel into
or beyond a limit.

The independent zero-motor-pair case disables the native limit enables before
writing the motor zero sentinel, then re-enables the native range. This ordering
avoids trying to create 0/0 through two writes while the ECMC read-only range is
already active. With motor 0/0 established, the driver leaves the motor
read-only range clear while ECMC continues enforcing its native limits.
ECMC also seeds motor limits once during ordinary startup even with sync off.
Acceptance failures are not grounds to substitute observed values or enable
sync as a cleanup shortcut. Reports distinguish the requested configuration
from actual readbacks. No live IOC or physical execution is implied by offline
test success.

`tests/simulation/test_slit_limit_modes.py` executes the actual simulator and
hardware case methods at controlled parameter boundaries. Delayed delivery must
pass; missing propagation, accidental no-sync writes, ignored DIR, incorrect OFF
application, unavailable zero pairs, missing unsynced range enforcement,
dropped enable flags and unintended motion must fail. It checks full restoration
and forbids movement commands. This is
harness validation, not a replacement motor/ECMC implementation.


Limit-mode waits distinguish the driver setting from motor-record receipt:
`-CfgSyncSftLim` must agree with the `MF_RW_SOFT_LIMITS` bit in `.MFLG` before
subsequent edits. No-sync stability is observed for 3.1 seconds to cover nominal
1 Hz motor polls; convergence retains the existing bounded 15-second simulator
wait (hardware uses its configured timeout). Failure details include the
requested pair, actual user/dial/native values, OFF/DIR and `.MFLG`. The general
simulator snapshot includes `.MFLG` too. Boundary checks now delay flag/limit
callbacks to 1 Hz and reject a missing record flag separately from missing
numeric propagation. This changes test observations only; motorECMC is untouched.
