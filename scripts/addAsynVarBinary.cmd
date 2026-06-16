#==============================================================================
# addAsynVarBinary.cmd
#- Arguments: NAME, ASYN_NAME, [DEV], [PORT], [DB_MACROS]

#-d /**
#-d   \brief Add an EPICS binary record for an asyn variable.
#-d   \details Loads a writable/readback-enabled `bo` record with PV name
#-d   \details `DEV:NAME`, where `DEV` defaults to `IOC`.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \param NAME Record name suffix, resulting PV is `DEV:NAME`
#-d   \param ASYN_NAME Full asyn parameter name, for example `plugin.enable`
#-d   \param DEV (optional) Device prefix, defaults to `IOC`
#-d   \param PORT (optional) Asyn port, defaults to `MC_CPU1`
#-d   \param DB_MACROS (optional) Extra DB template macros, for example `ONAM=Enable,ZNAM=Disable`
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addAsynVarBinary.cmd "NAME=FFTEnable,ASYN_NAME=PLUGIN.FFT0.enable,ONAM=Enable,ZNAM=Disable"
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addAsynVarBinary.cmd "NAME=PluginEnable,ASYN_NAME=plugin.enable,ONAM=On,ZNAM=Off"
#-d   \endcode
#-d */

epicsEnvSet("ECMC_ASYN_VAR_DEV", "${DEV=${IOC}}")

ecmcFileExist("ecmcAsynVarBinary.db",1,1)
dbLoadRecords("ecmcAsynVarBinary.db","DEV=${ECMC_ASYN_VAR_DEV},NAME=${NAME},ASYN_NAME=${ASYN_NAME},PORT=${PORT=MC_CPU1},ADDR=${ADDR=0},TIMEOUT=${TIMEOUT=0},T_SMP_MS=${T_SMP_MS=1000},TSE=${TSE=0},DESC='${DESC=}',ONAM=${ONAM=One},ZNAM=${ZNAM=Zero},PINI=${PINI=1},${DB_MACROS=}")

epicsEnvUnset(ECMC_ASYN_VAR_DEV)
