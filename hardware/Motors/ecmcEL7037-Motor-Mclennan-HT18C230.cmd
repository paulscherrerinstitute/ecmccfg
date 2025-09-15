#-d /**
#-d   \brief hardware script for EL7037-Motor-Mclennan-HT18C230
#-d   \details Parametrization of EL7037 for motor Mclennan-HT18C230
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- Set max current to 1500mA (actually max current is 1.73A for serial conection)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1500,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"

#- Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"

#- Coil resistance 1.5 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,150,2)"


#- Coil inductance 4.8mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,480,2)"
