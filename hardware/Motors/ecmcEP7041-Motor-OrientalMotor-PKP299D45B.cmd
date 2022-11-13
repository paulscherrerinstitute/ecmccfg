#-d /**
#-d   \brief hardware script for EP7041-Motor-OrientalMotor-PKP299D45B
#-d   \details Parmetrization of EP7041 for motor Oriental Motor PKP299D45B
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note Max current = 4.5 A/phase
#-d   \note Inductance per phase = 5.4 mH
#-d   \note Resistance = 0.6 Ohm
#-d */


#- Set max current to 2500 mA (actually max current is 4.5A for this motor) 
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,4500,2)" 

#- Reduced current 500 mA 
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1500,2)" 

#- Nominal voltage 4.7V (unit 10mV) 
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,470,2)"

