
############################################################
############# Parmetrization of EL7047 for motor Nanotec Leadshine Tecnology mod. 57HS09
############# COnfiguration file written by Maurizio Montis - INFN-LNL

# Beckhoff Manual for EL7047: https://download.beckhoff.com/download/document/io/ethercat-terminals/el70x7en.pdf
# Leadshine Manual for 57HS09: http://www.leadshine.com/UploadFile/Down/57HSxxd.pdf
#

# Configuration for motor in Bipolar-Serie setup
# Characteristics:
# Torque: 1.3 Nm
# Phase Current: 2.0 A
# Resistence: 1.6 Ohm
# Inductance: 4.8 mH 

#Set max current (unit 1mA)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2115,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,3000,2)"

#Reduced current 500mA (unit 1mA)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1500,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,2000,2)"

#Nominal voltage 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#Coil resistance 4.5 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,360,2)"

#Motor full steps count 200 - step angle degree: 1.8 deg
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#Coil inductance 7.5mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,600,2)"



