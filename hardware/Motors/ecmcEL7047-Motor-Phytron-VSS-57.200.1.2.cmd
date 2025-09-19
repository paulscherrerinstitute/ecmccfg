#-d /**
#-d   \brief hardware script for EL7047-Motor-Phytron-VSS-57.200.1.2
#-d   \details Parameterization of EL7047 for motor Phytron VSS-57.200.1.2
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Phytron-VSS-57.200.1.2.cmd


#- Coil inductance 11.6mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,1160,2)"
