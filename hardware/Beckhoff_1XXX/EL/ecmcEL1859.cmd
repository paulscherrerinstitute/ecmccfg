#-d /**
#-d   \brief hardware script for EL1859
#-d   \details HD terminal 8 ch digital input/output
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1859")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x07433052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- binary inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1008.cmd SM=1

#- binary outputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2008.cmd
