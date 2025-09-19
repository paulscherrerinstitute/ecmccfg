#-d /**
#-d   \brief hardware script for EL7041-Motor-Nanotec-ST5918L1008 (unipolar wiring)
#-d   \details Parametrization of EL7041 for motor Nanotec ST5918L1008 (unipolar wiring)
#-d   \file
#-d */

#- Set max current to 1A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1000,2)"

#- Reduced current 200mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"


#- Coil resistance 8.8 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,880,2)"

