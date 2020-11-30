#-d /**
#-d   \brief hardware script for CU1561
#-d   \details CU1561, EtherCAT media converter plastic optical fibre
#-d   \author Javier Cereijo Garcia
#-d   \file
#-d   \note No process data.
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "CU1561")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x06195432")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

ecmcConfigOrDie "Cfg.EcAddSlave(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

