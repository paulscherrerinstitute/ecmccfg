#-d /**
#-d   \brief hardware script for EL7041-Motor-OrientalMotor-PK296DB
#-d   \details Parametrization of EL7047 for motor Oriental Motor PK296DB
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note Max current= 4.5 A
#-d   \note Inductance per phase =1.5 mH
#-d   \note Resistance =1.13 Ohm
#-d */

#- Set max current to 4000mA (max current is 4.5A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,4000,2)"

#- Reduced current 1000mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1000,2)"


#- Coil resistance 0.24 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,24,2)"


#- Coil inductance 1.5mH (unit 0.01mH) Not settable in EL7041
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,150,2)"
