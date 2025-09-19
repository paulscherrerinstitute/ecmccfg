#-d /**
#-d   \brief hardware script for EL7047-Motor-Nanotec-SCA5618X2804
#-d   \details Parametrization of EL7047 for motor Nanotec SCA5618X2804
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Nanotec-SCA5618X2804.cmd


#- Coil inductance 1.8mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,180,2)"
