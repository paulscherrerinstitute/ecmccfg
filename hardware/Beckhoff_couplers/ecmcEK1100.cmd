#-d /**
#-d   \brief hardware script for EK1100
#-d   \details EK1100, EtherCAT coupler
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note No process data.
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EK1100")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x044c2c52")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

ecmcConfigOrDie "Cfg.EcAddSlave(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"
