#-d /**
#-d   \brief hardware script for EL7031-Motor-Faulhaber-2513
#-d   \details Parmetrization of EL7031 for motor Faulhaber 2513
#-d   \author Orell Hürzeler
#-d   \file
#-d   \note Unipolar Motor
#-d   \note Max current per phase = 0.25 A
#-d   \note Max voltage = ? V (V for bipolar usage)
#-d   \note Inductance per phase = ? mH
#-d   \note Resistance per phase = ? Ohm
#-d   \note Basic step angle = ? Degrees - 400 full steps count
#-d */

#- Set max current in mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,250,2)"

#- Reduced current in mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,25,2)"

#- Nominal voltage in cV
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,1200,2)"

#- Coil resistance in cOhm
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,750,2)"

#- Coil inductance in 10^-5 H
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,990,2)"

#- Motor full steps count
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,400,2)"
