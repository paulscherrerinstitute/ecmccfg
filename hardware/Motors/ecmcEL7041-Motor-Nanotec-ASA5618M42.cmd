#-d /**
#-d   \brief hardware script for ecmcEL7041-Motor-Nanotec-ASA5618M42
#-d   \details Parametrization of EL7041 for motor Nanotec ecmcEL7041-Motor-Nanotec-ASA5618M42
#-d   \author Niko Kivel
#-d   \file
#-d */

#- Set max current to 4200mA (actually max current is 4.2A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,4200,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,2000,2)"


#- Coil resistance 0.5 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,50,2)"


#- Coil inductance 1.5mH (unit 0.01mH) NOT USED FOR EL7041
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,150,2)"

