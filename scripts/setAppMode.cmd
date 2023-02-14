#==============================================================================
# setAppMode.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for switching to operational mode.
#-d   \author Niko Kivel
#-d   \file
#-d */
ecmcFileExist("${ECMC_CONFIG_ROOT}general.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}general.cmd

#- Only load ec records if master is selected. ECMC_EC_MASTER_ID is set in startup.cmd.
ecmcEpicsEnvSetCalcTernary(ECMC_MASTER_CMD, "${ECMC_EC_MASTER_ID=0}>=0", "","#- ")
${ECMC_MASTER_CMD} ecmcFileExist("ecmcEc.db",1,1)
${ECMC_MASTER_CMD} dbLoadRecords("ecmcEc.db","P=${ECMC_PREFIX},ECMC_EC_MP=${ECMC_EC_MP=m},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")

#- Load ecmc information into record
#- Set -1 to mark last in chains
epicsEnvSet(ECMC_AXES_CFG,"[${ECMC_AXES_CFG=""}-1]")
epicsEnvSet(ECMC_DS_CFG,"[${ECMC_DS_CFG=""}-1]")
epicsEnvSet(ECMC_PLG_CFG,"[${ECMC_PLG_CFG=""}-1]")
epicsEnvSet(ECMC_PLCS_CFG,"[${ECMC_PLCS_CFG=""}-1]")
epicsEnvSet(ECMC_EC_CFG,"[${ECMC_EC_CFG=""}-1]")

${ECMC_MASTER_CMD} ecmcFileExist("ecmcControllerConfigs.db",1,1)
dbLoadRecords("ecmcControllerConfigs.db","P=${SM_PREFIX},AXES_IDS='${ECMC_AXES_CFG=""}',M_ID=${ECMC_EC_MASTER_ID} ,PLC_IDS='${ECMC_PLCS_CFG=""}',DS_IDS='${ECMC_DS_CFG=""}', PLG_IDS='${ECMC_PLG_CFG=""}', EC_IDS='${ECMC_EC_CFG=""}'")

epicsEnvUnset(ECMC_AXES_CFG)
epicsEnvUnset(ECMC_DS_CFG)
epicsEnvUnset(ECMC_PLG_CFG)
epicsEnvUnset(ECMC_EC_CFG)

#- START
ecmcConfigOrDie "Cfg.SetAppMode(1)"
