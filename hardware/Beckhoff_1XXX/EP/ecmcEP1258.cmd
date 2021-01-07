#-d /**
#-d   \brief hardware script for EP1258-000X
#-d   \details 8-channel digital input with 2-channel timestamp
#-d   \details -0001: 8x M8  connector
#-d   \details -0002: 4x M12 connector
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP1258")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04ea4052")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1008.cmd
