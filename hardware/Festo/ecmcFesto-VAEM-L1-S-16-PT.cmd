#-d /**
#-d   \brief hardware script for Festo VAEM-L1-S-16-PT
#-d   \author Alvin Acerbo
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "Festo")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x0000001d")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0008bc8c")

#- verify slave
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x1,16,binaryOutputArray01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x2,16,binaryOutputArray02)"
