#-d /**
#-d   \brief hardware script for EL2634
#-d   \details 4-channel relay output terminal, 250 V AC, 30 V DC, 4 A
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2634")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0a4a3052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2004.cmd
