+++
title = "Axis YAML settings reference"
slug = "axisyaml-table"
weight = 16
chapter = false
+++

Reference for [Axis YAML configuration](../axisyaml/), grouped by section. Types are generated from the ECB schema; Python/Jinja may accept different forms (for example, `monitoring.stall.enable` is boolean in Python and integer in ECB). A mapping is a YAML block. A schema typo is identified rather than silently treated as a supported type. Defaults apply when the parent section exists; a dash means no documented fallback. Requirements distinguish loader, template and recommended explicit settings. Python discards unknown keys; ECB rejects them. See the [complete example]({{< relref "/manual/motion_cfg/axisYamlExample.md" >}}) for usage.

<!-- BEGIN GENERATED AXIS YAML REFERENCE -->

## axis

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `axis.id` | integer / string | Axis id. If omitted, the template uses the next id derived from ECMC_AXIS_NO; set it explicitly for stable references. | optional; explicit id recommended | next id from ECMC_AXIS_NO |
| `axis.type` | string / integer | Axis type; defaults to physical/joint (1). Virtual/end_effector is 2. | optional | joint |
| `axis.mode` | string | Drive mode: CSV, CSP or CSP_PC; defaults to CSV. | optional | CSV |
| `axis.parameters` | string | Additional motor driver options. `restoreMotorSoftLims=1;` lets initialized/autosave-restored motor dial limits override ECMC at startup and also enables ongoing synchronization. See [autosave]({{< relref "/manual/motion_cfg/autosave.md" >}}). — Additional motor driver options (e.g. powerAutoOnOff, powerOffDelay, powerOnDelay). `restoreMotorSoftLims=1;` enables startup restoration of motor dial limits and ongoing synchronization; see [autosave]({{< relref "/manual/motion_cfg/autosave.md" >}}). | optional | — |
| `axis.healthOutput` | string | EtherCAT entry for health output — EtherCAT entry for health output. | optional | — |
| `axis.feedSwitchesOutput` | string | EtherCAT entry for fed switches — EtherCAT entry for fed switches. | optional | — |
| `axis.feedSwitchesValue` | integer | Value to write to axis.feedSwitchesOutput. Defaults to 1 — Value written to `axis.feedSwitchesOutput`; defaults to 1. | optional | 1 |
| `axis.group` | string | Add axis to group (group will be created if it does not exist) — Group name; creates/uses a group and stores its id in `GRP_<axis.group>_ID`. See [Axis Groups]({{< relref "/manual/motion_cfg/axis_groups.md" >}}). | optional | — |
| `axis.autoMode` | mapping | Auto-switch drive modes for motion/homing. | optional | — |
| `axis.autoMode.modeSet` | string | EtherCAT entry drive mode write (set CSV,CSP,homing) — EtherCAT entry to write drive mode (CSV/CSP/homing). | optional | — |
| `axis.autoMode.modeAct` | string | EtherCAT entry drive mode reading (set CSV,CSP,homing) — EtherCAT entry reading drive mode. | optional | — |
| `axis.autoMode.modeCmdMotion` | integer | Drive mode value for normal motion (written to axis.drvMode.modeSet when normal motion) — Drive mode value used during normal motion. | optional | — |
| `axis.autoMode.modeCmdHome` | integer | Drive mode value for when homing (written to axis.drvMode.modeSet when homing) — Drive mode value used during homing. | optional | — |
| `axis.features` | mapping | Feature switches. | optional | — |
| `axis.features.blockCom` | boolean | Block communication to axis — Block communication to axis. | optional | — |
| `axis.features.allowSrcChangeWhenEnabled` | boolean | Allow traj/enc source change when axis is enabled — Allow trajectory/encoder source change while enabled. | optional | — |
| `axis.features.allowedFunctions.homing` | boolean | Allow homing — Allow homing. | optional | — |
| `axis.features.allowedFunctions.constantVelocity` | boolean | Allow constant velocity — Allow constant velocity mode. | optional | — |
| `axis.features.allowedFunctions.positioning` | boolean | Allow positioning — Allow positioning. | optional | — |
| `axis.autoEnable` | mapping | Native ecmc auto enable/disable. Preferred over motor record auto-enable. | optional | — |
| `axis.autoEnable.enableTimeout` | float | If defined, ecmc tries to auto-enable for a maximum enableTimeout seconds. — Try auto-enable for at most this many seconds. | optional | -1.0 |
| `axis.autoEnable.disableTimeout` | float | If defined, ecmc disables axis after idle (non busy) in disableTime seconds — Disable after being idle this many seconds. | optional | -1.0 |
| `axis.autoEnable.autoDisableLatchAtTarget` | boolean | Keep the auto-disable timer active after AtTarget has been asserted once — After the first AtTarget assertion, allow the auto-disable timer to continue if AtTarget is later lost (default false). | optional | false |
| `axis.autoEnable.atStartup` | boolean | Auto enable axis at ioc start, default False — Auto-enable at IOC start (default false). | optional | false |
| `axis.tweakDist` | float | Tweak value (both ecmc interface and motor record tweak value) — Tweak value for both ecmc and motor record. | optional | 1.0 |
| `axis.features.disableOnReset` | boolean | Disable the axis on error reset. | optional | — |
| `axis.features.alarmAtHardLimits` | boolean | Raise an axis error on hard-limit activation; recovery requires disabling this feature. | optional | — |

