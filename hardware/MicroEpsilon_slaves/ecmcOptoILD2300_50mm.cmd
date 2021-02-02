#-d /**
#-d   \brief hardware script for ILD2300_50mm
#-d   \details MICRO-EPSILON ILD2300 laser triangulation sensor 50mm range.
#-d   \author Anders Sandstrom
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "OptoILD2300_50mm")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x00000607")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x003ede74")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- Config PDOS:
#- SM3: PhysAddr 0x1280, DefaultSize    4, ControlRegister 0x20, Enable 1
#-  TxPDO 0x1a00 "Sample 0"
#-    PDO entry 0x6065:05, 32 bit, "Distance 1"

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6065,0x5,S32,CH1_VALUE,1)"
