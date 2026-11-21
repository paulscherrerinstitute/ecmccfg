# Python simulation models

For modular live slit tests (limits, enable loss, encoder faults and master/slave
sync), see [the separate slit acceptance setup](../../tests/integration/slit/README.md).

These tools run outside the IOC and use the generated simulation **I/O field**
records. They do not write axis commands or change the EtherCAT driver. The IOC
continues to use one cyclic RT thread. Python feedback is asynchronous and is
intended for functional configuration/motion checks, not RT timing validation.

Install the client dependency in your Python environment:

```sh
python3 -m pip install pyepics
```

The client uses [PyEpics PV reads and completed writes](https://pyepics.github.io/pyepics/pv.html).
It respects the usual Channel Access environment, including
`EPICS_CA_ADDR_LIST`. Start the updated IOC/ecmccfg with `SIM=1` first.

## Discover supported slaves in an IOC

Only one prefix is needed:

```sh
# Read-only discovery: report supported and unsupported hardware.
python3 tools/simulation/ioc.py --prefix c6025a-08:SIM: --list

# Start a model for each supported discovered slave.
python3 tools/simulation/ioc.py --prefix c6025a-08:SIM:

# Optional live window with drive values and digital I/O controls.
python3 tools/simulation/ioc.py --prefix c6025a-08:SIM: --gui
```

Discovery reuses normal ecmccfg metadata. Common ecmccfg hooks expose record
aliases under the simulation prefix:

| Simulation metadata PV | Existing source |
| --- | --- |
| `PREFIXFirstSlave` | `ECMC_PREFIX` + `MCU-Cfg-EC-FrstObjId` |
| `PREFIXecN:sM:HWType` | That slave's normal `HWType` record |
| `PREFIXecN:sM:NxtObjId` | That slave's normal next-slave pointer |

Aliases share the existing records; hardware information is not independently
maintained. Discovery follows sparse slave IDs and rejects broken/cyclic chains.
It does not guess numeric PV names over a range or require PVA. Normal default
slave metadata must be enabled (`DEFAULT_SLAVE_PVS=true`, the default). If you
override `ECMC_SIM_PREFIX`, set it **before adding slaves** so metadata aliases
and generated data records use the same prefix.

The default master is 0. Use `--master N` for a different master and optionally
`--first-slave M` to select a master-specific starting point. The existing
first/next chain stores slave IDs, not master IDs; automatically following chains
across multiple masters is not implemented. Scan a separate chain per master.

Supported stepper velocity-mode hardware descriptors:

- `EL7041`
- `EL7041-0052`
- `EL7031` and `EL7031-…` variants
- `EL7047`

`E*72xx` descriptors (for example EL7211, EP7211 and ELM7222 variants) select
the separate **DS402 CSV/CSP** model described below. CST descriptors are skipped.
The `*7062` family (EL7062, ED7062 and MO7062 variants) uses the same DS402
model; configured channels 01 and 02 are detected and run independently.
EL5042, EL5102 and EL5101 variants expose manual raw encoder fields.

Other types are listed as unsupported and left untouched. Supporting a drive
requires a supported descriptor/family in `model_module()` and compatible generated fields;
a similar hardware name alone is not sufficient. The models default to channel 01. EL7047 CSP/position-interface variants are not
selected: they need a different command model. EL7031 variants must expose the
same native velocity-mode PVs; record types are checked before feedback writes.
These types share the supplied default scaling; use per-slave overrides when a
configuration has different scaling. EL7047 motor-load feedback is not modeled.
Each supported slave connects to its own module/worker. A connection failure or
runtime error stops that model and is reported; other model workers continue.
These are external [CA-aware Python threads](https://pyepics.github.io/pyepics/advanced.html#using-python-threads),
not additional IOC RT threads.

Optional selection and settings:

```sh
python3 tools/simulation/ioc.py --prefix c6025a-08:SIM: --slave 14
python3 tools/simulation/ioc.py --prefix c6025a-08:SIM: --settings models.json
```

A settings file maps the normal data-path identity to model settings:

```json
{
  "ec0.s14": {
    "full_steps_per_second": 2000,
    "motor_steps_per_rev": 200,
    "encoder_counts_per_rev": 12800,
    "enable_delay": 0.05
  }
}
```

Other stepper optional keys are `counter_bits`, `lower_limit_revs`, `upper_limit_revs`
and `initial_position_revs`. Without an initial-position override, the model
preserves the current raw counter readback. That counter does not identify
previous revolutions after rollover; supply an explicit initial physical
coordinate if model limits need that history. Counter width must match the
configured unsigned position field.

## Live window and digital terminals

`--gui` opens a simple Tk window. Slave headings show the hardware model and
digital channel count/direction. Each slave expands into its live data fields:
drive control/status words (decimal and hexadecimal), raw command values,
position counters and available velocity/encoder feedback. Every displayed field
with a writable simulation record/access can be edited, including drive commands,
drive feedback, encoder fields and digital I/O. Model failures and
stopped workers are shown per slave; their last values are marked gray/stale.
The display refreshes at 10 Hz and coalesces model updates. EPICS reads/writes
stay in the external model workers, so network calls do not block Tk. Closing
the window stops those workers and runs the normal drive fault-feedback cleanup.

Configured optional drive diagnostics, digital-input words, secondary positions
and touch-probe fields are also displayed/editable when their native scalar PVs
are available. These optional fields remain manual; the CSV/CSP motion model
does not simulate the probe/sensor protocols or force them to healthy values.

Tkinter and a graphical display are required only for `--gui`. On systems where
Tk is packaged separately, install the distribution's Python Tk package (often
`python3-tk` or `python3-tkinter`). Headless usage remains available without Tk.
The window uses the same discovery, slave selection and settings arguments.
`--list` remains read-only even when `--gui` is supplied.

The following simple terminals are also recognized:

| Hardware | Channels | Simulation behavior |
| --- | --- | --- |
| EL1004 | 4 inputs | Manual input injection |
| EL1008, EL1808 | 8 inputs | Manual input injection |
| EL1809 | 16 inputs | Manual input injection |
| EL2004 | 4 outputs | Manual writes and readback |
| EL2008, EL2808 | 8 outputs | Manual writes and readback |

Select a `binaryInputNN` or `binaryOutputNN` row and press **Set 0** or **Set 1**.
For inputs these buttons write the generated simulation input PV; the displayed value
comes from its `-RB` record. Inputs keep their existing values at startup and
after this application closes. There is no background zeroing or automatic
loopback. Digital output writes use `binaryOutputNN-Set`; display reads the
original `binaryOutputNN` record. Writes happen once per click. An axis or PLC
that owns an output may overwrite it on its next cycle; there is no force or
override mode. Drive feedback writes may likewise be replaced by the running
model. Output write controls require the updated ECMC record
generator: rebuild/reinstall ECMC and restart the IOC to create `-Set` records.
With an older IOC those channels remain observable and their controls are disabled.

For a numeric field, select its row, enter an integer, hexadecimal word (`0xff`)
or decimal/exponent value, then press **Write value** or Enter. The **Set 0** and
**Set 1** shortcuts also work on numeric fields. Integers remain exact through
the GUI/CA boundary, including 64-bit values. Native bit widths and signed ranges
are checked before a write; invalid values are reported without stopping the
model. Unsigned 64-bit words use the existing signed Int64 wire representation.

Layouts follow the common ecmccfg `EX1004/1008/1016` and `EX2004/2008` scripts.
The configured native record names and types must match; custom renamed
channels and other terminal variants are not inferred. Digital terminals accept
no per-slave drive settings. Headless mode observes these terminals without
writing inputs; external scripts can still inject their generated PVs. One
external worker per terminal polls digital readback at 10 Hz. Connection/read
failures stop only that terminal and mark it unavailable in the window.

## Encoder terminals and dual-channel 7062 drives

EL5042 (including `_DC`) exposes both channels' 64-bit raw positions and status.
EL5102 exposes both 32-bit counters; EL5101 uses its configured 16- or 32-bit
scalar layout. EL5101 suffix variants are recognized and the available native
scalar records determine the fields shown. Encoder control/value words,
latch-position words (including the historical `encoderLatchPostion` spelling),
frequency/period and `nextSyncTime` are exposed when configured. Inputs are
injected through their normal simulation records; outputs use `-Set`, and the
table always reads the buffer's readback. No values are zeroed at connection.

These encoder fields are manual. No mechanical coupling, automatic counting,
counter-set acknowledgement or latch protocol is inferred. They can be driven
by another script/model through the same PVs. EL5101-0011's oversampling arrays
are not emulated: available scalar control/status/time fields are exposed and
the missing scalar position is reported explicitly. Neither `_DC` names nor
the Python loop imply real distributed-clock timing behavior.

For 7062 CSV/CSP drives the scanner probes `driveControl01/02` and creates one
worker/window row per configured channel, named `ecN.sM.ch01/02`. An absent
channel is skipped; an incompatible configured channel reports its own failure.
Both channels use the DS402 model, not the EL7041 Q15 model. CST/CSTCA and
drive-motion-control modes, touch-probe timing and auto-tuning are not emulated.
The DS402 scaling assumptions remain configurable; match your motor/configuration
instead of assuming a stepper shares the EL7041 or E72xx physical scaling.

Per-slave settings apply to both channels; channel settings override them:

```json
{
  "ec0.s7": {"encoder_counts_per_rev": 1048576},
  "ec0.s7.ch01": {"mode": "csv"},
  "ec0.s7.ch02": {"mode": "csp"}
}
```

The `channel` setting on `ecN.sM` selects just that channel when desired. Encoder
terminals accept no drive settings. Standalone encoder positions are not silently
linked to a nearby drive; configure their feedback relationship explicitly in
your model/configuration when a physical relationship is needed.

## EL7041 scaling and behavior

Defaults use the supplied scaling:

```text
full_steps_per_second = signed_velocity / 32768 × 2000
encoder_counts_per_full_step = 12800 / 200 = 64
encoder_counts_per_second = signed_velocity × 3.90625
```

Velocity is a signed 16-bit word. `-32768` corresponds to -2000 full steps/s;
`32767` is one raw LSB below +2000. Half scale (`16384`) gives 1000 full steps/s,
64000 encoder counts/s, or 5 rev/s. No axis millimeter/degree scaling is added.
The default 16-bit encoder counter wraps modulo 65536 while the model keeps an
unwrapped physical position and fractional counts internally.

The model reads:

- `PREFIXecN:sM:driveControl01`
- `PREFIXecN:sM:velocitySetpoint01`

It writes only:

- `PREFIXecN:sM:driveStatus01`
- `PREFIXecN:sM:encoderStatus01`
- `PREFIXecN:sM:positionActual01`

Control bit 0 requests enable; enabled feedback follows after 50 ms by default.
Bit 1 clears a model fault. Control bit 2 is reflected as reduced-torque status
bit 6. Status bits 0/1/3 represent ready/enabled/fault. The model uses status
bits 11/12 as normally-closed lower/upper limit inputs. They default to 1 and
clear at configured limits; reverse travel remains possible. Limits are optional
and specified in motor revolutions. Encoder warning/error/latch flags remain zero.
The mappings follow `ecmcEX70XX.cmd` and `ecmcEL7031-chX.template` in ecmccfg.

Only basic enable, velocity, counter feedback and optional limits are modeled.
No acceleration/electrical dynamics, latch/homing sensor model, hardware counter
set handshake, BiSS feedback, SDO behavior or DS402 state machine is supplied.
An axis using a different primary encoder needs feedback for that encoder too.

The default requested loop rate is 100 Hz. Reads bypass the PyEpics monitor cache;
completed feedback writes are checked. Actual elapsed monotonic time is used for
integration. A stalled loop stops instead of integrating a large stale-command
jump. On Ctrl+C, SIGTERM or a runtime error, connected models make a best-effort
fault-status write with enabled feedback cleared, retaining encoder position.
A forced kill or disconnected network cannot guarantee delivery of that write.

## Run one drive directly

```sh
python3 tools/simulation/el7041.py \
  --prefix c6025a-08:SIM: --master 0 --slave 14
```

The standalone model has the same defaults. Use `--help` for scaling, enable
latency, limits, counter width and initial-position options. `--duration 10`
runs a finite ten-second check. It validates generated record types/directions
before writing feedback. Existing hardware command records are not changed into
readback records; observe the generated simulation output PVs.

## DS402 CSV/CSP model

The same IOC command automatically selects `ds402.py` for E*72xx descriptors:

```sh
python3 tools/simulation/ioc.py --prefix c6025a-08:SIM:
```

It reads `driveControl01` and either `velocitySetpoint01` (CSV) or
`positionSetpoint01` (CSP). It writes `driveStatus01`, `positionActual01` and,
when present, `velocityActual01`. No `encoderStatus01` is required. It checks
native U16 control/status, S32 commands and U32 position record types before
any writes. Velocity feedback accepts signed `longout` records and legacy
unsigned `mbboDirect` records (from `EcAddEntryComplete(...,32,...)`). Negative
velocities use 32-bit two's-complement words for the unsigned layout. Other
field layouts fail with a diagnostic.

Mode is inferred from the available command field. When both fields exist,
specify `mode` explicitly. Settings use the same per-slave JSON file:

```json
{
  "ec0.s3": {
    "mode": "csv",
    "encoder_counts_per_rev": 1048576,
    "velocity_units_per_rev_per_second": 268435.456,
    "channel": "01"
  }
}
```

These scaling defaults match the repository's servo CSV example:
2^31 velocity units = 8000 rev/s, and 2^20 position counts = one revolution.
They are configurable assumptions, not values discovered from the motor/SDOs.
Different motor/configuration scaling must be supplied in the settings file.
For CSV, counts/s = raw velocity / velocity_units_per_rev_per_second ×
encoder_counts_per_rev. CSP uses native position counts directly, follows the
nearest modulo-32 target and derives velocity feedback from the position change.
`initial_position_revs` overrides the initial raw counter readback; `channel`
can select another configured channel (run a separate invocation for each).

The state model starts switch-on-disabled and handles shutdown (6), switch-on
(7), operation enable (15), disable-voltage, disable-operation, quick stop and
rising-edge fault reset (128). It follows the
[Beckhoff DS402 commissioning sequence](https://infosys.beckhoff.com/content/1033/ep7211/6910244747.html)
and [control/status word definitions](https://infosys.beckhoff.com/content/1033/el72x1-001x/1877700363.html).
Quick stop stops immediately. CSP follows commands ideally; there are no motor
dynamics, acceleration ramps, following-error model, torque/CST, touch probes,
STO or homing sensors. Additional diagnostic/encoder inputs remain available
for another model or manual injection; they are not fabricated here. Dynamic
SDO/PDO operation-mode changes are not implemented. The shutdown/stall handling
is shared with the stepper model and clears enabled feedback through a model
fault. This is functional simulation, not a full hardware emulator.

## Tests

`tests/simulation/test_simulation_gui.py` checks digital channel counts, input retention,
explicit input/output writes, read-only fallback, type/access failures, bounded UI
updates and model reporting with fake CA endpoints. It smoke-tests actual Tk
widgets under Xvfb when available, including input buttons and worker shutdown.
The Tk portion reports a skip when a usable display is unavailable.

`tests/simulation/test_simulation_terminals.py` checks encoder layouts and raw widths,
exact U64 writes, manual drive editing and independent two-channel 7062 CSV/CSP
dispatch using fake CA endpoints. It explicitly checks the oversampling notice;
it does not claim an oversampling, DC or electrical terminal model.

`tests/simulation/test_ds402_model.py` checks DS402 transitions/reset edges, CSV scaling,
CSP rollover, direction/type validation, optional velocity feedback and scanner
dispatch with fake CA PVs. It does not start an IOC or access the network.

`tests/simulation/test_el7041_model.py` checks physical scaling, reverse velocity,
fractional-count accumulation, rollover, enable delay, fault/reset, optional
limits and model/client failure cleanup. `tests/simulation/test_simulation_ioc.py` checks
sparse discovery, invalid metadata, support selection, per-slave workers and
read-only listing with controlled CA endpoints and deterministic worker clocks.
Neither test contacts an IOC or requires PyEpics. Live multi-drive CA operation
and actual achieved update rates still need testing on the target system.

Enable acknowledgement timing
----------------------------

The DS402 model defaults to `enable_delay: 0.01` seconds for each forward
handshake (ready, switched on, operation enabled, and re-enable after quick
stop). The EL70xx stepper model retains its 0.05-second enable delay. Both start
timing when a new command is first observed; elapsed time preceding that
observation is not credited. A cancelled enable discards the pending delay.
Faults, disabling and quick stop remain immediate model actions.

The `enable_delay` JSON setting can override the model delay, including zero
for intentionally instantaneous tests. CA transport, polling and Python
scheduling add variable latency beyond the model delay; these models provide
functional sequence timing, not deterministic RT timing. Position integration
uses only time after the enable acknowledgement.

The slit acceptance runner additionally composes the DS402 model with
`touch_probe.py`, a probe-1 single-shot latch. This model is currently specific
to the dedicated slit fixture's EL7062 auxiliary axis; automatic IOC model
workers do not supply probe input events. Its status uses separate enabled and
positive/negative stored bits, retains latched U32 positions/timestamps until
disarm/rearm, and does not emulate continuous capture or probe 2. The slit tests
validate raw capture transport. Successful position-compare output needs a native
SIM sample-clock provider and is not covered by the current fixture.

### EL5021

`el5021.EL5021` provides a reusable counter, preload, C-reset and C-latch
model. Supply mechanical position to `step(position, control, preset)`; it
returns the unsigned 32-bit counter, status and latch value. The position unit
is degrees by default (`counts_per_degree=819200`); set the scale explicitly
for other mechanics. C-reset is selected at construction, not from live SDOs.
The scanner exposes EL5021 fields as manual encoder fields, consistent with
other external encoders. Mechanical coupling belongs in the machine plant;
the scanner does not infer which drive moves an encoder.