## epics

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `epics.name` | string | PV name suffix; defaults to axis. Set a unique name for each axis. | optional; unique name recommended | axis |
| `epics.precision` | integer | Decimal count — PREC; default 3. | optional | 3 |
| `epics.description` | string | Axis description — Axis description. | optional | — |
| `epics.unit` | string | Unit — EGU; default mm. | optional | mm |
| `epics.motorRecord` | mapping | Motor record block. | optional | — |
| `epics.motorRecord.enable` | boolean | Enable motor record — Enable motor record. | optional | true |
| `epics.motorRecord.description` | string | This is MR — Motor record description. | optional | — |
| `epics.motorRecord.fieldInit` | string | Extra config for motor record — Additional motor record fields. | optional | — |
| `epics.motorRecord.syncSoftLimits` | boolean | Sync softlimits between motor and ecmc (default false; `restoreMotorSoftLims=1` overrides this to enabled). When synchronization is disabled, motor record HLM/LLM and ecmc soft limits may differ. On false->true, ecmc soft limits are copied to the motor record; while true, later motor record soft-limit changes are written back to ecmc. — Sync soft limits between motor record and ecmc (default false; `restoreMotorSoftLims=1` overrides this to enabled). When synchronization is disabled, motor record `HLM`/`LLM` and ecmc soft limits may differ. On false-to-true, ecmc soft limits are copied to the motor record; while true, later motor record soft-limit changes are written back to ecmc. | optional | false |
| `epics.motorRecord.restoreSoftLimits` | boolean | Restore motor DLLM/DHLM into ecmc at startup and keep the two interfaces synchronized; see the autosave guide. — Allow initialized or autosave-restored motor dial limits to override the YAML-derived ecmc limits during startup. This also enables ongoing motor/ecmc soft-limit synchronization; use with the documented startup gate and autosave request files. | optional; startup policy | false |
| `epics.motorRecord.pvt` | mapping | PVT/profile-move support. | optional | — |
| `epics.motorRecord.pvt.npoints` | integer | Max number of target points for PVT/profile move — Max number of target points. | optional | 0 |
| `epics.motorRecord.pvt.nreadback` | integer | Max number of readback points for PVT/profile move — Max number of readback points. | optional | 0 |

## drive

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `drive.numerator` | integer / float | Drive scale numerator; CSV uses velocity scaling, CSP uses position scaling. The schema default 0 is not a usable hardware scale. | optional; configure scaling explicitly | 0 |
| `drive.denominator` | integer | Drive scale denominator; configure it together with numerator for the selected drive mode. | optional | 1 |
| `drive.type` | integer | Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives) — 0=stepper, 1=DS402 (servo/advanced stepper). | optional | 0 |
| `drive.control` | string | Control word EtherCAT entry — Control word EtherCAT entry. | required | — |
| `drive.enable` | integer | Enable bit index; non-DS402 defaults to bit 0 with a warning. Ignored for DS402. | optional; non-DS402 only | 0 |
| `drive.enabled` | integer | Enabled status bit index; non-DS402 defaults to bit 1 with a warning. Ignored for DS402. | optional; non-DS402 only | 1 |
| `drive.status` | string | Status word EtherCAT entry — Status word EtherCAT entry. | required | — |
| `drive.setpoint` | string | Velocity setpoint if CSV. Position setpoint if CSP. `F32`/`F64` CSV setpoints are supported; `F32`/`F64` CSP setpoints require the selected CSP encoder actual-position entry to use the same datatype. — Velocity setpoint if CSV; position setpoint if CSP. `F32`/`F64` CSV setpoints are supported. `F32`/`F64` CSP setpoints require the selected CSP encoder actual-position entry to use the same datatype. | required | — |
| `drive.reduceTorque` | integer | Reduce-torque control bit; requires reduceTorqueEnable and control. | optional | — |
| `drive.reduceTorqueEnable` | boolean | Enable reduce-torque handling; requires reduceTorque and control. | optional | — |
| `drive.brake` | mapping | Brake control block. | optional | — |
| `drive.brake.enable` | boolean | Enable brake control. | required when drive.brake is present | — |
| `drive.brake.output` | string | EtherCAT link to brake output — EtherCAT link to brake output. | required when drive.brake is present | — |
| `drive.brake.openDelay` | integer | Brake timing parameter in cycles (default 1kHz) — Brake open delay in cycles. | optional | 0 |
| `drive.brake.closeAhead` | integer | Brake timing parameter in cycles (default 1kHz) — Brake close-ahead time in cycles. | optional | 0 |
| `drive.reset` | integer | Reset (if no drive reset bit then leave empty) — Reset bit. | optional | — |
| `drive.warning` | integer | Warning (if no drive warning bit then leave empty) — Warning bit. | optional | — |
| `drive.error` | list | Up to three error bit indices or full EtherCAT paths. Omit unused entries; do not use empty/null list items. The schema requires status when error is supplied. | optional, up to 3 entries | — |
| `drive.lookuptable` | mapping | Position-dependent CSV output compensation; see the drive output lookup-table guide. | optional; CSV only | — |
| `drive.lookuptable.filename` | string | Load position-dependent CSV drive-output compensation table. — Two-column LUT file: actual position and drive-command offset, both in engineering units. | required when drive.lookuptable is present | — |
| `drive.lookuptable.enable` | boolean | Enable or disable drive lookup-table compensation. — Enable compensation; a valid loaded table is enabled by default. | optional | true after a valid table is loaded (ecmc) |
| `drive.lookuptable.scale` | integer / float | Scale or invert the compensation value. — Multiplier applied to the engineering-unit LUT output before normal drive scaling. | optional | 1.0 |
| `drive.lookuptable.range` | integer / float | Optional modulo range in axis position engineering units. — Positive modulo range applied to actual position before lookup; zero disables wrapping. | optional | 0 |

