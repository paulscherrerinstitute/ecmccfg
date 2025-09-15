#-d /**
#-d   \brief hardware script for EL7031
#-d   \details EL7031 stepper drive (24V,1.5A)
#-d   \author Anders Sandstroem
#-d   \param V_NOM_MV   :  Nominal voltage in mV
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7031")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b773052")
epicsEnvSet("V_MAX_MV"                   "24000")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- common PDOs for status and control
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX70XX.cmd

#- If V_NOM_MV is not set, issue a warning and fall back to V_MAX_MV
ecmcFileExist("${ECMC_CONFIG_ROOT}issueWarning.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}issueWarning.cmd "EXPR_STR='${V_NOM_MV=-1}<0', WARNING_STR='WARNING: V_NOM_MV not defined. Falling back to ${V_MAX_MV} mV.'"
ecmcEpicsEnvSetCalc "V_NOM_MV" "${V_NOM_MV=${V_MAX_MV}}"

ecmcFileExist("${ECMC_CONFIG_ROOT}chkValidVoltageSetOrDie.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}chkValidVoltageSetOrDie.cmd"

#- Convert from mA to cA
ecmcEpicsEnvSetCalc "V_NOM_MV" "${V_NOM_MV}/10"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,${V_NOM_MV},2)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "EL70x1")
