#-d /**
#-d   \brief hardware script for AMI8121
#-d   \details AMI8000 integrated servo motor
#-d   \author Niko Kivel, based on intial work by Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "AMI8121_CSP")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x368ecc09")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- SyncManager 2
#- 0x1600 (default)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7010,0x01,U16,driveControl01)"
#- 0x1606 (default)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7010,0x05,U32,positionSetpoint01)"
#- 0x1610 (default)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1610,0x7030,0x01,U16,binaryOutputArray01)"

#- SyncManager 3
#- 0x1A00 (default)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,U32,positionActual01)"
#- 0x1A01 (default)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x01,U16,driveStatus01)"
#- 0x1A06 following error
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a06,0x6010,0x06,S32,followingError01)"

ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)

#- DC
#- NOTE important the sync  period needs to be the 62500 ns!
#- NOTE important the sync 1 period needs to be the cycle time!
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,62500,0,${ECMC_TEMP_PERIOD_NANO_SECS},0)"
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)

#- watchdog
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd
