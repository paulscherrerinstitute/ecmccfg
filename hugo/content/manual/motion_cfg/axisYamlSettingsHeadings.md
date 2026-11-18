+++
title = "Axis YAML settings (heading view)"
slug = "axisyaml-headings"
weight = 17
chapter = false
+++

Reference companion to [yaml configuration](../axisyaml/).
Use this page when you want to browse YAML settings by section instead of by
full key name.

Use the heading view when:

- you are building a new axis YAML file section by section
- you want to see related settings together
- you know you are working in `encoder`, `trajectory`, `monitoring`, or `plc`
  but do not remember the exact key names

Use the table view when:

- you want the exact full key path
- you want the fastest mandatory/optional lookup

See also: [Axis YAML settings table](../axisyaml-table/).

For examples and configuration guidance, use [yaml configuration](../axisyaml/).

Defaults apply when the parent block exists, unless stated otherwise. Optional
blocks can contain required children. If no default is listed, this reference
does not imply zero or disabled; an omitted setting may leave ecmc's value
unchanged. Both reference views are generated from the same audited source.

<!-- BEGIN GENERATED AXIS YAML REFERENCE -->

## axis

- `axis.id` (optional; explicit id recommended) — Axis id. If omitted, the template uses the next id derived from ECMC_AXIS_NO; set it explicitly for stable references. Defaults: `axis.id`: next id from ECMC_AXIS_NO.
- `axis.type` (optional) — Axis type; defaults to physical/joint (1). Virtual/end_effector is 2. Defaults: `axis.type`: joint.
- `axis.mode` (optional) — Drive mode: CSV, CSP or CSP_PC; defaults to CSV. Defaults: `axis.mode`: CSV.
- `axis.parameters` (optional) — Additional motor driver options (e.g. powerAutoOnOff, powerOffDelay, powerOnDelay). `restoreMotorSoftLims=1;` enables startup restoration of motor dial limits and ongoing synchronization; see [autosave]({{< relref "/manual/motion_cfg/autosave.md" >}}).
- `axis.healthOutput` (optional) — EtherCAT entry for health output.
- `axis.feedSwitchesOutput` (optional) — EtherCAT entry for fed switches.
- `axis.feedSwitchesValue` (optional) — Value written to `axis.feedSwitchesOutput`; defaults to 1. Defaults: `axis.feedSwitchesValue`: 1.
- `axis.group` (optional) — Group name; creates/uses a group and stores its id in `GRP_<axis.group>_ID`. See [Axis Groups]({{< relref "/manual/motion_cfg/axis_groups.md" >}}).
- `axis.autoMode` (optional) — Auto-switch drive modes for motion/homing.
- `axis.autoMode.modeSet` (optional) — EtherCAT entry to write drive mode (CSV/CSP/homing).
- `axis.autoMode.modeAct` (optional) — EtherCAT entry reading drive mode.
- `axis.autoMode.modeCmdMotion` (optional) — Drive mode value used during normal motion.
- `axis.autoMode.modeCmdHome` (optional) — Drive mode value used during homing.
- `axis.features` (optional) — Feature switches.
- `axis.features.blockCom` (optional) — Block communication to axis.
- `axis.features.allowSrcChangeWhenEnabled` (optional) — Allow trajectory/encoder source change while enabled.
- `axis.features.allowedFunctions.homing` (optional) — Allow homing.
- `axis.features.allowedFunctions.constantVelocity` (optional) — Allow constant velocity mode.
- `axis.features.allowedFunctions.positioning` (optional) — Allow positioning.
- `axis.autoEnable` (optional) — Native ecmc auto enable/disable. Preferred over motor record auto-enable.
- `axis.autoEnable.enableTimeout` (optional) — Try auto-enable for at most this many seconds. Defaults: `axis.autoEnable.enableTimeout`: -1.0.
- `axis.autoEnable.disableTimeout` (optional) — Disable after being idle this many seconds. Defaults: `axis.autoEnable.disableTimeout`: -1.0.
- `axis.autoEnable.autoDisableLatchAtTarget` (optional) — After the first AtTarget assertion, allow the auto-disable timer to continue if AtTarget is later lost (default false). Defaults: `axis.autoEnable.autoDisableLatchAtTarget`: false.
- `axis.autoEnable.atStartup` (optional) — Auto-enable at IOC start (default false). Defaults: `axis.autoEnable.atStartup`: false.
- `axis.tweakDist` (optional) — Tweak value for both ecmc and motor record. Defaults: `axis.tweakDist`: 1.0.
- `axis.features.disableOnReset` (optional) — Disable the axis on error reset.
- `axis.features.alarmAtHardLimits` (optional) — Raise an axis error on hard-limit activation; recovery requires disabling this feature.

