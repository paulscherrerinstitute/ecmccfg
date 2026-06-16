#==============================================================================
# addAsynVarAnalog.cmd
#- Arguments: NAME, ASYN_NAME, [DEV], [PORT], [DB_MACROS]

#-d /**
#-d   \brief Add an EPICS analog record for an asyn variable.
#-d   \details Loads a writable/readback-enabled `ao` record with PV name
#-d   \details `DEV:NAME`, where `DEV` defaults to `IOC`.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \param NAME Record name suffix, resulting PV is `DEV:NAME`
#-d   \param ASYN_NAME Full asyn parameter name, for example `plugin.adv.counter`
#-d   \param DEV (optional) Device prefix, defaults to `IOC`
#-d   \param PORT (optional) Asyn port, defaults to `MC_CPU1`
#-d   \param DB_MACROS (optional) Extra DB template macros, for example `EGU=mm,PREC=3,ESLO=0.1,EOFF=0`
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addAsynVarAnalog.cmd "NAME=AdvCounter,ASYN_NAME=plugin.adv.counter,EGU=counts,PREC=0"
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addAsynVarAnalog.cmd "NAME=LatencyMax,ASYN_NAME=ecmc.thread.latency.max,EGU=ns,PREC=0"
#-d   \endcode
#-d */

epicsEnvSet("ECMC_ASYN_VAR_DEV", "${DEV=${IOC}}")

ecmcFileExist("ecmcAsynVarAnalog.db",1,1)
dbLoadRecords("ecmcAsynVarAnalog.db","DEV=${ECMC_ASYN_VAR_DEV},NAME=${NAME},ASYN_NAME=${ASYN_NAME},PORT=${PORT=MC_CPU1},ADDR=${ADDR=0},TIMEOUT=${TIMEOUT=0},T_SMP_MS=${T_SMP_MS=1000},TSE=${TSE=0},DESC='${DESC=}',PREC=${PREC=3},EGU=${EGU=},ESLO=${ESLO=1},EOFF=${EOFF=0},LOPR=${LOPR=0},HOPR=${HOPR=0},DRVL=${DRVL=0},DRVH=${DRVH=0},PINI=${PINI=1},${DB_MACROS=}")

epicsEnvUnset(ECMC_ASYN_VAR_DEV)
