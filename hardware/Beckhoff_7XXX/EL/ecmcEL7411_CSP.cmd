#-d /**
#-d   \brief hardware script for EL7411 CSP
#-d   \details EL7411 BLDC terminal with incremental encoder and hall
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7411_CSP")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1cf33052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7411")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7010,0x01,16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7010,0x05,32,1,positionSetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,32,positionActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x01,16,driveStatus01)"

#- Ensure the drive receives some SDO settings
ecmcConfigOrDie "Cfg.EcSetSlaveNeedSDOSettings(${ECMC_EC_SLAVE_NUM},1,1)"

#- ############ Distributed clocks config EL7411:
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcEpicsEnvSetCalc("ECMC_SYNC_1","${ECMC_TEMP_PERIOD_NANO_SECS}-62500")

#- In TC sync 0 is always 62.5 microseconds and sync 1 is the cycle time minus sync 0.
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x1,3,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x1,3,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"

ecmcFileExist(${ecmccfg_DIR}applySlaveDCconfig.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveDCconfig.cmd "ASSIGN_ACTIVATE=0x700,SYNC_0_CYCLE=62500,SYNC_0_SHIFT=${SYNC_0_SHIFT=0},SYNC_1_CYCLE=${ECMC_SYNC_1}"

epicsEnvUnset(ECMC_SYNC_1)

# Peak current (to be overwritten by motor config)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,1000,4)"

ecmcEpicsEnvSetCalc("ECMC_TEMP_WHATCHDOG_1",1000/${ECMC_EC_SAMPLE_RATE=1000}*1000)
ecmcEpicsEnvSetCalc("ECMC_TEMP_WHATCHDOG_2",${ECMC_TEMP_WHATCHDOG_1}*10)

ecmcConfigOrDie "Cfg.EcSlaveConfigWatchDog(${ECMC_EC_SLAVE_NUM},${ECMC_TEMP_WHATCHDOG_1},${ECMC_TEMP_WHATCHDOG_2})"

#- CSP mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,8,1)"

epicsEnvUnset(ECMC_TEMP_WHATCHDOG_1)
epicsEnvUnset(ECMC_TEMP_WHATCHDOG_2)