## epics

- `epics.name` (optional; unique name recommended) — PV name suffix; defaults to axis. Set a unique name for each axis. Defaults: `epics.name`: axis.
- `epics.precision` (optional) — PREC; default 3. Defaults: `epics.precision`: 3.
- `epics.description` (optional) — Axis description.
- `epics.unit` (optional) — EGU; default mm. Defaults: `epics.unit`: mm.
- `epics.motorRecord` (optional) — Motor record block.
- `epics.motorRecord.enable` (optional) — Enable motor record. Defaults: `epics.motorRecord.enable`: true.
- `epics.motorRecord.description` (optional) — Motor record description.
- `epics.motorRecord.fieldInit` (optional) — Additional motor record fields.
- `epics.motorRecord.syncSoftLimits` (optional) — Sync soft limits between motor record and ecmc (default false; `restoreMotorSoftLims=1` overrides this to enabled). When synchronization is disabled, motor record `HLM`/`LLM` and ecmc soft limits may differ. On false-to-true, ecmc soft limits are copied to the motor record; while true, later motor record soft-limit changes are written back to ecmc. Defaults: `epics.motorRecord.syncSoftLimits`: false.
- `epics.motorRecord.restoreSoftLimits` (optional; startup policy) — Allow initialized or autosave-restored motor dial limits to override the YAML-derived ecmc limits during startup. This also enables ongoing motor/ecmc soft-limit synchronization; use with the documented startup gate and autosave request files. Defaults: `epics.motorRecord.restoreSoftLimits`: false.
- `epics.motorRecord.pvt` (optional) — PVT/profile-move support.
- `epics.motorRecord.pvt.npoints` (optional) — Max number of target points. Defaults: `epics.motorRecord.pvt.npoints`: 0.
- `epics.motorRecord.pvt.nreadback` (optional) — Max number of readback points. Defaults: `epics.motorRecord.pvt.nreadback`: 0.

## drive

