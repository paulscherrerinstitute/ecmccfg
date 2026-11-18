+++
title = "Complete axis YAML example"
slug = "axisyaml-example"
weight = 18
chapter = false
+++

This annotated example collects the available settings in one place. Adapt the
hardware entries, macros, values, and enabled features to your configuration.
Use the [axis YAML configuration guide]({{< relref "/manual/motion_cfg/axisYaml.md" >}})
for explanations and the [settings table]({{< relref "/manual/motion_cfg/axisYamlSettingsTable.md" >}})
for key lookup. This example includes optional and alternative settings; it is
not a minimal configuration to run unchanged.

The example uses the Python loader's boolean syntax for `monitoring.stall.enable`.
With ECB, change that value to integer `1` (or `0` to disable): the current ECB
schema uses an integer for this field while the Python schema uses a boolean.

## All yaml settings
```
axis:
  id: 1                                               # Axis id
  type: joint                                         # physical axis (1); virtual/end_effector is 2
  mode: CSV                                           # CSV, CSP or CSP_PC; default CSV
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
    disableOnReset: false                             # Disable the axis when an error is reset
    alarmAtHardLimits: false                          # Raise an axis error when a hard limit activates
    allowedFunctions:
      homing: true                                    # Allow homing
      constantVelocity: true                          # Allow constant velocity
      positioning: true                               # Allow positioning
  autoEnable:                                         # ecmc auto enable of axis (Please use this instead of motor record version..)
    enableTimeout: 5.0                                # If defined, ecmc tries to auto-enable for a maximum enableTimeout seconds.
    disableTimeout:   5.0                             # If defined, ecmc disables axis after idle (non busy) in disableTime seconds
    autoDisableLatchAtTarget: false                   # Continue auto-disable timing after AtTarget has been reached once
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
    restoreSoftLimits: false                          # Startup-only: autosave motor DLLM/DHLM overrides ecmc limits and enables sync
    pvt:
      npoints: 1000                                   # Maximum PVT target points
      nreadback: 1000                                 # Maximum PVT readback points

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
    openDelay: 0                                      # Brake timing in EtherCAT cycles; default 0
    closeAhead: 0                                     # Brake timing in EtherCAT cycles; default 0
  reset: 1                                            # Reset bit; omit key if unused
  warning: 2                                          # Warning bit; omit key if unused
  error:                                              # max 3
    - 3                                               # Error bit 0; omit unused list items
    - 7                                               # Error bit 1
    - 14                                              # Error bit 2

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
      size: 100                                       # Velocity filter window in EtherCAT samples
      enable: true                                    # Enable encoder velocity filter
    position:
      size: 100                                       # Position filter window in EtherCAT samples (default 10)
      enable: true                                    # Enable encoder position filter
  latch:
    position: ''                                      # Link to latched value. Used for some homing seqs
    timestamp: ''                                     # Optional 32/64-bit DC timestamp for the same latch event
    control: 0                                        # Bit in encoder control word to arm latch. Used for some homing seqs
    status: 0                                         # Bit in encoder status word for latch triggered status. Used for some homing seqs
    armCmd: 1                                         # Value written to encoder.control; default 1
    armBits: 1                                        # Bit length of armCmd; default 1
  touchProbe:                                         # Optional touch-probe mapping, separate from homing latch
    position: ec0.s$(ENC_SLAVE).touchProbePositionPos01_1 # Latched touch-probe position
    timestamp: ec0.s$(ENC_SLAVE).touchProbeTimestampPos01_1 # Optional 32/64-bit DC timestamp for same edge
    control: ec0.s$(ENC_SLAVE).touchProbeControl01    # Touch-probe control word
    controlBit: 0                                     # First control bit to write
    status: ec0.s$(ENC_SLAVE).touchProbeStatus01      # Touch-probe status word
    statusBit: 0                                      # Captured-event status bit
    armCmd: 17                                        # EL7062/ED7062 TP1 positive-edge arm command
    armBits: 5                                        # Number of bits written from armCmd
  primary: True                                       # Use this encoder as primary (for control)
  useAsCSPDrvEnc: True                                # Use this encoder as CSP drive encoder (ecmc controller enabled in CSP)
  unit: mm                                            # Optional encoder engineering unit
  desc: Main encoder                                  # Optional encoder description
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
#    enable: true                                     # Enable correction table (default enabled if loaded).
#    scale: 1                                         # Scale applied to LUT (if you want value to be added then set scale to -1.0)
#    range: 360                                       # LUT modulo value (Lut should cover the range 0..range)
  power:                                              # Optional relay-controlled absolute encoder power
    enable: false
    output: ec0.s$(PWR_SLAVE).binaryOutput01
    activeHigh: true
    idleDelay: 5.0                                    # Seconds idle before power is removed
    startupDelay: 0.5                                 # Seconds after power-on before checking ready
    startupTimeout: 5.0                               # Seconds allowed for encoder ready
    backup:
      encoder: 1                                      # Encoder index used while the absolute encoder is off
      maxPositionDifference: 0.1                     # Maximum accepted wake-up position difference

controller:
  Kp: 1                                               # Kp proportional gain
#  Ki: 0.001                                           # Ki integral gain
#  Kd: 0                                               # Kd derivative gain
#  Kff: 1                                              # Feed forward gain
#  resetIAtRmp: false                                  # Reset I-part while an internal trajectory is busy
#  freezeIAtRmp: false                                 # Freeze I-part while an internal trajectory is busy
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
#    tol: 0.1                                          # Distance band for inner PID; schema default 0

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
    acceleration: 1                                   # Optional JOG acceleration
  modulo:
    range: 360                                        # Modulo range 0..360
    type: 0                                           # Modulo type

positionCompare:                                      # Optional timed output at a position crossing
  output: ec0.s$(OUT_SLAVE).binaryOutput01            # Output value entry, for example EL2252 BO1
  activate: ec0.s$(OUT_SLAVE).activate                # Timed-output activation/control entry
  startTime: ec0.s$(OUT_SLAVE).startTime              # 64-bit DC start-time entry
  minLeadMs: 2.0                                      # Minimum scheduling lead time [ms]
  maxLeadMs: 100.0                                    # Maximum scheduling lead time [ms]
  activateIdle: 3                                     # EL2252 idle/no-new-schedule value
  activateSchedule: 0                                 # EL2252 schedule/load value, written for one cycle
  pulseWidthMs: 10.0                                  # Optional auto-reset pulse width [ms], 0 disables
  resetValue: 0                                       # Output value for auto reset

#  Limits can be overridden with plc-code by setting input.limit.forward or input.limit.backward to 'plcOverride', then 'ax<id>.mon.lowlim' and/or 'ax<id>.mon.highlim' needs to be written to in plc code (1 means limit OK).

input:
  limit:
    forward: ec0.s$(ENC_SLAVE).ONE.0                  # EtherCAT entry for low limit switch input,
    forwardPolarity: 0                                # Polarity of forward limit switch
    backward: ec0.s1.BI_2.0                           # EtherCAT entry for high limit switch input
    backwardPolarity: 0                               # Polarity of backward limit switch
    latchInput: false                                 # Latch limit input activation when supported
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
    slaveControlDeadband:                             # Optional independent master-axis band forwarded to slaves
      tolerance: 0.01                                 # Master error tolerance for slave control decisions
      time: 100                                       # Qualification time inside tolerance [cycles]
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
  macros: 'MY_MACRO=1'                                # Optional macros passed while loading plc.file
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
