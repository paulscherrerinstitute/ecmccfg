#-d /**
#-d   \brief hardware script for EL7041-Motor-Trinamic-QMot-QSH4218-41-10-035_target
#-d   \details Parametrization of EL7037 for motor Nanotec ST4118L184-b
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- Set max current to 70mA (actually max current is 1.8A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,70,2)"

#- Reduced current 50mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,50,2)"

#- Nominal voltage 48V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#- Coil resistance 4.5 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,450,2)"

