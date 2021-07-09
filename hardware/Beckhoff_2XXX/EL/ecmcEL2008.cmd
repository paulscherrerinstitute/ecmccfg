#-d /**
#-d   \brief hardware script for EL2008
#-d   \details 8-channel digital output terminal 24 V DC, 0.5 A
#-d   \author Thomas Fay and Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2008")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x07d83052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2008.cmd
