#-d /**
#-d   \brief hardware script for EL7047
#-d   \details EL7047 stepper drive (24V,5A)
#-d   \author Anders Sandstroem
#-d   \param V_NOM_MV   :  Nominal voltage in mV
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7047")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b873052")
epicsEnvSet("V_MAX_MV"                   "48000")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- common PDOs for status and control
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX70XX.cmd

ecmcFileExist("${ECMC_CONFIG_ROOT}chkValidVoltageSetOrDie.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}chkValidVoltageSetOrDie.cmd"

ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,${V_NOM_MV},2)"

#- Error on loss of steps = 1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0xA,1,1)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex70x7")
