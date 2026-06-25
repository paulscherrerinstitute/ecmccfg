#-d /**
#-d   \brief hardware script for EL7047-Motor-Leadshine-57HS04 (series wiring)
#-d   \details Parametrization of EL7047 for motor Nanotec Leadshine Tecnology mod. 57HS04 (series wiring)
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Leadshine-57HS04-series.cmd


#- Coil inductance 1.4mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,140,2)"
