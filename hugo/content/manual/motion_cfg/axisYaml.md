+++
title = "Axis YAML configuration"
slug = "axisyaml"
weight = 15
chapter = false
+++

## Start here

Use this page when you want to configure a new motion axis with the current
preferred workflow.

For new configurations:

- use `loadYamlAxis.cmd`
- use this page for the meaning of the YAML sections and keys
- use [motion best practice]({{< relref "/manual/motion_cfg/best_practice/_index.md" >}})
  if you want a working example tree first

If you are maintaining older `.ax`, `.vax`, and `.sax` files instead, use
[legacy motion]({{< relref "/manual/motion_cfg/legacy.md" >}}).

Since `ecmccfg` v7, axis configuration is YAML-based.
{{% notice info %}}
Backward compatibility with classic EPICS environment-variable based configuration is retained for legacy systems.
{{% /notice %}}

{{% notice warning %}}
`YAML` is, like `Python`, indentation-sensitive.
Do not use tab characters or trailing spaces in YAML files.
Tabs in particular can lead to cryptic error messages during Python parsing.
{{% /notice %}}

{{% notice tip %}}
Use 2 spaces per indentation level.
{{% /notice %}}

## Introduction
{{% notice info %}}
YAML loading supports two backends:
- `jinja` (default): Python-based
- `ecb`: C++-based (`ECMC_CFG_TOOL=ecb`)
{{% /notice %}}
The loader validates YAML keys/types and renders the ecmccfg templates. Missing mandatory keys are reported, and optional keys can be populated by defaults.

{{% notice info %}}
Default (`jinja`) path: `loadYamlAxis.cmd` invokes Python tooling and creates a virtual environment automatically.
If `ECMC_CFG_TOOL=ecb`, the same loader uses the external C++ tool [`ecb`]({{< relref "/manual/motion_cfg/ecb.md" >}}) instead.
{{% /notice %}}

{{% notice tip %}}
If you use the external [ecmc_cfg_tool]({{< relref "/manual/motion_cfg/ecmc_cfg_tool.md" >}}), treat it as a runtime inspection/tuning layer with access to the ecmc command parser. Initial config loading still happens through `loadYamlAxis.cmd`.
{{% /notice %}}

## Minimal startup pattern

Typical startup flow for one axis:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "HW_DESC=EK1100"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "HW_DESC=EL7062"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000, R_COIL_MOHM=1230,L_COIL_UH=500'"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd, "FILE=./cfg/ax1.yaml, DEV=${DEV}, DRV_SLAVE=4, ENC_SLAVE=3, ENC_CHANNEL=01, ECMC_TMPDIR=/tmp/"
```

Minimal YAML skeleton:

```yaml
axis:
  id: 1
  type: joint
  mode: CSP

epics:
  name: M1
  precision: 3
  unit: mm

drive:
  numerator: 2880000
  denominator: 2147483648
  type: 1
  control: ec0.s$(DRV_SLAVE).driveControl01
  status: ec0.s$(DRV_SLAVE).driveStatus01
  setpoint: ec0.s$(DRV_SLAVE).positionSetpoint01

encoder:
  numerator: 10
  denominator: 65536
  type: 0
  bits: 16
  absBits: 16
  position: ec0.s$(ENC_SLAVE).encoderActualPosition$(ENC_CHANNEL)

controller:
  Kp: 10
  Ki: 0
  Kd: 0

trajectory:
  axis:
    velocity: 10
    acceleration: 20

input:
  limit:
    forward: ec0.s$(DRV_SLAVE).ONE.0
    backward: ec0.s$(DRV_SLAVE).ONE.0
  home: ec0.s$(DRV_SLAVE).ONE.0
