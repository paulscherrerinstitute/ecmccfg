
############################################################
############# Parmetrization of EL2521 Step Direction interface to "external drive" 
# Output frequency can be scaled with the factor in  8001:06 (see below)

# Emergency ramp active (if the watchdog timer responds)
# 0 = Disabled ramp (default)
# 1 = Enabled ramp
# Setting 0
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x2,0,1)"

# Ramp active 
# The ramp controller should only be deactivated if a higher-level
# controller (e.g. NC controller) takes over the control of travel dis-
# tance and frequency.
# 0 = Disabled ramp (default) 
# 1 = Enabled ramp
# Setting 0 since ECMC controls ramps
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x6,0,1)"

# Direct Input Mode
# 0 = Relative input mode (default)
# 1 = Direct input mode
# Setting 1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x8,1,1)"

# Operating mode
# 8000:0E
# 0 = Frequency modulation operating mode (default)
# 1 = Pulse direction specification operating mode
# 2 = Incremental encoder operating mode
# Setting 1 = pulse direction mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0xE,1,1)"

# Negative logic
# 8000:0F
# 0 = Positive logic
# 1 = Negative logic
# Setting 0 (positive logic)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0xF,0,1)"

# Frequency factor (Digit x10 mHz) for direct input
# 8001:06
# Defualt setting 100
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8001,0x6,100,2)"
