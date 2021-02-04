#-d /**
#-d   \brief hardware script for EL1144
#-d   \details 4ch 12V digital input, 10us filter
#-d   \author Anders Sandström
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1144")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04783052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- binary inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1004.cmd
