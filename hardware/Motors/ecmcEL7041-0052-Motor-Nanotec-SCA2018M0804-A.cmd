#-d /**
#-d   \brief hardware script for EL70XX-Motor-Nanotec-SCA2018M0804-A
#-d   \details Parmetrization of EL70XX for motor Nanotec-SCA2018M0804-A
#-d   \author Anders Sandstroem
#-d   \note Max current for this motor is set to 800mA RMS
#-d   \param I_RUN_MA     : (optional) Running current in mA (defaults to 800mA)
#-d   \param I_STDBY_MA   : (optional) Standby current in mA (defaults to 100mA)
#-d   \param V_NOM_VA     : (optional) Nominal voltage in mV (defaults to 48000)
#-d   \file
#-d */

epicsEnvSet(I_RUN_MA_LOCAL,${I_RUN_MA=800})
epicsEnvSet(I_STDBY_MA_LOCAL,${I_STDBY_MA=100})
epicsEnvSet(V_NOM_MV_LOCAL,${V_NOM_MV=48000})

#- Call generic script for this motor
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL70XX-Motor-Nanotec-SCA2018M0804-A.cmd "I_RUN_MA=${I_RUN_MA_LOCAL},I_STDBY_MA=${I_STDBY_MA_LOCAL},V_NOM_MV=${V_NOM_MV_LOCAL}"

epicsEnvUnset("I_RUN_MA_LOCAL")
epicsEnvUnset("I_STDBY_MA_LOCAL")
epicsEnvUnset("V_NOM_MV_LOCAL")
