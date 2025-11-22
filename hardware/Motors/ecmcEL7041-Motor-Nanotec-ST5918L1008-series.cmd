#-d /**
#-d   \brief hardware script for EL7041-Motor-Nanotec-ST5918L1008 (series wiring)
#-d   \details Parametrization of EL7041 for motor Nanotec ST5918L1008 (series wiring)
#-d   \file
#-d */

#- Set max current to 710mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,710,2)"

#- Reduced current 200mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"


#- Coil resistance 17.6 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,1760,2)"

