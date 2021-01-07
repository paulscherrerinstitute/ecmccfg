#-d /**
#-d   \brief hardware script for EP1258-000X
#-d   \details 8-channel digital input with 2-channel timestamp
#-d   \details -0001: 8x M8  connector
#-d   \details -0002: 4x M12 connector
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP1258")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04ea4052")

#- configuration for sync manager 0
#- binary inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1008.cmd

#- configuration for sync manager 1
#- status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xae,U8,status01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xaf,U8,status02)"
#- timestamps
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xb0,U64,latchPositive01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xb8,U64,latchNegative01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xc0,U64,latchPositive02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a13,0x1d09,0xc8,U64,latchNegative02)"
