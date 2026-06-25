#-d /**
#-d   \brief hardware script for EL7041-Motor-Phytron-VSS-57.200.2.5
#-d   \details Parametrization of EL7041 for motor Phytron VSS 57.200.2.5
#-d   \file
#-d */

#- Set max current to 2.5A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2500,2)"

#- Reduced current 500mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"


#- Coil resistance 0.8 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,80,2)"

