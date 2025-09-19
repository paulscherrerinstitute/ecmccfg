#-d /**
#-d   \brief hardware script for EL7047-Motor-AMS-AM23-239-3
#-d   \details Parametrization of EL7047 for motor AMS-AM23-239-3
#-d   \author Julen Etxeberria
#-d   \file
#-d   \note Max current= 3.0 A
#-d   \note Inductance per phase =3.36 mH
#-d   \note Resistance =0.95 Ohm
#-d */

#- Set max current to 3000mA (actually max current is 3.0A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,3000,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"


#- Coil resistance 0.95 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,95,2)"


#- Coil inductance 3.36mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,336,2)"
