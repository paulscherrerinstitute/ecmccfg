#-d /**
#-d   \brief hardware script for EL7041-Motor-Trinamic-QMot-QSH4218-41-10-035
#-d   \details Parametrization of EL7037 for motor Nanotec ST4118L184-b
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- Set max current to 1000mA (actually max current is 1.8A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1000,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,100,2)"


#- Coil resistance 4.5 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,450,2)"

