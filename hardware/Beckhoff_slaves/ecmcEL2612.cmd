############################################################
############# Information:
# Description: 2-channel relay output terminal 125 V AC/30 V DC, potential-free change-over, no power contacts
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2612")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0a343052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1600,0x7000,0x1,1,OUPIN_1)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1601,0x7010,0x1,1,OUPIN_2)"

