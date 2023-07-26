#-d /**
#-d   \brief hardware script for EL7047-Motor-Nanotec-ST4118L1804-B
#-d   \details Parmetrization of EL7047 for motor Nanotec ST4118L184-B
#-d   \param I_MAX_MA     : (optional) Maximum current in mA (defaults to 1.8A)
#-d   \param I_RUN_MA     : (optional) Running current in mA (defaults to max current)
#-d   \param I_STDBY_MA   : (optional) Standby current in mA (defaults to 500mA)
#-d   \param V_MAX_MV     : (optional) Maximum voltage in mV (defaults to 48V)
#-d   \param V_NOM_MV     : (optional) Nominal voltage in mV (defaults to max voltage)
#-d   \file
#-d */

epicsEnvSet(V_MAX_MV_LOCAL,${V_MAX_MV=4800})
epicsEnvSet(V_NOM_MV_LOCAL,${V_NOM_MV=${V_MAX_MV_LOCAL}})

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Nanotec-ST4118L1804.cmd "V_MAX_MV=${V_MAX_MV_LOCAL},V_NOM_MV=${V_NOM_MV_LOCAL}"

#- Coil inductance 3.3mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,330,2)"

epicsEnvUnset("V_MAX_MV_LOCAL")
epicsEnvUnset("V_NOM_MV_LOCAL")
