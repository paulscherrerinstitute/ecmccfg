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

# Load ecmc inforamtion into record
dbLoadRecords("ecmcControllerConfigs.db","P=${SM_PREFIX},AXES_IDS=${ECMC_AXES_CFG=""}, PLC_IDS=${ECMC_PLCS_CFG=""},DS_IDS=${ECMC_DS_CFG=""}, PLG_IDS=${ECMC_PLG_CFG=""}")

#- START
ecmcConfigOrDie "Cfg.SetAppMode(1)"