```

## Companion References

- [Complete axis YAML example]({{< relref "/manual/motion_cfg/axisYamlExample.md" >}}) contains the full annotated configuration.

Use the [Axis YAML settings reference](../axisyaml-table/) for grouped key-by-key lookup, types, requirements and defaults.

Related motion docs:
- [Drive modes CSV, CSP, CSP-PC]({{< relref "/manual/motion_cfg/modes_CSV_CSP_CSP_PC.md" >}})
- [scaling](../scaling/)
- [direction](../direction/)
- [homing](../homing/)
- [axis PLC](../axisplc/)
- [motor record](../motor/)
- [Axis Groups]({{< relref "/manual/motion_cfg/axis_groups.md" >}})
- [Master/Slave State Machine]({{< relref "/manual/motion_cfg/master_slave_state_machine.md" >}})

The configuration is separated into the following mandatory sections:

- [axis](#axis)
- [drive (only mandatory for physical axis)](#drive)
- [encoder](#encoder)
- [trajectory](#trajectory)
- [input](#input)

In addition, the following optional sections are available:

- [epics](#epics)
- [controller](#controller) (physical axes)
- [axis PLC]({{< relref "/manual/motion_cfg/axisPLC.md" >}})
- [positionCompare](#positioncompare)
- [homing](#homing)
- [softlimits](#softlimits)
- [monitoring](#monitoring)

### Required keys and defaults

Required sections and required keys are different: an optional section can
require children once supplied, such as `drive.brake.enable` and
`drive.brake.output`. Defaults for children normally apply only when their
parent section exists. For example, `controller: {}` supplies the PID defaults;
omitting `controller` also uses the template's PID defaults.

The defaults in the [settings table](../axisyaml-table/) are taken from the
current schemas and rendering templates. A dash means no YAML default is
documented; it does not mean zero or disabled. If no command is rendered, the
value remains under ecmc's initialization/runtime configuration.

Set axis ids, PV names and hardware scaling explicitly even where the loader
provides fallbacks. In particular, the default drive/encoder numerator is zero,
which is not a usable hardware scale.

The Python loader discards unknown keys; ECB rejects them. A misspelled key can
therefore be silently ignored by Python. The loaders also differ for some
optional monitoring blocks; supply `enable` and its dependent values together
when configuring a monitor. See the reference table for conditional requirements.

One current type mismatch is `monitoring.stall.enable`: Python accepts a YAML
boolean (`true`/`false`), while the ECB schema requires an integer (`1`/`0`).
Use the form appropriate to the selected loader. The other monitoring enables
use booleans in both schemas.

***

## axis
The `axis` section is required. Explicitly set:

- `id`: unique numeric identifier of the axis. If omitted, the template derives
  the next id from `ECMC_AXIS_NO`; explicit ids avoid load-order dependencies.

optional
- `type`: type of the axis; default `joint` (physical axis, type 1)
- `mode`: operating mode of the drive; default `CSV`; allowed `CSV`, `CSP`, `CSP_PC`
- `parameters`: additional motor driver options, separated by semicolons. For autosave-restored dial limits use `restoreMotorSoftLims=1;`; this also enables ongoing soft-limit synchronization. See [autosave]({{< relref "/manual/motion_cfg/autosave.md" >}}).

```yaml
axis:
  id: 1
  # type: joint   # axis types:
                  # 1 (equiv: physical, joint, j, motor, real)
                  # 2 (equiv: virtual, end_effector, endeffector, ee, e)
  # mode: CSV     # supported modes: CSV, CSP and CSP_PC
  # parameters: powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=1.0;
```

### Auto enable/disable

#### ecmc native (preferred way)
Native ecmc auto-enable/disable is the preferred way and can be configured by:
```yaml
axis:
  autoEnable:                                         # ecmc auto enable of axis (Please use this instead of motor record version..)
    enableTimeout: 5.0                                # If defined, ecmc tries to auto-enable for a maximum enableTimeout seconds.
    disableTimeout:   5.0                                # If defined, ecmc disables axis after idle (non busy) in disableTime seconds
    autoDisableLatchAtTarget: false                      # Continue auto-disable timing after AtTarget has been reached once
```
The motor record auto-enable/disable functionality will then automatically be disabled.
{{% notice warning %}}
However, do not configure both ecmc native and motor record auto enable/disable at the same time.
{{% /notice %}}

#### motor record (do not use)

{{% notice info %}}
Please use the ecmc-native auto-enable/disable described above.
{{% /notice %}}

Auto enable/disable is enabled by default in the motor record. However, this solution is not optimal since the motor record only polls information from ecmc, and all motor records can block when one motor waits for enable.
This is how the timing parameters can be changed.
```yaml
axis:
  parameters: powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=1.0;
```
{{% notice info %}}
`powerAutoOnOff` defines a mode and should always be set to `2`.
{{% /notice %}}

{{% notice info %}}
Note the mandatory ";" in the end of the parameters string. If not present, then the last parameter will not be parsed.
{{% /notice %}}


### Tweak value
The ecmc and motor record tweak value can be defined in `axis.tweakDist`:
```yaml
axis:
  tweakDist: 5.0                                    # Tweak distance
