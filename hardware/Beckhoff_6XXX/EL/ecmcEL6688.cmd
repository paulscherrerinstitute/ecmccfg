#-d /**
#-d   \brief hardware script for EL6688
#-d   \details PTP Sync Terminal
#-d   \author Anders Sandstroem
#-d   \note Only tested without PTP clock.
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL6688")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1a203052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#-  TxPDO 0x1a00 "  TxPDO-Map External Sync"
#-    PDO entry 0x10f4:01,  2 bit, "Sync Mode"
#-    PDO entry 0x0000:00,  6 bit, "Gap"
#-    PDO entry 0x0000:00,  5 bit, "Gap"
#-    PDO entry 0x10f4:0e,  1 bit, "Control value update toggle"
#-    PDO entry 0x10f4:0f,  1 bit, "Time stamp update toggle"
#-    PDO entry 0x10f4:10,  1 bit, "External device not connected"
#-    PDO entry 0x10f4:11, 64 bit, "Internal time stamp"
#-    PDO entry 0x10f4:12, 64 bit, "External time stamp"
#-    PDO entry 0x10f4:13, 32 bit, "Control Value for DC Master Clock"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x10f4,0x01,16,status01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x10f4,0x11,64,timeDc01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x10f4,0x12,64,timePtp01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x10f4,0x13,32,controlValueDcMaster01)"

ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x30,${ECMC_TEMP_PERIOD_NANO_SECS},0,0,0)"
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
