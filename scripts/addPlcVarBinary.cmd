#==============================================================================
# addPlcVarBinary.cmd
#- Arguments: NAME, PLC_VAR, [SCOPE], [PLC_VAR_PLC_ID], [DEV], [PORT], [DB_MACROS]

#-d /**
#-d   \brief Add an EPICS binary record for a PLC variable.
#-d   \details Loads a writable/readback-enabled `bo` record with PV name
#-d   \details `DEV:NAME`, where `DEV` defaults to `IOC`.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \param NAME Record name suffix, resulting PV is `DEV:NAME`
#-d   \param PLC_VAR PLC variable specifier. Supported forms:
#-d   \param PLC_VAR - `hold` -> `plcs.plc<PLC_ID>.static.hold`
#-d   \param PLC_VAR - `static.hold` -> `plcs.plc<PLC_ID>.static.hold`
#-d   \param PLC_VAR - `global.mode` -> `plcs.global.mode`
#-d   \param PLC_VAR - `plcs.plc0.static.hold` -> used as-is
#-d   \param SCOPE (optional) `static` or `global`, defaults to `static`
#-d   \param PLC_VAR_PLC_ID (optional) PLC id, defaults to `ECMC_PLC_ID`
#-d   \param DEV (optional) Device prefix, defaults to `IOC`
#-d   \param PORT (optional) Asyn port, defaults to `MC_CPU1`
#-d   \param DB_MACROS (optional) Extra DB template macros, for example `ONAM=Run,ZNAM=Stop`
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addPlcVarBinary.cmd "NAME=Hold,PLC_VAR=hold,ONAM=Hold,ZNAM=Run"
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addPlcVarBinary.cmd "NAME=Hold,PLC_VAR=hold,PLC_VAR_PLC_ID=3,ONAM=Hold,ZNAM=Run"
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addPlcVarBinary.cmd "NAME=Mode,PLC_VAR=mode,SCOPE=global,ONAM=Remote,ZNAM=Local"
#-d   \endcode
#-d */

epicsEnvSet("ECMC_PLC_VAR_DEV", "${DEV=${IOC}}")
epicsEnvSet("ECMC_PLC_VAR_PLC_ID", "${PLC_VAR_PLC_ID=${ECMC_PLC_ID}}")
epicsEnvSet("ECMC_PLC_VAR_SCOPE", "${SCOPE=static}")

ecmcIf("'plcs.' in '${PLC_VAR}'",PLC_VAR_TRUE_1,PLC_VAR_FALSE_1)
${PLC_VAR_TRUE_1}epicsEnvSet("ECMC_PLC_VAR_RESOLVED", "${PLC_VAR}")
#- else
${PLC_VAR_FALSE_1}ecmcIf("'global.' in '${PLC_VAR}'",PLC_VAR_TRUE_2,PLC_VAR_FALSE_2)
${PLC_VAR_TRUE_2}epicsEnvSet("ECMC_PLC_VAR_RESOLVED", "plcs.${PLC_VAR}")
#- else
${PLC_VAR_FALSE_2}ecmcIf("'static.' in '${PLC_VAR}'",PLC_VAR_TRUE_3,PLC_VAR_FALSE_3)
${PLC_VAR_TRUE_3}epicsEnvSet("ECMC_PLC_VAR_RESOLVED", "plcs.plc${ECMC_PLC_VAR_PLC_ID}.${PLC_VAR}")
#- else
${PLC_VAR_FALSE_3}ecmcIf("'${ECMC_PLC_VAR_SCOPE}'='global'",PLC_VAR_TRUE_4,PLC_VAR_FALSE_4)
${PLC_VAR_TRUE_4}epicsEnvSet("ECMC_PLC_VAR_RESOLVED", "plcs.global.${PLC_VAR}")
#- else
${PLC_VAR_FALSE_4}epicsEnvSet("ECMC_PLC_VAR_RESOLVED", "plcs.plc${ECMC_PLC_VAR_PLC_ID}.static.${PLC_VAR}")
ecmcEndIf(PLC_VAR_TRUE_4,PLC_VAR_FALSE_4)
ecmcEndIf(PLC_VAR_TRUE_3,PLC_VAR_FALSE_3)
ecmcEndIf(PLC_VAR_TRUE_2,PLC_VAR_FALSE_2)
ecmcEndIf(PLC_VAR_TRUE_1,PLC_VAR_FALSE_1)

ecmcFileExist("ecmcPlcVarBinary.db",1,1)
dbLoadRecords("ecmcPlcVarBinary.db","DEV=${ECMC_PLC_VAR_DEV},NAME=${NAME},PLC_VAR=${ECMC_PLC_VAR_RESOLVED},PORT=${PORT=MC_CPU1},ADDR=${ADDR=0},TIMEOUT=${TIMEOUT=0},T_SMP_MS=${T_SMP_MS=1000},TSE=${TSE=0},DESC='${DESC=}',ONAM=${ONAM=One},ZNAM=${ZNAM=Zero},PINI=${PINI=1},${DB_MACROS=}")

epicsEnvUnset(ECMC_PLC_VAR_DEV)
epicsEnvUnset(ECMC_PLC_VAR_PLC_ID)
epicsEnvUnset(ECMC_PLC_VAR_SCOPE)
epicsEnvUnset(ECMC_PLC_VAR_RESOLVED)
