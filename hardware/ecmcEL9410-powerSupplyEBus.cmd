############################################################
############# Information:
# Description: Power supply terminal with refresh of E-Bus
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL9410")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x24c23052")

EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,1,EBUS_UNDERVOLTAGE)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6000,0x1,1,POWER_UNDERVOLTAGE)"
