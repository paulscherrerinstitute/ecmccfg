#-d /**
#-d   \brief hardware script for EL7041-Motor-Nanotec-ST5918L1008 (parallel wiring)
#-d   \details Parametrization of EL7041 for motor Nanotec ST5918L1008 (parallel wiring)
#-d   \file
#-d */

#- Set max current to 1.41A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1410,2)"

#- Reduced current 200mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"


#- Coil resistance 4.4 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,440,2)"

