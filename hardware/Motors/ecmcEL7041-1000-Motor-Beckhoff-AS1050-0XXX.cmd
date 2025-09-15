#-d /**
#-d   \brief hardware script for EL7041-1000-Motor-Beckhoff-AS1050-0XXX
#-d   \details Parametrization of EL7041-1000 for motor Beckhoff AS1050-0XXX
#-d   \author Niko Kivel
#-d   \file
#-d   \note Torque: 1.2 Nm
#-d   \note Phase Current: 5.0 A
#-d   \note Resolution: 1.8 deg/step (200 steps/rev)
#-d   \note Resistence: 0.28 Ohm
#-d   \note Inductance: 0.86 mH
#-d   \note Voltge: 24-50V
#-d   \note Beckhoff Manual for EL7041: https://download.beckhoff.com/download/document/io/ethercat-terminals/el70x1en.pdf
#-d   \note Beckhoff Manual for AS1050-0120: https://www.beckhoff.com/english.asp?drive_technology/as1050.htm
#-d */

#-----------------------------------------------------------
#-  Index 8010 STM Motor Settings Ch.1
#-
#- Set max current (unit 1mA)
#-  8010:01 Maximal current
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,5000,2)"
#- reduced to 1/10 th of nominal for testing
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2500,2)"

#- Nominal voltage 48V (unit 1mV)
#- 8010:03 Nominal voltage
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

