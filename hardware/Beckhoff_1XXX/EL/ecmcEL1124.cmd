#-d /**
#-d   \brief hardware script for EL1124
#-d   \details 4ch digital input
#-d   \author Orell Hürzeler
#-d   \file
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: 4ch digital input
#-
#-  by Orell Hürzeler, Paul Scherrer Institute, 2019
#-  email: orell.huerzeler@psi.ch
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL1124")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04643052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- binary inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1004.cmd