## encoder

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `encoder.numerator` | integer / string / float | Encoder scale numerator in engineering units. The schema default 0 is not a usable hardware scale. | optional; configure scaling explicitly | 0.0 |
| `encoder.denominator` | integer | Scaling denominator example 4096 ticks per 360 degree — Scaling denominator (e.g. ticks per rev). | optional | 1 |
| `encoder.type` | integer | Type: 0=Incremental, 1=Absolute — 0=incremental, 1=absolute. | optional | 0 |
| `encoder.bits` | integer | Bit count used for ecmc's encoder value; does not alter the raw EtherCAT slave value — Bit count used for ecmc's encoder value; it does not alter the raw EtherCAT slave value. | optional | 16 |
| `encoder.absBits` | integer | Absolute bit count (for absolute encoders) always least significant part of 'bits' — Absolute bit count (LSBs of `bits`). | optional | 25 |
| `encoder.absOffset` | integer / float / string | Encoder offset in eng units (for absolute encoders) — Offset in engineering units for absolute encoders. | optional | 0.0 |
| `encoder.mask` | string | Mask applied to ecmc's encoder value; the original EtherCAT value remains visible in the hardware PVs — Mask applied to ecmc's encoder value, not the raw EtherCAT slave value. The original value remains visible in the EtherCAT hardware PVs. | optional | — |
| `encoder.position` | string | EtherCAT entry for actual position input (encoder). `F32`/`F64` actual-position entries are only valid for absolute encoders (`encoder.type: 1`). Keep `encoder.bits` and `encoder.absBits` aligned with the datatype width (`32`/`32` or `64`/`64`). — EtherCAT entry for actual position. `F32`/`F64` actual-position entries are only valid for absolute encoders (`type: 1`). Keep `bits` and `absBits` aligned with the datatype width (`32`/`32` or `64`/`64`). | required for EtherCAT position feedback (source 0) | — |
| `encoder.control` | string | Mandatory only if 'reset' is used — Encoder control word entry. | optional; required if reset is used | — |
| `encoder.status` | string | Encoder status word entry; required with ready, warning or error. | required with ready, warning or error | — |
| `encoder.ready` | integer | Bit in encoder status word for encoder ready — Status bit for encoder ready. | optional | — |
| `encoder.source` | integer | 0 = Encoder value from EtherCAT hardware, 1 = Encoder value from PLC — 0=from EtherCAT hardware, 1=from PLC. | optional | 0 |
| `encoder.reset` | integer | Reset — Reset bit. | optional | — |
| `encoder.warning` | integer | Warning — Warning bit. | optional | — |
| `encoder.error` | list | Up to three error bit indices or full EtherCAT paths. Omit unused entries; do not use empty/null list items. The schema requires status when error is supplied. | optional, up to 3 entries | — |
| `encoder.filter` | mapping | Encoder filtering uses nested velocity and position blocks, each with size and enable. See the encoder-filter example in the YAML configuration guide. | optional | — |
| `encoder.filter.velocity.size` | integer | Velocity filter window in EtherCAT samples/cycles; applies when encoder.filter.velocity is supplied. | optional | 100 |
| `encoder.filter.velocity.enable` | boolean | Enable the encoder velocity filter; defaults to true when encoder.filter.velocity is supplied. | optional | true |
| `encoder.filter.position.size` | integer | Position filter window in EtherCAT samples/cycles; applies when encoder.filter.position is supplied. | optional | 10 |
| `encoder.filter.position.enable` | boolean | Enable the encoder position filter; defaults to true when encoder.filter.position is supplied. | optional | true |
| `encoder.latch` | mapping | Homing latch settings. For EL7062/ED7062 touch-probe use outside homing, prefer the separate `touchProbe` section. | optional | — |
| `encoder.latch.position` | string | Link to latched value. Used for some homing seqs — Latched value link. | required when encoder.latch is present | — |
| `encoder.latch.timestamp` | string | Optional 32/64-bit DC timestamp for the same latch event — Optional DC timestamp for the same latch event. | optional | — |
| `encoder.latch.control` | integer | Bit in encoder control word to arm latch. Used for some homing seqs — Control bit to arm latch. | optional | 0 |
| `encoder.latch.status` | integer | Bit in encoder status word for latch triggered status. Used for some homing seqs — Status bit for latch triggered. | optional | 0 |
| `encoder.latch.armCmd` | integer | Value in dec to arm latch to write to encoder.control — Value written to `encoder.control` to arm latch. | optional | 1 |
| `encoder.latch.armBits` | integer | Bit size of encoder.latch.armCmd — Bit length of `armCmd`. | optional | 1 |
| `encoder.touchProbe` | mapping | Encoder touch-probe mapping separate from homing latch. | optional | — |
| `encoder.touchProbe.position` | string | Link to touch-probe latched position. Used for touch-probe functionality separate from homing latch. — Latched touch-probe position entry. | required when encoder.touchProbe is present | — |
| `encoder.touchProbe.timestamp` | string | Optional 32/64-bit DC timestamp for the same touch-probe edge — Optional 32- or 64-bit DC timestamp entry for the same edge. | optional | — |
| `encoder.touchProbe.control` | string | Touch-probe control word entry — Touch-probe control word entry. | required when encoder.touchProbe is present | — |
| `encoder.touchProbe.controlBit` | integer | First bit in touch-probe control word to write `armBits` bits from `armCmd`; default 0 — First bit to write in the control word (default `0`). | optional | 0 |
| `encoder.touchProbe.status` | string | Touch-probe status word entry — Touch-probe status word entry. | required when encoder.touchProbe is present | — |
| `encoder.touchProbe.statusBit` | integer | Status bit for captured touch-probe event; default 0 — Status bit that indicates a captured event (default `0`). | optional | 0 |
| `encoder.touchProbe.armCmd` | integer | Value in dec to arm touch probe; default 17 for EL7062/ED7062 TP1 positive edge — Value written to arm the touch probe (default `17`, EL7062/ED7062 TP1 positive edge). | optional | 17 |
| `encoder.touchProbe.armBits` | integer | Bit size of encoder.touchProbe.armCmd; default 5 — Number of bits written from `armCmd` (default `5`). | optional | 5 |
| `encoder.primary` | boolean | Use this encoder as primary (for control) — Use as primary encoder for control. | optional | — |
| `encoder.useAsCSPDrvEnc` | boolean | Use this encoder as CSP drive encoder (ecmc controller enabled in CSP) — Use as CSP drive encoder when controller enabled in CSP. | optional | — |
| `encoder.allowOverUnderFlow` | boolean | Allow over/under flow of encoder raw counter (default true). Set to false for linear encoders. | optional | true (ecmc default; no YAML command if omitted) |
| `encoder.homing` | mapping | Encoder homing settings. | optional | — |
| `encoder.homing.type` | integer | Homing sequence type — Homing sequence type. | optional | — |
| `encoder.homing.position` | integer / float / string | Position to reference encoder to — Referenced position. | optional | — |
| `encoder.homing.velocity.to` | integer / float | Velocity to cam/sensor (used for some homing seqs) — Velocity to cam/sensor. | optional | — |
| `encoder.homing.velocity.from` | integer / float | Velocity from cam/sensor (used for some homing seqs) — Velocity off cam/sensor. | optional | velocity.to |
| `encoder.homing.acceleration` | integer / float (schema typo) | Homing acceleration in engineering units/s². | optional | — |
| `encoder.homing.deceleration` | integer / float | Homing deceleration in engineering units/s². | optional | — |
| `encoder.homing.refToEncIDAtStartup` | integer | Encoder id used as startup position reference; -1 disables copying. | optional | -1 |
| `encoder.homing.refAtHome` | integer | Enable referencing this encoder at homing (integer flag, default 0). | optional | 0 |
| `encoder.homing.tolToPrim` | integer / float | If set then this is the max allowed tolerance between prim encoder and this encoder — Max tolerance vs primary encoder. | optional | 0 |
| `encoder.homing.postMoveEnable` | boolean | Enable post-homing move; true requires postMovePosition. | optional | no command if omitted |
| `encoder.homing.postMovePosition` | integer / float / string | Post-homing target in engineering units; required when postMoveEnable is true. | required when postMoveEnable is true | no target inferred |
| `encoder.homing.trigg` | string | EtherCAT entry for triggering drive internal homing seq (seq id 26) — EtherCAT entry to trigger drive internal homing sequence. | optional | — |
| `encoder.homing.ready` | string | EtherCAT entry for reading drive internal homing seq ready (seq id 26) — Status entry for drive internal homing ready. | optional | — |
| `encoder.homing.latchCount` | integer | Latch count offset for homing. | optional | — |
| `encoder.delayComp` | mapping | Delay compensation between set and act. | optional | — |
| `encoder.delayComp.time` | integer / float | Delay time between set and act [cycles] — Delay time in cycles. | required when encoder.delayComp is present | — |
| `encoder.delayComp.enable` | boolean | enable (defaults to 1 if not set) — Enable flag (defaults to true if set). | optional | true |
| `encoder.lookuptable` | mapping | Correction lookup table (applied when homed). | optional | — |
| `encoder.lookuptable.filename` | string | Load correction lookup table file. Value will be subtracted from encoder value. — LUT file; value subtracted from encoder value. | required when encoder.lookuptable is present | — |
| `encoder.lookuptable.enable` | boolean | Enable lookup table (defaults to true when loaded); use a YAML boolean. | optional | true after a valid table is loaded (ecmc) |
| `encoder.lookuptable.scale` | integer / float | Scale applied to LUT (if you want value to be added then set scale to -1.0) — LUT scale; set to -1.0 to add instead of subtract. | optional | no command if omitted |
| `encoder.lookuptable.range` | integer / float | LUT modulo value (LUT should cover the range 0..range) — Modulo range the LUT covers. | optional | no command if omitted |
| `encoder.desc` | string | Encoder description. | optional | — |
| `encoder.unit` | string | Encoder engineering unit. | optional | — |
| `encoder.homing.timeout` | integer | Homing sequence timeout in seconds. | optional | — |
| `encoder.power.enable` | boolean | Enable automatic encoder relay power control. — Enable automatic encoder relay power control. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). | optional; see encoder power configuration | false |
| `encoder.power.output` | string | Writable EtherCAT bit path; required when enabled. A supplied output is also linked when enable is false. — Writable EtherCAT bit path; required when enabled. A supplied output is also linked when enable is false. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). | optional; see encoder power configuration | — |
| `encoder.power.activeHigh` | boolean | Logical ON writes 1 when true, 0 when false. — Logical ON writes 1 when true, 0 when false. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). | optional; see encoder power configuration | true |
| `encoder.power.startupDelay` | integer / float | Minimum warm-up delay, seconds. — Minimum warm-up delay, seconds. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). | optional; see encoder power configuration | 0.1 |
| `encoder.power.startupTimeout` | integer / float | Maximum wake time, seconds; greater than startupDelay. — Maximum wake time, seconds; greater than startupDelay. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). | optional; see encoder power configuration | 5.0 |
| `encoder.power.idleDelay` | integer / float | Continuous atTarget/tighter-deadband dwell before off, seconds. — Continuous atTarget/tighter-deadband dwell before off, seconds. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). | optional; see encoder power configuration | 2.0 |
| `encoder.power.backup.encoder` | integer | Always-powered incremental backup index (checked at final startup validation), 1…8. — Always-powered incremental backup index (checked at final startup validation), 1…8. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). | optional; see encoder power configuration | — |
| `encoder.power.backup.maxPositionDifference` | integer / float | Positive permitted wake discrepancy, engineering units. — Positive permitted wake discrepancy, engineering units. See [encoder power control]({{< relref "/manual/motion_cfg/encoder_power.md" >}}). | optional; see encoder power configuration | — |