```

## EPICS
EPICS configuration.

{{% notice info %}}
The EPICS motor record can now be disabled.
{{% /notice %}}

The `epics` section is optional. Set `name` explicitly for a unique PV name;
the fallback is `axis`.

optional

- `precision`: PREC field; default 3
- `unit`: EGU field; optional default mm
- `motorRecord`
  * `enable`: default true; set to false to disable motor record. Omitting the
    whole `motorRecord` block also creates a motor record.
  * `description`: DESC field; default ''
  * `fieldInit`: string with additional field initial values; default ''
  * `syncSoftLimits`: sync motor record and ecmc soft limits; default false. `axis.parameters: "restoreMotorSoftLims=1;"` also enables synchronization, even when this YAML setting is omitted or false. When synchronization is disabled, motor record `HLM`/`LLM` and ecmc soft limits can differ. When changed from false to true at runtime, the current ecmc soft limits are copied to the motor record. While enabled, later motor record soft-limit changes are written back to ecmc.
  * `pvt`
    * `npoints`: max number of target points for PVT/profile move
    * `nreadback`: max number of readback points for PVT/profile move

```yaml
epics:
  name: M1
  # precision: 3
  # unit: deg
  # motorRecord:
  #   enable: false
  #   fieldInit: 'RRES=1.0,RTRY=2,RMOD=1,UEIP=0,RDBD=0.1,URIP=1,RDBL=$(IOC):$(ECMC_MOTOR_NAME)-PosActSim'
  #   fieldInit: 'NTM=1'
  #   syncSoftLimits: false
  #   description: AM8111 CSV
  #   pvt:
  #     npoints: 20
  #     nreadback: 20
```

## drive
mandatory for physical axis

- `control`: control word entry
- `setpoint`: setpoint entry, **position** or **velocity**, depending on mode
- `status`: status word entry used by the drive template. The schemas do not
  require it, but the standard hardware drive setup links it unconditionally.

Scaling and drive type have loader defaults, but must match the hardware:

- `numerator`: scaling numerator; default 0 (configure explicitly)
- `denominator`: scaling denominator; default 1, minimum 1
- `type`: default 0; `0`=simple bit-controlled drive, `1`=DS402

{{% notice info %}}
Floating-point EtherCAT entries are supported in ecmc, but the rules differ by use case:

- encoder actual-position entries (`encoder.position`) with `F32`/`F64` are only valid for absolute encoders (`encoder.type: 1`)
- CSP drive position setpoints with `F32`/`F64` require the selected CSP encoder actual-position entry to use the same EtherCAT datatype
- CSV drive velocity setpoints with `F32`/`F64` are supported
{{% /notice %}}

optional

- `enable`: enable bit; default 0 for non-DS402, ignored for DS402
- `enabled`: enabled-status bit; default 1 for non-DS402, ignored for DS402
- `reduceTorque`: control word _bit_ to set for reduced torque mode; supply
  together with `reduceTorqueEnable`
- `reduceTorqueEnable`: boolean enabling reduced-torque handling
- `brake`
  * `enable`: required boolean when `brake` is present
  * `output`: required EtherCAT output entry when `brake` is present
  * `openDelay`: number of cycles to wait after enable to disengage the brake
  * `closeAhead`: number of cycles to wait after the brake was engaged
- `reset`: control word _bit_ to set in order to reset the drive
- `warning`: status word _bit_ for drive warning
- `error`: list of status _bits_ for drive errors

```yaml
drive:
  numerator: 2880000        # Fastest speed in engineering units
  denominator:  2147483648  # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET
  type: 1                   # Stepper: 0, DS402: 1 (DS402 = servos and advanced stepper drives)
  control: ec0.s$(DRV_SLAVE).driveControl01
  status: ec0.s$(DRV_SLAVE).driveStatus01
  setpoint: ec0.s$(DRV_SLAVE).velocitySetpoint01
  # reduceTorque: 2 # Reduce torque bit in drive control word
  # reduceTorqueEnable: true
  # brake:
  #   enable: true
  #   output: ec0.s$(BRAKE_SLAVE).binaryOutput01.0
  #   openDelay: 0  # Brake timing parameter in EtherCAT cycles
  #   closeAhead: 0 # Brake timing parameter in EtherCAT cycles
  # reset: 1        # Reset bit in control word
  # warning: 2      # Warning bit of status word
  # error:          # max 3
  #   - 3           # Error 0 bit of status word
  #   - 7           # Error 1 bit of status word
  #   - 14          # Error 2 bit of status word
