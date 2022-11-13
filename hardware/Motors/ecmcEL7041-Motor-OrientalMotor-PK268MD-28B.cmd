#-d /**
#-d   \brief hardware script for EL7041-Motor-OrientalMotor-PK268MD
#-d   \details Parmetrization of EL7041 for motor Oriental Motor PK268MD
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note Max current = 2.8 A/phase
#-d   \note Inductance per phase = 5.6 mH
#-d   \note Resistance = 1.23 Ohm
#-d */

#- Set max current to 2000mA (max current is 2.8A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2000,2)"

#- Reduced current 600mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,600,2)"

#- Nominal voltage 3.4V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,340,2)"

#- Coil resistance 1.23 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,123,2)"

#- Motor full steps count 400
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,400,2)"

#- Coil inductance 5.6mH (unit 0.01mH) Not settable in EL7041
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,560,2)"
