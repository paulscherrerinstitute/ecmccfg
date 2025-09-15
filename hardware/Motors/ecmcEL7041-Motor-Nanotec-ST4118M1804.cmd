#-d /**
#-d   \brief hardware script for EL7041-Motor-Nanotec-ST4118M1804-B
#-d   \details Parametrization of EL7041 for motor Nanotec ST4118M184-b
#-d   \author Julen Etxeberria (ported to ecmccfg by Javier Cereijo Garcia)
#-d   \file
#-d */

#- Set max current to 1.8A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1800,2)"

#- Reduced current 500mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"

#- Nominal voltage 48V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#- Coil resistance 1.1 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,110,2)"

