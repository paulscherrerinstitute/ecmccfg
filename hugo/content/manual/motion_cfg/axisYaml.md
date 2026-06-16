+++
title = "yaml configuration"
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
  axis: 1

input:
  limit:
    forward: ec0.s$(DRV_SLAVE).ONE
    backward: ec0.s$(DRV_SLAVE).ONE
```

## Companion References
Use this page as the configuration guide, and use the two pages below as fast references:
- [Axis YAML settings table](../axisyaml-table/) for compact key-by-key lookup.
- [Axis YAML settings (heading view)](../axisyaml-headings/) for grouped section overview.

Related motion docs:
- [Drive modes CSV, CSP, CSP-PC](../modes_CSV_CSP_CSP_PC/)
- [scaling](../scaling/)
- [direction](../direction/)
- [homing](../homing/)
- [axis PLC](../axisplc/)
- [motor record](../motor/)
- [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}})
- [Master/Slave State Machine]({{< relref "/manual/general_cfg/master_slave_state_machine.md" >}})

The configuration is separated into the following mandatory sections:

- [axis](#axis)
- [epics](#epics)
- [drive (only mandatory for physical axis)](#drive)
- [encoder](#encoder)
- [controller](#controller)
- [trajectory](#trajectory)
- [input](#input)

In addition, the following optional sections are available:

- [output](#output)
- [homing](#homing)
- [softlimits](#softlimits)
- [monitoring](#monitoring)

Each section provides an example; optional keys are commented.

***

## axis
mandatory
- `id`: unique numeric identifier of the axis

optional
- `type`: type of the axis
- `mode`: operating mode of the drive
- `parameters`: additional parameters

```yaml
axis:
  id: 1
  # type: joint   # axis types:
                  # 1 (equiv: physical, axis, j, motor, real)
                  # 2 (equiv: virtual, end_effector, end-effector, ee, e)
  # mode: CSV     # supported modes: CSV and CSP
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

mandatory

- `name`: name of the PV

optional

- `precision`: PREC field; default 3
- `unit`: EGU field; optional default mm
- `motorRecord`
  * `enable`: set to false to disable motor record
  * `description`: DESC field; default ''
  * `fieldInit`: string with additional field initial values; default ''
  * `syncSoftLimits`: sync motor record and ecmc soft limits; default false. When false, motor record `HLM`/`LLM` and ecmc soft limits can differ. When changed from false to true at runtime, the current ecmc soft limits are copied to the motor record. While enabled, later motor record soft-limit changes are written back to ecmc.
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

- `numerator`: scaling numerator
- `denominator`: scaling denominator
- `type`: type of drive: `0`=stepper, `1`=DS402, aka servo or complex stepper
- `control`: control word entry
- `status`: status word entry
- `setpoint`: setpoint entry, **position** or **velocity**, depending on mode

{{% notice info %}}
Floating-point EtherCAT entries are supported in ecmc, but the rules differ by use case:

- encoder actual-position entries (`encoder.position`) with `F32`/`F64` are only valid for absolute encoders (`encoder.type: 1`)
- CSP drive position setpoints with `F32`/`F64` require the selected CSP encoder actual-position entry to use the same EtherCAT datatype
- CSV drive velocity setpoints with `F32`/`F64` are supported
{{% /notice %}}

optional

- `reduceTorque`: control word _bit_ to set for reduced torque mode
- `brake`
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
  # brake:
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
mandatory

- `numerator`: scaling numerator, equivalent distance to the maximum drive frequency (default: 2000 Hz i.e. 2000 full steps), also effectively absolute maximum velocity
- `denominator`: scaling denominator
- `type`: type of encoder: `0`=incremental, `1`=absolute
- `bits`: raw data bit count
- `absBits`: Absolute bit count (for absolute encoders) always least significant part of 'bits'
- `absOffset`: Encoder offset in engineering units (for absolute encoders)
- `position`: position entry

optional

