#-d /**
#-d   \brief hardware script for EK1501-0010
#-d   \details EK1501-0010, EtherCAT coupler A E-Bus, FX-SingleMode, ID-Switc
#-d   \author Julen etxeberria
#-d   \file
#-d   \note No process data.
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EK1501-0010")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x05dd2c52")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

ecmcConfigOrDie "Cfg.EcAddSlave(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,16,ID)"

