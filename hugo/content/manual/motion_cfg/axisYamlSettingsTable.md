+++
title = "Axis YAML settings table"
slug = "axisyaml-table"
weight = 16
chapter = false
+++

Reference companion to [yaml configuration](../axisyaml/).
Use this page when you need the exact YAML key name quickly.

Use the table view when:

- you already know roughly which section you need
- you want to confirm whether a key exists
- you want a fast mandatory/optional check

Use the heading view when:

- you want grouped navigation by section
- you want to browse related settings together

See also: [Axis YAML settings (heading view)](../axisyaml-headings/).

Notes:

- `Optional = No` means the schema treats the key as required in the relevant
  context.
- Some keys are only required for physical axes or only required when a related
  feature is enabled.
- For explanations and examples, use
  [yaml configuration](../axisyaml/) rather than this page.

| Key | Description | Optional |
| --- | --- | --- |
| axis.id | Axis id | No |
| axis.type | Axis type | No |
| axis.mode | Supported mode, CSV and CSP, defaults CSV | Yes |
| axis.parameters | Additional params to motor record driver | No |
| axis.healthOutput | EtherCAT entry for health output | No |
| axis.feedSwitchesOutput | EtherCAT entry for fed switches | No |
| axis.feedSwitchesValue | Value to write to axis.feedSwitchesOutput. Defaults to 1 | No |
| axis.group | Add axis to group (group will be created if it does not exist) | No |
| axis.autoMode.modeSet | EtherCAT entry drive mode write (set CSV,CSP,homing) | No |
| axis.autoMode.modeAct | EtherCAT entry drive mode reading (set CSV,CSP,homing) | No |
| axis.autoMode.modeCmdMotion | Drive mode value for normal motion (written to axis.drvMode.modeSet when normal motion) | No |
| axis.autoMode.modeCmdHome | Drive mode value for when homing (written to axis.drvMode.modeSet when homing) | No |
| axis.features.blockCom | Block communication to axis | Yes |
| axis.features.allowSrcChangeWhenEnabled | Allow traj/enc source change when axis is enabled | No |
| axis.features.allowedFunctions.homing | Allow homing | No |
| axis.features.allowedFunctions.constantVelocity | Allow constant velocity | No |
| axis.features.allowedFunctions.positioning | Allow positioning | No |
| axis.autoEnable.enableTimeout | If defined, ecmc tries to auto-enable for a maximum enableTimeout seconds. | No |
| axis.autoEnable.disableTimeout | If defined, ecmc disables axis after idle (non busy) in disableTime seconds | No |
| axis.autoEnable.autoDisableLatchAtTarget | Keep the auto-disable timer active after AtTarget has been asserted once | No |
| axis.autoEnable.atStartup | Auto enable axis at ioc start, default False | No |
| axis.tweakDist | Tweak value (both ecmc interface and motor record tweak value) | No |
| epics.name | Axis name | No |
| epics.precision | Decimal count | No |
| epics.description | Axis description | No |
| epics.unit | Unit | No |
| epics.motorRecord.enable | Enable motor record | No |
| epics.motorRecord.description | This is MR | No |
| epics.motorRecord.fieldInit | Extra config for motor record | No |
| epics.motorRecord.syncSoftLimits | Sync softlimits between motor and ecmc (default false). When false, motor record HLM/LLM and ecmc soft limits may differ. On false->true, ecmc soft limits are copied to the motor record; while true, later motor record soft-limit changes are written back to ecmc. | No |
| epics.motorRecord.pvt.npoints | Max number of target points for PVT/profile move | No |
| epics.motorRecord.pvt.nreadback | Max number of readback points for PVT/profile move | No |
| drive.numerator | Fastest speed in engineering units | No |
| drive.denominator | I/O range for ECMC_EC_ALIAS_DRV_VELO_SET | No |
| drive.type | Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives) | No |
| drive.control | Control word EtherCAT entry | No |
| drive.enable | Enable bit index in control word (not used if DS402) | No |
| drive.enabled | Enabled bit index in status word (not used if DS402) | No |
| drive.status | Status word EtherCAT entry | No |
| drive.setpoint | Velocity setpoint if CSV. Position setpoint if CSP. `F32`/`F64` CSV setpoints are supported; `F32`/`F64` CSP setpoints require the selected CSP encoder actual-position entry to use the same datatype. | No |
| drive.reduceTorque | Reduce torque bit in drive control word | No |
| drive.reduceTorqueEnable | Enable reduce torque functionality | No |
| drive.brake.enable |  | No |
| drive.brake.output | EtherCAT link to brake output | No |
| drive.brake.openDelay | Brake timing parameter in cycles (default 1kHz) | No |
| drive.brake.closeAhead | Brake timing parameter in cycles (default 1kHz) | No |
| drive.reset | Reset (if no drive reset bit then leave empty) | No |
| drive.warning | Warning (if no drive warning bit then leave empty) | No |
| drive.error[0] | Error 0 (if no drive error bit then leave empty) | No |
| drive.error[1] | Error 1 (if no drive error bit then leave empty) | No |
| drive.error[2] | Error 2 (if no drive error bit then leave empty) | No |
| encoder.numerator | Scaling numerator example 360 deg/rev | No |
| encoder.denominator | Scaling denominator example 4096 ticks per 360 degree | No |
| encoder.type | Type: 0=Incremental, 1=Absolute | No |
| encoder.bits | Bit count used for ecmc's encoder value; does not alter the raw EtherCAT slave value | No |
| encoder.absBits | Absolute bit count (for absolute encoders) always least significant part of 'bits' | No |
| encoder.absOffset | Encoder offset in eng units (for absolute encoders) | No |
| encoder.mask | Mask applied to ecmc's encoder value; the original EtherCAT value remains visible in the hardware PVs | No |
| encoder.position | EtherCAT entry for actual position input (encoder). `F32`/`F64` actual-position entries are only valid for absolute encoders (`encoder.type: 1`). Keep `encoder.bits` and `encoder.absBits` aligned with the datatype width (`32`/`32` or `64`/`64`). | No |
| encoder.control | Mandatory only if 'reset' is used | No |
| encoder.status | Mandatory only if 'warning' or 'error' are used | No |
| encoder.ready | Bit in encoder status word for encoder ready | Yes |
| encoder.source | 0 = Encoder value from EtherCAT hardware, 1 = Encoder value from PLC | No |
| encoder.reset | Reset | Yes |
| encoder.warning | Warning  | Yes |
| encoder.error[0] | Error 0 | Yes |
| encoder.error[1] | Error 1 | Yes |
| encoder.error[2] | Error 2 | Yes |
| encoder.filter.velocity.size | Filter size for velocity | Yes |
| encoder.filter.velocity.enable | enable velocity filter | Yes |
| encoder.filter.position.size | Filter size for encoder value | Yes |
| encoder.filter.position.enable | enable encoder value filter | Yes |
| encoder.latch.position | Link to latched value. Used for some homing seqs | Yes |
| encoder.latch.timestamp | Optional 32/64-bit DC timestamp for the same latch event | Yes |
| encoder.latch.control | Bit in encoder control word to arm latch. Used for some homing seqs | Yes |
| encoder.latch.status | Bit in encoder status word for latch triggered status. Used for some homing seqs | Yes |
| encoder.latch.armCmd | Value in dec to arm latch to write to encoder.control | Yes |
| encoder.latch.armBits | Bit size of encoder.latch.armCmd | Yes |
| encoder.touchProbe.position | Link to touch-probe latched position. Used for touch-probe functionality separate from homing latch. | Yes |
| encoder.touchProbe.timestamp | Optional 32/64-bit DC timestamp for the same touch-probe edge | Yes |
| encoder.touchProbe.control | Touch-probe control word entry | Yes |
| encoder.touchProbe.controlBit | First bit in touch-probe control word to write `armBits` bits from `armCmd`; default 0 | Yes |
| encoder.touchProbe.status | Touch-probe status word entry | Yes |
| encoder.touchProbe.statusBit | Status bit for captured touch-probe event; default 0 | Yes |
| encoder.touchProbe.armCmd | Value in dec to arm touch probe; default 17 for EL7062/ED7062 TP1 positive edge | Yes |
| encoder.touchProbe.armBits | Bit size of encoder.touchProbe.armCmd; default 5 | Yes |
| encoder.primary | Use this encoder as primary (for control) | Yes |
| encoder.useAsCSPDrvEnc | Use this encoder as CSP drive encoder (ecmc controller enabled in CSP) | Yes |
| encoder.allowOverUnderFlow | Allow over/under flow of encoder raw counter (default true). Set to false for linear encoders. | Yes |
| encoder.homing.type | Homing sequence type | No |
| encoder.homing.position | Position to reference encoder to | No |
| encoder.homing.velocity.to | Velocity to cam/sensor (used for some homing seqs) | No |
| encoder.homing.velocity.from | Velocity from cam/sensor (used for some homing seqs) | No |
| encoder.homing.acceleration | Acceleration during homing | No |
| encoder.homing.deceleration | Deceleration during homing | No |
| encoder.homing.refToEncIDAtStartup | At startup then set the start value of this encoder to actpos of this encoder id | No |
| encoder.homing.refAtHome | If homing is executed then set position of this encoder | No |
| encoder.homing.tolToPrim | If set then this is the max allowed tolerance between prim encoder and this encoder | No |
| encoder.homing.postMoveEnable | Enable move after successful homing | No |
| encoder.homing.postMovePosition | Position to move to after successful homing | No |
| encoder.homing.trigg | EtherCAT entry for triggering drive internal homing seq (seq id 26) | No |
| encoder.homing.ready | EtherCAT entry for reading drive internal homing seq ready (seq id 26) | No |
| encoder.homing.latchCount | latch number to reference on (1=ref on first latch) | No |
| encoder.delayComp.time | Delay time between set and act [cycles] | No |
| encoder.delayComp.enable | enable (defaults to 1 if not set) | Yes |
| encoder.lookuptable.filename | Load correction lookup table file. Value will be subtracted from encoder value. | Yes |
| encoder.lookuptable.enable | Enable correction table (default enabled if loaded). | Yes |
| encoder.lookuptable.scale | Scale applied to LUT (if you want value to be added then set scale to -1.0) | Yes |
| encoder.lookuptable.range | LUT modulo value (LUT should cover the range 0..range) | Yes |
| controller.Kp | Kp proportional gain | Yes |
| controller.Ki | Ki integral gain | Yes |
| controller.Kd | Kd derivative gain | Yes |
| controller.Kff | Feed forward gain | Yes |
| controller.resetIAtRmp | Reset the integral part to zero while an internal trajectory is busy. Reset takes precedence over freeze. | Yes |
| controller.freezeIAtRmp | Keep the current integral part unchanged while an internal trajectory is busy. | Yes |
| controller.deadband.tol | Stop control if within this distance from target for the below time | Yes |
| controller.deadband.time | Deadband time filter | Yes |
| controller.limits.minOutput | Minimum controller output. Output limiting is active only when `maxOutput > minOutput`; `minOutput=0` and `maxOutput=0` disables it. | Yes |
| controller.limits.maxOutput | Maximum controller output. Output limiting is active only when `maxOutput > minOutput`; `minOutput=0` and `maxOutput=0` disables it. | Yes |
| controller.limits.minIntegral | Minimum integral output. Integral limiting is active only when `maxIntegral > minIntegral`; `minIntegral=0` and `maxIntegral=0` disables it. | Yes |
| controller.limits.maxIntegral | Maximum integral output. Integral limiting is active only when `maxIntegral > minIntegral`; `minIntegral=0` and `maxIntegral=0` disables it. | Yes |
| controller.inner.Kp | Kp for when close to target | Yes |
| controller.inner.Ki | Ki for when close to target | Yes |
| controller.inner.Kd | Kd for when close to target | Yes |
| controller.inner.tol | Distance from target for when inner PID params will be used, defaults to atTarget tol | Yes |
| trajectory.type | Default 0 = trapezoidal, 1 = S-curve (ruckig) | No |
| trajectory.source | 0 = take trajectory setpoint from axis traj object, 1 = trajectory setpoint from plc | No |
| trajectory.axis.velocity | Default velocity for axis | No |
| trajectory.axis.acceleration | Default acceleration for axis | No |
| trajectory.axis.deceleration | Default deceleration for axis | No |
| trajectory.axis.emergencyDeceleration | Deceleration when axis in error state | No |
| trajectory.axis.jerk | Default jerk for axis | No |
| trajectory.jog.velocity | Default velocity for JOG (motor record) | No |
| trajectory.modulo.range | Modulo range 0..360 | No |
| trajectory.modulo.type | Modulo type | No |
| positionCompare.output | EtherCAT output entry to schedule, for example an EL2252 binary output | Yes |
| positionCompare.activate | EtherCAT activation/control entry used by the timed-output terminal | Yes |
| positionCompare.startTime | EtherCAT DC start-time entry; use a 64-bit integer entry/PV for EL2252 | Yes |
| positionCompare.minLeadMs | Minimum scheduling lead time [ms], default 2.0 | Yes |
| positionCompare.maxLeadMs | Maximum scheduling lead time [ms], default 100.0 | Yes |
| positionCompare.activateIdle | Activation value written while idle, default 3 for EL2252 | Yes |
| positionCompare.activateSchedule | Activation value written for one cycle to load a schedule, default 0 for EL2252 | Yes |
| positionCompare.pulseWidthMs | Optional automatic reset pulse width [ms], default 0. Fractions such as 0.5 are allowed. | Yes |
| positionCompare.resetValue | Output value for automatic reset after pulseWidthMs, default 0 | Yes |
| input.limit.forward | EtherCAT entry for low limit switch input | No |
| input.limit.forwardPolarity | Polarity of forward limit switch | No |
| input.limit.backward | EtherCAT entry for high limit switch input | No |
| input.limit.backwardPolarity | Polarity of backward limit switch | No |
| input.home | EtherCAT entry for home switch | No |
| input.homePolarity | Polarity of home switch | No |
| input.interlock | EtherCAT entry for interlock switch input | No |
| input.interlockPolarity | Polarity of interlock switch | No |
| input.analog.interlock | EtherCAT entry for analog interlock | No |
| input.analog.interlockPolarity | 0: High value is bad, 1 = Low value is bad | No |
| input.analog.rawLimit | Analog raw limit | No |
| input.analog.enable | Enable analog interlock default true if analog.interlock is set | No |
| softlimits.enable | Enable soft limits | No |
| softlimits.forward | Soft limit position fwd | No |
| softlimits.forwardEnable | Soft limit position fwd enable | No |
| softlimits.backward | Soft limit position bwd | No |
| softlimits.backwardEnable | Soft limit position bwd enable | No |
| monitoring.lag.enable | Enable position lag monitoring (following error) | No |
| monitoring.lag.tolerance | Allowed tolerance | No |
| monitoring.lag.time | Allowed time outside tolerance | No |
| monitoring.target.enable | Enable at target monitoring (needs to be enabled and configured if using motor record) | No |
| monitoring.target.tolerance | Allowed tolerance | No |
| monitoring.target.time | Filter time inside tolerance to be at target | No |
| monitoring.target.slaveControlDeadband.tolerance | Master-axis tolerance forwarded to slaves for reduced-torque control; defaults to AtTarget tolerance | No |
| monitoring.target.slaveControlDeadband.time | Filter time inside slave-control deadband; defaults to AtTarget time | No |
| monitoring.velocity.enable | Enable velocity monitoring | No |
| monitoring.velocity.max | Allowed max velocity | No |
| monitoring.velocity.time.trajectory | Time allowed outside max velocity before system init halt | No |
| monitoring.velocity.time.drive | Time allowed outside max velocity before system disables drive | No |
| monitoring.velocityDifference.enable | Enable velocity difference monitoring (velocity set vs velocity actual) | No |
| monitoring.velocityDifference.max | Allowed max difference | No |
| monitoring.velocityDifference.time.trajectory | Time allowed outside max diff velo before system init halt | No |
| monitoring.velocityDifference.time.drive | Time allowed outside max diff velo before system disables drive | No |
| monitoring.stall.enable | Enable stall monitoring. At target must be enabled for this functionality | No |
| monitoring.stall.time.timeout | If not at target after "timeout" cycles after trajectory generator is ready then drive will disable | No |
| monitoring.stall.time.factor | Measures duration of last motion command (busy high edge to busy low edge). The new timeout will be defined as this duration multiplied by this factor. The timeout finally used for stall detection will be the longest (of time.timeout and calculated from time.factor). | No |
| plc.enable | Enable axis plc | No |
| plc.externalCommands | Allow axis input from PLC | No |
| plc.file | File with plc code | No |
| plc.code[0] | Enable axis if one of master axes is enabled | No |
| plc.code[1] | Calculate set position for physical axis | No |
| plc.velocity_filter.encoder.enable | Filter enable | No |
| plc.velocity_filter.encoder.size | Filter size | No |
| plc.velocity_filter.trajectory.enable | Filter enable | No |
| plc.velocity_filter.trajectory.size | Filter size | No |
| plc.filter.velocity.enable | Filter enable | Yes |
| plc.filter.velocity.size | Filter size | Yes |
| plc.filter.trajectory.enable | Filter enable | Yes |
| plc.filter.trajectory.size | Filter size | Yes |