```

## encoder
The `encoder` section is required. The scaling and format keys have defaults,
but should be configured explicitly for the selected hardware:

- `numerator`: engineering units per `denominator` raw counts; default 0
- `denominator`: scaling denominator; default 1, minimum 1
- `type`: `0`=incremental (default), `1`=absolute
- `bits`: raw data bit count; default 16
- `absBits`: absolute bit count, in the least significant part of `bits`; default 25
- `absOffset`: absolute encoder offset in engineering units; default 0
- `position`: hardware position entry for `source: 0`; not used for PLC position
  feedback (`source: 1`)

The default `absBits: 25` is not consistent with the default `bits: 16` for an
absolute encoder. Set both to the actual encoder format when selecting `type: 1`.

`encoder.bits` and `encoder.mask` are applied to the encoder value maintained
by ecmc after reading the configured position entry. They do not alter the raw
EtherCAT process-data value received from the slave. The original hardware
value remains available through the EtherCAT hardware PVs.

optional

- `source`: position source, 0=from EC entry ; 1=from PLC
- `control`: control word entry; mandatory when **reset** is set.
- `status`: status word entry; mandatory when **ready**, **error** or **warning** are set
- `reset`: control word _bit_ to set in order to reset the encoder
- `warning`: status word _bit_ for encoder warning
- `error`: list of status _bits_ for encoder errors
- `filter.velocity`: `size` (default 100 cycles), `enable` (default true)
- `filter.position`: `size` (default 10 cycles), `enable` (default true)
  These defaults apply when the corresponding filter block is supplied.
- `latch`:
  * `position`: required latched position entry when `latch` is present
  * `timestamp`: ''
  * `control`: ''
  * `status`: ''
- `touchProbe`: touch-probe mapping for use outside homing
  * `position`: latched touch-probe position entry
  * `timestamp`: optional 32/64-bit DC timestamp entry for the same edge
  * `control`: touch-probe control word entry
  * `controlBit`: first control bit to write, default 0
  * `status`: touch-probe status word entry
  * `statusBit`: captured-event status bit, default 0
  * `armCmd`: arm command value, default 17 for EL7062/ED7062 TP1 positive edge
  * `armBits`: number of bits written from `armCmd`, default 5

When `encoder.touchProbe` is configured, ecmccfg also loads optional
encoder-specific touch-probe PVs. The main readbacks are:
`<Axis>-Enc0<ENC>-TP-Valid`, `-TP-Seq`, `-TP-Pos`, `-TP-TimeValid`,
`-TP-TimeRaw`, `-TP-EventTimeNs`, and `-TP-Armed`. The matching caQtDM panel is
`ecmcEncTouchProbe.ui`. A static config marker, `<Axis>-Enc0<ENC>-TP-HasTP`, is
also loaded with `VAL=1` and can be used by GUIs to show or hide touch-probe
controls.

Probe commands share the native encoder control word `ax<axis>.enc.control<ENC>`
through the `asynUInt32Digital` interface. The shared parameter exists for every
encoder; probe-specific records are loaded when configured. Individual
command/readback PVs use masks:

| Bit | Command PV suffix | Readback PV suffix | Meaning |
| --- | --- | --- | --- |
| 0 (`0x1`) | `-TP-EnableCmd` | `-TP-Enable-RB` | Enable probe-control writes |
| 1 (`0x2`) | `-TP-ArmCmd` | `-TP-Armed` | Arm capture while control is enabled |
| 2 (`0x4`) | `-TP-AutoRearmCmd` | `-TP-AutoRearm-RB` | Automatically rearm after capture |
| 3 (`0x8`) | `-ForceOn` | `-ForceOn-RB` | Hold this encoder powered for inspection |

These suffixes follow `<Axis>-Enc0<ENC>`. Enable control before arming. Clearing
enable also disarms and sends the idle control word before releasing control.
Clearing arm alone retains enable. All bits default to zero; enable alone does
not arm, and an arm request while disabled leaves the probe disarmed. Set
auto-rearm to zero for single-shot capture. Native/PLC probe commands update the
same control word, so PV masked writes preserve their other current bits.
The existing arm PV names remain; their native binding replaces the former
separate `enc.touchprobe.armcmd` and `enc.touchprobe.armed` parameters. Deploy
matching ECMC and ecmccfg builds when updating these records.

```yaml
encoder:
  numerator: 360
  denominator: 1048576
  type: 1         # Type: 0=Incremental, 1=Absolute
  bits: 32        # Total bit count of encoder raw data
  absBits: 25     # Absolute bit count (for absolute encoders) always least significant part of 'bits'
  absOffset: 0    # Encoder offset in eng units (for absolute encoders)
  position: ec0.s$(DRV_SLAVE).positionActual01  # EtherCAT entry for actual position input (encoder)
  # source: 0
  # control: ec0.s$(ENC_SLAVE).encoderControl01   # mandatory only if 'reset' is used
  # status: ec0.s$(DRV_SLAVE).encoderStatus01     # mandatory only if 'warning' or 'error' are used
  # reset: 1        # Reset   (optional)
  # warning: 2      # Warning (optional)
  # error:          # max 3 (optional)
  #   - 5           # Error 0
  #   - 9           # Error 1
  #   - 11          # Error 2
  # filter:
  #   velocity:
  #     size: 100       # Samples: 100 ms at 1 kHz, 200 ms at 500 Hz
  #     enable: true
  #   position:
  #     size: 1
  #     enable: false
  # latch:
  #   position: ''
  #   timestamp: ''
  #   control: ''
  #   status: ''
  # touchProbe:
  #   position: ec0.s$(ENC_SLAVE).touchProbePositionPos01_1
  #   timestamp: ec0.s$(ENC_SLAVE).touchProbeTimestampPos01_1
  #   control: ec0.s$(ENC_SLAVE).touchProbeControl01
  #   controlBit: 0
  #   status: ec0.s$(ENC_SLAVE).touchProbeStatus01
  #   statusBit: 0
  #   armCmd: 17
  #   armBits: 5
