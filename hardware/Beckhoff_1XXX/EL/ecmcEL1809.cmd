#-d /**
#-d   \brief hardware script for EL1809
#-d   \details HD terminal 16ch digital input
#-d   \author Julen Etxeberria
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1809")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x07113052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- binary inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1008.cmd
