#-d /**
#-d   \brief hardware script for EL7221-9014
#-d   \details EP7221-9014 Servo terminal with OCT feedback, touch probe inputs and STO
#-d   
#-d   \note This configuration exposes the 2 limit switches and STO status in infoData02:
#-d         bit0: Input 1
#-d         bit1: Input 2
#-d         bit8: STO
#-d
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7211-9014_CSP_STD")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1c353052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7211_OCT")

#- Load standard cfg
ecmcFileExist(${ecmccfg_DIR}ecmcEX72XX-9014_CSP_STD-ch01.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX-9014_CSP_STD-ch01.cmd
