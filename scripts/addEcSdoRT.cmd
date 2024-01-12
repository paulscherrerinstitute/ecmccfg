#==============================================================================
# addEcSdoRT.cmd
#-d /**
#-d   \brief Script for adding asyn SDO object (access to SDO:s in realtime)
#-d   \author Anders Sandström
#-d   \file
#-d   \param SLAVE_ID (optional) bus position
#-d   \param INDEX  sdo index
#-d   \param SUBINDEX  sdo subindex
#-d   \param DT  data type
#-d   \param NAME  name to be used for adressing and suffix of PV name
#-d   \param P_SCRIPT (optional) naming convention prefix script
#-d */

epicsEnvSet("P_SCRIPT",           "${P_SCRIPT=${ECMC_P_SCRIPT}}")

# Add async SDO
ecmcConfigOrDie "Cfg.EcAddSdoAsync(${SLAVE_ID=0},${INDEX},${SUBINDEX},${DT},${NAME})"

# deduce what the prefix should be
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd" "MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},HWTYPE=${ECMC_EC_HWTYPE}"

#- Load SDO control and status records
ecmcFileExist("ecmcSDOAsync.template",1,1)
dbLoadRecords("ecmcSDOAsync.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")

#- Load SDO value record based on datatype
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD_FLOAT, "'${DT}'='F32' or '${DT}'='F64' ","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD_INT, "'${DT}'='F32' or '${DT}'='F64' ","#-","")
${ECMC_EXE_CMD_INT}ecmcFileExist("ecmcSDOAsyncInt.template",1,1)
${ECMC_EXE_CMD_INT}dbLoadRecords("ecmcSDOAsyncInt.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
${ECMC_EXE_CMD_FLOAT}ecmcFileExist("ecmcSDOAsyncFloat.template",1,1)
${ECMC_EXE_CMD_FLOAT}dbLoadRecords("ecmcSDOAsyncFloat.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
epicsEnvUnset(ECMC_EXE_CMD_INT)
epicsEnvUnset(ECMC_EXE_CMD_FLOAT)
