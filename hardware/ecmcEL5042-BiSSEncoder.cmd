############################################################
############# Information:
# Description: 2 channel BiSS encoder interface
#
# by Niko Kivel, Paul Scherrer Institute, 2018
# email: niko.kivel@psi.ch
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL5042")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x13b23052")

#############  Reset terminal
EthercatMCConfigController "${ECMC_MOTOR_PORT}", "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

############################################################
############# Config PDOS:
# Channel 1
EthercatMCConfigController "${ECMC_MOTOR_PORT}", "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,16,STATUS0)"
EthercatMCConfigController "${ECMC_MOTOR_PORT}", "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,64,POSITION0)"
# Channel 2
EthercatMCConfigController "${ECMC_MOTOR_PORT}", "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x1,16,STATUS1)"
EthercatMCConfigController "${ECMC_MOTOR_PORT}", "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x11,64,POSITION1)"
