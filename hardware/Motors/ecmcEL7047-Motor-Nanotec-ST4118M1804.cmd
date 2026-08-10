#-d /**
#-d   \brief hardware script for EL7047-Motor-Nanotec-ST4118M1804-B
#-d   \details Parametrization of EL7047 for motor Nanotec ST4118M184-B
#-d   \author Idoia Mazkiaran (ported to ecmccfg by Javier Cereijo Garcia)
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Nanotec-ST4118M1804.cmd


#- Coil inductance 1.85mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,185,2)"
