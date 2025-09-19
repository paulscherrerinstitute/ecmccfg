#-d /**
#-d   \brief hardware script for EL7041-Motor-Phytron-VSS-52.200.2.5
#-d   \details Parametrization of EL7041 for motor Phytron VSS 52.200.2.5
#-d   \author Julen Etxeberria
#-d   \file
#-d */

#- Set max current to 2.5A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2500,2)"

#- Reduced current 200mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"


#- Coil resistance 0.6 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,60,2)"

