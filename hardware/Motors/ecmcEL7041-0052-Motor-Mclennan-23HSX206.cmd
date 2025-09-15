#-d /**
#-d   \brief hardware script for EL7041-0052-Motor-Mclenan-23HSX206
#-d   \details Parametrization of EL7041-0052 for motor Mclenan-23HSX206
#-d   \author Julen Etxeberria
#-d   \file
#-d */

#- Set max current to 2000mA (actually max current is 3.0A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2000,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"


#- Coil resistance 0.70 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,70,2)"

