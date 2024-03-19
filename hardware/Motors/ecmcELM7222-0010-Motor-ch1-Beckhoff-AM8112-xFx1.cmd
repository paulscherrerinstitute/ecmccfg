############################################################
############# Parmetrization of ELM7222-XXXX for motor AM8112-xFx1 on channel 1
#- Motor WITH brake
#-
#- Note: For important parameters see TwinCAT CoE startup list for the 
#-       motor terminal configuration.
#-
#- Macros (optional):
#-d   \param I_MAX_MA : Maximum current in mA (defaults to 16500 mA)
#-d   \param I_RUN_MA : Running current in mA (defaults to 4500 mA)
#-d */

#- Current loop integral time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x12,6,2)"
#- Current loop proportianal gain
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x13,133,2)"

#- Velocity loop integral time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,150,4)"
#- Velocity loop proportianal gain
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,82,4)"

#- standstill window
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x33,10,2)"


#- Motor max current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,${I_MAX_MA=16500},4)"
#- Motor rated current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,${I_RUN_MA=4500},4)"
#- Motor pole pairs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x13,3,1)"
#- Commutation offset
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x15,270,2)"
#- Torque contstant
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x16,81,4)"
#- Rotor moment of inertia
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,75,4)"
#- Winding inductance
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x19,8,2)"
#- Motor speed limitation
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,10000,4)"

#- Motor Temperature warn level
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2b,1200,2)"
#- Motor thermal time constant
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2d,419,2)"

#- Release delay
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x11,20,2)"
#- Application delay
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x12,8,2)"
