#-d /**
#-d   \brief hardware script for EL7041-1000-Motor-Amp-57TH76-4280
#-d   \details Parametrization of EL7041-1000 for motor Amp-57TH76-4280
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note Phase Current: 2.8A A
#-d   \note Resolution: 1.8 deg/step (200 steps/rev)
#-d   \note Voltge: 24--50V
#-d   \note Beckhoff Manual for EL7041: https://download.beckhoff.com/download/document/io/ethercat-terminals/el70x1en.pdf
#-d */

#-----------------------------------------------------------
#-  Index 8010 STM Motor Settings Ch.1
#-
#- Set max current (unit 1mA)
#- Set max current to 2800mA (max current is 2.8A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2800,2)"

#- Nominal voltage 48V (unit 1mV)
#- 8010:03 Nominal voltage
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#- Motor full steps count 200 - step angle degree: 1.8 deg
#- 8010:06 Motor fullsteps
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"
