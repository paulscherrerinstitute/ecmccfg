############################################################
############# Information:
# Description: EL5101 Incremental encoder interface (differential RS422) 32 bit support
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL5101")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x13ed3052")

EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1603,0x7010,0x01,16,ENC_CONTROL)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1603,0x7010,0x11,32,VALUE)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6010,0x01,16,ENC_STATUS)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6010,0x11,32,POSITION)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6010,0x12,32,LATCH_POSITION)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,32,FREQUENCY)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a06,0x6010,0x14,32,PERIOD)"
