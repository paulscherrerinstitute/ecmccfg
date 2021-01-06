#-d /**
#-d   \brief hardware script for EP2008-000X
#-d   \details 8 channel digital output, 0.5A
#-d   \details -0001: 8x M8  connector
#-d   \details -0002: 4x M12 connector
#-d   \details -0002: 8x M12 connector
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP2008")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x07d84052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2008.cmd
