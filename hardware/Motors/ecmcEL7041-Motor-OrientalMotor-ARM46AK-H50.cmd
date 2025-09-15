#-d /**
#-d   \brief hardware script for EL7041-Motor-OrientalMotor-ARM24SAK-H50
#-d   \details Parametrization of EL7041 for motor OrientalMotor ARM24SAK-H50
#-d   \author Alvin Acerbo
#-d   \file
#-d   \note Max current per phase = 1.3 A
#-d   \note Max voltage = 24 VDC
#-d   \note Basic step angle = 0.36 Degrees - 1000 full steps count
#-d */

#- Maximum current: 1480 mA (Actual max current is 1.48A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1480,2)"

#- Reduced current: 500 mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"

#- Nominal voltage 24V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,24000,2)"

#- Motor coil resistance 100 Ohm (unit 0.01Ohm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,100,2)"

