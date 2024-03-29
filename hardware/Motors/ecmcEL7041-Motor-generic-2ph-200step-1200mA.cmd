#-d /**
#-d   \brief hardware script for EL7041-Motor-generic-2ph-200step-1200mA
#-d   \details Parametrization of EL7041 for a generic 2 phase 200 step/rev motor rated at 1.2 A
#-d   \author Niko Kivel
#-d   \file
#-d   \note Max current= 1.2 A
#-d */

#- Set max current to 1200 mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,1200,2)"

#- Reduced current 200mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,100,2)"

#- Nominal voltage 48V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#- Coil resistance 1.13 Ohm (unit 10mOhm)
#- EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,113,2)"

#- Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#-  8011:01 Kp factor (curr.) Kp control factor (proportional component) for the current controller (unit: 0.001) UINT16 RW default was 400
#- EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1,2000,2)"

#-  8011:02 Ki factor (curr.) Ki control factor (integral component) for the current controller (unit: 0.001) UINT16 RW default 4
#- EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2,50,2)"

#-  8011:03 Inner window (curr.) Inner window for the I component of the current controller (unit: 1%) UINT8 RW 0x00 (0 dec)
#- EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x3,0,1)"

#-  8011:05 Outer window (curr.) Outer window for the I component of the current controller (unit: 1%) UINT8 RW 0x00 (0 dec)
#- EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x5,0,1)"

#-  8011:06 Filter cut off frequency (curr.) Filter limit frequency of the current controller (low-pass, unit: 1 Hz) UINT16 RW 0x0000 (0 dec)
#-  8011:07 Ka factor (curr.) Ka control factor (acceleration component) for the current controller (unit: 0.001) UINT16 RW 0x0064 (100 dec)
#-  8011:08 Kd factor (curr.) Kd control factor (deceleration component) for the current controller (unit: 0.001) UINT16 RW 0x0064 (100 dec)
