# Change update rate for motor record

Two poll-rates (update rates) of motor record can be changed:
* when idle (not moving)
* when moving 

## Poll rate setting when idle
```
epicsEnvSet(ECMC_MR_IDLE_POLL_MS, 500)
...
require ecmccfg develop
$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=develop"

```
Note: the "ECMC_MR_IDLE_POLL_MS" variable needs to be set before execution of startup.cmd (and before require ecmccfg at PSI)

## Poll rate setting when moving
```
epicsEnvSet(ECMC_MR_MOV_POLL_MS, 100)
...
require ecmccfg develop
$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=develop"
```
Note: the "ECMC_MR_MOV_POLL_MS" variable needs to be set before execution of startup.cmd (and before require ecmccfg at PSI)
