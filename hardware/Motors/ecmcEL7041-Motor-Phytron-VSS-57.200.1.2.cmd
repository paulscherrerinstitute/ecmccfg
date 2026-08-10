#-d /**
#-d   \brief hardware script for EL7041-Motor-Phytron-VSS-57.200.1.2
#-d   \details Parameterization of EL7041 for motor Phytron VSS-57.200.1.2
#-d   \author Alvin Acerbo
#-d   \file
#-d */

#- Set max current to 1.2A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1200,2)"

#- Reduced current 800mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,800,2)"


#- Coil resistance 3.9 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,390,2)"

