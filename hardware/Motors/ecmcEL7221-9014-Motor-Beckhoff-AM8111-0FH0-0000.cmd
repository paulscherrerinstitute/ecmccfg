
############################################################
############# Parmetrization of EL7221-9014 for motor AM8111-0FH0-0000
#
# Note: For important parameters see TwinCAT CoE startup list for the 
#       motor terminal configuration.

#Nominal voltage = 48V
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,33900,4)"
#Motor max current = 6A
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,6000,4)"
#Motor rated current = 4A
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,4000,4)"
#Motor pole pairs = 3
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x13,3,1)"
#Torque contstant = 125
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x16,200,4)"
#Winding inductance = 28
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x19,33,2)"
#Rotor moment of inertia = 134
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,330,4)"
#Commutation offset = 270
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x15,270,2)"
#Motor thermal time constant = 564
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2d,7800,2)"
#Motor speed limitation = 3378
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,5406,4)"
#Current loop proportianal gain = 332
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x13,100,2)"
#Current loop integral time = 5
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x12,10,2)"
#Velocity loop proportianal gain = 95
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,150,4)"
#Velocity loop integral time = 150
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,50,4)"
