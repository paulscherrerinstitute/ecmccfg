#-d /**
#-d   \brief hardware script for EL2828
#-d   \details 8ch digital output 2A
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2828")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0b0c3052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2008.cmd
