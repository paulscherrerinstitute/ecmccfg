#==============================================================================
# addEcSdoAsynccmd
#-d /**
#-d   \brief Script for adding asyn SDO object (access to SDO:s in runtime)
#-d   \author Anders Sandström
#-d   \file
#-d   \param SLAVE_ID (optional) bus position
#-d   \param INDEX  sdo index
#-d   \param SUBINDEX  sdo subindex
#-d   \param DT  data type
#-d   \param NAME  name to be used for adressing and suffix of PV name
#-d   \param P_SCRIPT (optional) naming convention prefix script
#-d */

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID=0}")
epicsEnvSet("P_SCRIPT",           "${P_SCRIPT=${ECMC_P_SCRIPT}}")

# Add async SDO 
ecmcConfigOrDie "Cfg.EcAddSdoAsync(${ECMC_EC_SLAVE_NUM=0},${INDEX},${SUBINDEX},${DT},${NAME})"

ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd" "NELM=${NELM=1}"

# deduce what the prefix should be
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd" "MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE}"

dbLoadRecords("ecmcSDOAsync.template","ECMC_P=${ECMC_P},MASTER_ID=,ECMC_MASTER_ID,SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")