- `source`: position source, 0=from EC entry ; 1=from PLC
- `control`: control word entry; mandatory when **reset** is set.
- `status`: status word entry; mandatory when **error** or **warning** are set
- `reset`: control word _bit_ to set in order to reset the encoder
- `warning`: status word _bit_ for encoder warning
- `error`: list of status _bits_ for encoder errors
- `velocityFilterSize`: size of the velocity filter (cycles)
- `positionFilterSize`: size of the position filter (cycles)
- `positionFilterEnable`: position filter enable
- `latch`:
  * `position`: ''
  * `control`: ''
  * `status`: ''

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
  # velocityFilterSize: 100
  # positionFilterSize: 1
  # positionFilterEnable: false
  # latch:
  #   position: ''
  #   control: ''
  #   status: ''
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

optional

- `velocityFilterSize`: Add filtering if the encoder is too coarse to reliably determine velocity each PLC cycle

## controller
Parameters for centralized PID controller.

These settings are only valid for:
* Physical axes
* CSV mode
* CSP_PC mode (CSP with one encoder setup as useAsCSPDrvEnc). In this mode there are double position control loops, one in ecmc and one in drive.

mandatory
- `Kp`: proportional

optional
- `Ki`: integral; default 0
- `Kd`: differential; default 0
- `Kff`: feed forward; default 1
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

```yaml
controller:
  Kp:  90
  #Ki:  0.1
  #Kd:  0
  #Kff: 1
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
  #tol: 0.1
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
  - `deceleration`: deceleration setpoint for initialization (in EGU/sec2)
  - `emergencyDeceleration`: deceleration setpoint for emergencies. Defaults to acceleration setpoint if not specified.
  - `jerk`: jerk for s-curved profiles (in EGU/sec3)
- `jog`
  - `velocity`: velocity setpoint the axis will be initialized to for jogging
  - `acceleration`: acceleration setpoint for initialization, for jogging
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

## input
Links to the binary input sensors for limit switches, home sensor and external interlock.
All four inputs must be provided.
If an input is not used, set it to the `ONE.0` entry of a slave.
See the example for details.

mandatory

- `limit`
  - `forward`: limit switch sensor input in the forward direction.
  - `backward`: limit switch sensor input in the backward direction.
- `home`: binary input for the home sensor
- `extinterlock`: binary input for external interlock.

```yaml
input:
  limit:
    forward: ec0.s$(DRV_SLAVE).ONE.0    #  EtherCAT entry for low limit switch input
    backward: ec0.s$(DRV_SLAVE).ONE.0   #  EtherCAT entry for high limit switch input
  home: ec0.s$(DRV_SLAVE).ONE.0         #  EtherCAT entry for home switch input
  interlock: ec0.s$(DRV_SLAVE).ONE.0    #  EtherCAT entry for interlock switch input
```
The inputs can also be overridden with the keyword "plcOverride". In this case these values must be written in PLC code instead.
```
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
Two outputs can be used with `ECMC`.

{{% notice info %}}
The brake output was moved to the `drive` key, as it is directly coupled to the drive state.
{{% /notice %}}

optional
- `health`: sum parameter for axis health

```yaml
# output:
#   health: ''      # EtherCAT entry for health output
```

## homing
This section is mostly obsolete at PSI, as for all new installations using EtherCAT, absolute encoders are mandatory.
In case a legacy system or temporary installation requires an incremental encoder, or even open loop operation, several procedures for referencing are available.

optional

- `type`: referencing procedure
- `position`: position of the reference mark in engineering units
- `postMoveEnable`: post homing move
- `postMovePosition`: post homing move target
- `switchPolarity`: home switch polarity, for NO switches
- `latchCount`: latch counter
- `velocity`: velocities
  * `to`: to the cam
  * `from`: off the cam
- `acceleration`: acceleration time in s
- `deceleration`: deceleration time in s