- `drive.numerator` (optional; configure scaling explicitly) — Drive scale numerator; CSV uses velocity scaling, CSP uses position scaling. The schema default 0 is not a usable hardware scale. Defaults: `drive.numerator`: 0.
- `drive.denominator` (optional) — Drive scale denominator; configure it together with numerator for the selected drive mode. Defaults: `drive.denominator`: 1.
- `drive.type` (optional) — 0=stepper, 1=DS402 (servo/advanced stepper). Defaults: `drive.type`: 0.
- `drive.control` (required) — Control word EtherCAT entry.
- `drive.enable` (optional; non-DS402 only) — Enable bit index; non-DS402 defaults to bit 0 with a warning. Ignored for DS402. Defaults: `drive.enable`: 0.
- `drive.enabled` (optional; non-DS402 only) — Enabled status bit index; non-DS402 defaults to bit 1 with a warning. Ignored for DS402. Defaults: `drive.enabled`: 1.
- `drive.status` (required) — Status word EtherCAT entry.
- `drive.setpoint` (required) — Velocity setpoint if CSV; position setpoint if CSP. `F32`/`F64` CSV setpoints are supported. `F32`/`F64` CSP setpoints require the selected CSP encoder actual-position entry to use the same datatype.
- `drive.reduceTorque` (optional) — Reduce-torque control bit; requires reduceTorqueEnable and control.
- `drive.reduceTorqueEnable` (optional) — Enable reduce-torque handling; requires reduceTorque and control.
- `drive.brake` (optional) — Brake control block.
- `drive.brake.enable` (required when drive.brake is present) — Enable brake control.
- `drive.brake.output` (required when drive.brake is present) — EtherCAT link to brake output.
- `drive.brake.openDelay` (optional) — Brake open delay in cycles. Defaults: `drive.brake.openDelay`: 0.
- `drive.brake.closeAhead` (optional) — Brake close-ahead time in cycles. Defaults: `drive.brake.closeAhead`: 0.
- `drive.reset` (optional) — Reset bit.
- `drive.warning` (optional) — Warning bit.
- `drive.error` (optional, up to 3 entries) — Up to three error bit indices or full EtherCAT paths. Omit unused entries; do not use empty/null list items. The schema requires status when error is supplied.
- `drive.lookuptable` (optional; CSV only) — Position-dependent CSV output compensation; see the drive output lookup-table guide.
- `drive.lookuptable.filename` (required when drive.lookuptable is present) — Two-column LUT file: actual position and drive-command offset, both in engineering units.
- `drive.lookuptable.enable` (optional) — Enable compensation; a valid loaded table is enabled by default. Defaults: `drive.lookuptable.enable`: true after a valid table is loaded (ecmc).
- `drive.lookuptable.scale` (optional) — Multiplier applied to the engineering-unit LUT output before normal drive scaling. Defaults: `drive.lookuptable.scale`: 1.0.
- `drive.lookuptable.range` (optional) — Positive modulo range applied to actual position before lookup; zero disables wrapping. Defaults: `drive.lookuptable.range`: 0.

## encoder

