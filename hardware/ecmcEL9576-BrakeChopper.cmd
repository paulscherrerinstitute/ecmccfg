############################################################
############# Information:
# Description: EL9576, brake chopper terminal
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL9576")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x25683052")

############# Config PDOS:

EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,16,STATUS)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,32,DC_VOLTAGE)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x13,32,RESISTOR_CURRENT)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x14,8,DUTY_CYCLE)"