## controller

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `controller.Kp` | integer / float | Kp proportional gain — Proportional gain. | optional | 1 |
| `controller.Ki` | integer / float (schema typo) | Ki integral gain — Integral gain. | optional | 0 |
| `controller.Kd` | integer / float | Kd derivative gain — Derivative gain. | optional | 0 |
| `controller.Kff` | integer / float | Feed forward gain — Feed-forward gain. | optional | 1 |
| `controller.resetIAtRmp` | boolean | Reset the integral part to zero while an internal trajectory is busy. | optional | no command if omitted |
| `controller.freezeIAtRmp` | boolean | Freeze the integral part at its current value while an internal trajectory is busy. | optional | no command if omitted |
| `controller.deadband.tol` | integer / float | Deadband tolerance in engineering units; supply together with time. | optional | — |
| `controller.deadband.time` | integer / float | Deadband time in EtherCAT cycles; supply together with tol. | optional | — |
| `controller.limits.minOutput` | integer / float | Minimum controller output. Output limiting is active only when `maxOutput > minOutput`; `minOutput=0` and `maxOutput=0` disables it. — Output clamps. Active only when `maxOutput > minOutput`; both `0` disables the limits. | optional | — |
| `controller.limits.maxOutput` | integer / float | Maximum controller output. Output limiting is active only when `maxOutput > minOutput`; `minOutput=0` and `maxOutput=0` disables it. | optional | — |
| `controller.limits.minIntegral` | integer / float | Minimum integral output. Integral limiting is active only when `maxIntegral > minIntegral`; `minIntegral=0` and `maxIntegral=0` disables it. — Integral clamps. Active only when `maxIntegral > minIntegral`; both `0` disables the limits. | optional | — |
| `controller.limits.maxIntegral` | integer / float | Maximum integral output. Integral limiting is active only when `maxIntegral > minIntegral`; `minIntegral=0` and `maxIntegral=0` disables it. | optional | — |
| `controller.inner.Kp` | integer / float | Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. | optional | 1.0 |
| `controller.inner.Ki` | integer / float | Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. | optional | 0 |
| `controller.inner.Kd` | integer / float | Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. | optional | 0 |
| `controller.inner.tol` | integer / float | Inner PID used near target. Defaults when inner is present: Kp=1, Ki=0, Kd=0, tol=0; set tol explicitly to select the inner control band. | optional | 0 |