- `encoder.numerator` (optional; configure scaling explicitly) — Encoder scale numerator in engineering units. The schema default 0 is not a usable hardware scale. Defaults: `encoder.numerator`: 0.0.
- `encoder.denominator` (optional) — Scaling denominator (e.g. ticks per rev). Defaults: `encoder.denominator`: 1.
- `encoder.type` (optional) — 0=incremental, 1=absolute. Defaults: `encoder.type`: 0.
- `encoder.bits` (optional) — Bit count used for ecmc's encoder value; it does not alter the raw EtherCAT slave value. Defaults: `encoder.bits`: 16.
- `encoder.absBits` (optional) — Absolute bit count (LSBs of `bits`). Defaults: `encoder.absBits`: 25.
- `encoder.absOffset` (optional) — Offset in engineering units for absolute encoders. Defaults: `encoder.absOffset`: 0.0.
- `encoder.mask` (optional) — Mask applied to ecmc's encoder value, not the raw EtherCAT slave value. The original value remains visible in the EtherCAT hardware PVs.
- `encoder.position` (required for EtherCAT position feedback (source 0)) — EtherCAT entry for actual position. `F32`/`F64` actual-position entries are only valid for absolute encoders (`type: 1`). Keep `bits` and `absBits` aligned with the datatype width (`32`/`32` or `64`/`64`).
- `encoder.control` (optional; required if reset is used) — Encoder control word entry.
- `encoder.status` (required with ready, warning or error) — Encoder status word entry; required with ready, warning or error.
- `encoder.ready` (optional) — Status bit for encoder ready.
- `encoder.source` (optional) — 0=from EtherCAT hardware, 1=from PLC. Defaults: `encoder.source`: 0.
- `encoder.reset` (optional) — Reset bit.
- `encoder.warning` (optional) — Warning bit.
- `encoder.error` (optional, up to 3 entries) — Up to three error bit indices or full EtherCAT paths. Omit unused entries; do not use empty/null list items. The schema requires status when error is supplied.
- `encoder.filter` (optional) — Encoder filtering uses nested velocity and position blocks, each with size and enable. See the encoder-filter example in the YAML configuration guide.
- `encoder.filter.velocity.size` (optional) — Velocity filter window in EtherCAT samples/cycles; applies when encoder.filter.velocity is supplied. Defaults: `encoder.filter.velocity.size`: 100.
- `encoder.filter.velocity.enable` (optional) — Enable the encoder velocity filter; defaults to true when encoder.filter.velocity is supplied. Defaults: `encoder.filter.velocity.enable`: true.
- `encoder.filter.position.size` (optional) — Position filter window in EtherCAT samples/cycles; applies when encoder.filter.position is supplied. Defaults: `encoder.filter.position.size`: 10.
- `encoder.filter.position.enable` (optional) — Enable the encoder position filter; defaults to true when encoder.filter.position is supplied. Defaults: `encoder.filter.position.enable`: true.
- `encoder.latch` (optional) — Homing latch settings. For EL7062/ED7062 touch-probe use outside homing, prefer the separate `touchProbe` section.
- `encoder.latch.position` (required when encoder.latch is present) — Latched value link.
- `encoder.latch.timestamp` (optional) — Optional DC timestamp for the same latch event.
- `encoder.latch.control` (optional) — Control bit to arm latch. Defaults: `encoder.latch.control`: 0.
- `encoder.latch.status` (optional) — Status bit for latch triggered. Defaults: `encoder.latch.status`: 0.
- `encoder.latch.armCmd` (optional) — Value written to `encoder.control` to arm latch. Defaults: `encoder.latch.armCmd`: 1.
- `encoder.latch.armBits` (optional) — Bit length of `armCmd`. Defaults: `encoder.latch.armBits`: 1.
- `encoder.touchProbe` (optional) — Encoder touch-probe mapping separate from homing latch.
- `encoder.touchProbe.position` (required when encoder.touchProbe is present) — Latched touch-probe position entry.
- `encoder.touchProbe.timestamp` (optional) — Optional 32- or 64-bit DC timestamp entry for the same edge.
- `encoder.touchProbe.control` (required when encoder.touchProbe is present) — Touch-probe control word entry.
- `encoder.touchProbe.controlBit` (optional) — First bit to write in the control word (default `0`). Defaults: `encoder.touchProbe.controlBit`: 0.
- `encoder.touchProbe.status` (required when encoder.touchProbe is present) — Touch-probe status word entry.
- `encoder.touchProbe.statusBit` (optional) — Status bit that indicates a captured event (default `0`). Defaults: `encoder.touchProbe.statusBit`: 0.
- `encoder.touchProbe.armCmd` (optional) — Value written to arm the touch probe (default `17`, EL7062/ED7062 TP1 positive edge). Defaults: `encoder.touchProbe.armCmd`: 17.
- `encoder.touchProbe.armBits` (optional) — Number of bits written from `armCmd` (default `5`). Defaults: `encoder.touchProbe.armBits`: 5.
- `encoder.primary` (optional) — Use as primary encoder for control.
- `encoder.useAsCSPDrvEnc` (optional) — Use as CSP drive encoder when controller enabled in CSP.
- `encoder.allowOverUnderFlow` (optional) — Allow over/under flow of encoder raw counter (default true). Set to false for linear encoders. Defaults: `encoder.allowOverUnderFlow`: true (ecmc default; no YAML command if omitted).
- `encoder.homing` (optional) — Encoder homing settings.
- `encoder.homing.type` (optional) — Homing sequence type.
- `encoder.homing.position` (optional) — Referenced position.
- `encoder.homing.velocity.to` (optional) — Velocity to cam/sensor.
- `encoder.homing.velocity.from` (optional) — Velocity off cam/sensor. Defaults: `encoder.homing.velocity.from`: velocity.to.
- `encoder.homing.acceleration` (optional) — Homing acceleration in engineering units/s².
- `encoder.homing.deceleration` (optional) — Homing deceleration in engineering units/s².
- `encoder.homing.refToEncIDAtStartup` (optional) — Encoder id used as startup position reference; -1 disables copying. Defaults: `encoder.homing.refToEncIDAtStartup`: -1.
- `encoder.homing.refAtHome` (optional) — Enable referencing this encoder at homing (integer flag, default 0). Defaults: `encoder.homing.refAtHome`: 0.
- `encoder.homing.tolToPrim` (optional) — Max tolerance vs primary encoder. Defaults: `encoder.homing.tolToPrim`: 0.
- `encoder.homing.postMoveEnable` (optional) — Enable post-homing move; true requires postMovePosition. Defaults: `encoder.homing.postMoveEnable`: no command if omitted.
- `encoder.homing.postMovePosition` (required when postMoveEnable is true) — Post-homing target in engineering units; required when postMoveEnable is true. Defaults: `encoder.homing.postMovePosition`: no target inferred.
- `encoder.homing.trigg` (optional) — EtherCAT entry to trigger drive internal homing sequence.
- `encoder.homing.ready` (optional) — Status entry for drive internal homing ready.
- `encoder.homing.latchCount` (optional) — Latch count offset for homing.
- `encoder.delayComp` (optional) — Delay compensation between set and act.
- `encoder.delayComp.time` (required when encoder.delayComp is present) — Delay time in cycles.
- `encoder.delayComp.enable` (optional) — Enable flag (defaults to true if set). Defaults: `encoder.delayComp.enable`: true.
- `encoder.lookuptable` (optional) — Correction lookup table (applied when homed).
- `encoder.lookuptable.filename` (required when encoder.lookuptable is present) — LUT file; value subtracted from encoder value.
- `encoder.lookuptable.enable` (optional) — Enable lookup table (defaults to true when loaded); use a YAML boolean. Defaults: `encoder.lookuptable.enable`: true after a valid table is loaded (ecmc).
- `encoder.lookuptable.scale` (optional) — LUT scale; set to -1.0 to add instead of subtract. Defaults: `encoder.lookuptable.scale`: no command if omitted.
- `encoder.lookuptable.range` (optional) — Modulo range the LUT covers. Defaults: `encoder.lookuptable.range`: no command if omitted.
- `encoder.desc` (optional) — Encoder description.
- `encoder.unit` (optional) — Encoder engineering unit.
- `encoder.homing.timeout` (optional) — Homing sequence timeout in seconds.
- `encoder.power.enable` (optional; see encoder power configuration) — Enable automatic encoder relay power control. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). Defaults: `encoder.power.enable`: false.
- `encoder.power.output` (optional; see encoder power configuration) — Writable EtherCAT bit path; required when enabled. A supplied output is also linked when enable is false. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}).
- `encoder.power.activeHigh` (optional; see encoder power configuration) — Logical ON writes 1 when true, 0 when false. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). Defaults: `encoder.power.activeHigh`: true.
- `encoder.power.startupDelay` (optional; see encoder power configuration) — Minimum warm-up delay, seconds. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). Defaults: `encoder.power.startupDelay`: 0.1.
- `encoder.power.startupTimeout` (optional; see encoder power configuration) — Maximum wake time, seconds; greater than startupDelay. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). Defaults: `encoder.power.startupTimeout`: 5.0.
- `encoder.power.idleDelay` (optional; see encoder power configuration) — Continuous atTarget/tighter-deadband dwell before off, seconds. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). Defaults: `encoder.power.idleDelay`: 2.0.
- `encoder.power.backup.encoder` (optional; see encoder power configuration) — Always-powered incremental backup index (checked at final startup validation), 1…8. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}).
- `encoder.power.backup.maxPositionDifference` (optional; see encoder power configuration) — Positive permitted wake discrepancy, engineering units. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}).

