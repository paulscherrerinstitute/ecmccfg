#-d /**
#-d   \brief hardware script for iPOSXXXX
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "iPOS4808BX")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x000001a3")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x01a0c82d")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmciPOSXXXX.cmd
