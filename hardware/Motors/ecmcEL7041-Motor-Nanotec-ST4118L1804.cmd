#-d /**
#-d   \brief hardware script for EL7041-Motor-Nanotec-ST4118L1804-B
#-d   \details Parametrization of EL7041 for motor Nanotec ST4118L184-B
#-d   \author Anders Sandstroem
#-d   \param I_MAX_MA     : (optional) Maximum current in mA (defaults to 1.8A)
#-d   \param I_RUN_MA     : (optional) Running current in mA (defaults to max current)
#-d   \param I_STDBY_MA   : (optional) Standby current in mA (defaults to 500mA)
#-d   \param V_MAX_MV     : (optional) Maximum voltage in mV (defaults to 48V)
#-d   \param V_NOM_MV     : (optional) Nominal voltage in mV (defaults to max voltage)
#-d   \file
#-d */

epicsEnvSet(I_MAX_MA_LOCAL,${I_MAX_MA=1800})
epicsEnvSet(I_RUN_MA_LOCAL,${I_RUN_MA=${I_MAX_MA_LOCAL}})
epicsEnvSet(I_STDBY_MA_LOCAL,${I_STDBY_MA=500})
epicsEnvSet(V_MAX_MV_LOCAL,${V_MAX_MV=48000})
epicsEnvSet(V_NOM_MV_LOCAL,${V_NOM_MV=${V_MAX_MV_LOCAL}})

#- Ensure valid current settings
ecmcFileExist("${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd "I_RUN_MA=${I_RUN_MA_LOCAL},I_STDBY_MA=${I_STDBY_MA_LOCAL},I_MAX_MA=${I_MAX_MA_LOCAL}"

#- Set max current (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,${I_RUN_MA_LOCAL},2)"

#- Reduced current (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,${I_STDBY_MA_LOCAL},2)"

#- Nominal voltage (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,${V_NOM_MV_LOCAL},2)"

#- Coil resistance 1.75 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,175,2)"


epicsEnvUnset("I_MAX_MA_LOCAL")
epicsEnvUnset("I_RUN_MA_LOCAL")
epicsEnvUnset("I_STDBY_MA_LOCAL")
epicsEnvUnset("V_MAX_MV_LOCAL")
epicsEnvUnset("V_NOM_MV_LOCAL")
