#-d /**
#-d   \brief hardware script for EL2602
#-d   \details 2-channel relay output terminal 230 V AC/30 V DC, relay contact is connected to the power contacts.
#-d   \author Markus Kristensson
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2602")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0a2a3052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2002.cmd
