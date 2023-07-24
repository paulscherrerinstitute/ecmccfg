#-d /**
#-d   \brief hardware script for EL7037-Motor-Nanotec-ST2818S1006 (bipolar series wiring)
#-d   \details Parmetrization of EL7037 for motor Nanotec ST2818S1006 (bipolar series wiring)
#-d   \author Javier Cereijo Garcia
#-d   \file
#-d */

#- Set max current to 670mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,670,2)"

#- Reduced current 200mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"

#- Nominal voltage up to 48V (unit 10mV)
#- Torque curve varies with voltage, check manufacture website
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil resistance 5.6 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,560,2)"

#- Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#- Coil inductance 4mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,400,2)"
