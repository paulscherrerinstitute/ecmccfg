
############################################################
############# Parmetrization of EL72XX-XXXX for motor AM8121-0F00-0000
#- Motor WITH brake
#-
#- Note: For important parameters see TwinCAT CoE startup list for the 
#-       motor terminal configuration.
#-
#- Macros (optional):
#-d   \param I_MAX_MA : Maximum current in mA (defaults to 17000mA)
#-d   \param I_RUN_MA : Running current in mA (defaults to 4000mA)
#-d   \param V_NOM_MV : Nominal voltage in mV (defaults to 48000mV)

#- Nominal voltage
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,${V_NOM_MV=48000},4)"
#- Motor max current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,${I_MAX_MA=17000},4)"
#- Motor rated current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,${I_RUN_MA=4000},4)"
#- Motor pole pairs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x13,3,1)"
#- Torque contstant
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x16,125,4)"
#- Winding inductance
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x19,28,2)"
#- Commutation offset
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x15,270,2)"
#- Motor thermal time constant
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2d,564,2)"
#- Motor speed limitation
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,3432,4)"
#- Current loop proportianal gain
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x13,332,2)"
#- Current loop integral time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x12,5,2)"
#- Velocity loop proportianal gain
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,95,4)"
#- Velocity loop integral time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,146,4)"

#- ###### Differs with brake:
#- Rotor moment of inertia
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,206,4)"
#- Application delay
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x12,25,2)"
#- Release delay
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x11,8,2)"
