#-d /**
#-d   \brief hardware script for EL6688
#-d   \details PTP Sync Terminal
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL6688")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1a203052")

#- ############# Verify terminal
ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

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

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x10f4,0x01,16,STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x10f4,0x11,64,DC_TIME)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x10f4,0x12,64,PTP_TIME)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x10f4,0x13,32,CONT_VAL_DC_MASTER)"

ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x30,0,0,1000000,0)"
