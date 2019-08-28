############################################################
############# Parmetrization of EL7041 for motor Nanotec AS5918L4204-ENM24B

#Set max current to 4000mA (actually max current is 4.2A for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,4000,2)"

#Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,500,2)"

#Nominal voltage 48V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#Coil resistance 0.58 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,58,2)"

#Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"
 
#Coil inductance 1.9mH (unit 0.01mH) NOT USED FOR EL7041
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,190,2)"

# 8011:01 Kp factor (curr.) Kp control factor (proportional component) for the current controller (unit: 0.001) UINT16 RW default was 400
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1,300,2)"

# 8011:02 Ki factor (curr.) Ki control factor (integral component) for the current controller (unit: 0.001) UINT16 RW default 4
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2,2,2)"

# 8011:03 Inner window (curr.) Inner window for the I component of the current controller (unit: 1%) UINT8 RW 0x00 (0 dec)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x3,0,1)"

# 8011:05 Outer window (curr.) Outer window for the I component of the current controller (unit: 1%) UINT8 RW 0x00 (0 dec)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x5,0,1)"

# 8011:06 Filter cut off frequency (curr.) Filter limit frequency of the current controller (low-pass, unit: 1 Hz) UINT16 RW 0x0000 (0 dec)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x6,2500,2)"

# 8011:07 Ka factor (curr.) Ka control factor (acceleration component) for the current controller (unit: 0.001) UINT16 RW 0x0064 (100 dec)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x7,200,2)"

# 8011:08 Kd factor (curr.) Kd control factor (deceleration component) for the current controller (unit: 0.001) UINT16 RW 0x0064 (100 dec)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x8,200,2)"

