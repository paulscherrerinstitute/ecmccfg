#-d /**
#-d   \brief hardware script for ecmcEL7041-Motor-OwisLTM60.cmd
#-d   \details Parametrization of EL7041 for motor mounted to an OWIS LTM60 linear stage
#-d   \author Niko Kivel
#-d   \file
#-d */

#- Set max current to 1000mA (actually max current is 1.5A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1000,2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"


#- Coil resistance 1.7 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,170,2)"


#- Coil inductance 2.9mH (unit 0.01mH)
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,290,2)"
