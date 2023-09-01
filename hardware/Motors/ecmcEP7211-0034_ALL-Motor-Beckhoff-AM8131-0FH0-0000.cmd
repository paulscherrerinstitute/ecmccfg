#-d /**
#-d   \brief hardware script for EP7211-0034-Motor-Beckhoff-AM8131-0FH0-0000
#-d   \details Parametrization of EP7211 for motor Beckhoff AM8131-0FH0-0000
#-d   \author Niko Kivel
#-d   \file
#-d   \note For important parameters see TwinCAT CoE startup list for the motor terminal configuration.
#-d 
#-d   \file
#-d */

#- 0x9009 0x0A Effective nominal voltage (mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,48000,4)"

#- 0x9009 0x07 Effective Max current (mA) In twincat 27.8A!!!!
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,10000,4)"
#- 0x9009 0x08 Effective rated current (mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,4950,4)"
#- 0x9009 0x06 Number of pole pair
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x13,4,1)"
#-
#- Commutation offset = -90 (reset by auto-configuration)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x15,-90,2)"

#- 0x9009 0x0E Torque constant (mNm/A)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x16,270,4)"
#- 0x9009 0x14 Mass moment of inertia (g cm^2)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,467,4)"
#- 0x9009 0x11 Inductance in the direction of flow (0.1 mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x19,53,2)"
#- 0x9009 0x18 Thermal time constant of the motor (s)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2d,721,2)"

#- 0x9009 0x13 Maximum speed (rpm)
#- --> 10000 (reset by auto-configuration to 5406)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,1233,4)"
#-
#- Current loop integral time = 5 (reset by auto-configuration to 10)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x12,5,2)"
#- Current loop proportianal gain = 106 (reset by auto-configuration to 100)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x13,628,2)"
#- Velocity loop integral time = 50 (reset by auto-configuration to 50)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,150,4)"
#- Velocity loop proportianal gain = 150 (reset by auto-configuration to 150)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,151,4)"

