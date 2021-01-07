#-d /**
#-d   \brief hardware script for EPP1008-00XX
#-d   \details 8-channel digital input terminal 24 V DC, 3 ms
#-d   \details -0001: 8x M8  connector
#-d   \details -0002: 4x M12 connector
#-d   \details -0002: 8x M12 connector
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EPP1008")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x64760509")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1008.cmd
