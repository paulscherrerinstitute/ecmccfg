+++  
title = "yaml configuration"
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
                  # 2 (equiv: virtual, end_effector, end-effector, ee, e)
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
- `type`: type of velocity profile: 0=trapezoidal ; 1=s-curve
- `axis`
  - `deceleration`: deceleration setpoint for initialization (in EGU/sec2)
  - `emergencyDeceleration`: deceleration setpoint for emergencies. Defaults to acceleration setpoint if not specified.
  - `jerk`: jerk for s-curved profiles (in EGU/sec3)
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
This section is should be obsolete at PSI, as for all new installation using EtherCAT, absolute encoders are mandatory.
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

## All yaml settings
```
axis:
  id: 1                                               # Axis id
  type: joint                                         # this is for future selection of axis type
  mode: CSV                                           # supported mode, CSV and CSP, defaults CSV
  parameters: 'axisPar' # additional parameters       # Additional params to motor record driver
  #                                                       "powerAutoOnOff=<value>;"  //2: What you want, 1:do not use, 0 to disable
  #                                                       "powerOffDelay=<value>:"
  #                                                       "powerOnDelay=<value>;"
  healthOutput: ec0...                                # Ethercat entry for health output
  feedSwitchesOutput: ec0...                          # Ethercat entry for fed switches
  feedSwitchesValue: 1                                # Value to write to axis.feedSwitchesOutput. Defaults to 1
  group: testGroup                                    # Add axis to group (group will be created if not exists), 
  #                                                     group id will be stored in GRP<axis.group>_ID for later use.
  autoMode:                                           # Switch drive modes automaticaly for normal motion and homing (smaract for instance)
    modeSet: ec0..                                    # Ethercat entry drive mode write (set CSV,CSP,homing)
    modeAct: ec0..                                    # Ethercat entry drive mode reading (set CSV,CSP,homing)
    modeCmdMotion: 9                                  # Drive mode value for normal motion (written to axis.drvMode.modeSet when normal motion)
    modeCmdHome: 10                                   # Drive mode value for when homing (written to axis.drvMode.modeSet when homing)
  features:
    blockCom: false                                   # Block communication to axis
    allowSrcChangeWhenEnabled: false                  # Allow traj/enc source change when axis is enabled                      
    allowedFunctions:
      homing: true                                    # Allow homing
      constantVelocity: true                          # Allow constant velocity
      positioning: true                               # Allow positioning

epics:
  name: M1                                            # Axis name
  precision: 3                                        # Decimal count
  description: very important motor axis              # Axis description
  unit: mm                                            # Unit
  motorRecord:
    enable: true
    description: This is MR
    fieldInit: 'RRES=1.0,RTRY=2,RMOD=1,UEIP=0,RDBD=0.1,URIP=1,RDBL=$(IOC):$(ECMC_MOTOR_NAME)-PosActSim' # Extra config for Motor record

drive:
  numerator: 360                                      # Fastest speed in engineering units
  denominator: 4096                                   # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET
  type: 0                                             # Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives)
  control: ec0.s$(DRV_SLAVE).driveControl01           # Control word ethercat entry
  enable: 0                                           # Enable bit index in control word (not used if DS402)
  enabled: 1                                          # Enabled bit index in status word (not used if DS402)
  status: ec0.s$(DRV_SLAVE).driveStatus01             # Status word ethercat entry
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
  position: ec0.s$(ENC_SLAVE).positionActual01        # Ethercat entry for actual position input (encoder)
  control: ec0.s$(ENC_SLAVE).encoderControl01         # mandatory only if 'reset' is used
  status: ec0.s$(DRV_SLAVE).encoderStatus01           # mandatory only if 'warning' or 'error' are used
  ready: 10                                           # Bit in encoder status word for encoder ready
  source: 0                                           # 0 = Encoder value from etehrcat hardware, 1 = Encoder value from PLC
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
  primary: 1                                          # Use this encoder as primary (for control)
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
    postMoveEnable: yes                               # Enable move after successfull homing
    postMovePosition: 10                              # Position to move to after successfull homing
    trigg: ec0..                                      # Ethercat entry for triggering drive internal homing seq (seq id 26)
    ready: ec0..                                      # Ethercat entry for readinf drive internal homing seq ready (seq id 26)
    latchCount: 1                                     # latch number to ref on (1=ref on first latch)
  delayComp:                                          # Delay compensation for time between application of setpoint to reading of encoder (normally atleast 1 cycle)
    time: 1.5                                         # Delay time between set and act [cycles]
#    enable: true                                     # enable (defaults to 1 if not set)
  lookuptable:
    filename: ./cfg/enc.corr                          # Load correction lockuptable file (default enabled if loaded)
#    enable: 1                                        # Enable correction table
#    mask: '0x3FF'                                    # Encoder raw mask to apply correction (example single turn bits or period bits of EL5021)

controller:
  Kp: 15                                              # Kp proportional gain
  Ki: 0.02                                            # Ki integral gain
  Kd: 0                                               # Kd derivative gain
  Kff: 1                                              # Feed forward gain
  deadband:
    tol: 0.01                                         # Stop control if within this distance from target for the below time
    time: 100
  limits:
    minOutput: -100                                   # Minimum controller output
    maxOutput: 100                                    # Maximum controller output
    minIntegral: -100                                 # Minimum integral output
    maxIntegral: 100                                  # Maximum integral output
  inner:
    Kp: 0.1                                           # Kp for when close to target
    Ki: 0.1                                           # Ki for when close to target
    Kd: 0.1                                           # Kd for when close to target
    tol: 0.1                                          # Distance from target for when inner PID params will be used, defaults to atTarget tol

trajectory:
  type: 1                                             # Default 0 = trapetz, 1 = S-curve (ruckig)
  source: 0                                           # 0 = take trajectory setpoint from axis traj object, 1 = trajectory setpoint from plc
  axis:
    velocity: 10                                      # Default velo for axis
    acceleration: 0.1                                 # Default acc for axis
    deceleration: 0.1                                 # Default dec for axis
    emergencyDeceleration: 0.05                       # Deceleration when axis in error state
    jerk: 10                                          # Default jerk for axis
  jog:
    velocity: 5                                       # Default velo fro JOG (motor record)
  modulo:
    range: 360                                        # Modulo range 0..360
    type: 0                                           # Modulo type

input:
  limit:
    forward: ec0.s$(ENC_SLAVE).ONE.0                  # Ethercat entry for low limit switch input
    forwardPolarity: 0                                # Polarity of forward limit switch
    backward: ec0.s1.BI_2.0                           # Ethercat entry for high limit switch input
    backwardPolarity: 0                               # Polarity of forward limit switch
  home: 'ec0.s$(MCS2_SLAVE_NUM).ONE.0'                # Ethercat entry for home switch
  homePolarity: 0                                     # Polarity of home switch
  interlock: 'ec0.s$(ENC_SLAVE).ONE.0'                # Ethercat entry for interlock switch input
  interlockPolarity: 0                                # Polarity of interlock switch
  analog:
    interlock: 'ec0.s$(ENC_SLAVE).ONE'                # Ethercat entry for analog interlock
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
    time: 10                                          # Allowed time outside tolerance
  target:
    enable: true                                      # Enable at target monitoring (needs to be enabled if using motor record)
    tolerance: 0.5                                    # Allowed tolerance
    time: 10                                          # Filter time inside tolerance to be at target
  velocity:
    enable: false                                     # Enable velocity monitoring
    max: 100                                          # Allowed max velocity
    time:
      trajectory: 100                                 # Time allowed outside max velo before system init halt
      drive: 200                                      # Time allowed outside max velo before system disables drive
  velocityDifference:
    enable: true                                      # Enable velocity diff monitoring (velo set vs velo act)
    max: 100                                          # Allowed max difference
    time:
      trajectory: 100                                 # Time allowed outside max diff velo before system init halt
      drive: 200                                      # Time allowed outside max diff velo before system disables drive
  stall:
    enable: True                                      # Enable stall monitoring. Attarget must be enabled for this functionallity
    time:
      timeout: 10000                                  # If not attarget after "timeout" cycles after trajectory generator is ready then drive will disable
      factor: 5.0                                     # Measures duration of last motion command (busy high edge to busy low edge). The new timeout will be defined as this duration multiplied by this factor. The timeout finaly used for stall detection will be the longest (of time.timeout and calculated from time.factor).

plc:
  enable: true                                        # Enable axis plc
  externalCommands: true                              # Allow axis to inputs from PLC
  file: myplcfile.plc                                 # File with plc code
  code:                                               # Sync code (appended after code in plc.file)
    - if(ax2.traj.source){ax2.drv.enable:=(ax10.drv.enable or ax11.drv.enable)}; # Enable axis if one of master axes is enabled
    - ax2.traj.setpos:=ax10.traj.setpos-ax11.traj.setpos/2; # calculate set pos for physical axis
  velocity_filter:                                    # Filter used to smother velocity feedforward
    encoder:                                          # Filter plc enc velo
      enable: false                                   # Filter enable
      size: 100                                       # Filter size
    trajectory:                                       # Filter plc traj velo
      enable: false                                   # Filter enable
      size: 100                                       # Filter size
#  filter:                                            # Use "velocity_filter" instead since this naming is missleading and should be phased out
#    velocity:                                        # Filter plc enc velo
#      enable: false
#      size: 100
#    trajectory:                                      # Filter plc traj velo
#      enable: false
#      size: 100

```

