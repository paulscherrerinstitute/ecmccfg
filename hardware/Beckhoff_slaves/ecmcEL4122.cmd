############################################################
############# Information EL4102:
# Description: 2 channel analog output module 4..20mA 16 bit
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL4122")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x101a3052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

############# Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x1,16,CH1_VALUE)"

############# Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x1,16,CH2_VALUE)"
