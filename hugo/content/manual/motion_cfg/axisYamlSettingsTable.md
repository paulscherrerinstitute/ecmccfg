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

- Requirements distinguish loader requirements, template needs and recommended
  explicit hardware settings. Optional sections can have required children.
- Defaults apply when the parent section exists, unless stated otherwise. A dash
  means no YAML fallback is documented; ecmc may retain its initialized value.
  Schema acceptance does not guarantee that hardware scaling or bit counts are usable.
- The source of defaults is `scripts/jinja2/ecmcYamlSchema.py`,
  `scripts/jinja2/ecbSchema.json`, and `scripts/jinja2/templates/`. Backend
  differences are labelled explicitly. Python discards unknown keys; ECB rejects them.
- Both reference views use the same requirements and descriptions source.
- “Optional” means the key can be omitted in the stated context; conditional
  requirements are shown explicitly.

<!-- BEGIN GENERATED AXIS YAML REFERENCE -->

| Key | Description | Requirement | Default when parent section is present |
| --- | --- | --- | --- |
| `axis.id` | Axis id. If omitted, the template uses the next id derived from ECMC_AXIS_NO; set it explicitly for stable references. | optional; explicit id recommended | next id from ECMC_AXIS_NO |
| `axis.type` | Axis type; defaults to physical/joint (1). Virtual/end_effector is 2. | optional | joint |
| `axis.mode` | Drive mode: CSV, CSP or CSP_PC; defaults to CSV. | optional | CSV |
| `axis.parameters` | Additional motor driver options. `restoreMotorSoftLims=1;` lets initialized/autosave-restored motor dial limits override ECMC at startup and also enables ongoing synchronization. See [autosave]({{< relref "/manual/motion_cfg/autosave.md" >}}). | optional | — |
| `axis.healthOutput` | EtherCAT entry for health output | optional | — |
| `axis.feedSwitchesOutput` | EtherCAT entry for fed switches | optional | — |
| `axis.feedSwitchesValue` | Value to write to axis.feedSwitchesOutput. Defaults to 1 | optional | 1 |
| `axis.group` | Add axis to group (group will be created if it does not exist) | optional | — |
| `axis.autoMode.modeSet` | EtherCAT entry drive mode write (set CSV,CSP,homing) | optional | — |
| `axis.autoMode.modeAct` | EtherCAT entry drive mode reading (set CSV,CSP,homing) | optional | — |
| `axis.autoMode.modeCmdMotion` | Drive mode value for normal motion (written to axis.drvMode.modeSet when normal motion) | optional | — |
| `axis.autoMode.modeCmdHome` | Drive mode value for when homing (written to axis.drvMode.modeSet when homing) | optional | — |
| `axis.features.blockCom` | Block communication to axis | optional | — |
| `axis.features.allowSrcChangeWhenEnabled` | Allow traj/enc source change when axis is enabled | optional | — |
| `axis.features.allowedFunctions.homing` | Allow homing | optional | — |
| `axis.features.allowedFunctions.constantVelocity` | Allow constant velocity | optional | — |
| `axis.features.allowedFunctions.positioning` | Allow positioning | optional | — |
| `axis.autoEnable.enableTimeout` | If defined, ecmc tries to auto-enable for a maximum enableTimeout seconds. | optional | -1.0 |
| `axis.autoEnable.disableTimeout` | If defined, ecmc disables axis after idle (non busy) in disableTime seconds | optional | -1.0 |
| `axis.autoEnable.autoDisableLatchAtTarget` | Keep the auto-disable timer active after AtTarget has been asserted once | optional | false |
| `axis.autoEnable.atStartup` | Auto enable axis at ioc start, default False | optional | false |
| `axis.tweakDist` | Tweak value (both ecmc interface and motor record tweak value) | optional | 1.0 |
| `axis.features.disableOnReset` | Disable the axis on error reset. | optional | — |
| `axis.features.alarmAtHardLimits` | Raise an axis error on hard-limit activation; recovery requires disabling this feature. | optional | — |
| `epics.name` | PV name suffix; defaults to axis. Set a unique name for each axis. | optional; unique name recommended | axis |
| `epics.precision` | Decimal count | optional | 3 |
| `epics.description` | Axis description | optional | — |
| `epics.unit` | Unit | optional | mm |
| `epics.motorRecord.enable` | Enable motor record | optional | true |
| `epics.motorRecord.description` | This is MR | optional | — |
| `epics.motorRecord.fieldInit` | Extra config for motor record | optional | — |
| `epics.motorRecord.syncSoftLimits` | Sync softlimits between motor and ecmc (default false; `restoreMotorSoftLims=1` overrides this to enabled). When synchronization is disabled, motor record HLM/LLM and ecmc soft limits may differ. On false->true, ecmc soft limits are copied to the motor record; while true, later motor record soft-limit changes are written back to ecmc. | optional | false |
| `epics.motorRecord.restoreSoftLimits` | Restore motor DLLM/DHLM into ecmc at startup and keep the two interfaces synchronized; see the autosave guide. | optional; startup policy | false |
| `epics.motorRecord.pvt.npoints` | Max number of target points for PVT/profile move | optional | 0 |
| `epics.motorRecord.pvt.nreadback` | Max number of readback points for PVT/profile move | optional | 0 |
| `drive.numerator` | Drive scale numerator; CSV uses velocity scaling, CSP uses position scaling. The schema default 0 is not a usable hardware scale. | optional; configure scaling explicitly | 0 |
| `drive.denominator` | Drive scale denominator; configure it together with numerator for the selected drive mode. | optional | 1 |
| `drive.type` | Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives) | optional | 0 |
| `drive.control` | Control word EtherCAT entry | required | — |
| `drive.enable` | Enable bit index; non-DS402 defaults to bit 0 with a warning. Ignored for DS402. | optional; non-DS402 only | 0 |
| `drive.enabled` | Enabled status bit index; non-DS402 defaults to bit 1 with a warning. Ignored for DS402. | optional; non-DS402 only | 1 |
| `drive.status` | Status word EtherCAT entry | required | — |
| `drive.setpoint` | Velocity setpoint if CSV. Position setpoint if CSP. `F32`/`F64` CSV setpoints are supported; `F32`/`F64` CSP setpoints require the selected CSP encoder actual-position entry to use the same datatype. | required | — |
| `drive.reduceTorque` | Reduce-torque control bit; requires reduceTorqueEnable and control. | optional | — |
| `drive.reduceTorqueEnable` | Enable reduce-torque handling; requires reduceTorque and control. | optional | — |
| `drive.brake.enable` | Enable brake control. | required when drive.brake is present | — |
| `drive.brake.output` | EtherCAT link to brake output | required when drive.brake is present | — |
| `drive.brake.openDelay` | Brake timing parameter in cycles (default 1kHz) | optional | 0 |
| `drive.brake.closeAhead` | Brake timing parameter in cycles (default 1kHz) | optional | 0 |
| `drive.reset` | Reset (if no drive reset bit then leave empty) | optional | — |
| `drive.warning` | Warning (if no drive warning bit then leave empty) | optional | — |
| `drive.lookuptable.filename` | Load position-dependent CSV drive-output compensation table. | required when drive.lookuptable is present | — |
| `drive.lookuptable.enable` | Enable or disable drive lookup-table compensation. | optional | true after a valid table is loaded (ecmc) |
| `drive.lookuptable.scale` | Scale or invert the compensation value. | optional | 1.0 |
| `drive.lookuptable.range` | Optional modulo range in axis position engineering units. | optional | 0 |
| `encoder.numerator` | Encoder scale numerator in engineering units. The schema default 0 is not a usable hardware scale. | optional; configure scaling explicitly | 0.0 |
| `encoder.denominator` | Scaling denominator example 4096 ticks per 360 degree | optional | 1 |
| `encoder.type` | Type: 0=Incremental, 1=Absolute | optional | 0 |
| `encoder.bits` | Bit count used for ecmc's encoder value; does not alter the raw EtherCAT slave value | optional | 16 |
| `encoder.absBits` | Absolute bit count (for absolute encoders) always least significant part of 'bits' | optional | 25 |
| `encoder.absOffset` | Encoder offset in eng units (for absolute encoders) | optional | 0.0 |
| `encoder.mask` | Mask applied to ecmc's encoder value; the original EtherCAT value remains visible in the hardware PVs | optional | — |
| `encoder.position` | EtherCAT entry for actual position input (encoder). `F32`/`F64` actual-position entries are only valid for absolute encoders (`encoder.type: 1`). Keep `encoder.bits` and `encoder.absBits` aligned with the datatype width (`32`/`32` or `64`/`64`). | required for EtherCAT position feedback (source 0) | — |
| `encoder.control` | Mandatory only if 'reset' is used | optional; required if reset is used | — |
| `encoder.status` | Encoder status word entry; required with ready, warning or error. | required with ready, warning or error | — |
| `encoder.ready` | Bit in encoder status word for encoder ready | optional | — |
| `encoder.source` | 0 = Encoder value from EtherCAT hardware, 1 = Encoder value from PLC | optional | 0 |
| `encoder.reset` | Reset | optional | — |
| `encoder.warning` | Warning | optional | — |
| `encoder.filter.velocity.size` | Velocity filter window in EtherCAT samples/cycles; applies when encoder.filter.velocity is supplied. | optional | 100 |
| `encoder.filter.velocity.enable` | Enable the encoder velocity filter; defaults to true when encoder.filter.velocity is supplied. | optional | true |
| `encoder.filter.position.size` | Position filter window in EtherCAT samples/cycles; applies when encoder.filter.position is supplied. | optional | 10 |
| `encoder.filter.position.enable` | Enable the encoder position filter; defaults to true when encoder.filter.position is supplied. | optional | true |
| `encoder.latch.position` | Link to latched value. Used for some homing seqs | required when encoder.latch is present | — |
| `encoder.latch.timestamp` | Optional 32/64-bit DC timestamp for the same latch event | optional | — |
| `encoder.latch.control` | Bit in encoder control word to arm latch. Used for some homing seqs | optional | 0 |
| `encoder.latch.status` | Bit in encoder status word for latch triggered status. Used for some homing seqs | optional | 0 |
| `encoder.latch.armCmd` | Value in dec to arm latch to write to encoder.control | optional | 1 |
| `encoder.latch.armBits` | Bit size of encoder.latch.armCmd | optional | 1 |
| `encoder.touchProbe.position` | Link to touch-probe latched position. Used for touch-probe functionality separate from homing latch. | required when encoder.touchProbe is present | — |
| `encoder.touchProbe.timestamp` | Optional 32/64-bit DC timestamp for the same touch-probe edge | optional | — |
| `encoder.touchProbe.control` | Touch-probe control word entry | required when encoder.touchProbe is present | — |
| `encoder.touchProbe.controlBit` | First bit in touch-probe control word to write `armBits` bits from `armCmd`; default 0 | optional | 0 |
| `encoder.touchProbe.status` | Touch-probe status word entry | required when encoder.touchProbe is present | — |
| `encoder.touchProbe.statusBit` | Status bit for captured touch-probe event; default 0 | optional | 0 |
| `encoder.touchProbe.armCmd` | Value in dec to arm touch probe; default 17 for EL7062/ED7062 TP1 positive edge | optional | 17 |
| `encoder.touchProbe.armBits` | Bit size of encoder.touchProbe.armCmd; default 5 | optional | 5 |
| `encoder.primary` | Use this encoder as primary (for control) | optional | — |
| `encoder.useAsCSPDrvEnc` | Use this encoder as CSP drive encoder (ecmc controller enabled in CSP) | optional | — |
| `encoder.allowOverUnderFlow` | Allow over/under flow of encoder raw counter (default true). Set to false for linear encoders. | optional | true (ecmc default; no YAML command if omitted) |
| `encoder.homing.type` | Homing sequence type | optional | — |
| `encoder.homing.position` | Position to reference encoder to | optional | — |
| `encoder.homing.velocity.to` | Velocity to cam/sensor (used for some homing seqs) | optional | — |
| `encoder.homing.velocity.from` | Velocity from cam/sensor (used for some homing seqs) | optional | velocity.to |
| `encoder.homing.acceleration` | Homing acceleration in engineering units/s². | optional | — |
| `encoder.homing.deceleration` | Homing deceleration in engineering units/s². | optional | — |
| `encoder.homing.refToEncIDAtStartup` | Encoder id used as startup position reference; -1 disables copying. | optional | -1 |
| `encoder.homing.refAtHome` | Enable referencing this encoder at homing (integer flag, default 0). | optional | 0 |
| `encoder.homing.tolToPrim` | If set then this is the max allowed tolerance between prim encoder and this encoder | optional | 0 |
| `encoder.homing.postMoveEnable` | Enable post-homing move; true requires postMovePosition. | optional | no command if omitted |
| `encoder.homing.postMovePosition` | Post-homing target in engineering units; required when postMoveEnable is true. | required when postMoveEnable is true | no target inferred |
| `encoder.homing.trigg` | EtherCAT entry for triggering drive internal homing seq (seq id 26) | optional | — |
| `encoder.homing.ready` | EtherCAT entry for reading drive internal homing seq ready (seq id 26) | optional | — |
| `encoder.homing.latchCount` | Latch count offset for homing. | optional | — |
| `encoder.delayComp.time` | Delay time between set and act [cycles] | required when encoder.delayComp is present | — |
| `encoder.delayComp.enable` | enable (defaults to 1 if not set) | optional | true |
| `encoder.lookuptable.filename` | Load correction lookup table file. Value will be subtracted from encoder value. | required when encoder.lookuptable is present | — |
| `encoder.lookuptable.enable` | Enable lookup table (defaults to true when loaded); use a YAML boolean. | optional | true after a valid table is loaded (ecmc) |
| `encoder.lookuptable.scale` | Scale applied to LUT (if you want value to be added then set scale to -1.0) | optional | no command if omitted |
| `encoder.lookuptable.range` | LUT modulo value (LUT should cover the range 0..range) | optional | no command if omitted |
| `encoder.desc` | Encoder description. | optional | — |
| `encoder.unit` | Encoder engineering unit. | optional | — |
| `encoder.homing.timeout` | Homing sequence timeout in seconds. | optional | — |
| `encoder.power.enable` | Enable automatic encoder relay power control. | optional; see encoder power configuration | false |
| `encoder.power.output` | Writable EtherCAT bit path; required when enabled. A supplied output is also linked when enable is false. | optional; see encoder power configuration | — |
| `encoder.power.activeHigh` | Logical ON writes 1 when true, 0 when false. | optional; see encoder power configuration | true |
| `encoder.power.startupDelay` | Minimum warm-up delay, seconds. | optional; see encoder power configuration | 0.1 |
| `encoder.power.startupTimeout` | Maximum wake time, seconds; greater than startupDelay. | optional; see encoder power configuration | 5.0 |
| `encoder.power.idleDelay` | Continuous atTarget/tighter-deadband dwell before off, seconds. | optional; see encoder power configuration | 2.0 |
| `encoder.power.backup.encoder` | Always-powered incremental backup index (checked at final startup validation), 1…8. | optional; see encoder power configuration | — |
| `encoder.power.backup.maxPositionDifference` | Positive permitted wake discrepancy, engineering units. | optional; see encoder power configuration | — |
| `controller.Kp` | Kp proportional gain | optional | 1 |
| `controller.Ki` | Ki integral gain | optional | 0 |
| `controller.Kd` | Kd derivative gain | optional | 0 |
| `controller.Kff` | Feed forward gain | optional | 1 |
| `controller.resetIAtRmp` | Reset the integral part to zero while an internal trajectory is busy. | optional | no command if omitted |
| `controller.freezeIAtRmp` | Freeze the integral part at its current value while an internal trajectory is busy. | optional | no command if omitted |
| `controller.deadband.tol` | Deadband tolerance in engineering units; supply together with time. | optional | — |
| `controller.deadband.time` | Deadband time in EtherCAT cycles; supply together with tol. | optional | — |
| `controller.limits.minOutput` | Minimum controller output. Output limiting is active only when `maxOutput > minOutput`; `minOutput=0` and `maxOutput=0` disables it. | optional | — |
| `controller.limits.maxOutput` | Maximum controller output. Output limiting is active only when `maxOutput > minOutput`; `minOutput=0` and `maxOutput=0` disables it. | optional | — |
| `controller.limits.minIntegral` | Minimum integral output. Integral limiting is active only when `maxIntegral > minIntegral`; `minIntegral=0` and `maxIntegral=0` disables it. | optional | — |
| `controller.limits.maxIntegral` | Maximum integral output. Integral limiting is active only when `maxIntegral > minIntegral`; `minIntegral=0` and `maxIntegral=0` disables it. | optional | — |
| `controller.inner.Kp` | Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. | optional | 1.0 |
| `controller.inner.Ki` | Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. | optional | 0 |
| `controller.inner.Kd` | Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. | optional | 0 |
| `controller.inner.tol` | Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. | optional | 0 |
| `trajectory.type` | Default 0 = trapezoidal, 1 = S-curve (ruckig) | optional | 0 |
| `trajectory.source` | 0 = take trajectory setpoint from axis traj object, 1 = trajectory setpoint from plc | optional | 0 |
| `trajectory.axis.velocity` | Default velocity for axis | required | — |
| `trajectory.axis.acceleration` | Default acceleration for axis | required | — |
| `trajectory.axis.deceleration` | Deceleration in engineering units/s²; defaults to axis acceleration. | optional | trajectory.axis.acceleration |
| `trajectory.axis.emergencyDeceleration` | Emergency deceleration in engineering units/s²; defaults to ten times the greater of axis acceleration and deceleration. | optional | 10 × max(acceleration, deceleration) |
| `trajectory.axis.jerk` | S-curve jerk in engineering units/s³; the fallback is numerically equal to axis acceleration. | optional | trajectory.axis.acceleration |
| `trajectory.jog.velocity` | Default velocity for JOG (motor record) | optional | ECMC: axis.velocity; motor record: axis.velocity / 10 |
| `trajectory.modulo.range` | Modulo range 0..360 | optional | 0.0 |
| `trajectory.modulo.type` | Modulo type | optional | 0 |
| `trajectory.jog.acceleration` | Jog acceleration for the motor record. The ECMC trajectory template does not set a separate jog acceleration. | optional; motor record only | trajectory.axis.acceleration (motor record only) |
| `touchProbe.position` | Link to touch-probe latched position. Used for touch-probe functionality separate from homing latch. | required when touchProbe is present | — |
| `touchProbe.timestamp` | Optional 32/64-bit DC timestamp for the same touch-probe edge | optional | — |
| `touchProbe.control` | Touch-probe control word entry | required when touchProbe is present | — |
| `touchProbe.controlBit` | First bit in touch-probe control word to write `armBits` bits from `armCmd`; default 0 | optional | 0 |
| `touchProbe.status` | Touch-probe status word entry | required when touchProbe is present | — |
| `touchProbe.statusBit` | Status bit for captured touch-probe event; default 0 | optional | 0 |
| `touchProbe.armCmd` | Value in dec to arm touch probe; default 17 for EL7062/ED7062 TP1 positive edge | optional | 17 |
| `touchProbe.armBits` | Bit size of touchProbe.armCmd; default 5 | optional | 5 |
| `positionCompare.output` | EtherCAT output entry to schedule, for example an EL2252 binary output | required when positionCompare is present | — |
| `positionCompare.activate` | EtherCAT activation/control entry used by the timed-output terminal | required when positionCompare is present | — |
| `positionCompare.startTime` | EtherCAT DC start-time entry; use a 64-bit integer entry/PV for EL2252 | required when positionCompare is present | — |
| `positionCompare.minLeadMs` | Minimum scheduling lead time [ms], default 2.0 | optional | 2.0 |
| `positionCompare.maxLeadMs` | Maximum scheduling lead time [ms], default 100.0 | optional | 100.0 |
| `positionCompare.activateIdle` | Activation value written while idle, default 3 for EL2252 | optional | 3 |
| `positionCompare.activateSchedule` | Activation value written for one cycle to load a schedule, default 0 for EL2252 | optional | 0 |
| `positionCompare.pulseWidthMs` | Optional automatic reset pulse width [ms], default 0. Fractions such as 0.5 are allowed. | optional | 0.0 |
| `positionCompare.resetValue` | Output value for automatic reset after pulseWidthMs, default 0 | optional | 0 |
| `input.limit.forward` | EtherCAT entry for low limit switch input | required | — |
| `input.limit.forwardPolarity` | Polarity of forward limit switch | optional | — |
| `input.limit.backward` | EtherCAT entry for high limit switch input | required | — |
| `input.limit.backwardPolarity` | Polarity of backward limit switch | optional | — |
| `input.home` | Home switch entry. Omit when unused; no sensor link is generated and the panel link is N/A. | optional | — |
| `input.homePolarity` | Home switch polarity; used only when input.home is linked to hardware. | optional | — |
| `input.interlock` | EtherCAT entry for interlock switch input | optional | — |
| `input.interlockPolarity` | Polarity of interlock switch | optional | — |
| `input.analog.interlock` | EtherCAT entry for analog interlock | optional | — |
| `input.analog.interlockPolarity` | 0: High value is bad, 1 = Low value is bad | optional | — |
| `input.analog.rawLimit` | Analog raw limit | optional | — |
| `input.analog.enable` | Enable analog interlock default true if analog.interlock is set | optional | true when interlock is linked |
| `input.limit.latchInput` | Latch/debounce the limit inputs. | optional | — |
| `softlimits.enable` | Enable soft limits | optional | Python: not supplied; ECB: false |
| `softlimits.forward` | Soft limit position fwd | required with forwardEnable | — |
| `softlimits.forwardEnable` | Soft limit position fwd enable | required with forward; also requires enable | — |
| `softlimits.backward` | Soft limit position bwd | required with backwardEnable | — |
| `softlimits.backwardEnable` | Soft limit position bwd enable | required with backward; also requires enable | — |
| `monitoring.lag.enable` | Enable position lag monitoring (following error) | optional block; Python requires enable, tolerance and time if explicitly supplied | false when lag block omitted |
| `monitoring.lag.tolerance` | Allowed tolerance | optional block; Python requires enable, tolerance and time if explicitly supplied | 0 when lag block omitted |
| `monitoring.lag.time` | Allowed time outside tolerance (EtherCAT cycles) | optional block; Python requires enable, tolerance and time if explicitly supplied | 100 when lag block omitted |
| `monitoring.target.enable` | Enable at target monitoring (needs to be enabled and configured if using motor record) | optional block; supply enable, tolerance and time together | Python: required in block; ECB: false |
| `monitoring.target.tolerance` | Allowed tolerance | optional block; supply enable, tolerance and time together | — |
| `monitoring.target.time` | Filter time inside tolerance to be at target (EtherCAT cycles) | optional block; supply enable, tolerance and time together | — |
| `monitoring.target.slaveControlDeadband.tolerance` | Master-axis tolerance forwarded to slaves for reduced-torque control; defaults to AtTarget tolerance | required pair when slaveControlDeadband is present | monitoring.target.tolerance (ecmc) |
| `monitoring.target.slaveControlDeadband.time` | Filter time inside slave-control deadband; defaults to AtTarget time (EtherCAT cycles) | required pair when slaveControlDeadband is present | monitoring.target.time (ecmc) |
| `monitoring.velocity.enable` | Enable velocity monitoring | optional block; supply enable, max and time.trajectory; time.drive optional | Python: required in block; ECB: false |
| `monitoring.velocity.max` | Allowed max velocity | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocity.time.trajectory` | Time allowed outside max velocity before system init halt (EtherCAT cycles) | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocity.time.drive` | Time allowed outside max velocity before system disables drive (EtherCAT cycles) | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocityDifference.enable` | Enable velocity difference monitoring (velocity set vs velocity actual) | optional block; supply enable, max and time.trajectory; time.drive optional | Python: required in block; ECB: false |
| `monitoring.velocityDifference.max` | Allowed max difference | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocityDifference.time.trajectory` | Time allowed outside max diff velo before system init halt (EtherCAT cycles) | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocityDifference.time.drive` | Time allowed outside max diff velo before system disables drive (EtherCAT cycles) | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.stall.enable` | Python: boolean true/false; ECB: integer 1/0 | optional | — |
| `monitoring.stall.time.timeout` | If not at target after "timeout" cycles after trajectory generator is ready then drive will disable | optional | — |
| `monitoring.stall.time.factor` | Measures duration of last motion command (busy high edge to busy low edge). The new timeout will be defined as this duration multiplied by this factor. The timeout finally used for stall detection will be the longest (of time.timeout and calculated from time.factor). | optional | — |
| `plc.enable` | Enable the axis PLC; required by both axis-PLC schemas when the block is present. | required when axis plc is present | — |
| `plc.externalCommands` | Allow axis input from PLC | optional | false |
| `plc.file` | File with plc code | optional | — |
| `plc.code[0]` | Enable axis if one of master axes is enabled | optional | — |
| `plc.code[1]` | Calculate set position for physical axis | optional | — |
| `plc.velocity_filter.encoder.enable` | Filter enable | optional | false |
| `plc.velocity_filter.encoder.size` | Filter size | optional | 1 |
| `plc.velocity_filter.trajectory.enable` | Filter enable | optional | false |
| `plc.velocity_filter.trajectory.size` | Filter size | optional | 1 |
| `plc.filter.velocity.enable` | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.filter.velocity.size` | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.filter.trajectory.enable` | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.filter.trajectory.size` | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.macros` | Macros for an external axis PLC file. | optional | — |
| `homing.type` | Homing sequence type | optional | — |
| `homing.position` | Position to reference encoder to | optional | — |
| `homing.velocity.to` | Velocity to cam/sensor (used for some homing seqs) | optional | — |
| `homing.velocity.from` | Velocity from cam/sensor (used for some homing seqs) | optional | velocity.to |
| `homing.acceleration` | Homing acceleration in engineering units/s². | optional | — |
| `homing.deceleration` | Homing deceleration in engineering units/s². | optional | — |
| `homing.refToEncIDAtStartup` | Encoder id used as startup position reference; -1 disables copying. | optional | -1 |
| `homing.refAtHome` | Enable referencing this encoder at homing (integer flag, default 0). | optional | 0 |
| `homing.tolToPrim` | If set then this is the max allowed tolerance between prim encoder and this encoder | optional | 0 |
| `homing.postMoveEnable` | Enable post-homing move; true requires postMovePosition. | optional | no command if omitted |
| `homing.postMovePosition` | Post-homing target in engineering units; required when postMoveEnable is true. | required when postMoveEnable is true | no target inferred |
| `homing.trigg` | EtherCAT entry for triggering drive internal homing seq (seq id 26) | optional | — |
| `homing.ready` | EtherCAT entry for reading drive internal homing seq ready (seq id 26) | optional | — |
| `homing.latchCount` | Latch count offset for homing. | optional | — |
| `homing.timeout` | Homing sequence timeout in seconds. | optional | — |

<!-- END GENERATED AXIS YAML REFERENCE -->
