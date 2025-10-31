#-d /**
#-d   \brief hardware script for EP7041-3102
#-d   \details EP7041-3102 stepper drive (24V,5A)
#-d   \author Orell Huerzeler
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP7041-3102")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b814052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EP7041-3102")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- common PDOs for status and control
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX70XX.cmd

#- Max full step freq = 2000Hz (setting is 1)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x5,1,1)"

#- Invert motor polarity = 0
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x9,0,1)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "EL70x1")
