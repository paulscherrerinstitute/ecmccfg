#-d /**
#-d   \brief hardware script for EL7041-Motor-AS4118L1804
#-d   \details Parametrization of EL7041 for motor AS4118L1804
#-d   \file
#-d */

#- Set max current to 1.8A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1800,2)"

#- Reduced current 500mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"


#- Coil resistance 1.75 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,175,2)"

