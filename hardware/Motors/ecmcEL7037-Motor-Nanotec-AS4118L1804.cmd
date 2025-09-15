#-d /**
#-d   \brief hardware script for EL7037-Motor-Nanotec-AS4118L1804
#-d   \details Parametrization of EL7037 for motor Nanotec AS4118L1804
#-d   \author Julen Etxeberria (ported to ecmccfg by Javier Cereijo Garcia)
#-d   \file
#-d */

#- Load common config from EL7047
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7047-Motor-Nanotec-AS4118L1804.cmd

#- Set max current to 1.5A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1500,2)"

