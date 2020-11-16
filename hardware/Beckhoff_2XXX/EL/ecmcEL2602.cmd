#-d /**
#-d   \brief hardware script for EL2602
#-d   \details 2-channel relay output terminal 230 V AC/30 V DC, relay contact is connected to the power contacts.
#-d   \author Markus Kristensson
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2602")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0a2a3052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1600,0x7000,0x1,1,BO_1)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1601,0x7010,0x1,1,BO_2)"