## trajectory

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `trajectory.type` | integer | Default 0 = trapezoidal, 1 = S-curve (ruckig) — 0=trapezoidal, 1=s-curve (ruckig); defaults to trapezoidal. | optional | 0 |
| `trajectory.source` | integer | 0 = take trajectory setpoint from axis traj object, 1 = trajectory setpoint from plc — 0=trajectory generator, 1=PLC source. | optional | 0 |
| `trajectory.axis.velocity` | integer / float | Default velocity for axis — Default velocity. | required | — |
| `trajectory.axis.acceleration` | integer / float | Default acceleration for axis — Default acceleration. | required | — |
| `trajectory.axis.deceleration` | integer / float | Deceleration in engineering units/s²; defaults to axis acceleration. | optional | trajectory.axis.acceleration |
| `trajectory.axis.emergencyDeceleration` | integer / float | Emergency deceleration in engineering units/s²; defaults to ten times the greater of axis acceleration and deceleration. | optional | 10 × max(acceleration, deceleration) |
| `trajectory.axis.jerk` | integer / float | S-curve jerk in engineering units/s³; the fallback is numerically equal to axis acceleration. | optional | trajectory.axis.acceleration |
| `trajectory.jog.velocity` | integer / float | Default velocity for JOG (motor record) — Default jog velocity (motor record). | optional | ECMC: axis.velocity; motor record: axis.velocity / 10 |
| `trajectory.modulo.range` | integer / float | Modulo range 0..360 — Modulo range. | optional | 0.0 |
| `trajectory.modulo.type` | integer | Modulo type — Modulo type. | optional | 0 |
| `trajectory.jog.acceleration` | integer / float | Jog acceleration for the motor record. The ECMC trajectory template does not set a separate jog acceleration. | optional; motor record only | trajectory.axis.acceleration (motor record only) |

