#-d /**
#-d   \brief hardware script for EL1124
#-d   \details 4ch digital input
#-d   \author Orell Hürzeler
#-d   \file
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: 4ch digital input
#-
#-  by Orell Hürzeler, Paul Scherrer Institute, 2019
#-  email: orell.huerzeler@psi.ch
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1124")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04643052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,1,BI_1)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6010,0x1,1,BI_2)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a02,0x6020,0x1,1,BI_3)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a03,0x6030,0x1,1,BI_4)"
