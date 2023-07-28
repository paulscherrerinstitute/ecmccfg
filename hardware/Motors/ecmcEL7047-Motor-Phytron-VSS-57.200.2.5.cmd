#-d /**
#-d   \brief hardware script for EL7047-Motor-Phytron-VSS-57.200.2.5
#-d   \details Parmetrization of EL7047 for motor Phytron VSS 57.200.2.5
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Phytron-VSS-57.200.2.5.cmd

#- Nominal voltage 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil inductance 2.9 mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,290,2)"