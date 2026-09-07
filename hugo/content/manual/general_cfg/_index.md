+++
title = "general"
weight = 7
chapter = false
+++

## Topics
{{% children %}}
---

## Scope
General configuration covers IOC/bootstrap behavior that is not axis-specific:
- startup mode and global macros
- record update/processing behavior
- iocsh utility functions
- common data buffering patterns
- command-parser reference access

## By Task
### Start and parameterize ecmccfg
- [startup.cmd]({{< relref "/manual/general_cfg/startup/_index.md" >}}) for startup arguments/macros and initialization behavior.
- [modes]({{< relref "/manual/general_cfg/startup/modes.md" >}}) for `FULL`, `DAQ`, `NO_MR`, and `ENG_MODE`.

### Configure EPICS record processing/update rate
- [PV Processing Rate]({{< relref "/manual/general_cfg/PVProcessingRate.md" >}}) for `ECMC_SAMPLE_RATE_MS`, per-record overrides, and processing hooks.

### Use utility functions in startup scripts
- [iocsh utilities]({{< relref "/manual/general_cfg/iocsh_utils.md" >}}) for `ecmcEpicsEnvSetCalc`, `ecmcIf`, loops, and file existence checks.
- [Script Reference]({{< relref "/manual/general_cfg/script_reference.md" >}}) for which `scripts/` entry points are public, advanced, or internal helpers.
- [Startup Validator]({{< relref "/manual/general_cfg/startup_validator.md" >}}) for checking startup syntax, script macros, and local file references before IOC execution.
- [ESI Parser]({{< relref "/manual/general_cfg/esi_parser.md" >}}) for the legacy EtherCAT ESI XML utility.
- [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}) for extra domains, data items, DC, slave verify, and topology skips.
- [EtherCAT Endpoint Timing]({{< relref "/manual/general_cfg/ethercat_timing.md" >}}) for input/output delay, DC phase, timestamps, timing PVs, and the diagnostic panel.
- [FSoE and TwinSAFE]({{< relref "/manual/general_cfg/fsoe.md" >}}) for direct safety-telegram forwarding and hardware-panel navigation.
- [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}}) for named axis collections used by `mc_grp_...` PLC helpers.
- [Master/Slave State Machine]({{< relref "/manual/general_cfg/master_slave_state_machine.md" >}}) for synchronized virtual/physical systems.
- [Lookup Tables]({{< relref "/manual/general_cfg/lut.md" >}}) for loading numeric correction/value tables into ecmc.

### Configure generic data capture/buffering
- [data storage buffer]({{< relref "/manual/general_cfg/data_storage.md" >}}) for `ds_append_data`/`ds_push_asyn` usage patterns.

### Apply platform-level recommendations
- [best practice]({{< relref "/manual/general_cfg/best_practice.md" >}}) for EtherCAT rate and host-side setup guidance.

### Browse command API details
- [ecmc command reference]({{< relref "/manual/general_cfg/ecmc_command_ref.md" >}}) for command syntax by domain.

## Recommended Reading Paths
### New IOC bootstrap/config path
1. [startup.cmd]({{< relref "/manual/general_cfg/startup/_index.md" >}})
2. [modes]({{< relref "/manual/general_cfg/startup/modes.md" >}})
3. [PV Processing Rate]({{< relref "/manual/general_cfg/PVProcessingRate.md" >}})
4. [best practice]({{< relref "/manual/general_cfg/best_practice.md" >}})

### Script authoring / automation path
1. [iocsh utilities]({{< relref "/manual/general_cfg/iocsh_utils.md" >}})
2. [Script Reference]({{< relref "/manual/general_cfg/script_reference.md" >}})
3. [Startup Validator]({{< relref "/manual/general_cfg/startup_validator.md" >}})
4. [ESI Parser]({{< relref "/manual/general_cfg/esi_parser.md" >}})
5. [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}})
6. [FSoE and TwinSAFE]({{< relref "/manual/general_cfg/fsoe.md" >}})
7. [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}})
8. [Master/Slave State Machine]({{< relref "/manual/general_cfg/master_slave_state_machine.md" >}})
9. [Lookup Tables]({{< relref "/manual/general_cfg/lut.md" >}})
10. [data storage buffer]({{< relref "/manual/general_cfg/data_storage.md" >}})
11. [ecmc command reference]({{< relref "/manual/general_cfg/ecmc_command_ref.md" >}})
