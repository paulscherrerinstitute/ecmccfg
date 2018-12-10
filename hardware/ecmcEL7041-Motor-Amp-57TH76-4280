
############################################################
############# Parmetrization of EL7041 for motor AMP-57TH76-4280
# Max current= 2.8A
# Inductance per phase =3.6mH
# Resistance =1.13 Ohm

#Set max current to 2800mA (actually max current is 2.8A for this motor)
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2800,2)"

#Reduced current 100mA
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,100,2)"

#Nominal voltage 48V (unit 1mV)
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#Coil resistance 1.13 Ohm (unit 10mOhm)
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,113,2)"

#Motor full steps count 200
EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

# 8011:01 Kp factor (curr.) Kp control factor (proportional component) for the current controller (unit: 0.001) UINT16 RW default was 400
#EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1,2000,2)"

# 8011:02 Ki factor (curr.) Ki control factor (integral component) for the current controller (unit: 0.001) UINT16 RW default 4
#EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2,50,2)"

# 8011:03 Inner window (curr.) Inner window for the I component of the current controller (unit: 1%) UINT8 RW 0x00 (0 dec)
#EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x3,0,1)"

# 8011:05 Outer window (curr.) Outer window for the I component of the current controller (unit: 1%) UINT8 RW 0x00 (0 dec)
#EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x5,0,1)"

# 8011:06 Filter cut off frequency (curr.) Filter limit frequency of the current controller (low-pass, unit: 1 Hz) UINT16 RW 0x0000 (0 dec)
# 8011:07 Ka factor (curr.) Ka control factor (acceleration component) for the current controller (unit: 0.001) UINT16 RW 0x0064 (100 dec)
# 8011:08 Kd factor (curr.) Kd control factor (deceleration component) for the current controller (unit: 0.001) UINT16 RW 0x0064 (100 dec)
