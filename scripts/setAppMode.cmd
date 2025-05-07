#==============================================================================
# setAppMode.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Script for switching to operational mode.
#-d   \details Validates configuration, starts realtime thread and checks EtherCAT slaves are in OP.
#-d   \author Niko Kivel
#-d
#-d   Macros (optional):
#-d     T_SMP_HOOK_MS  : Update rate of MCU-Updated PV [ms]
#-d     PROC_HOOK      : Forward link pf MCU-Updated PV
#-d     ECMC_PROC_HOOK : Same as PROC_HOOK
#-d     T_SMP_MS       : Maximum sample time of other records loaded by this script [ms]
#-d 
#-d   \file
#-d */
ecmcFileExist("${ECMC_CONFIG_ROOT}general.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}general.cmd

#- Only load ec records if master is selected. ECMC_EC_MASTER_ID is set in startup.cmd.
ecmcEpicsEnvSetCalcTernary(ECMC_MASTER_CMD, "${ECMC_EC_MASTER_ID=0}>=0", "","#- ")
${ECMC_MASTER_CMD} ecmcFileExist("ecmcEc.db",1,1)
${ECMC_MASTER_CMD} dbLoadRecords("ecmcEc.db","P=${ECMC_PREFIX},ECMC_EC_MP=${ECMC_EC_MP=m},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},ECMCCFG_VER=${ecmccfg_VERSION},EPICS_VER=${EPICS_RELEASE}")

#- Load pvt controller records if PVT is in use and not been previously configured
ecmcIf("${ECMC_MR_PVT_CONTROLLER_CONFIGURED=0}==0 and ${ECMC_MR_PVT_AXES_COUNT_IN_USE=0}>0")
${IF_TRUE}# Warning: PVT configured for axes but PVT asynMotorController config not done. A default configuration will be executed:
${IF_TRUE}${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}pvtControllerConfig.cmd
${IF_TRUE}epicsEnvUnset(ECMC_MR_PVT_MAX_RB_POINTS_IN_USE)
${IF_TRUE}epicsEnvUnset(ECMC_MR_PVT_MAX_POINTS_IN_USE)
${IF_TRUE}epicsEnvUnset(ECMC_MR_PVT_AXES_COUNT_IN_USE)
ecmcEndIf()
epicsEnvUnset(ECMC_MR_PVT_CONTROLLER_CONFIGURED)

# EtherCAT bus startup delay (minimum startup time) [seconds->cycles]:
ecmcEpicsEnvSetCalc("EC_DELAY_CYCLES" ,"${ECMC_EC_SAMPLE_RATE=1000}*${ECMC_EC_STARTUP_DELAY=0}")
ecmcConfigOrDie "Cfg.EcSetDelayECOkAtStartup(${EC_DELAY_CYCLES=0})"
epicsEnvUnset(EC_DELAY_CYCLES)
epicsEnvUnset(ECMC_EC_STARTUP_DELAY)

#- Start RT thread
ecmcConfigOrDie "Cfg.SetAppMode(1)"

#- Add some time before iocInit
# Stabilize EtherCAT bus.....
epicsThreadSleep ${ECMC_EC_STABILIZATION_TIME=2}

#- For check in finalize.cmd if executed
epicsEnvSet(ECMC_SET_APP_MODE_DONE,1)
