#-d /**
#-d   \brief hardware script for EL7047-Motor-Beckhoff-AS1050-0110
#-d   \details Parametrization of EL7047 for motor Beckhoff AS1050-0110
#-d   \author Maurizio Montis
#-d   \file
#-d   \note Torque: 1.2 Nm
#-d   \note Phase Current: 5.0 A
#-d   \note Resistence: 0.28 Ohm
#-d   \note Inductance: 0.86 mH
#-d   \note Voltge: 24-50V
#-d   \note Beckhoff Manual for EL7047: https://download.beckhoff.com/download/document/io/ethercat-terminals/el70x7en.pdf
#-d   \note Beckhoff Manual for AS1050-0110: https://www.beckhoff.it/as1050/
#-d */

#- Set max current (unit 1mA)
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2115,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,5000,2)"

#- Reduced current 500mA (unit 1mA)
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,1500,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,2000,2)"


#- Coil resistance 4.5 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,280,2)"


#- Coil inductance 7.5mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,860,2)"
