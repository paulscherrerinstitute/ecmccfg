#-d /**
#-d   \brief hardware script for EL7037-Motor-Nanotec-ST2818M1006 (unipolar or bipolar 1 winding wiring)
#-d   \details Parmetrization of EL7037 for motor Nanotec ST2818M1006 (unipolar or bipolar 1 winding wiring)
#-d   \author Julen Etxeberria Malkorra
#-d   \file
#-d */

#- Set max current to 950mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,950,2)"

#- Reduced current 200mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,200,2)"

#- Nominal voltage up to 48V (unit 10mV)
#- Torque curve varies with voltage, check manufacture website
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil resistance 3.4 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,340,2)"

#- Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#- Coil inductance 1.2mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,120,2)"