```

If `encoder.position` or the drive setpoint/actual-position entry uses `F32` or `F64`
data in EtherCAT, then configure absolute encoder mode:

- `encoder.type: 1`

Keep `encoder.bits` and `encoder.absBits` aligned with the floating-point width:

- `encoder.bits: 32` and `encoder.absBits: 32` for `F32`
- `encoder.bits: 64` and `encoder.absBits: 64` for `F64`

In current ecmc, those two keys are accepted for floating-point encoder entries but
ignored during validation, and a warning is printed. It is still recommended to set
them consistently in YAML for clarity.

### Encoder filters

Configure encoder velocity and position filters under `encoder.filter`:

```yaml
encoder:
  filter:
    velocity:
      size: 100
      enable: true
    position:
      size: 10
      enable: true
```

Merge this into the existing `encoder` section; either filter can be configured
independently. `size` is the window length in EtherCAT samples/cycles. For example,
100 samples correspond to 100 ms at 1 kHz and 200 ms at 500 Hz.

When a filter block is supplied, its default `enable` is true. The default
`size` is 100 for velocity and 10 for position. Omitting a filter block emits
no configuration commands for that filter. Use the velocity filter if the
encoder is too coarse to reliably determine velocity each EtherCAT cycle.

The old flat encoder keys are unused by the current rendering template:

| Old key inside `encoder` | Current key |
| --- | --- |
| `velocityFilterSize` | `filter.velocity.size` |
| `positionFilterSize` | `filter.position.size` |
| `positionFilterEnable` | `filter.position.enable` |

Python discards these old flat keys; ECB still accepts them in its schema, but
they do not configure the filters. Explicitly use `filter.velocity.enable` to
enable or disable the encoder velocity filter.

## controller
Parameters for centralized PID controller.

These settings are only valid for:
* Physical axes
* CSV mode
* CSP_PC mode (CSP with one encoder setup as useAsCSPDrvEnc). In this mode there are double position control loops, one in ecmc and one in drive.

The `controller` section is optional. Defaults are `Kp: 1`, `Ki: 0`,
`Kd: 0`, `Kff: 1`, including when the entire section is omitted.

optional
- `Kp`: proportional; default 1
- `Ki`: integral; default 0
- `Kd`: differential; default 0
- `Kff`: feed forward; default 1
- `resetIAtRmp`: Reset the integral part to zero while the internal trajectory is busy; default false
- `freezeIAtRmp`: Keep the current integral part unchanged while the internal trajectory is busy; default false
- `deadband`:
  - `tol`: Stop control if within this distance from target for the below time
  - `time`: Time filter
- `limits`:
  - `minOutput`: Minimum controller output
  - `maxOutput`: Maximum controller output
  - `minIntegral`: Minimum integral output
  - `maxIntegral`: Maximum integral output
- `inner`:
  - `tol`: When within this distance to target, `inner.Kp`, `inner.Ki`, `inner.Kd` will be used
  - `Kp`: Kp for when close to target
  - `Ki`: Ki for when close to target
  - `Kd`: Kd for when close to target

Limit handling for `controller.limits`:

- Output limiting is active only when `maxOutput > minOutput`.
- If `minOutput = 0` and `maxOutput = 0`, the controller output limits are disabled.
- Integral limiting follows the same rule: it is active only when `maxIntegral > minIntegral`.
- If `minIntegral = 0` and `maxIntegral = 0`, the integral limits are disabled.

The ramp settings apply only when the trajectory source is internal and the local
trajectory is busy. Outside that state, the controller integrates normally. If
both `resetIAtRmp` and `freezeIAtRmp` are enabled, reset takes precedence.

```yaml
controller:
  Kp:  90
  #Ki:  0.1
  #Kd:  0
  #Kff: 1
  #resetIAtRmp: false
  #freezeIAtRmp: false
  #deadband:
  #  tol: 0.01
  #  time: 100
  #limits:
  #  minOutput: -100
  #  maxOutput: 100
  #  minIntegral: -100
  #  maxIntegral: 100
  #inner:
  #  Kp: 0.1
  #  Ki: 0.1
  #  Kd: 0.1
  #  tol: 0.1
