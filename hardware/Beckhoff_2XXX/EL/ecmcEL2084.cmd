#-d /**
#-d   \brief hardware script for EL2084
#-d   \details 4ch digital output, 0.5A negative switching
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2084")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x08243052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2004.cmd
