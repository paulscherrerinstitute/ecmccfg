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

## Motion and Axis Behavior
- **Axis will not enable**: check auto-enable strategy, STO/brake signals, and drive readiness.
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}})
- **Axis moves in the wrong direction**:
  Use: [direction]({{< relref "/manual/motion_cfg/direction.md" >}}), [motion]({{< relref "/manual/knowledgebase/motion.md" >}})
- **Homing stalls or never completes**:
  Use: [homing]({{< relref "/manual/motion_cfg/homing.md" >}}), [motion]({{< relref "/manual/knowledgebase/motion.md" >}})
- **Soft limits are not respected**:
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [yaml configuration]({{< relref "/manual/motion_cfg/axisYaml.md" >}})
- **Following error, stall, or poor motion quality**:
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [tuning]({{< relref "/manual/knowledgebase/tuning.md" >}})

## PLC and Scripting
- **Limit logic overrides do not behave as expected**: when using `plcOverride`, verify that PLC code writes `ax<id>.mon.lowlim/highlim` correctly.
  Use: [motion]({{< relref "/manual/knowledgebase/motion.md" >}}), [PLC configuration]({{< relref "/manual/PLC_cfg/_index.md" >}})
- **Startup scripts or verification scripts behave unexpectedly**: review `SCRIPTEXEC` use and macro expansion.
  Use: [general]({{< relref "/manual/knowledgebase/general.md" >}}), [Script Reference]({{< relref "/manual/general_cfg/script_reference.md" >}})

## Diagnostics Tools
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
| `ERROR_MON_STALL` | Motion stall. |
| `ERROR_MON_TOL_OUT_OF_RANGE` | Invalid monitor tolerance or limit window, for example calculated virtual-axis softlimits outside the valid range. See [motion]({{< relref "/manual/knowledgebase/motion.md#error_mon_tol_out_of_range" >}}). |
| `ERROR_DRV_HW_ALARM_X` | Hardware error, missing power supply; check dedicated hardware panels. |
| `ERROR_ENC_NOT_READY` | Encoder issue, cabling issue, or missing power supply. |
| `ERROR_EC_LINK_DOWN` | EtherCAT cabling issue, slave power missing. |
| `ERROR_EC_STATUS_NOT_OK` | EtherCAT cabling issue, slave power missing. |
| `ERROR_EC_MAIN_DOMAIN_DATA_FAILED` | EtherCAT cabling issue, slave power missing. |
| `ERROR_AXIS_SLAVED_AXIS_INTERLOCK` | Slaved axis in error (synchronized axes). |

## Related Pages
- [knowledge base]({{< relref "/manual/knowledgebase/_index.md" >}})
- [panel]({{< relref "/manual/knowledgebase/panel.md" >}})
- [ethercat command line interface]({{< relref "/manual/knowledgebase/ethercatCLI.md" >}})
