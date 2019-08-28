
############################################################
############# Parmetrization of EL7047 for motor Nanotec Leadshine Tecnology mod. 57HS09
############# COnfiguration file written by Maurizio Montis - INFN-LNL

# Beckhoff Manual for EL7047: https://download.beckhoff.com/download/document/io/ethercat-terminals/el70x7en.pdf
# Beckhoff Manual for AS1050-0110: https://www.beckhoff.it/as1050/
#

# Configuration for motor:
# Characteristics:
# Torque: 1.2 Nm
# Phase Current: 5.0 A
# Resistence: 0.28 Ohm
# Inductance: 0.86 mH 
# Voltge: 24-50V 

#Set max current (unit 1mA)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2115,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,5000,2)"

#Reduced current 500mA (unit 1mA)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1500,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,2000,2)"

#Nominal voltage 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#Coil resistance 4.5 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,280,2)"

#Motor full steps count 200 - step angle degree: 1.8 deg
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#Coil inductance 7.5mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,860,2)"



