#-d /**
#-d   \brief hardware script for EL1004
#-d   \details 4ch digital input
#-d   \author Anders Sandstrom
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1004")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x03ec3052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- binary inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1004.cmd
