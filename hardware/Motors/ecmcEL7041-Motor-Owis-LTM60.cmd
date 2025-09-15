#-d /**
#-d   \brief hardware script for EL7041-Motor-Owis-LTM60
#-d   \details Parametrization of EL7041 for motor Owis LTM60
#-d   \author Julen Etxeberria Malkorra - Saeed Haghtalab
#-d   \file
#-d */

#- Set max current to 1500 mA (actually max current is 1.5A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1500,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"


#- Coil resistance 1 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,100,2)"

