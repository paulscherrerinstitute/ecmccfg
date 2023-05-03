#-d /**
#-d   \brief hardware script for EL7041-Motor-Phytron-VSS-57.200.1.2
#-d   \details Parmetrization of EL7041 for motor Phytron VSS-57.200.1.2
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note Max current = 1.2 A/phase
#-d   \note Inductance per phase = 11.6 mH
#-d   \note Resistance = 3.9 Ohm
#-d */

#- Set max current to 1000mA (max current is 1.2A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1000,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,800,2)"

#- Nominal voltage 48.0V (unit 1mV) max 48V
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#- Coil resistance 2.0 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,200,2)"

#- Motor full steps count 32x200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,6400,2)"

#- Coil inductance 11.6mH (unit 0.01mH) Not settable in EL7041
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,1160,2)"
