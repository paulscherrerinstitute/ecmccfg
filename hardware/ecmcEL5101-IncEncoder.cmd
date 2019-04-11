############################################################
############# Information:
# Description: EL5101 Incremental encoder interface (differential RS422)
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL5101")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x13ed3052")

EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x01,8,ENC_CONTROL)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x02,16,VALUE)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x00,16,ENC_STATUS)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x10,16,POSITION)"
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x20,16,LATCH_POSITION)"
