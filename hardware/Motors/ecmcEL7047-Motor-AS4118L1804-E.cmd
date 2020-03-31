#-d /**
#-d   \brief hardware script for EL7047-Motor-AS4118L1804-E
#-d   \details Parmetrization of EL7047 for motor AS4118L1804-E
#-d   \author Julen Etxeberria
#-d   \file
#-d   \note Max current= 1.8 A
#-d   \note Inductance per phase =3.3 mH
#-d   \note Resistance =1.75 Ohm
#-d */

#- Set max current to 1800mA (actually max current is 2.8A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1800,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"

#- Nominal voltage 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil resistance 1.75 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,175,2)"

#- Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#- Coil inductance 3.3mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,330,2)"
