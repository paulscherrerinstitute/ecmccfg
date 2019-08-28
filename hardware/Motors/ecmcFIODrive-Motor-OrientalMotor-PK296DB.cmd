
############################################################
############# Configure SDOS:
#Pole count = 50
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2030,0x0,50,4)"
#Max current 4000mA (should be moved)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2031,0x0,4000,4)"
#Max Velocity
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2032,0x0,10,4)"

#Configure speed range to +-10HZ (RPS) 
# Velocity Nominator =10
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2061,0x0,10,4)"
# Velocity Denominator =2^15-1=32767 (Velocity setpoint is 16bit)=>65535 will give 10Hz
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2062,0x0,32767,4)"

#Configure actual speed range to +-10HZ (RPS) 
# Velocity Nominator =10
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x604c,0x1,10,4)"
# Velocity Denominator =2^15-1=32767 (Velocity setpoint is 16bit)=>65535 will give 10Hz
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x604c,0x2,32767,4)"










