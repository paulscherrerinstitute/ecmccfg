# ecmc modes
ecmc can be started in different modes:
1. FULL
2. DAQ

## mode==FULL (default)

In FULL mode all ecmc functionalities are supported, like motion, daq and plcs.

Example of starting ecmc in FULL mode:
```
$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=develop,MODE=FULL"

# or since FULL mode is default the MODE parameter can be ignored

$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=develop"
```

## mode==DAQ
In DAQ mode, motion functionalities are disabled and the following commands are blocked:
1. configureAxis.cmd
2. configureVirtualAxis.cmd
3. addAxis.cmd
4. addVirtualAxis.cmd

This mode is inteded to be used for pure DAQ use cases.

Example of starting ecmc in DAQ mode:
```
$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=develop,MODE=DAQ"
```
