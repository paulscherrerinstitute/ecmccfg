#-d /**
#-d   \brief hardware script for EL7031-Motor-OrientalMotor-PK244M-01B
#-d   \details Parmetrization of EL7031 for motor OrientalMotor-PK244M-01B
#-d   \author Orell Hürzeler
#-d   \file
#-d   \note Unipolar Motor
#-d   \note Max current per phase = 1.2 A
#-d   \note Max voltage = 4 V (8V for bipolar usage)
#-d   \note Inductance per phase = 4.3 mH
#-d   \note Resistance per phase = 3.3 Ohm
#-d   \note Basic step angle = 0.9 Degrees - 400 full steps count
#-d */

#- Set max current in mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1200,2)"

#- Reduced current in mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,120,2)"

#- Nominal voltage in cV
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,800,2)"

#- Coil resistance in cOhm
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,330,2)"

#- Coil inductance in 10^-5 H
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,430,2)"

#- Motor full steps count
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,400,2)"
