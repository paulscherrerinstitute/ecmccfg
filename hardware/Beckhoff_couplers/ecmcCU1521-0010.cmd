#-d /**
#-d   \brief hardware script for CU1521-0010
#-d   \details CU1521-0010, EtherCAT media converter fibre optic
#-d   \author Julen Etxeberria
#-d   \file
#-d   \note No process data.
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "CU1521-0010")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x05f15432")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

ecmcConfigOrDie "Cfg.EcAddSlave(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

