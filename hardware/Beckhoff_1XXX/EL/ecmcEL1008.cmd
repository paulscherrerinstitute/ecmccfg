#-d /**
#-d   \brief hardware script for EL1008
#-d   \details 8-channel digital input terminal 24 V DC, 3 ms
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1008")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x03f03052")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1008.cmd