## touchProbe

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `touchProbe.position` | string | Link to touch-probe latched position. Used for touch-probe functionality separate from homing latch. — Latched touch-probe position entry. | required when touchProbe is present | — |
| `touchProbe.timestamp` | string | Optional 32/64-bit DC timestamp for the same touch-probe edge — Optional 32- or 64-bit DC timestamp entry for the same edge. | optional | — |
| `touchProbe.control` | string | Touch-probe control word entry — Touch-probe control word entry. | required when touchProbe is present | — |
| `touchProbe.controlBit` | integer | First bit in touch-probe control word to write `armBits` bits from `armCmd`; default 0 — First bit to write in the control word (default `0`). | optional | 0 |
| `touchProbe.status` | string | Touch-probe status word entry — Touch-probe status word entry. | required when touchProbe is present | — |
| `touchProbe.statusBit` | integer | Status bit for captured touch-probe event; default 0 — Status bit that indicates a captured event (default `0`). | optional | 0 |
| `touchProbe.armCmd` | integer | Value in dec to arm touch probe; default 17 for EL7062/ED7062 TP1 positive edge — Value written to arm the touch probe (default `17`, EL7062/ED7062 TP1 positive edge). | optional | 17 |
| `touchProbe.armBits` | integer | Bit size of touchProbe.armCmd; default 5 — Number of bits written from `armCmd` (default `5`). | optional | 5 |

## positionCompare

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `positionCompare.output` | string | EtherCAT output entry to schedule, for example an EL2252 binary output — EtherCAT output entry to schedule, for example an EL2252 binary output. | required when positionCompare is present | — |
| `positionCompare.activate` | string | EtherCAT activation/control entry used by the timed-output terminal — EtherCAT activation/control entry used by the timed-output terminal. | required when positionCompare is present | — |
| `positionCompare.startTime` | string | EtherCAT DC start-time entry; use a 64-bit integer entry/PV for EL2252 — EtherCAT DC start-time entry. Use a 64-bit integer PV/entry for EL2252 start time. | required when positionCompare is present | — |
| `positionCompare.minLeadMs` | float | Minimum scheduling lead time [ms], default 2.0 — Minimum allowed scheduling lead time in milliseconds (default `2.0`). | optional | 2.0 |
| `positionCompare.maxLeadMs` | float | Maximum scheduling lead time [ms], default 100.0 — Maximum allowed scheduling lead time in milliseconds (default `100.0`). | optional | 100.0 |
| `positionCompare.activateIdle` | integer | Activation value written while idle, default 3 for EL2252 — Activation value written while idle (default `3` for EL2252). | optional | 3 |
| `positionCompare.activateSchedule` | integer | Activation value written for one cycle to load a schedule, default 0 for EL2252 — Activation value written for one cycle to load a new schedule (default `0` for EL2252). | optional | 0 |
| `positionCompare.pulseWidthMs` | float | Optional automatic reset pulse width [ms], default 0. Fractions such as 0.5 are allowed. — If greater than zero, schedule an automatic reset after this pulse width in milliseconds. Fractions such as `0.5` are allowed. | optional | 0.0 |
| `positionCompare.resetValue` | integer | Output value for automatic reset after pulseWidthMs, default 0 — Output value used for the automatic reset (default `0`). | optional | 0 |

