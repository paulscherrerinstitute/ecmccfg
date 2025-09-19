#-d /**
#-d   \brief hardware script for EL7047-Motor-Nanotec-AS4118L1804
#-d   \details Parametrization of EL7047 for motor Nanotec AS4118L1804
#-d   \author Julen Etxeberria (ported to ecmccfg by Javier Cereijo Garcia)
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Nanotec-AS4118L1804.cmd


#- Coil inductance 3.3mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,330,2)"
