#-d /**
#-d   \brief hardware script for EL1088
#-d   \details 8ch digital input
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1088")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04403052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- binary inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1008.cmd
