############################################################
############# Information:
# Description: 2 channel SSI encoder interface
#
# by Niko Kivel, Paul Scherrer Institute, 2018
# email: niko.kivel@psi.ch
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL5002")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x138a3052")

#############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

############################################################
############# Config PDOS:
# Channel 1:
epicsEnvSet("N" 0)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${N},0x60${N}0,0x1,8,STATUS${N})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${N},0x60${N}0,0x11,32,POSITION${N})"

# Channel 2:
epicsEnvSet("N" 1)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${N},0x60${N}0,0x1,8,STATUS${N})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${N},0x60${N}0,0x11,32,POSITION${N})"
