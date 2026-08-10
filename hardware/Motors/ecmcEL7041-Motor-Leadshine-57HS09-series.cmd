#-d /**
#-d   \brief hardware script for EL7041-Motor-Leadshine-57HS09 (series wiring)
#-d   \details Parametrization of EL7041 for motor Nanotec Leadshine Tecnology mod. 57HS09 (series wiring)
#-d   \file
#-d */

#- Set max current to 2A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2000,2)"

#- Reduced current 500mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"


#- Coil resistance 1.6 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,160,2)"

