#-d /**
#-d   \brief hardware script for EL7047-Motor-OrientalMotor-PK244M-01B
#-d   \details Parametrization of EL7047 for motor Oriental Motor PK244M-01B
#-d   \author Orell Hürzeler
#-d   \file
#-d   \note Max current= 4.8 A
#-d   \note Inductance per phase = 4.3 mH
#-d   \note Resistance per phase = 3.3 Ohm
#-d */

#- Set max current to 1.2A/pase = 4.8A (max current is ? A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,4800,2)"

#- Reduced current 1000mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1000,2)"


#- Coil resistance 3.3 Ohm per phase (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,330,2)"

#- Motor full steps count 400
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,400,2)"

#- Coil inductance 4.3 mH per coil
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,430,2)"
