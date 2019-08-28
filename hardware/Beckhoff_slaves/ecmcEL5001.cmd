############################################################
############# Information:
# Description: 1 channel SSI encoder interface
#
# by Niko Kivel, Paul Scherrer Institute, 2018
# email: niko.kivel@psi.ch
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL5001")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x13893052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

############################################################
############# Config PDOS:

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6010,0x1,8,ENC_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6010,0x11,32,ENC_POSITION)"
