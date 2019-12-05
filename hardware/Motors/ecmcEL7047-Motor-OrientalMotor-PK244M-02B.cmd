#-d /**
#-d   \brief hardware script for EL7047-Motor-OrientalMotor-PK244M-02B
#-d   \details Parmetrization of EL7047 for motor Oriental Motor PK244M-02B
#-d   \author Orell Hürzeler
#-d   \file
#-d   \note Max current= 2.4 A
#-d   \note Inductance per phase = 9.8 mH
#-d   \note Resistance = 7.5 Ohm
#-d */

#- Set max current to 0.8A per phase 2400mA (max current is ? A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2400,2)"

#- Reduced current 1000mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1000,2)"

#- Nominal voltage 6V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,600,2)"

#- Coil resistance 7.5 Ohm per phase (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,750,2)"

#- Motor full steps count 400
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,400,2)"

#- Coil inductance 9.8 mH per coil
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,980,2)"
