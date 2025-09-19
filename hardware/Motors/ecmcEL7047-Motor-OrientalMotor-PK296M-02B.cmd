#-d /**
#-d   \brief hardware script for EL7047-Motor-OrientalMotor-PK296M-02B
#-d   \details Parametrization of EL7047 for motor Oriental Motor PK296M-02B
#-d   \author Orell Hürzeler
#-d   \file
#-d   \note Max current= 2 A
#-d   \note Inductance per phase =? mH
#-d   \note Resistance = 2.25 Ohm
#-d */

#- Set max current to 2000mA (max current is 2A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2000,2)"

#- Reduced current 1000mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1000,2)"


#- Coil resistance 2.25 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,225,2)"

#- Motor full steps count 400
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,400,2)"

#- Coil inductance 1.5mH (unit 0.01mH)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,150,2)"
