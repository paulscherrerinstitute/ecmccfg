#-d /**
#-d   \brief hardware script for EL7031-Motor-OrientalMotor-PK243B1-SG18
#-d   \details Parametrization of EL7031 for motor Oriental Motor PK243B1-SG18
#-d   \author Orell Hürzeler
#-d   \file
#-d   \note Max current= 0.95 A
#-d   \note Max voltage= 4 V
#-d   \note Inductance per phase =? mH
#-d   \note Resistance = 4.2 Ohm
#-d */

#- Set max current in mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,950,2)"

#- Reduced current 1000mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,95,2)"

#- Nominal voltage 400 cV
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,800,2)"

#- Coil resistance 4.2 cOhm
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,420,2)"

#- Motor stepps
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,400,2)"

#- Coil inductance 1.5mH (unit 0.01mH)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,150,2)"
