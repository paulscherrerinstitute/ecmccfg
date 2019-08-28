
############################################################
############# Parmetrization of EL7037 for motor Nanotec ST4118L184-b

#Set max current to 710mA (max current for serial configuration)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,710,2)"

#Reduced current 200mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"

#Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"

#Coil resistance 17.6 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,1760,2)"

#Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#Coil inductance 7.6mH Ohm (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,7600,2)"