## controller

- `controller.Kp` (optional) — Proportional gain. Defaults: `controller.Kp`: 1.
- `controller.Ki` (optional) — Integral gain. Defaults: `controller.Ki`: 0.
- `controller.Kd` (optional) — Derivative gain. Defaults: `controller.Kd`: 0.
- `controller.Kff` (optional) — Feed-forward gain. Defaults: `controller.Kff`: 1.
- `controller.resetIAtRmp` (optional) — Reset the integral part to zero while an internal trajectory is busy. Defaults: `controller.resetIAtRmp`: no command if omitted.
- `controller.freezeIAtRmp` (optional) — Freeze the integral part at its current value while an internal trajectory is busy. Defaults: `controller.freezeIAtRmp`: no command if omitted.
- `controller.deadband.tol` (optional) — Deadband tolerance in engineering units; supply together with time.
- `controller.deadband.time` (optional) — Deadband time in EtherCAT cycles; supply together with tol.
- `controller.limits.minOutput` / `controller.limits.maxOutput` (optional) — Output clamps. Active only when `maxOutput > minOutput`; both `0` disables the limits.
- `controller.limits.minIntegral` / `controller.limits.maxIntegral` (optional) — Integral clamps. Active only when `maxIntegral > minIntegral`; both `0` disables the limits.
- `controller.inner.Kp` / `controller.inner.Ki` / `controller.inner.Kd` / `controller.inner.tol` (optional) — Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. Defaults: `controller.inner.Kp`: 1.0; `controller.inner.Ki`: 0; `controller.inner.Kd`: 0; `controller.inner.tol`: 0.

