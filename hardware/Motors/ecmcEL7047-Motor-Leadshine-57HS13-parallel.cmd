#-d /**
#-d   \brief hardware script for EL7047-Motor-Leadshine-57HS13 (parallel wiring)
#-d   \details Parametrization of EL7047 for motor Nanotec Leadshine Tecnology mod. 57HS13 (parallel wiring)
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Leadshine-57HS13-parallel.cmd


#- Coil inductance 2.1mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,210,2)"
