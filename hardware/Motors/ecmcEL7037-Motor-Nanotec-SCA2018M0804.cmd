#-d /**
#-d   \brief hardware script for EL7037-Motor-Nanotec-SCA2018M0804
#-d   \details Parametrization of EL7037 for motor Nanotec SCA2018M0804
#-d   \file
#-d */

epicsEnvSet(V_MAX_MV_LOCAL,${V_MAX_MV=2400})
epicsEnvSet(V_NOM_MV_LOCAL,${V_NOM_MV=${V_MAX_MV_LOCAL}})

#- Load common config from EL7047
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7047-Motor-Nanotec-SCA2018M0804.cmd "V_MAX_MV=${V_MAX_MV_LOCAL},V_NOM_MV=${V_NOM_MV_LOCAL}"

epicsEnvUnset("V_MAX_MV_LOCAL")
epicsEnvUnset("V_NOM_MV_LOCAL")
