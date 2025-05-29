#-d /**
#-d   \brief hardware script for EP7211-0034
#-d   \details EP7211-0034 Servo terminal with OCT feedback and touch probe inputs
#-d   \author Niko Kivel, based on intial work by Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP7211-0034_CSP_STD")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1c2b4052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7211_OCT")

#- Load standard cfg
ecmcFileExist(${ecmccfg_DIR}ecmcEX72XX-9014_CSP_STD-ch01.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX-9014_CSP_STD-ch01.cmd
