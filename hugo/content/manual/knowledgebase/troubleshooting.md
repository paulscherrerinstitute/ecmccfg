+++
title = "Troubleshooting"
weight = 18
chapter = false
aliases = ["/manual/troubleshooting/"]
+++

## Scope
Use this page as the symptom-based index for the knowledge base. Start here when
you know the visible problem, but not yet which detailed page to use.

## Fast Routing
1. Check [panel]({{< relref "/manual/knowledgebase/panel.md" >}}) for overall status.
2. Check [ethercat command line interface]({{< relref "/manual/knowledgebase/ethercatCLI.md" >}}) if EtherCAT or slave state is in doubt.
3. Use the symptom groups below to pick the detailed page.

## Startup and EtherCAT
- **EtherCAT validation fails**: verify slave order/ids, confirm process image matches hardware, and check for missing power or ESTOP on drives.
  Use: [general]({{< relref "/manual/knowledgebase/general.md" >}}), [ethercat command line interface]({{< relref "/manual/knowledgebase/ethercatCLI.md" >}}), [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}})
- **IOC will not start after partial hardware failure**: fix cabling and power first; restarting with missing slaves can leave the IOC unusable.
  Use: [general]({{< relref "/manual/knowledgebase/general.md" >}}), [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}})
- **No slaves are visible or link is down**:
  Use: [ethercat command line interface]({{< relref "/manual/knowledgebase/ethercatCLI.md" >}}), [host / ecmc server]({{< relref "/manual/knowledgebase/host.md" >}}), [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}})

- **`0x002D: "No Sync Error"` and DC slaves remain in `SAFEOP + ERROR`**:
  A known cause is connecting the incoming EtherCAT cable to the coupler's
  downstream/output port instead of its upstream/input port. Slaves may still
  be detected, but the reversed topology can prevent Distributed Clocks (DC)
  from synchronizing. The IOC may then fail to start and report:

  ```text
  Failed to set OP state, slave refused state change (SAFEOP + ERROR).
  AL status message 0x002D: "No Sync Error".
  ```

  Check the coupler's port labels or direction arrows: the cable from the
  controller or preceding slave must enter **IN**, and **OUT** must lead to the
  next slave. Do not assume the direction is correct merely because the link
  is up or `ethercat slaves` finds the terminals. After correcting the cable,
  power-cycle the affected coupler/terminals if necessary, restart the IOC,
  and verify that the slaves reach `OP`.

  A reversed coupler connection is one known cause, not the only cause of
  `0x002D`. If the ports are correct, continue by checking the configured DC
  cycle time, application timing/jitter, link quality, and EtherCAT topology.
  See also the [EL72xx hardware note]({{< relref "/manual/knowledgebase/hardware/EL72xx.md" >}}).

- **Slaves remain in an error state**: power-cycle the affected slaves. You can
  also try `ethercat rescan -<master_id>`. Always specify the master ID;
  otherwise, the command rescans every master on the host and may cause error
  messages in other IOCs.
- **Slaves repeatedly appear and disappear**: check for grounding issues. In
  observed cases, connecting an oscilloscope to measure signals interrupted
  EtherCAT communication. If possible, use a differential probe and avoid an
  external ground reference.

## Motion and Axis Behavior
- **Axis will not enable**: check auto-enable strategy, STO/brake signals, and drive readiness.
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}})
- **Axis will not move and reports `ERROR_AXIS_HW_NOT_READY`**: either the
  drive hardware or the currently selected encoder hardware is reporting that
  it is not ready. Check the hardware state. For the encoder, also verify that
  it provides a valid position value. If an open-loop encoder is configured,
  motion may still be possible by selecting the open-loop encoder as the
  primary encoder used for control.
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}}), [YAML encoder settings]({{< relref "/manual/motion_cfg/axisYaml.md#encoder" >}})
- **Axis moves in the wrong direction**:
  Use: [direction]({{< relref "/manual/motion_cfg/direction.md" >}}), [motion]({{< relref "/manual/knowledgebase/motion.md" >}})
- **Homing stalls or never completes**:
  Use: [homing]({{< relref "/manual/motion_cfg/homing.md" >}}), [motion]({{< relref "/manual/knowledgebase/motion.md" >}})
- **Soft limits are not respected**:
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [yaml configuration]({{< relref "/manual/motion_cfg/axisYaml.md" >}})
- **Following error, stall, or poor motion quality**:
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [tuning]({{< relref "/manual/knowledgebase/tuning.md" >}})
- **Axis stops close to the target without reaching it**: a small position error,
  combined with a low proportional gain, can become a zero velocity setpoint
  after output scaling or quantization. Increase `Kp`, add a small `Ki`, or
  reduce the controller deadband tolerance so that position correction remains
  active near the target.
  Use: [tuning: axis stops close to target]({{< relref "/manual/knowledgebase/tuning.md#axis-stops-close-to-target" >}}), [YAML controller settings]({{< relref "/manual/motion_cfg/axisYaml.md#controller" >}})
