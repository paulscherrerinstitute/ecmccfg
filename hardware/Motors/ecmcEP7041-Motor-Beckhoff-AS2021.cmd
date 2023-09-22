#-d /**
#-d   \brief hardware script for EP7041-Motor-Beckhoff-AS2021
#-d   \details Parametrization of EL7041 for AS2021-XXXX
#-d   \author Niko Kivel
#-d   \file
#-d   \note Unipolar Motor
#-d   \note Max current per phase = 2.0 A
#-d   \note Voltage = 24/50 V
#-d   \note Inductance per phase = ? mH
#-d   \note Resistance per phase = ? Ohm
#-d   \note Basic step angle = 1.8 Degrees - 200 full steps count
#-d */

#- Set max current in mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2000,2)"

#- Reduced current in mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,250,2)"

#- Nominal voltage in cV
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,1200,2)"

#- Coil resistance in cOhm
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,750,2)"

#- Coil inductance in 10^-5 H
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,990,2)"

#- Motor full steps count
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"
