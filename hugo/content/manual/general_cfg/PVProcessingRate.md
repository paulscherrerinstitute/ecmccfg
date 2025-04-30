+++  
title = "PV Processing Rate"
weight = 30
chapter = false  
+++  

## PV Processing Rate:
Normally the the EPICS PVs will update at a lower rate than the EtherCAT master rate. However it's possible to configure the system so that the records update at a custom rate (integer of the EtherCAT rate).

### ECMC_SAMPLE_RATE_MS Macro

The PV sampling rate is controlled by the global ECMC_SAMPLE_RATE_MS macro.
The Macro can be set with the following wrapper:
```
${SCRIPTEXEC} ${ecmccfg_DIR}setRecordUpdateRate.cmd "RATE_MS=1"
```
All records loaded after "setRecordUpdateRate.cmd" is issued will be updated with the new rate.

The rate can be restored with:
```
${SCRIPTEXEC} ${ecmccfg_DIR}restoreRecordUpdateRate.cmd
```
All records loaded after "restoreRecordUpdateRate.cmd" is issued will be updated with the default rate.

### T_SMP_MS

Another alternative is to use the MACROS macro when adding a slave. In this case the T_SMP_MS macro should be set:
```
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=12,HW_DESC=EL7031,MACROS='T_SMP_MS=1'"
```
### Triggering of processing in epics layer

For triggering processing with forward links in the EPICS layer a dedicated named ${P}:MCU-Updated can be used. In order to set the FLNK and processing rate the "setProcHook.cmd" should be used.
The command takes two optional macros:
1. PROC_HOOK: The PV that should be triggered, defaults to ''
2. T_SMP_HOOK_MS: Sample rate of the MCU-Updated PV, defaults to EtherCAT rate (if this script is called, otherwise default is same as default for other records).

```
${SCRIPTEXEC} ${ecmccfg_DIR}setProcHook.cmd "PROC_HOOK=TEST:TRIGG.PROC,T_SMP_HOOK_MS=1"
```
