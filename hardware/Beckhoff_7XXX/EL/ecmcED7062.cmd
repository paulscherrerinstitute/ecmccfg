#-d /**
#-d   \brief hardware script for ED7062 CSV
#-d   \details ED7062 stepper drive 3ch 8-48V, 3A, max 5A per channel (sum <= 6A)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ED7062")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b961052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7062")

#- Load standard cfg
ecmcFileExist(${ecmccfg_DIR}ecmcEX7062.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX7062.cmd
