#-d /**
#-d   \brief hardware script for EL2024
#-d   \details 4ch digital output
#-d   \author Orell Hürzeler
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2024")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x07e83052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2004.cmd
