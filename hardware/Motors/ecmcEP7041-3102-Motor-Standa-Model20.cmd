#-d /**
#-d   \brief hardware script for EP7041-3102-Motor-Standa-Model20
#-d   \details Parametrization of EL7041-3102 for motor Standa Model 20
#-d   \author Niko Kivel
#-d   \file
#-d   \note Max current per phase = 0.6 A
#-d   \note Max voltage = 4.3 V
#-d   \note Inductance per phase = 1.5 mH (not used for Ex70x1 slaves)
#-d   \note Resistance per phase = 5.4 Ohm (not used for Ex70x1 slaves)
#-d   \note Basic step angle = 1.8 Degrees - 200 full steps count
#-d */

#- Set max current in mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,250,2)"

#- Reduced current in mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,0,2)"

#- Nominal voltage in cV
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,430,2)"

#- Motor full steps count
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"