## input

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `input.limit.forward` | string | EtherCAT entry for low limit switch input — Forward limit switch entry. | required | — |
| `input.limit.forwardPolarity` | integer | Polarity of forward limit switch — Forward limit polarity. | optional | — |
| `input.limit.backward` | string | EtherCAT entry for high limit switch input — Backward limit switch entry. | required | — |
| `input.limit.backwardPolarity` | integer | Polarity of backward limit switch — Backward limit polarity. | optional | — |
| `input.home` | string | Home switch entry. Omit when unused; no sensor link is generated and the panel link is N/A. | optional | — |
| `input.homePolarity` | integer | Home switch polarity; used only when input.home is linked to hardware. | optional | — |
| `input.interlock` | string | EtherCAT entry for interlock switch input — Interlock input entry. | optional | — |
| `input.interlockPolarity` | integer | Polarity of interlock switch — Interlock polarity. | optional | — |
| `input.analog` | mapping | Analog interlock block. | optional | — |
| `input.analog.interlock` | string | EtherCAT entry for analog interlock — Analog interlock entry. | optional | — |
| `input.analog.interlockPolarity` | integer | 0: High value is bad, 1 = Low value is bad — 0: high is bad; 1: low is bad. | optional | — |
| `input.analog.rawLimit` | integer / float | Analog raw limit — Raw analog limit. | optional | — |
| `input.analog.enable` | boolean | Enable analog interlock default true if analog.interlock is set — Enable analog interlock (default true if set). | optional | true when interlock is linked |
| `input.limit.latchInput` | boolean | Latch/debounce the limit inputs. | optional | — |

## softlimits

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `softlimits.enable` | boolean | Enable soft limits — Global soft limit enable. | optional | Python: not supplied; ECB: false |
| `softlimits.forward` | integer / float | Soft limit position fwd — Forward soft limit. | required with forwardEnable | — |
| `softlimits.forwardEnable` | boolean | Soft limit position fwd enable — Forward soft limit enable. | required with forward; also requires enable | — |
| `softlimits.backward` | integer / float | Soft limit position bwd — Backward soft limit. | required with backwardEnable | — |
| `softlimits.backwardEnable` | boolean | Soft limit position bwd enable — Backward soft limit enable. | required with backward; also requires enable | — |

