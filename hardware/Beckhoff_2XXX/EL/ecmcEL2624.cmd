#-d /**
#-d   \brief hardware script for EL2624
#-d   \details 4-channel relay output terminal 125 V AC/30 V DC, potential-free, normally open, with power contacts
#-d   \author Thomas Fay
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2624")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0a403052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2004.cmd
