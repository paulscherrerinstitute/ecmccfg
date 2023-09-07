# SmarAct MCS2

## Description

The MCS2 with EC interface can control up to 3 SmarAct pizeo actuators.
As with the other SmarAct controllers, the actuators have to be calibrated before operation.
Since the actuators do only have incremental encoders, homing after a power loss is mandatory.

### Calibration
Set the mode of operation to `-1`, which is achieved by selecting `2` of the `ModeSet` pv.

### Homing
Similar to the calibration, the homing is commenced by setting the mode of operation to `6`, which is also `6` of the `ModeSet` pv.

### Positioning
Finally, the CSP positioning is selected by mode of operation `8`, which is represented by `8` of the `ModeSet` pv.

## Open issues
1. The system does _not_ recover from power loss w/o restarting the IOC.
2. Axes will creep to negative values when left _disabled_.
3. Homing does fail occasionally.
4. Recover from axes errors is still flaky.

## TODO
* migrate to new naming

## ioc startup example

```bash
#- require ecmccfg
require ecmccfg

#- add Slave
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "HW_DESC=MCS2"
#- no configuration as of 2021-01-06

#- Apply hardware configuration
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd

#- configure upto 3 axes
epicsEnvSet("DEV",      "STEST-MYDEVICE")
${SCRIPTEXEC} ${ecmccfg_DIR}configureAxis.cmd,            "CONFIG=./cfg/SLC17_X.pax"
${SCRIPTEXEC} ${ecmccfg_DIR}configureAxis.cmd,            "CONFIG=./cfg/SLC17_Y.pax"
${SCRIPTEXEC} ${ecmccfg_DIR}configureAxis.cmd,            "CONFIG=./cfg/SLC17_Z.pax"

############# Configure diagnostics:

ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(100)"
ecmcConfigOrDie "Cfg.SetDiagAxisIndex(1)"
ecmcConfigOrDie "Cfg.SetDiagAxisFreq(1)"
ecmcConfigOrDie "Cfg.SetDiagAxisEnable(0)"

#- go active
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd

#- this will switch to CSP mode, if those 3 lines are omitted, the MCS2 stays in operation mode '0', aka 'None' and has to manually switched to CSP mode.
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_MCS2_SLAVE_NUM},mode01,8)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_MCS2_SLAVE_NUM},mode02,8)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_MCS2_SLAVE_NUM},mode03,8)"
```

# Anders notes
* In web configuration the default password is "smaract"

## GUI
```
caqtdm -macro "IOC=c6025a,MasterID=0,SlaveID=002" ecmcMCS2.ui 
```

## Issues
* Sometimes moves when startup, why?
* Enabled in smaract service tool but not enabled over ethercat? WHY? Sometimes enabled at startup
* Sometimes the 0x2000 SDO exists and sometimes not? WHY? Also similar problem for other adresses
```
[ 3459.292211] EtherCAT ERROR 1-main-2: SDO download 0x2000:00 (4 bytes) aborted.
[ 3459.292219] EtherCAT ERROR 1-main-2: SDO abort message 0x06020000: "This object does not exist in the object directory"
```
* How to read the limits (virtual)?
* 

# status wd when in limit:
```
c6025a:m1s002-Drv01-Stat 0b00000000000000000001001000110111 Moving Fwd:
c6025a:m1s002-Drv01-Stat 0b00000000000000000000101000110111 FwdLim:
c6025a:m1s002-Drv01-Stat 0b00000000000000000000101000011000 Error:
c6025a:m1s002-Drv01-Stat 0b00000000000000000001001000110111 Moving Bwd:
c6025a:m1s002-Drv01-Stat 0b00000000000000000000001001010000 Error:
```
