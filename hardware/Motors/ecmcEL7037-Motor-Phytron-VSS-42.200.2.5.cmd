#-d /**
#-d   \brief hardware script for EL7037-Motor-Phytron-VSS-42.200.2.5
#-d   \details Parmetrization of EL7037 for motor Phytron VSS 42.200.2.5
#-d   \file
#-d */

#- Load common config from EL7047
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7047-Motor-Phytron-VSS-42.200.2.5.cmd

#- Set max current to 1500mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1500,2)"

#- Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"
