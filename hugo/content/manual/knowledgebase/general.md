+++  
title = "general"   
weight = 12
chapter = false  
+++

### General

#### ERROR_EC_MAIN_INVALID_SLAVE_INDEX

This error could be generated if:
* Power to the slaves are missing.
* Slave index is wrong
* Slaves are disconnected (cable disconnected)
* The MASTER_ID of the current IOC is wrong (the slaves are on another master).

Example of error in iocsh:
```
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/addSlave.cmd,       "HW_DESC=EK1100"
#==============================================================================

ecmcIf("'NAN'!='NAN' and 0!=1")
ecmcEndIf()
epicsEnvUnset(ECMC_HW_PANEL)
epicsEnvSet("ECMC_EC_SLAVE_NUM",  "0")
epicsEnvSet("HW_DESC",            "EK1100")
epicsEnvSet("P_SCRIPT",           "mXsXXX")
epicsEnvUnset(ECMC_EC_COMP_TYPE)
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/ecmcEK1100.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/ecmcEK1100.cmd" "NELM=1"
epicsEnvSet("ECMC_EC_HWTYPE"             "EK1100")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x044c2c52")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/slaveVerify.cmd
ecmcEpicsEnvSetCalcTernary(SLAVE_VERIFY, "0==0","","#- ")
ecmcConfigOrDie "Cfg.EcSlaveVerify(0,0,0x2,0x044c2c52)"
2024/12/19 08:57:22.552 ../ecmc/devEcmcSup/ethercat/ecmcEc.cpp/verifySlave:1881: INFO: Slave index out of range (0x26002).
ECMC command "Cfg.EcSlaveVerify(0,0,0x2,0x044c2c52)" returned error: ERROR_EC_MAIN_INVALID_SLAVE_INDEX (0x26002)
```

Diagnose the issue by logging into the host/server and run the "ethercat slaves" command. Ensure that the slaves are there and powered.

#### Asyn parameter count exceeded

For big IOC:s sometimes the default maximum asyn parameter count might not be enough and an error will be shown:
```
...
ecmcConfigOrDie "Cfg.SetAppMode(1)"
2025/10/27 11:15:39.015 ecmcAsynPortDriver:appendAvailParam: ERROR: Parameter table full (available params).
Parameter with name plcs.ax27.traj.extsetpos will be discarded (max params = 1500).
Increase paramtable size in call to ecmcAsynPortDriverConfigure().
.....
```

The solution is to increase the maximum parameter count by setting the "MAX_PARAM_COUNT" macro when requiring ecmccfg:
```
require ecmccfg "MASTER_ID=1,......,MAX_PARAM_COUNT=2000"
```
#### Callback Queue Size

The default callback queue in EPICS base is only 2000 bytes. 
To increase the use the following command in the top of your startup script:
```
callbackSetQueueSize(<size>)
```
