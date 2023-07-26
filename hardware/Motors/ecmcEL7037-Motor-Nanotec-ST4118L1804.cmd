#-d /**
#-d   \brief hardware script for EL7037-Motor-Nanotec-ST4118L1804-B
#-d   \details Parmetrization of EL7037 for motor Nanotec ST4118L184-B
#-d   \author Anders Sandstroem
#-d   \param I_MAX_MA     : (optional) Maximum current in mA (defaults to 1.5A)
#-d   \param I_RUN_MA     : (optional) Running current in mA (defaults to max current)
#-d   \param I_STDBY_MA   : (optional) Standby current in mA (defaults to 500mA)
#-d   \param V_MAX_MV     : (optional) Maximum voltage in mV (defaults to 24V)
#-d   \param V_NOM_MV     : (optional) Nominal voltage in mV (defaults to max voltage)
#-d   \note Max current for this motor is 1.8A but drive only allows 1.5A
#-d   \file
#-d */

epicsEnvSet(I_MAX_MA_LOCAL,${I_MAX_MA=1500})
epicsEnvSet(I_RUN_MA_LOCAL,${I_RUN_MA=${I_MAX_MA_LOCAL}})
epicsEnvSet(V_MAX_MV_LOCAL,${V_MAX_MV=2400})
epicsEnvSet(V_NOM_MV_LOCAL,${V_NOM_MV=${V_MAX_MV_LOCAL}})

#- Load common config from EL7047
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7047-Motor-Nanotec-ST4118L1804.cmd "I_MAX_MA=${I_MAX_MA_LOCAL},I_RUN_MA=${I_RUN_MA_LOCAL},V_MAX_MV=${V_MAX_MV_LOCAL},V_NOM_MV=${V_NOM_MV_LOCAL}"

epicsEnvUnset("I_MAX_MA_LOCAL")
epicsEnvUnset("I_RUN_MA_LOCAL")
epicsEnvUnset("V_MAX_MV_LOCAL")
epicsEnvUnset("V_NOM_MV_LOCAL")