```

## trajectory
settings for the trajectory planning.

{{% notice warning %}}
*All* accelerations are now defined in EGU s^{-2}
{{% /notice %}}

mandatory

- `axis`
  - `velocity`: velocity setpoint the axis will be initialized to (in EGU/sec)
  - `acceleration`: acceleration setpoint for initialization (in EGU/sec2)

optional

- `source`: source of position setpoint, 0=trajectory generator of axis ; 1=from PLC
- `type`: type of velocity profile: 0=trapezoidal ; 1=s-curve
- `axis`
  - `deceleration`: deceleration setpoint (EGU/sec2); defaults to acceleration
  - `emergencyDeceleration`: emergency deceleration (EGU/sec2); defaults to
    `10 * max(acceleration, deceleration)`
  - `jerk`: jerk for s-curved profiles (EGU/sec3); defaults numerically to acceleration
- `jog`
  - `velocity`: ECMC jog velocity defaults to `axis.velocity`; motor-record JVEL
    defaults to `axis.velocity / 10`. Set this key explicitly to use the same value.
  - `acceleration`: motor-record jog acceleration; defaults to `axis.acceleration`.
    This key does not set a separate ECMC jog acceleration.
- `modulo`
  - `range`: modulo range
  - `type`: modulo type

```yaml
trajectory:
# source: 0
# type: 0
  axis:
    velocity: 180
    acceleration: 180
    # deceleration: 360
    # jerk: 1.0
    # emergencyDeceleration: 0.05
  # jog:
  #   velocity: 90
  #   acceleration: 0.1
  # modulo:
  #   range: 0
  #   type: 0
```

## positionCompare
Optional one-shot timed output at an axis position crossing. This is typically
used with an EL2252 timestamp-scheduled digital output.

mandatory

- `output`: EtherCAT output entry to schedule, for example `binaryOutput01`
- `activate`: EtherCAT activation/control entry
- `startTime`: EtherCAT DC start-time entry. Use a 64-bit integer entry/PV for EL2252.

optional

- `minLeadMs`: minimum allowed scheduling lead time in milliseconds, default 2.0
- `maxLeadMs`: maximum allowed scheduling lead time in milliseconds, default 100.0
- `activateIdle`: activation value while idle, default 3 for EL2252
- `activateSchedule`: activation value written for one cycle to load a schedule, default 0 for EL2252
- `pulseWidthMs`: automatic reset pulse width in milliseconds, default 0. Fractions such as 0.5 are allowed.
- `resetValue`: output value for the automatic reset, default 0

```yaml
positionCompare:
  output: ec0.s$(OUT_SLAVE).binaryOutput01
  activate: ec0.s$(OUT_SLAVE).activate
  startTime: ec0.s$(OUT_SLAVE).startTime
  minLeadMs: 2.0
  maxLeadMs: 4.0
  activateIdle: 3
  activateSchedule: 0
  pulseWidthMs: 10.0
  resetValue: 0
```

Arm and inspect it at runtime with:

```text
AxisPositionCompareArm(axis,target,direction,outputValue)
AxisPositionCompareCancel(axis)
AxisPrintPositionCompare(axis)
```

`direction` is `1` for positive crossing, `-1` for negative crossing and `0`
for either direction.

### Practical timing notes

The EL2252 timed-output path can be very accurate, but the final position error
also depends on how early the axis position compare predicts the crossing. A
large `maxLeadMs` makes ecmc schedule farther ahead of the target and gives
following error, velocity error and acceleration-model error more time to
accumulate. For a 1 kHz EtherCAT cycle, a useful tested starting point is:

```yaml
positionCompare:
  minLeadMs: 2.0
  maxLeadMs: 4.0
