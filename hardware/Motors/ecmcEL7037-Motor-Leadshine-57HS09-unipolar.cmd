#-d /**
#-d   \brief hardware script for EL7037-Motor-Leadshine-57HS09 (unipolar wiring)
#-d   \details Parametrization of EL7037 for motor Nanotec Leadshine Tecnology mod. 57HS09 (unipolar wiring)
#-d   \file
#-d */

#- Load common config from EL7047
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7047-Motor-Leadshine-57HS09-unipolar.cmd

#- Set max current to 1.5A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1500,2)"

#- Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"
