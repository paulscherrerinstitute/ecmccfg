+++  
title = "axis yaml configuration"
weight = 15
chapter = false  
+++  

Since `ecmccfg` v7, the axis configuration is based on yaml files.
{{% notice info %}}
Backwards compatibility for classic EPICS environment variable based configuration is assured for legacy systems.
{{% /notice %}}

{{% notice warning %}}
`yaml` is - like `python` - indentation sensitive!
{{% /notice %}}

{{% notice tip %}}
Indent with 2 spaces.
{{% /notice %}}

## introduction
{{% notice info %}}
`python 3.x` is required
{{% /notice %}}
The config is processed by a python script with a `jinja2` backend. The processor will complain if mandatory keys are missing. Likewise, missing optional keys are populated with default values.

{{% notice info %}}
The [script](../../../source/scripts/jinja2/loadyamlaxis/) invokes a python script which subsequently uses a `jinja2` processor to render the respective templates. The script will create a `python` virtual environment and install the required libraries automatically.
{{% /notice %}}

The configuration is separated into the following mandatory sections:

- [axis](#axis)
- [epics](#epics)
- [drive (only mandatory for physical axis)](#drive)
- [encoder](#encoder)
- [controller](#controller)
- [trajectory](#trajectory)
- [input](#input)

in addition the following optional sections are available.

- [output](#output)
- [homing](#homing)
- [softlimits](#softlimits)
- [monitoring](#monitoring)

Each sections provides an example, the optional keys are commented.

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
                  # 1 (equiv: physical, joint, j, motor, real)
                  # 2 (equiv: virtual, end_effector, endeffector, ee, e)
  # mode: CSV     # supported modes: CSV and CSP
  # parameters: powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=1.0;
```

## epics
Epics configuration.

{{% notice info %}}
The Epics motorRecord can now be disabled.
{{% /notice %}}

mandatory

- `name`: name of the PV

optional

- `precision`: PREC field; default 3
- `unit`: EGU field; optional default mm
- `motorRecord`
  * `enable`: set to false to disable motorRecord
  * `description`: DESC field; default ''
  * `fieldInit`: string with additional field initial values; default ''

```yaml
epics:
  name: M1
  # precision: 3
  # unit: deg
  # motorRecord:
  #   enable: false
  #   fieldInit: 'RRES=1.0,RTRY=2,RMOD=1,UEIP=0,RDBD=0.1,URIP=1,RDBL=$(IOC):$(ECMC_MOTOR_NAME)-PosActSim'
  #   fieldInit: 'NTM=1'
  #   description: AM8111 CSV
```

## drive
mandatory for physical axis

- `numerator`: scaling numerator
- `denominator`: scaling denominator
- `type`: type of drive: `0`=stepper, `1`=DS402, aka servo or complex stepper
- `control`: control word entry
- `status`: status word entry
- `setpoint`: setpoint entry, **position** or **velocity**, depending on mode

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
  position: ec0.s$(DRV_SLAVE).positionActual01  # Ethercat entry for actual position input (encoder)
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

optional

- `velocityFilterSize`: Add filtering if the encoder is too coarse to reliably determine velocity each PLC cycle


## controller
PID controller parameters

mandatory

- `Kp`: proportional

optional

- `Ki`: integral; default 0
- `Kd`: differential; default 0
- `Kff`: feed forward; default 1

```yaml
controller:
  Kp:  90
  # Ki:  0.1
  # Kd:  0
  # Kff: 1
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
- `type`: type of velocity profile: 0=trapezoidal ; 1=scurve
- `axis`
  - `deceleration`: deccelerartion setpoint for initialization (in EGU/sec2)
  - `emergencyDeceleration`: deceleration setpoint for emergencies. Defaults to acceleration setpoint if not specified.
  - `jerk`: jerk for scurved profiles (in EGU/sec3)
- `jog`
  * `velocity`: velocity setpoint the axis will be initialized to for jogging
  * `acceleration`: acceleration setpoint for initialization, for jogging
- `modulo`
  * `range`: modulo range
  * `type`: modulo type

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
  * `forward`: limit switch sensor input in the forward direction.
  * `backward`: limit switch sensor input in the backward direction.
- `home`: binary input for the home sensor
- `extinterlock`: binary input for external interlock.

```yaml
input:
  limit:
    forward: ec0.s$(DRV_SLAVE).ONE.0    #  Ethercat entry for low limit switch input
    backward: ec0.s$(DRV_SLAVE).ONE.0   #  Ethercat entry for high limit switch input
  home: ec0.s$(DRV_SLAVE).ONE.0         #  Ethercat entry for home switch input
  interlock: ec0.s$(DRV_SLAVE).ONE.0    #  Ethercat entry for interlock switch input
```

## output
Two outputs can be utilizes with `ECMC`.

{{% notice info %}}
The brake output was moved to the `drive` key, as it is directly coupled to the drive state.
{{% /notice %}}

optional
- `health`: sum parameter for axis health

```yaml
# output:
#   health: ''      # Ethercat entry for health output
```

## homing
This section is should be obsolete at PSI, as for all new installation using EtherCAT, absoulte encoders are mandatory.
In case a legacy system or temporary installation requires a incremental encoder, or even open loop operation, several procedures for referencing are available.

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
Soft limits to propagate to the motorRecord.

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
Failure to do so, will most likely results in unexpected behaviour.
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
  * `enable`: enable target monitoring
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