```

In one EL2252-to-EL7062/ED7062 touch-probe test at about 10 engineering
units/s, reducing the maximum lead improved the measured output position error
from roughly one EtherCAT cycle scale down to tens of microseconds. With
`minLeadMs: 2.0` and `maxLeadMs: 4.0`, constant-velocity crossings were about
13 to 18 microseconds late, and acceleration/deceleration crossings were about
20 microseconds from the requested position in opposite directions. Treat these
numbers as an example, not a guarantee; mechanics, grounding, terminal timing,
DC shift and following error all affect the result.

When validating with a hardware touch probe, distinguish the two errors:

- Position-compare output error is approximately
  `(latched_position - target_position) / velocity`.
- The `timing_us` field printed by the touch-probe reconstruction PLC is the
  reconstruction check between the hardware-latched position and the encoder
  position estimated at the touch-probe timestamp.

For the first expression, a negative value means the output occurred before the
axis reached the requested target position, and a positive value means it
occurred after the target.

When `positionCompare` is configured, ecmccfg also loads optional axis-specific
position-compare PVs. The main readbacks are:
`<Axis>-PC-State`, `-PC-Reason`, `-PC-Seq`, `-PC-Target`, `-PC-Pos`,
`-PC-Vel`, `-PC-Dir`, `-PC-ScheduledTimeNs`, `-PC-LeadTimeNs`,
`-PC-PulseWidthNs`, `-PC-ResetTimeNs`, `-PC-LastActivate`, and
`-PC-LastOutput`. The matching caQtDM panel is `ecmcAxisPositionCompare.ui`.
A static config marker, `<Axis>-PC-HasPC`, is also loaded with `VAL=1` and can be
used by GUIs to show or hide position-compare controls.

## input
Links to the binary input sensors for limit switches, home sensor and external interlock.
The `limit` block and its `forward` and `backward` entries are required.
`home` and `interlock` are optional. For an unused limit input, use the `ONE.0`
entry of a slave.
See the example for details.

Omit `home` when no home sensor is connected. No home-input link is generated,
and the encoder monitor retains its default disabled home-switch state. The
panel hardware-link record is still created with `N/A` and slave ID `-1`.
Python/Jinja and ECB both support this omission.

mandatory

- `limit`
  - `forward`: limit switch sensor input in the forward direction.
  - `backward`: limit switch sensor input in the backward direction.

Optional:

- `home`: binary input for the home sensor
- `interlock`: binary input for external interlock
- `homePolarity`, `interlockPolarity`, `limit.forwardPolarity`,
  `limit.backwardPolarity`: polarity overrides; if omitted, no polarity command
  is issued

```yaml
input:
  limit:
    forward: ec0.s$(DRV_SLAVE).ONE.0    #  EtherCAT entry for low limit switch input
    backward: ec0.s$(DRV_SLAVE).ONE.0   #  EtherCAT entry for high limit switch input
  home: ec0.s$(DRV_SLAVE).ONE.0         #  EtherCAT entry for home switch input
  interlock: ec0.s$(DRV_SLAVE).ONE.0    #  EtherCAT entry for interlock switch input
```
The inputs can also be overridden with the keyword "plcOverride". In this case these values must be written in PLC code instead.
```text
...
input:
  limit:
    forward: 'plcOverride'                            # Overridden, see plc code below
    backward: 'plcOverride'                           # Overridden, see plc code below
...
plc:
  enable: true                                        # Enable axis plc
  externalCommands: true                              # Allow axis to inputs from PLC
  code:                                               # Sync code (appended after code in plc.file)
    - ax${AX_ID=1}.mon.lowlim:=ec_chk_bit(ec0.s$(DRV_SID).binaryInputs01,0) and ec_chk_bit(ec0.s$(DRV_SID).ONE,0);
    - ax${AX_ID=1}.mon.highlim:=ec_chk_bit(ec0.s$(DRV_SID).binaryInputs01,1) and ec_chk_bit(ec0.s$(DRV_SID).ONE,1);
  ..
