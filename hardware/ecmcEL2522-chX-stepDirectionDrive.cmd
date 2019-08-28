# SDO settings valid for a individual channel. 
# Note: The variable "ECMC_EC_SDO_INDEX" needs to be set in advance of inlining this snippet.

# ECMC_EC_SDO_INDEX=0x8000 for CH1
# ECMC_EC_SDO_INDEX=0x8010 for CH2

##################### DRIVE

# Adapt A/B on position set:
# If the counter value is set to "0", the C-track goes into
# the "high" state. 
# The behavior of channels A and B can be defined in this
# case.
# By default the value is FALSE; the position of the C-
# track relative to A and B is then not changed. If the
# value is set to TRUE, channels A and B are both set to
# high. Consequently, a change of state occurs on both
# channels!
# Setting 0
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x1,0,1)"

# Emergency ramp active (if the watchdog timer responds):
# 0 = Disabled ramp (default)
# 1 = Enabled ramp
# Setting 0 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x2,0,1)"

# Watchdog timer deactive
# TRUE The watchdog timer is deactivated FALSE The
# watchdog timer is activated in the delivery state. Either
# the manufacturer's of the user's switch-on value is out-
# put if the watchdog overflows.
# Setting 0 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x3,0,1)"

# Sign/amount representation
# TRUE The output value is displayed in magnitude-sign
# format: -2dec= 0x8002 -1dec= 0x8001 1dec= 0x0001
# 2dec= 0x0002 FALSE The output value is output as a
# signed integer in two's complement: -2dec= 0xFFFE
# -1dec= 0xFFFF 1dec= 0x0001 2dec= 0x0002
# Setting 0 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x4,0,1)"

# Ramp active 
# The ramp controller should only be deactivated if a higher-level
# controller (e.g. NC controller) takes over the control of travel dis-
# tance and frequency.
# 0 = Disabled ramp (default) 
# 1 = Enabled ramp
# Setting 0 since ECMC controls ramps
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x6,0,1)"

# Direct Input Mode
# 0 = Relative input mode (default)
# 1 = Direct input mode
# Setting 1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x8,1,1)"

# Users switch-on value on wdt
# TRUE Behavior with triggered watchdog timer: User's
# switch-on value FALSE Behavior with triggered watch-
# dog timer: Manufacturer's switch-on value
# Setting 0 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x9,0,1)"

# Travel distance control active
# TRUE Travel distance control activated FALSE Travel
# distance control deactivated
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0xA,0,1)"

# Operating mode
# 8000:0E
# 0 = Frequency modulation operating mode (default)
# 1 = Pulse direction specification operating mode
# 2 = Incremental encoder operating mode
# Setting 1 = pulse direction mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0xE,1,1)"

# Negative logic
# 8000:10
# 0 = Positive logic
# 1 = Negative logic
# Setting 0 (positive logic)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x10,0,1)"

# Users switch-on value
# User switch-on value (frequency)
# Setting 0 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x11,0,2)"

# Base frequency 1
# Setting 50000 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x12,50000,4)"

# Base frequency 2
# Setting 100000 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x13,100000,4)"

# Ramp time constant (rising)
# Setting 1000 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x14,1000,2)"

# Ramp time constant (falling)
# Setting 1000 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x15,1000,2)"

# Frequency factor (Digitx 10mHz)
# Frequency factor (direct input, digit x 10mHz)
# Defualt setting 100
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x16,100,2)"

# Slowing down frequency
# Defualt setting 50
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x17,50,2)"

# Ramp time constant emergency
# Ramp time constant for controlled switch-off; user's
# switch-on value is driven to (object 8pp0:11)
# Defualt setting 1000
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x18,1000,2)"