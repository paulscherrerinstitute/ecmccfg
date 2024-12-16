+++  
title = "modes"   
weight = 15
chapter = false  
+++  

### ecmc modes
ecmc can be started in different modes by setting the MODE parameter to startup.cmd (or require ecmccfg):
1. FULL
2. DAQ
3. NO_MR

A separate mode for commissioning is also available, called ENG_MODE.

#### mode==FULL (default)

In FULL mode all ecmc functionalities are supported, like motion, daq and plcs.

Example of starting ecmc in FULL mode:
```
$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=develop,MODE=FULL"

# or since FULL mode is default the MODE parameter can be ignored

$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=develop"
```

#### mode==DAQ
In DAQ mode, motion functionalities are disabled and the following commands are blocked:
1. configureAxis.cmd
2. configureVirtualAxis.cmd
3. addAxis.cmd
4. addVirtualAxis.cmd

This mode is intended to be used for pure DAQ use cases.

Example of starting ecmc in DAQ mode:
```
$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=develop,MODE=DAQ"
```

NOTE: The default record update rate is set to 10ms in initAlll.cmd. For DAQ applications it could be needed to change this parameter to update records faster by changing the ECMC_SAMPLE_RATE_MS variable:
```
epicsEnvSet("ECMC_SAMPLE_RATE_MS",1)
```

#### mode==NO_MR

In this mode all features are supported, but motor record will not be created for motion axes.


#### ENG_MODE

Setting the parameter ENG_MODE=1 will result in loading of extra PVs usefull for commissioning, i.e. controller parameters for motion axes.
