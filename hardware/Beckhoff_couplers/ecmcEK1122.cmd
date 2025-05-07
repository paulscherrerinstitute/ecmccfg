#-d /**
#-d   \brief hardware script for EK1122
#-d   \details 2 port EtherCAT Junction
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note No process data.
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EK1122")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04622c52")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

# Alias = 0
ecmcConfigOrDie "Cfg.EcAddSlave(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"
