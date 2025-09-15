#-d /**
#-d   \brief hardware script for EL7047-Motor-Phytron-VSS-80.200.5
#-d   \details Parametrization of EL7047 for motor Phytron VSS 80.200.5
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Phytron-VSS-80.200.5.cmd


#- Coil inductance 2.3mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,230,2)"
