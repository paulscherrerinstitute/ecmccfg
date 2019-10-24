#-d /**
#-d   \brief hardware script for EL1252
#-d   \details 2ch digital input (fast with timestamp)
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1252")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04e43052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#-SM0: PhysAddr 0x1000, DefaultSize    1, ControlRegister 0x22, Enable 1
#-  TxPDO 0x1a00 "Channel 1"
#-    PDO entry 0x6000:01,  1 bit, "Input"
#-  TxPDO 0x1a01 "Channel 2"
#-    PDO entry 0x6000:02,  1 bit, "Input"
#-    PDO entry 0x0000:00,  6 bit, ""
#-  TxPDO 0x1a02 "Reserved"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,1,BI_1)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6000,0x2,1,BI_2)"

#-SM1: PhysAddr 0x09ae, DefaultSize    0, ControlRegister 0x00, Enable 4
#-  TxPDO 0x1a13 "Latch"
#-    PDO entry 0x1d09:ae,  8 bit, "Status1"
#-    PDO entry 0x1d09:af,  8 bit, "Status2"
#-    PDO entry 0x1d09:b0, 64 bit, "LatchPos1"
#-    PDO entry 0x1d09:b8, 64 bit, "LatchNeg1"
#-    PDO entry 0x1d09:c0, 64 bit, "LatchPos2"
#-    PDO entry 0x1d09:c8, 64 bit, "LatchNeg2"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xae,8,CH1_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xaf,8,CH2_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xb0,64,CH1_LATCH_POS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xb8,64,CH1_LATCH_NEG)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xc0,64,CH2_LATCH_POS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xc0,64,CH2_LATCH_NEG)"
