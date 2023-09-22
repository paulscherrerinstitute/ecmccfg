#-d /**
#-d   \brief hardware script for EL7037-Motor-Phytron-VSS-25.200.1.2
#-d   \details Parametrization of EL7037 for motor Phytron VSS 25.200.1.2
#-d   \file
#-d */

#- Load common config from EL7047
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7047-Motor-Phytron-VSS-25.200.1.2.cmd

#- Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"
