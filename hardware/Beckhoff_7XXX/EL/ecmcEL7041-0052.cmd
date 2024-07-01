#-d /**
#-d   \brief hardware script for EL7041-0052
#-d   \details EL7041 stepper drive (24V,5A)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7041-0052")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b813052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7041")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- common PDOs for status and control
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX70XX.cmd

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "EL70x1")