```yaml
# homing:
#   type: 3
#   position: 0
#   postMoveEnable: false
#   postMovePosition: 0
#   switchPolarity: 0 ## 0: NC, 1: NO
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

If synchronization is not enabled, disable ecmc soft limits with the enable PVs:

- `<PREFIX>:<MOTOR>-SftLimBwdEna`
- `<PREFIX>:<MOTOR>-SftLimFwdEna`

optional

- `enable`: global enable of soft limits.
- `forwardEnable`: forward on/off.
- `forward`: soft limit in the forward direction.
- `backwardEnable`: backward on/off.
- `backward`: soft limit in the backward direction.

```yaml
# softlimits:
#   enable: true
#   forwardEnable: true # optional switch for forward direction
#   forward: 300.0
#   backwardEnable: true # optional switch for backward direction
#   backward: 25.0
```

## monitoring
Three entities can be monitored, (1) lag, aka following error, (2) target, aka in position, (3) velocity.

{{% notice info %}}
It is highly advisable to always use the `lag` and `target` monitoring fo closed-loop axis.
Failure to do so will most likely result in unexpected behavior.
{{% /notice %}}

{{% notice info %}}
The `monitoring` key, **must** be included in the config, despite all features being optional.
It's a means to let the integrator think twice to skip it all together.
{{% /notice %}}

optional

- `lag`
  * `enable`: enable lag monitoring
  * `tolerance`: tolerance in engineering units
  * `time`: time for the condition to be true in ms
- `target`
  * `enable`: enable target monitoring. This is mandatory for use with motor record.
  * `tolerance`: tolerance in engineering units
  * `time`: time for the condition to be true in ms
- `velocity`
  * `enable`: enable velocity monitoring
  * `max`: upper limit for velocity
  * `time`
    * `trajectory`: time for the condition to be in violation in ms
    * `drive`: time for the condition to be in violation in ms

```yaml
monitoring:
  # lag:
  #   enable: false
  #   tolerance: 5
  #   time: 100
  # target:
  #   enable: true
  #   tolerance: 0.125
  #   time: 100
  # velocity:
  #   enable: false
  #   max: 100
  #   time:
  #     trajectory: 100
  #     drive: 200
```

## All yaml settings
```
axis:
  id: 1                                               # Axis id
  type: joint                                         # axis type selector for future use
  mode: CSV                                           # supported mode, CSV and CSP, defaults CSV
  # Please switch to ecmc auto-enable/disable (axis.autoEnable) instead of the motor record.
  parameters: 'axisPar' # additional parameters       # Additional params to motor record driver
  #                                                       "powerAutoOnOff=<value>;"  //2: What you want, 1:do not use, 0 to disable
  #                                                       "powerOffDelay=<value>:"
  #                                                       "powerOnDelay=<value>;"
  healthOutput: ec0...                                # EtherCAT entry for health output
  feedSwitchesOutput: ec0...                          # EtherCAT entry for fed switches
  feedSwitchesValue: 1                                # Value to write to axis.feedSwitchesOutput. Defaults to 1
  group: testGroup                                    # Add axis to group (group will be created if it does not exist),
  #                                                     group id will be stored in GRP_<axis.group>_ID for later use.
  autoMode:                                           # Switch drive modes automatically for normal motion and homing (smaract for instance)
    modeSet: ec0..                                    # EtherCAT entry drive mode write (set CSV,CSP,homing)
    modeAct: ec0..                                    # EtherCAT entry drive mode reading (set CSV,CSP,homing)
    modeCmdMotion: 9                                  # Drive mode value for normal motion (written to axis.drvMode.modeSet when normal motion)
    modeCmdHome: 10                                   # Drive mode value for when homing (written to axis.drvMode.modeSet when homing)
  features:
    blockCom: false                                   # Block communication to axis
    allowSrcChangeWhenEnabled: false                  # Allow traj/enc source change when axis is enabled
    allowedFunctions:
      homing: true                                    # Allow homing
      constantVelocity: true                          # Allow constant velocity
      positioning: true                               # Allow positioning
  autoEnable:                                         # ecmc auto enable of axis (Please use this instead of motor record version..)
    enableTimeout: 5.0                                # If defined, ecmc tries to auto-enable for a maximum enableTimeout seconds.
    disableTimeout:   5.0                             # If defined, ecmc disables axis after idle (non busy) in disableTime seconds
    atStartup: True                                   # Auto enable axis at ioc start, default False
  tweakDist: 2.0                                      # Tweak value (both ecmc interface and motor record tweak value)

