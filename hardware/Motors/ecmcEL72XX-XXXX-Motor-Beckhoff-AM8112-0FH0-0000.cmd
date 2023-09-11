
############################################################
############# Parmetrization of EL72XX-XXXX for motor AM8112-0F20-0000
#- Motor WITHOUT brake
#-
#- Note: For important parameters see TwinCAT CoE startup list for the 
#-       motor terminal configuration.
#-
#- Macros (optional):
#-d   \param I_MAX_MA : Maximum current in mA (defaults to 16500mA)
#-d   \param I_RUN_MA : Running current in mA (defaults to 4500mA)
#-d   \param V_NOM_MV : Nominal voltage in mV (defaults to 48000mV)

#- Nominal voltage
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,${V_NOM_MV=48000},4)"
#- Motor max current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,${I_MAX_MA=16500},4)"
#- Motor rated current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,${I_RUN_MA=4500},4)"
#- Motor pole pairs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x13,3,1)"
#- Torque contstant
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x16,81,4)"
#- Winding inductance
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x19,8,2)"
#- Commutation offset
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x15,270,2)"
#- Motor thermal time constant
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2d,419,2)"
#- Motor speed limitation
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,5100,4)"
#- Current loop proportianal gain
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x13,94,2)"
#- Current loop integral time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x12,5,2)"
#- Velocity loop proportianal gain
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,53,4)"
#- Velocity loop integral time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,150,4)"

#- ###### Differs with brake:
#- Rotor moment of inertia
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,48,4)"