## monitoring

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `monitoring.lag.enable` | boolean | Enable position lag monitoring (following error) — Following-error monitoring; time is in EtherCAT cycles. An omitted lag block defaults to disabled when monitoring is present. | optional block; Python requires enable, tolerance and time if explicitly supplied | false when lag block omitted |
| `monitoring.lag.tolerance` | integer / float | Allowed tolerance | optional block; Python requires enable, tolerance and time if explicitly supplied | 0 when lag block omitted |
| `monitoring.lag.time` | integer | Allowed time outside tolerance (EtherCAT cycles) | optional block; Python requires enable, tolerance and time if explicitly supplied | 100 when lag block omitted |
| `monitoring.target.enable` | boolean | Enable at target monitoring (needs to be enabled and configured if using motor record) — At-target monitoring; enable it for motor-record completion detection. Time is in EtherCAT cycles. | optional block; supply enable, tolerance and time together | Python: required in block; ECB: false |
| `monitoring.target.tolerance` | integer / float | Allowed tolerance | optional block; supply enable, tolerance and time together | — |
| `monitoring.target.time` | integer | Filter time inside tolerance to be at target (EtherCAT cycles) | optional block; supply enable, tolerance and time together | — |
| `monitoring.target.slaveControlDeadband.tolerance` | integer / float | Master-axis tolerance forwarded to slaves for reduced-torque control; defaults to AtTarget tolerance — Independent live master-axis error band and qualification time forwarded to slaves for control-deadband decisions such as reduced torque. Configure these keys on the master axis. They apply to physical and virtual masters and may be tighter or slower than ordinary AtTarget. If omitted, ecmc uses the AtTarget tolerance and time. Example: `slaveControlDeadband: {tolerance: 0.01, time: 100}`. | required pair when slaveControlDeadband is present | monitoring.target.tolerance (ecmc) |
| `monitoring.target.slaveControlDeadband.time` | integer | Filter time inside slave-control deadband; defaults to AtTarget time (EtherCAT cycles) | required pair when slaveControlDeadband is present | monitoring.target.time (ecmc) |
| `monitoring.velocity.enable` | boolean | Enable velocity monitoring — Velocity monitoring. Times are in EtherCAT cycles. | optional block; supply enable, max and time.trajectory; time.drive optional | Python: required in block; ECB: false |
| `monitoring.velocity.max` | integer / float | Allowed max velocity | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocity.time.trajectory` | integer | Time allowed outside max velocity before system init halt (EtherCAT cycles) | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocity.time.drive` | integer | Time allowed outside max velocity before system disables drive (EtherCAT cycles) | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocityDifference.enable` | boolean | Enable velocity difference monitoring (velocity set vs velocity actual) — Velocity setpoint vs actual monitoring. Its trajectory and drive delays are independent of the maximum-velocity monitor. Times are in EtherCAT cycles. | optional block; supply enable, max and time.trajectory; time.drive optional | Python: required in block; ECB: false |
| `monitoring.velocityDifference.max` | integer / float | Allowed max difference | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocityDifference.time.trajectory` | integer | Time allowed outside max diff velo before system init halt (EtherCAT cycles) | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.velocityDifference.time.drive` | integer | Time allowed outside max diff velo before system disables drive (EtherCAT cycles) | optional block; supply enable, max and time.trajectory; time.drive optional | — |
| `monitoring.stall.enable` | integer | Python: boolean true/false; ECB: integer 1/0 — Stall monitoring requires target monitoring. Python uses boolean enable (true/false); ECB currently requires integer enable (1/0). timeout is in EtherCAT cycles; factor is dimensionless. | optional | — |
| `monitoring.stall.time.timeout` | integer | If not at target after "timeout" cycles after trajectory generator is ready then drive will disable | optional | — |
| `monitoring.stall.time.factor` | integer / float | Measures duration of last motion command (busy high edge to busy low edge). The new timeout will be defined as this duration multiplied by this factor. The timeout finally used for stall detection will be the longest (of time.timeout and calculated from time.factor). | optional | — |

## plc

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `plc.enable` | boolean | Enable the axis PLC; required by both axis-PLC schemas when the block is present. | required when axis plc is present | — |
| `plc.externalCommands` | boolean | Allow axis input from PLC — Allow external PLC commands. | optional | false |
| `plc.file` | string | File with plc code — PLC code file to include. | optional | — |
| `plc.code` | list | Inline PLC code list (appended after `plc.file` content); example shows enable logic and setpoint calculation. | optional | — |
| `plc.code[0]` | string (list item) | Enable axis if one of master axes is enabled | optional | — |
| `plc.code[1]` | string (list item) | Calculate set position for physical axis | optional | — |
| `plc.velocity_filter` | mapping | Velocity feedforward smoothing. | optional | — |
| `plc.velocity_filter.encoder.enable` | boolean | Filter enable — Filter PLC encoder velocity. | optional | false |
| `plc.velocity_filter.encoder.size` | integer | Filter size | optional | 1 |
| `plc.velocity_filter.trajectory.enable` | boolean | Filter enable — Filter PLC trajectory velocity. | optional | false |
| `plc.velocity_filter.trajectory.size` | integer | Filter size | optional | 1 |
| `plc.filter` | mapping | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.filter.velocity.enable` | boolean | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.filter.velocity.size` | integer | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.filter.trajectory.enable` | boolean | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.filter.trajectory.size` | integer | Deprecated filter syntax. Prefer plc.velocity_filter.encoder and plc.velocity_filter.trajectory. | optional; deprecated alias | — |
| `plc.macros` | string | Macros for an external axis PLC file. | optional | — |

## homing (legacy; prefer encoder.homing)

| Key | Type (ECB schema) | Description | Requirement | Default |
| --- | --- | --- | --- | --- |
| `homing.type` | integer | Homing sequence type — Homing sequence type. | optional | — |
| `homing.position` | integer / float / string | Position to reference encoder to — Referenced position. | optional | — |
| `homing.velocity.to` | integer / float | Velocity to cam/sensor (used for some homing seqs) — Velocity to cam/sensor. | optional | — |
| `homing.velocity.from` | integer / float | Velocity from cam/sensor (used for some homing seqs) — Velocity off cam/sensor. | optional | velocity.to |
| `homing.acceleration` | integer / float | Homing acceleration in engineering units/s². | optional | — |
| `homing.deceleration` | integer / float | Homing deceleration in engineering units/s². | optional | — |
| `homing.refToEncIDAtStartup` | integer | Encoder id used as startup position reference; -1 disables copying. | optional | -1 |
| `homing.refAtHome` | integer | Enable referencing this encoder at homing (integer flag, default 0). | optional | 0 |
| `homing.tolToPrim` | integer / float | If set then this is the max allowed tolerance between prim encoder and this encoder — Max tolerance vs primary encoder. | optional | 0 |
| `homing.postMoveEnable` | boolean | Enable post-homing move; true requires postMovePosition. | optional | no command if omitted |
| `homing.postMovePosition` | integer / float / string | Post-homing target in engineering units; required when postMoveEnable is true. | required when postMoveEnable is true | no target inferred |
| `homing.trigg` | string | EtherCAT entry for triggering drive internal homing seq (seq id 26) — EtherCAT entry to trigger drive internal homing sequence. | optional | — |
| `homing.ready` | string | EtherCAT entry for reading drive internal homing seq ready (seq id 26) — Status entry for drive internal homing ready. | optional | — |
| `homing.latchCount` | integer | Latch count offset for homing. | optional | — |
| `homing.timeout` | integer | Homing sequence timeout in seconds. | optional | — |

<!-- END GENERATED AXIS YAML REFERENCE -->