## trajectory

- `trajectory.type` (optional) — 0=trapezoidal, 1=s-curve (ruckig); defaults to trapezoidal. Defaults: `trajectory.type`: 0.
- `trajectory.source` (optional) — 0=trajectory generator, 1=PLC source. Defaults: `trajectory.source`: 0.
- `trajectory.axis.velocity` (required) — Default velocity.
- `trajectory.axis.acceleration` (required) — Default acceleration.
- `trajectory.axis.deceleration` (optional) — Deceleration in engineering units/s²; defaults to axis acceleration. Defaults: `trajectory.axis.deceleration`: trajectory.axis.acceleration.
- `trajectory.axis.emergencyDeceleration` (optional) — Emergency deceleration in engineering units/s²; defaults to ten times the greater of axis acceleration and deceleration. Defaults: `trajectory.axis.emergencyDeceleration`: 10 × max(acceleration, deceleration).
- `trajectory.axis.jerk` (optional) — S-curve jerk in engineering units/s³; the fallback is numerically equal to axis acceleration. Defaults: `trajectory.axis.jerk`: trajectory.axis.acceleration.
- `trajectory.jog.velocity` (optional) — Default jog velocity (motor record). Defaults: `trajectory.jog.velocity`: ECMC: axis.velocity; motor record: axis.velocity / 10.
- `trajectory.modulo.range` (optional) — Modulo range. Defaults: `trajectory.modulo.range`: 0.0.
- `trajectory.modulo.type` (optional) — Modulo type. Defaults: `trajectory.modulo.type`: 0.
- `trajectory.jog.acceleration` (optional; motor record only) — Jog acceleration for the motor record. The ECMC trajectory template does not set a separate jog acceleration. Defaults: `trajectory.jog.acceleration`: trajectory.axis.acceleration (motor record only).

## touchProbe

- `touchProbe.position` (required when touchProbe is present) — Latched touch-probe position entry.
- `touchProbe.timestamp` (optional) — Optional 32- or 64-bit DC timestamp entry for the same edge.
- `touchProbe.control` (required when touchProbe is present) — Touch-probe control word entry.
- `touchProbe.controlBit` (optional) — First bit to write in the control word (default `0`). Defaults: `touchProbe.controlBit`: 0.
- `touchProbe.status` (required when touchProbe is present) — Touch-probe status word entry.
- `touchProbe.statusBit` (optional) — Status bit that indicates a captured event (default `0`). Defaults: `touchProbe.statusBit`: 0.
- `touchProbe.armCmd` (optional) — Value written to arm the touch probe (default `17`, EL7062/ED7062 TP1 positive edge). Defaults: `touchProbe.armCmd`: 17.
- `touchProbe.armBits` (optional) — Number of bits written from `armCmd` (default `5`). Defaults: `touchProbe.armBits`: 5.

## positionCompare

