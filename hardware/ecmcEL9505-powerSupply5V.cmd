############################################################
############# Information:
# Description: Power supply terminal 5V
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL9505")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x25213052")

EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,1,POWER_OK)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x2,1,OVERLOAD)"
