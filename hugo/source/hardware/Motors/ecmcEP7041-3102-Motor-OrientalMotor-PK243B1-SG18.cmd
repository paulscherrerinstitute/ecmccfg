#-d /**
#-d   \brief hardware script for EL7041-3102-Motor-OrientalMotor-PK243B1-SG18
#-d   \details Parmetrization of EL7041-3102 for motor Oriental Motor PK243B1-SG18
#-d   \author Orell Hürzeler
#-d   \file
#-d   \note Max current= 0.95 A
#-d   \note Inductance per phase = 9.8 mH
#-d   \note Resistance = 4.2 Ohm
#-d */

#- Set max current to 0.95A per phase 950mA (max current is ? A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,950,2)"

#- Reduced current 100mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,100,2)"

#- Nominal voltage 6V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,600,2)"

#- Coil resistance 7.5 Ohm per phase (unit 10mOhm)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,750,2)"

#- Motor full steps count 3600
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,3600,2)"

#- Coil inductance 9.8 mH per coil
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,980,2)"
