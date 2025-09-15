#-d /**
#-d   \brief hardware script for EL7041-Motor-Phytron-VSS-25.200.1.2
#-d   \details Parametrization of EL7041 for motor Phytron VSS 25.200.1.2
#-d   \author Niko Kivel
#-d   \file
#-d */

#- Set max current to 1.2A (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1200,2)"

#- Reduced current 250mA (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,250,2)"

#- Nominal voltage 48V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#- Coil resistance 0.95 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,95,2)"

