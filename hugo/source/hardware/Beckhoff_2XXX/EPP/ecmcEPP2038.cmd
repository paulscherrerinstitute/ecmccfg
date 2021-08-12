#-d /**
#-d   \brief hardware script for EPP2038-000X; 8-channel digital output 24 V DC, Imax = 2 A (sum 3 A), with diagnostics
#-d   \details 8 channel digital output, 2 A (sum 3 A)
#-d   \details -0001: M8  connector
#-d   \details -0002: M12 connector
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EPP2038")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x64764569")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- binary outputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX2008.cmd

#- diagnostics inputs
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX1008.cmd "KEY=diagnosticInput"