- `positionCompare.output` (required when positionCompare is present) — EtherCAT output entry to schedule, for example an EL2252 binary output.
- `positionCompare.activate` (required when positionCompare is present) — EtherCAT activation/control entry used by the timed-output terminal.
- `positionCompare.startTime` (required when positionCompare is present) — EtherCAT DC start-time entry. Use a 64-bit integer PV/entry for EL2252 start time.
- `positionCompare.minLeadMs` (optional) — Minimum allowed scheduling lead time in milliseconds (default `2.0`). Defaults: `positionCompare.minLeadMs`: 2.0.
- `positionCompare.maxLeadMs` (optional) — Maximum allowed scheduling lead time in milliseconds (default `100.0`). Defaults: `positionCompare.maxLeadMs`: 100.0.
- `positionCompare.activateIdle` (optional) — Activation value written while idle (default `3` for EL2252). Defaults: `positionCompare.activateIdle`: 3.
- `positionCompare.activateSchedule` (optional) — Activation value written for one cycle to load a new schedule (default `0` for EL2252). Defaults: `positionCompare.activateSchedule`: 0.
- `positionCompare.pulseWidthMs` (optional) — If greater than zero, schedule an automatic reset after this pulse width in milliseconds. Fractions such as `0.5` are allowed. Defaults: `positionCompare.pulseWidthMs`: 0.0.
- `positionCompare.resetValue` (optional) — Output value used for the automatic reset (default `0`). Defaults: `positionCompare.resetValue`: 0.

## input

- `input.limit.forward` (required) — Forward limit switch entry.
- `input.limit.forwardPolarity` (optional) — Forward limit polarity.
- `input.limit.backward` (required) — Backward limit switch entry.
- `input.limit.backwardPolarity` (optional) — Backward limit polarity.
- `input.home` (optional) — Home switch entry. Omit when unused; no sensor link is generated and the panel link is N/A.
- `input.homePolarity` (optional) — Home switch polarity; used only when input.home is linked to hardware.
- `input.interlock` (optional) — Interlock input entry.
- `input.interlockPolarity` (optional) — Interlock polarity.
- `input.analog` (optional) — Analog interlock block.
- `input.analog.interlock` (optional) — Analog interlock entry.
- `input.analog.interlockPolarity` (optional) — 0: high is bad; 1: low is bad.
- `input.analog.rawLimit` (optional) — Raw analog limit.
- `input.analog.enable` (optional) — Enable analog interlock (default true if set). Defaults: `input.analog.enable`: true when interlock is linked.
- `input.limit.latchInput` (optional) — Latch/debounce the limit inputs.

## softlimits

- `softlimits.enable` (optional) — Global soft limit enable. Defaults: `softlimits.enable`: Python: not supplied; ECB: false.
- `softlimits.forward` (required with forwardEnable) — Forward soft limit.
- `softlimits.forwardEnable` (required with forward; also requires enable) — Forward soft limit enable.
- `softlimits.backward` (required with backwardEnable) — Backward soft limit.
- `softlimits.backwardEnable` (required with backward; also requires enable) — Backward soft limit enable.

## monitoring

- `monitoring.lag.enable` / `monitoring.lag.tolerance` / `monitoring.lag.time` (optional block; Python requires enable, tolerance and time if explicitly supplied) — Following-error monitoring; time is in EtherCAT cycles. An omitted lag block defaults to disabled when monitoring is present. Defaults: `monitoring.lag.enable`: false when lag block omitted; `monitoring.lag.tolerance`: 0 when lag block omitted; `monitoring.lag.time`: 100 when lag block omitted.
- `monitoring.target.enable` / `monitoring.target.tolerance` / `monitoring.target.time` (optional block; supply enable, tolerance and time together) — At-target monitoring; enable it for motor-record completion detection. Time is in EtherCAT cycles. Defaults: `monitoring.target.enable`: Python: required in block; ECB: false.
- `monitoring.target.slaveControlDeadband.tolerance` / `monitoring.target.slaveControlDeadband.time` (required pair when slaveControlDeadband is present) — Independent live master-axis error band and qualification time forwarded to slaves for control-deadband decisions such as reduced torque. Configure these keys on the master axis. They apply to physical and virtual masters and may be tighter or slower than ordinary AtTarget. If omitted, ecmc uses the AtTarget tolerance and time. Example: `slaveControlDeadband: {tolerance: 0.01, time: 100}`. Defaults: `monitoring.target.slaveControlDeadband.tolerance`: monitoring.target.tolerance (ecmc); `monitoring.target.slaveControlDeadband.time`: monitoring.target.time (ecmc).
- `monitoring.velocity.enable` / `monitoring.velocity.max` / `monitoring.velocity.time.trajectory` / `monitoring.velocity.time.drive` (optional block; supply enable, max and time.trajectory; time.drive optional) — Velocity monitoring. Times are in EtherCAT cycles. Defaults: `monitoring.velocity.enable`: Python: required in block; ECB: false.
- `monitoring.velocityDifference.enable` / `monitoring.velocityDifference.max` / `monitoring.velocityDifference.time.trajectory` / `monitoring.velocityDifference.time.drive` (optional block; supply enable, max and time.trajectory; time.drive optional) — Velocity setpoint vs actual monitoring. Times are in EtherCAT cycles. Current template also checks velocity.time.drive; supply both monitor blocks and drive delays (see the configuration guide). Defaults: `monitoring.velocityDifference.enable`: Python: required in block; ECB: false.
- `monitoring.stall.enable` / `monitoring.stall.time.timeout` / `monitoring.stall.time.factor` (optional) — Stall monitoring requires target monitoring. Python uses boolean enable (true/false); ECB currently requires integer enable (1/0). timeout is in EtherCAT cycles; factor is dimensionless.