```

## output

There is no current top-level `output` YAML section. Use `axis.healthOutput`
for the axis health output and `drive.brake` for the brake output.

## homing
Prefer `encoder.homing`. Top-level `homing` is retained for legacy configurations;
do not define both locations in the same axis file.

This section is mostly obsolete at PSI, as for all new installations using EtherCAT, absolute encoders are mandatory.
In case a legacy system or temporary installation requires an incremental encoder, or even open loop operation, several procedures for referencing are available.

optional

- `type`: referencing procedure
- `position`: position of the reference mark in engineering units
- `postMoveEnable`: post homing move
- `postMovePosition`: post-homing target; required when `postMoveEnable: true`
- `latchCount`: latch counter
- `velocity`: velocities
  * `to`: to the cam
  * `from`: off the cam
- `acceleration`: homing acceleration in EGU/sec2
- `deceleration`: homing deceleration in EGU/sec2
- `timeout`: homing sequence timeout in seconds

Home-switch polarity belongs in `input.homePolarity`; `homing.switchPolarity`
is not a supported key.

```yaml
# homing:
#   type: 3
#   position: 0
#   postMoveEnable: false
#   postMovePosition: 0
#   latchCount: 0
#   velocity:
#     to: 2.72
#     # from: 3.14
#   # acceleration: 2
#   # deceleration: 5
```

## softlimits
Soft limits define the allowed software travel range of an axis.

There are two related sets of soft limits:

- ecmc soft limits, configured by the `softlimits` YAML section and enforced by
  ecmc.
- motor-record soft limits, exposed as the motor record `HLM` and `LLM`
  limits.

The ecmc soft limits should normally describe the outer maximum range that the
axis is allowed to move. During startup the motor-record soft limits are
initialized from the same values. If soft-limit synchronization is disabled, the
motor-record limits can then be adjusted at runtime to a narrower range while
the ecmc soft limits remain as the outer protection.

In newer versions of ecmc and the motor record, the two limit sets can be
synchronized with `epics.motorRecord.syncSoftLimits`. When synchronization is
enabled, the ecmc and motor-record limits are kept equal. If the synchronized
motor-record soft limits are set to `0,0`, both the ecmc and motor-record soft
limits are disabled.

After changing soft limits, reload any open caQtDM panels. Their numeric input
widgets use the soft limits read when the panel was opened. Until the panel is
reloaded, these widgets can reject values based on the previous limits, for
example when entering a motor target position in the `VAL` field.

For startup restoration from autosave, use `restoreMotorSoftLims=1;` in `axis.parameters` and save the motor `.DLLM`/`.DHLM` fields. Without autosave restoring those fields, the standard generated motor record retains its YAML-derived limits. See [motor position and soft-limit autosave]({{< relref "/manual/motion_cfg/autosave.md" >}}) for precedence, restore passes and startup gating.

If synchronization is not enabled, disable ecmc soft limits with the enable PVs:

- `<PREFIX>:<MOTOR>-SftLimBwdEna`
- `<PREFIX>:<MOTOR>-SftLimFwdEna`

optional

- `enable`: global enable of soft limits.
- `forwardEnable`: forward on/off.
- `forward`: soft limit in the forward direction.
- `backwardEnable`: backward on/off.
- `backward`: soft limit in the backward direction.

Supply each directional position together with its enable flag. The Python
schema also requires `enable` when either directional enable flag is present.
The template applies the block only when `enable: true`; a missing block does
not emit soft-limit configuration commands.

```yaml
# softlimits:
#   enable: true
#   forwardEnable: true # optional switch for forward direction
#   forward: 300.0
#   backwardEnable: true # optional switch for backward direction
#   backward: 25.0
```

## monitoring
Monitoring covers following error (`lag`), in-position detection (`target`),
maximum velocity (`velocity`), velocity tracking (`velocityDifference`) and
failure to reach the target (`stall`).

{{% notice info %}}
It is highly advisable to always use the `lag` and `target` monitoring fo closed-loop axis.
Failure to do so will most likely result in unexpected behavior.
{{% /notice %}}

{{% notice info %}}
The `monitoring` section is optional in both schemas. Configure it explicitly
for a working axis: target monitoring supplies motion-completion detection,
and following-error monitoring is recommended for closed-loop axes.
{{% /notice %}}

When supplying `lag` or `target`, include `enable`, `tolerance` and `time`.
For `velocity` and `velocityDifference`, include `enable`, `max` and
`time.trajectory`; `time.drive` is optional. Dependencies still apply when
`enable` is false. An empty `monitoring: {}` does not enable monitoring.

The monitoring `time` values below are **EtherCAT cycles**, not milliseconds.
At 1 kHz, 100 cycles is 100 ms; at 500 Hz it is 200 ms.

The trajectory and drive delays for `velocityDifference` are independent of
the corresponding maximum-velocity monitor delays. Either monitor can be
configured without enabling the other.

optional

- `lag`
  * `enable`: enable lag monitoring
  * `tolerance`: tolerance in engineering units
  * `time`: time for the condition to be true in EtherCAT cycles
- `target`
  * `enable`: enable target monitoring. This is mandatory for use with motor record.
  * `tolerance`: tolerance in engineering units
  * `time`: time for the condition to be true in EtherCAT cycles
  * `slaveControlDeadband`: optional independent band evaluated on a master axis
    and forwarded to its slaves for control decisions such as reduced torque
    * `tolerance`: master-axis error tolerance in engineering units
    * `time`: qualification time inside that tolerance in EtherCAT cycles
- `velocity`
  * `enable`: enable velocity monitoring
  * `max`: upper limit for velocity
  * `time`
    * `trajectory`: violation delay in EtherCAT cycles
    * `drive`: drive-interlock delay in EtherCAT cycles
- `velocityDifference`: same `enable`, `max` and `time` structure as `velocity`;
  compares actual velocity with the trajectory velocity
- `stall`: optional `enable` and `time.timeout` (minimum timeout in EtherCAT
  cycles), `time.factor` (dimensionless motion-time multiplier); requires target
  monitoring for target detection

```yaml
monitoring:
  # lag:
  #   enable: false
  #   tolerance: 5
  #   time: 100
  target:
    enable: true
    tolerance: 0.125
    time: 100  # EtherCAT cycles
    # Optional on a master axis. If omitted, ecmc uses target tolerance/time.
    slaveControlDeadband:
      tolerance: 0.01
      time: 100  # EtherCAT cycles
  # velocity:
  #   enable: false
  #   max: 100
  #   time:
  #     trajectory: 100
  #     drive: 200
```

## All yaml settings

The full annotated configuration is on the [complete axis YAML example]({{< relref "/manual/motion_cfg/axisYamlExample.md" >}}) page.
