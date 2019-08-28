############################################################
############# Parmetrization of EL7047 for motor Oriental Motor PK296DB
# Max current= 4.5A
# Inductance per phase =1.5mH
# Resistance =1.13 Ohm

#Set max current to 4000mA (max current is 4.5A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,4000,2)"

#Reduced current 1000mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1000,2)"

#Nominal voltage 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#Coil resistance 0.24 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,24,2)"

#Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#Coil inductance 1.5mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,150,2)"
