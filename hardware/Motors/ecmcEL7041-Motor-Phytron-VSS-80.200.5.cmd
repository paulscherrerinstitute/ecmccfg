#-d /**
#-d   \brief hardware script for EL7041-Motor-Phytron-VSS-80.200.5
#-d   \details Parametrization of EL7041 for motor Phytron VSS 80.200.5
#-d   \file
#-d */

#- Set max current to 5A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,5000,2)"

#- Reduced current 200mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"


#- Coil resistance 0.4 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,40,2)"

