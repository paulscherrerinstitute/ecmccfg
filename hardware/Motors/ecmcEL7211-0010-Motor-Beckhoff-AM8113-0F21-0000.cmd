
############################################################
############# Parmetrization of EL7211-0010 for motor AM8121-F00-0000
#
# Note: For important parameters see TwinCAT CoE startup list for the 
#       motor terminal configuration.

#Nominal voltage = 48V
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,48000,4)"
#Motor max current = 6A (Atually max is 18A)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,6000,4)"
#Motor rated current = 4.65A
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,4650,4)"
#Motor pole pairs = 3
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x13,3,1)"
#Torque contstant = 108
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x16,108,4)"
#Winding inductance = 10
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x19,10,2)"
#Rotor moment of inertia = 89
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,89,4)"
#Commutation offset = 270
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x15,270,2)"
#Motor thermal time constant = 531
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2d,531,2)"
#Motor speed limitation = 3576
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,3576,4)"
#Current loop proportianal gain = 115
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x13,115,2)"
#Current loop integral time = 5
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x12,5,2)"
#Velocity loop proportianal gain = 73
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,73,4)"
#Velocity loop integral time = 150
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,150,4)"