epics:
  name: M1                                            # Axis name
  precision: 3                                        # Decimal count
  description: very important motor axis              # Axis description
  unit: mm                                            # Unit
  motorRecord:
    enable: true
    description: This is MR
    fieldInit: 'RRES=1.0,RTRY=2,RMOD=1,UEIP=0,RDBD=0.1,URIP=1,RDBL=$(IOC):$(ECMC_MOTOR_NAME)-PosActSim' # Extra config for Motor record
    syncSoftLimits: false                             # Optional: Sync softlimits between motor and ecmc (default false).
                                                      # On false->true, ecmc soft limits are copied to the motor record.
                                                      # While true, later motor record soft-limit changes are written back to ecmc.

drive:
  numerator: 360                                      # Fastest speed in engineering units
  denominator: 4096                                   # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET
  type: 0                                             # Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives)
  control: ec0.s$(DRV_SLAVE).driveControl01           # Control word EtherCAT entry
  enable: 0                                           # Enable bit index in control word (not used if DS402)
  enabled: 1                                          # Enabled bit index in status word (not used if DS402)
  status: ec0.s$(DRV_SLAVE).driveStatus01             # Status word EtherCAT entry
  setpoint: ec0.s$(DRV_SLAVE).velocitySetpoint01      # Velocity setpoint if CSV. Position setpoint if CSP
  reduceTorque: 2                                     # Reduce torque bit in drive control word
  reduceTorqueEnable: True                            # Enable reduce torque functionality
  brake:
    enable: false
    output: ec0...                                    # Ethercat link to brake output
    openDelay: 0                                      # Brake timing parameter in cycles (default 1kHz)
    closeAhead: 0                                     # Brake timing parameter in cycles (default 1kHz)
  reset: 1                                            # Reset   (if no drive reset bit then leave empty)
  warning: 2                                          # Warning (if no drive warning bit then leave empty)
  error:                                              # max 3
    - 3                                               # Error 0 (if no drive error bit then leave empty)
    - 7                                               # Error 1 (if no drive error bit then leave empty)
    - 14                                              # Error 2 (if no drive error bit then leave empty)

encoder:
  numerator: 360                                      # Scaling numerator example 360 deg/rev
  denominator: 4096                                   # Scaling denominator example 4096 ticks per 360 degree
  type: 0                                             # Type: 0=Incremental, 1=Absolute
  bits: 16                                            # Total bit count of encoder raw data
  absBits: 0                                          # Absolute bit count (for absolute encoders) always least significant part of 'bits'
  absOffset: 0                                        # Encoder offset in eng units (for absolute encoders)
  mask: '0xFFF00'                                     # Mask applied to raw encoder value
  position: ec0.s$(ENC_SLAVE).positionActual01        # EtherCAT entry for actual position input (encoder)
  control: ec0.s$(ENC_SLAVE).encoderControl01         # mandatory only if 'reset' is used
  status: ec0.s$(DRV_SLAVE).encoderStatus01           # mandatory only if 'warning' or 'error' are used
  ready: 10                                           # Bit in encoder status word for encoder ready
  source: 0                                           # 0 = Encoder value from EtherCAT hardware, 1 = Encoder value from PLC
  reset: 1                                            # Reset   (optional)
  warning: 2                                          # Warning (optional)
  error:                                              # max 3 (optional)
    - 5                                               # Error 0
    - 9                                               # Error 1
    - 11                                              # Error 2
  filter:
    velocity:
      size: 100                                       # Filter size for velocity
      enable: true                                    # enable velocity filter
    position:
      size: 100                                       # Filter size for encoder value
      enable: true                                    # enable encoder value filter
  latch:
    position: ''                                      # Link to latched value. Used for some homing seqs
    control: 0                                        # Bit in encoder control word to arm latch. Used for some homing seqs
    status: 0                                         # Bit in encoder status word for latch triggered status. Used for some homing seqs
    armCmd:                                           # Value in dec to arm latch/touch probe to write to encoder.control
    armBits:                                          # Bit size of encoder.latch.armCmd
  primary: True                                       # Use this encoder as primary (for control)
  useAsCSPDrvEnc: True                                # Use this encoder as CSP drive encoder (ecmc controller enabled in CSP)
