#-d /**
#-d   \brief hardware script for EL7041-Motor-Nanotec-ST2818S1006 (bipolar series wiring)
#-d   \details Parametrization of EL7041 for motor Nanotec ST2818S1006 (bipolar series wiring)
#-d   \file
#-d */

#- Set max current to 670mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,670,2)"

#- Reduced current 200mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"


#- Coil resistance 5.6 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,560,2)"

