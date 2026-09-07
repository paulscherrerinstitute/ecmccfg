#-d /**
#-d   \brief hardware script for EL5042 with DC setting
#-d   \details 2 channel BISS-C encoder interface
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

ecmcFileExist(${ecmccfg_DIR}ecmcEL5042.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL5042.cmd

ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcFileExist(${ecmccfg_DIR}applySlaveDCconfig.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveDCconfig.cmd "ASSIGN_ACTIVATE=0x300,SYNC_0_CYCLE=${ECMC_TEMP_PERIOD_NANO_SECS},SYNC_1_CYCLE=${ECMC_TEMP_PERIOD_NANO_SECS}"

# 0x1C33:01 is not readable in OP on some EL5042 revisions. Declare the
# ESI-defined input timing source explicitly: 0=cycle-only, 1=SYNC0, 2=SYNC1.
ecmcConfigOrDie "Cfg.EcSetSlaveTimingSource(${ECMC_EC_SLAVE_NUM},2,${ECMC_EC_TIMING_IN_SOURCE=1})"
