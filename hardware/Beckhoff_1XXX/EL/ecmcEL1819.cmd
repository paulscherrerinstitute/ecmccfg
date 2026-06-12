#-d /**
#-d   \brief hardware script for EL1819
#-d   \details HD terminal 16ch digital input
#-d   \author Xiaoqiang Wang
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1819")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x71b3052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- binary inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1016.cmd