# allowOverUnderFlow: True                            # Allow over/under flow of encoder raw counter (default true). Set to false for linear encoders.
  homing:
    type: 3                                           # Homing sequence type
    position: -30                                     # Position to reference encoder to
    velocity:
      to: 10                                          # Velocity to cam/sensor (used for some homing seqs)
      from: 5                                         # Velocity from cam/sensor (used for some homing seqs)
    acceleration: 20                                  # Acceleration during homing
    deceleration: 100                                 # Deceleration during homing
    refToEncIDAtStartup: 1                            # At startup then set the start value of this encoder to actpos of this encoder id
    refAtHome: 1                                      # If homing is executed then set position of this encoder
    tolToPrim: 0                                      # If set then this is the max allowed tolerance between prim encoder and this encoder
    postMoveEnable: yes                               # Enable move after successful homing
    postMovePosition: 10                              # Position to move to after successful homing
    trigg: ec0..                                      # EtherCAT entry for triggering drive internal homing seq (seq id 26)
    ready: ec0..                                      # EtherCAT entry for reading drive internal homing seq ready (seq id 26)
    latchCount: 1                                     # latch number to ref on (1=ref on first latch)
  delayComp:                                          # Delay compensation for time between application of setpoint to reading of encoder (normally at least 1 cycle)
    time: 1.5                                         # Delay time between set and act [cycles]
#    enable: true                                     # enable (defaults to 1 if not set)
  lookuptable:                                        # Lookup tables are only applied when encoder is homed
    filename: ./cfg/enc.corr                          # Load correction lookup table file. Value will be subtracted from encoder value.
#    enable: 1                                        # Enable correction table (default enabled if loaded).
#    scale: 1                                         # Scale applied to LUT (if you want value to be added then set scale to -1.0)
#    range: 360                                       # LUT modulo value (Lut should cover the range 0..range)

controller:
  Kp: 1                                               # Kp proportional gain
#  Ki: 0.001                                           # Ki integral gain
#  Kd: 0                                               # Kd derivative gain
#  Kff: 1                                              # Feed forward gain
#  deadband:
#    tol: 0.01                                         # Stop control if within this distance from target for the below time
#    time: 100
#  limits:
#    minOutput: -100                                   # Minimum controller output
#    maxOutput: 100                                    # Maximum controller output
#    minIntegral: -100                                 # Minimum integral output
#    maxIntegral: 100                                  # Maximum integral output
#  inner:
#    Kp: 0.1                                           # Kp for when close to target
#    Ki: 0.1                                           # Ki for when close to target
#    Kd: 0.1                                           # Kd for when close to target
#    tol: 0.1                                          # Distance from target for when inner PID params will be used, defaults to atTarget tol

trajectory:
  type: 1                                             # Default 0 = trapezoidal, 1 = S-curve (ruckig)
  source: 0                                           # 0 = take trajectory setpoint from axis traj object, 1 = trajectory setpoint from plc
  axis:
    velocity: 10                                      # Default velo for axis
    acceleration: 0.1                                 # Default acc for axis
    deceleration: 0.1                                 # Default dec for axis
    emergencyDeceleration: 0.05                       # Deceleration when axis in error state
    jerk: 10                                          # Default jerk for axis
  jog:
    velocity: 5                                       # Default velocity for JOG (motor record)
  modulo:
    range: 360                                        # Modulo range 0..360
    type: 0                                           # Modulo type

#  Limits can be overridden with plc-code by setting input.limit.forward or input.limit.backward to 'plcOverride', then 'ax<id>.mon.lowlim' and/or 'ax<id>.mon.highlim' needs to be written to in plc code (1 means limit OK).

