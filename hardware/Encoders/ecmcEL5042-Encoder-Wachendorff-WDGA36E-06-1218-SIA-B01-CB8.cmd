############################################################
############# Information:
# Description: Wachendorff SSI encoder
# Supply:     10-24V
# Resolution: 12 bit singleturn, 18 bit multiturn
# Coding:     Binary 
#
#  Need the following varibales:
#      1. ECMC_EC_SLAVE_NUM    Slave index
#      2. ECMC_EC_SDO_INDEX    0x8008 for CH1
#                              0x8018 for CH2
############################################################

# 0x80p8:01: Invert feedback direction (default 0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x1,0,1)"

# 0x80p8:02: Disable Status Bits (default 0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x2,0,1)"

# 0x80p8:03: CRC Invert (default 1 ?)  
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x3,1,1)"

# 0x80p8:12: Supply voltage
# 50: 5V (default)
# 90: 9V
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x12,50,1)"

# 0x80p8:13: Clock Frequency (default 50 (5V)) Can also be set to 90 (9V)  
# 0: 10 MHz (default)
# 1: 5 MHZ
# 2: 3.33 MHz
# 3: 2.5 MHz
# 4: 2 MHz
# 9: 1 MHz (Max for SSI)
# 17: 500 kHz
# 19: 250 kHz
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x13,17,1)"

# 0x80p8:14: Coding
# 0: Dual code active (default)
# 1: Gray code active
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x14,0,1)"

# 0x80p8:15: Multiturn [Bit] Number of multiturn bits
# default 12
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x15,18,1)"

# 0x80p8:16: Singleturn [Bit] Number of singleturn bits
# default 13
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x16,12,1)"

# 0x80p8:17: Offset LSB Bit [Bit] Number of “right aligned” Offset bits
# default 0
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x17,0,1)"

# 0x80p8:18: Mode
# 0: BiSS-C mode (default)
# 1: SSI mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x18,1,1)"
