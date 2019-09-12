############################################################
############# Information:
# Description: Technosoft IPOS4808 (stepper and servo) 
# Feedbacks: 
#     -Incremental feedback (differential rs422) 
#     -SSI,BISS (config in drive needs to be updated)
#     -Analog  (config in drive needs to be updated)
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "iPOS4808")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x000001a3")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x019f418d")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

${SCRIPTEXEC} ${ecmccfg_DIR}ecmciPOSXXXX.cmd