input:
  limit:
    forward: ec0.s$(ENC_SLAVE).ONE.0                  # EtherCAT entry for low limit switch input,
    forwardPolarity: 0                                # Polarity of forward limit switch
    backward: ec0.s1.BI_2.0                           # EtherCAT entry for high limit switch input
    backwardPolarity: 0                               # Polarity of backward limit switch
  home: 'ec0.s$(MCS2_SLAVE_NUM).ONE.0'                # EtherCAT entry for home switch
  homePolarity: 0                                     # Polarity of home switch
  interlock: 'ec0.s$(ENC_SLAVE).ONE.0'                # EtherCAT entry for interlock switch input
  interlockPolarity: 0                                # Polarity of interlock switch
  analog:
    interlock: 'ec0.s$(ENC_SLAVE).ONE'                # EtherCAT entry for analog interlock
    interlockPolarity: 1                              # 0: High value is bad, 1 = Low value is bad
    rawLimit: 2000                                    # Analog raw limit
    enable: true                                      # Enable analog interlock default true if analog.interlock is set

softlimits:
  enable: false                                       # Enable soft limits
  forward: 100                                        # Soft limit position fwd
  forwardEnable: false                                # Soft limit position fwd enable
  backward: -100                                      # Soft limit position bwd
  backwardEnable: false                               # Soft limit position bwd enable

monitoring:
  lag:
    enable: false                                     # Enable position lag monitoring (following error)
    tolerance: 0.5                                    # Allowed tolerance
    time: 10                                          # Allowed time outside tolerance [cycles]
  target:
    enable: true                                      # Enable at target monitoring (needs to be enabled and configured if using motor record)
    tolerance: 0.5                                    # Allowed tolerance
    time: 10                                          # Filter time inside tolerance to be at target [cycles]
  velocity:
    enable: false                                     # Enable velocity monitoring
    max: 100                                          # Allowed max velocity
    time:
      trajectory: 100                                 # Time allowed outside max velo before system init halt [cycles]
      drive: 200                                      # Time allowed outside max velo before system disables drive [cycles]
  velocityDifference:
    enable: true                                      # Enable velocity diff monitoring (velo set vs velo act)
    max: 100                                          # Allowed max difference
    time:
      trajectory: 100                                 # Time allowed outside max diff velo before system init halt [cycles]
      drive: 200                                      # Time allowed outside max diff velo before system disables drive [cycles]
  stall:
    enable: True                                      # Enable stall monitoring. At target must be enabled for this functionality
    time:
      timeout: 10000                                  # If not at target after "timeout" cycles after trajectory generator is ready then drive will disable
      factor: 5.0                                     # Measures duration of last motion command (busy high edge to busy low edge). The new timeout will be defined as this duration multiplied by this factor. The timeout finally used for stall detection will be the longest (of time.timeout and calculated from time.factor).

plc:
  enable: true                                        # Enable axis plc
  externalCommands: true                              # Allow axis to inputs from PLC
  file: myplcfile.plc                                 # File with plc code
  code:                                               # Sync code (appended after code in plc.file)
    - if(ax2.traj.source){ax2.drv.enable:=(ax10.drv.enable or ax11.drv.enable)}; # Enable axis if one of master axes is enabled
    - ax2.traj.setpos:=ax10.traj.setpos-ax11.traj.setpos/2; # calculate set pos for physical axis
  velocity_filter:                                    # Filter used to smooth velocity feedforward
    encoder:                                          # Filter plc enc velo
      enable: false                                   # Filter enable
      size: 100                                       # Filter size
    trajectory:                                       # Filter plc traj velo
      enable: false                                   # Filter enable
      size: 100                                       # Filter size
#  filter:                                            # Use "velocity_filter" instead since this naming is misleading and should be phased out
#    velocity:                                        # Filter plc enc velo
#      enable: false
#      size: 100
#    trajectory:                                      # Filter plc traj velo
#      enable: false
#      size: 100

```
