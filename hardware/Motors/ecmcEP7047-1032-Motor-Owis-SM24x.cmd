#-d /**
#-d   \brief hardware script for EP7047-1032-Motor-Owis-SM24x
#-d   \details Parmetrization of EP7047-1032 for motor Owis-SM24x
#-d   \author Niko Kivel
#-d   \file
#-d   \note Max current = 1.5 A
#-d   \note Inductance per phase = 2.9 mH
#-d   \note Resistance = 1.7 Ohm
#-d */

#- Set max current to 500mA (actually max current is 1.5A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,500,2)"

#- Reduced current 100mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,100,2)"

#- Nominal voltage 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil resistance 1.7 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,170,2)"

#- Coil inductance 2.9mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,290,2)"
