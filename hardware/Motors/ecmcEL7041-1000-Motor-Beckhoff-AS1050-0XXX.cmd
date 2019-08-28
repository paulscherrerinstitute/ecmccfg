############################################################
############# Parmetrization of EL7041-1000 for motor Beckhoff AS1050-0XXX
############# Configuration file written by Niko Kivel, PSI

# Beckhoff Manual for EL7041: https://download.beckhoff.com/download/document/io/ethercat-terminals/el70x1en.pdf
# Beckhoff Manual for AS1050-0120: https://www.beckhoff.com/english.asp?drive_technology/as1050.htm
#

# Configuration for motor:
# Characteristics:
# Torque: 1.2 Nm
# Phase Current: 5.0 A
# Resolution: 1.8 deg/step (200 steps/rev)
# Resistence: 0.28 Ohm
# Inductance: 0.86 mH 
# Voltge: 24-50V
#
#-----------------------------------------------------------
# Index 8010 STM Motor Settings Ch.1
#
#Set max current (unit 1mA)
# 8010:01 Maximal current
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,5000,2)"
#reduced to 1/10 th of nominal for testing
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2500,2)"

#Nominal voltage 48V (unit 1mV)
#8010:03 Nominal voltage
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#Motor full steps count 200 - step angle degree: 1.8 deg
#8010:06 Motor fullsteps
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"
