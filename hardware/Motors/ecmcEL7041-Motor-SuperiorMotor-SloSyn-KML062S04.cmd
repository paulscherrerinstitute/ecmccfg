#-d /**
#-d   \brief hardware script for ecmcEL7041-Motor-SuperiorMotor-SloSyn-KML062S04
#-d   \details Parmetrization of EL7041 for motor SuperiorMotor-SloSyn-KML062S04
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note Max current = 2.12 A/phase
#-d   \note Inductance per phase = 4.22 mH
#-d   \note Resistance = 1.47 Ohm (Measured: 3.6 Ohm)
#-d */

#- Set max current to 1800mA (max current is 2.12A for this motor) (unit 1mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1800,2)"

#- Reduced current 600mA (unit 1 mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,600,2)"

#- Nominal voltage 48V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#- Coil resistance 1.47 Ohm measured 3.2+0.4 Ohm (unit 10mOhm)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,147,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,360,2)"


#- Coil inductance 4.22mH (unit 0.01mH) Not settable in EL7041
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,422,2)"