- **Encoder raw value differs from the EtherCAT slave value**: `encoder.bits`
  and `encoder.mask` apply to the encoder value derived inside ecmc; they do
  not modify the raw EtherCAT process-data value. Compare with the EtherCAT
  hardware PV to inspect the original value received from the slave.
  Use: [yaml configuration]({{< relref "/manual/motion_cfg/axisYaml.md#encoder" >}}), [scaling]({{< relref "/manual/motion_cfg/scaling.md#encoder-scaling" >}})

## PLC and Scripting
- **Limit logic overrides do not behave as expected**: when using `plcOverride`, verify that PLC code writes `ax<id>.mon.lowlim/highlim` correctly.
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [PLC configuration]({{< relref "/manual/PLC_cfg/_index.md" >}})
- **Startup scripts or verification scripts behave unexpectedly**: review `SCRIPTEXEC` use and macro expansion.
  Use: [general]({{< relref "/manual/knowledgebase/general.md" >}}), [Script Reference]({{< relref "/manual/general_cfg/script_reference.md" >}})

## Diagnostics Tools
- Use the [RT logger diagnostics]({{< relref "/manual/general_cfg/rt_logger_diagnostics.md" >}})
  to trace motion commands through the motor-record request, ecmc request, and
  execute stages, inspect blockers, and create a YAML motion-state dump.
- Use the hardware diagnostics guide for `ec_diagnostic_messages.py` usage and interpretation:
  [Diagnostics]({{< relref "/manual/knowledgebase/hardware/Diag.md" >}})
- Use `read_el70xx_diag.sh` or `read_el5042_diag.sh` for Beckhoff drives/encoders.
- Check `iocsh` output for YAML lint/schema errors.

## Error Code Quick Map
| Error | Typical cause |
|---|---|
| `ERROR_MON_BOTH_LIMIT_INTERLOCK` | 24V feed for limits missing, cabling issue. |
| `ERROR_MON_MAX_VELOCITY_EXCEEDED` | Velocity too high, configuration mismatch, or encoder malfunction. |
| `ERROR_MON_POS_LAG_INTERLOCK` | Following error, motion blocked, configuration mismatch (tolerance too tight). |
| `ERROR_MON_STALL` | Axis did not reach `atTarget` after motion finished. Check for motor stall, too-low near-target controller output, unstable mechanics, or too-tight at-target/stall timing. See [motion]({{< relref "/manual/knowledgebase/motion.md#error_mon_stall" >}}). |
| `ERROR_MON_TOL_OUT_OF_RANGE` | Invalid monitor tolerance or limit window, for example calculated virtual-axis softlimits outside the valid range. See [motion]({{< relref "/manual/knowledgebase/motion.md#error_mon_tol_out_of_range" >}}). |
| `ERROR_DRV_HW_ALARM_X` | Hardware error, missing power supply; check dedicated hardware panels. |
| `ERROR_ENC_NOT_READY` | Encoder issue, cabling issue, or missing power supply. |
| `ERROR_AXIS_HW_NOT_READY` | The drive or currently selected encoder hardware is not ready; check its state and verify that the encoder provides a valid position value. |
| `ERROR_EC_LINK_DOWN` | EtherCAT cabling issue, slave power missing. |
| `ERROR_EC_STATUS_NOT_OK` | EtherCAT cabling issue, slave power missing. |
| `ERROR_EC_MAIN_DOMAIN_DATA_FAILED` | EtherCAT cabling issue, slave power missing. |
| `ERROR_MAIN_ASYN_CREATE_PARAM_FAIL` (`0x20044`) | The asyn parameter table is full. Increase `MAX_PARAM_COUNT`; see [Asyn Parameter Count Exceeded]({{< relref "/manual/knowledgebase/general.md#asyn-parameter-count-exceeded" >}}). Sometimes referred to as `ECMC_MAIN_ASYN_CREATE_PARAM_FAIL`. |
| `ERROR_AXIS_SLAVED_AXIS_INTERLOCK` | Slaved axis in error (synchronized axes). |

## Related Pages
- [knowledge base]({{< relref "/manual/knowledgebase/_index.md" >}})
- [panel]({{< relref "/manual/knowledgebase/panel.md" >}})
- [ethercat command line interface]({{< relref "/manual/knowledgebase/ethercatCLI.md" >}})