## plc

- `plc.enable` (required when axis plc is present) — Enable the axis PLC; required by both axis-PLC schemas when the block is present.
- `plc.externalCommands` (optional) — Allow external PLC commands. Defaults: `plc.externalCommands`: false.
- `plc.file` (optional) — PLC code file to include.
- `plc.code` (optional) — Inline PLC code list (appended after `plc.file` content); example shows enable logic and setpoint calculation.
- `plc.velocity_filter` (optional) — Velocity feedforward smoothing.
- `plc.velocity_filter.encoder.enable` / `plc.velocity_filter.encoder.size` (optional) — Filter PLC encoder velocity. Defaults: `plc.velocity_filter.encoder.enable`: false; `plc.velocity_filter.encoder.size`: 1.
- `plc.velocity_filter.trajectory.enable` / `plc.velocity_filter.trajectory.size` (optional) — Filter PLC trajectory velocity. Defaults: `plc.velocity_filter.trajectory.enable`: false; `plc.velocity_filter.trajectory.size`: 1.
- `plc.filter` (optional; deprecated alias) — Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory.
- `plc.macros` (optional) — Macros for an external axis PLC file.

## homing (legacy; prefer encoder.homing)

- `homing.type` (optional) — Homing sequence type.
- `homing.position` (optional) — Referenced position.
- `homing.velocity.to` (optional) — Velocity to cam/sensor.
- `homing.velocity.from` (optional) — Velocity off cam/sensor. Defaults: `homing.velocity.from`: velocity.to.
- `homing.acceleration` (optional) — Homing acceleration in engineering units/s².
- `homing.deceleration` (optional) — Homing deceleration in engineering units/s².
- `homing.refToEncIDAtStartup` (optional) — Encoder id used as startup position reference; -1 disables copying. Defaults: `homing.refToEncIDAtStartup`: -1.
- `homing.refAtHome` (optional) — Enable referencing this encoder at homing (integer flag, default 0). Defaults: `homing.refAtHome`: 0.
- `homing.tolToPrim` (optional) — Max tolerance vs primary encoder. Defaults: `homing.tolToPrim`: 0.
- `homing.postMoveEnable` (optional) — Enable post-homing move; true requires postMovePosition. Defaults: `homing.postMoveEnable`: no command if omitted.
- `homing.postMovePosition` (required when postMoveEnable is true) — Post-homing target in engineering units; required when postMoveEnable is true. Defaults: `homing.postMovePosition`: no target inferred.
- `homing.trigg` (optional) — EtherCAT entry to trigger drive internal homing sequence.
- `homing.ready` (optional) — Status entry for drive internal homing ready.
- `homing.latchCount` (optional) — Latch count offset for homing.
- `homing.timeout` (optional) — Homing sequence timeout in seconds.

<!-- END GENERATED AXIS YAML REFERENCE -->
