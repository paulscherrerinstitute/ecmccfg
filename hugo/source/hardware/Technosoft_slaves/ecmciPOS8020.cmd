#-d /**
#-d   \brief hardware script for iPOS8020
#-d   \details Technosoft IPOS8020 (stepper and servo)
#-d   \author Anders Sandstroem
#-d   \file
#-d */

############################################################
############# Information:
# Description: Technosoft IPOS8020 (stepper and servo)
# Feedbacks:
#     -Incremental feedback (differential rs422)
#     -SSI,BISS (config in drive needs to be updated)
#     -Analog  (config in drive needs to be updated)
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "iPOS8020")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x000001a3")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x01bae7ae")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

${SCRIPTEXEC} ${ecmccfg_DIR}ecmciPOSXXXX.cmd
