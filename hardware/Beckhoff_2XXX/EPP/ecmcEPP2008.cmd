#-d /**
#-d   \brief hardware script for EP2008-00XX
#-d   \details 8 channel digital output, 0.5A
#-d   \details -0001: 8x M8  connector
#-d   \details -0002: 4x M12 connector
#-d   \details -0002: 8x M12 connector
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EPP2008")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x64764389")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2008.cmd
