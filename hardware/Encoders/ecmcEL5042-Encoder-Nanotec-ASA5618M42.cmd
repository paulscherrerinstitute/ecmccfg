#-d /**
#-d   \brief hardware script for ecmcEL5042-Encoder-Nanotec-ASA5618M42
#-d   \details SSI encoder used in Nanotec ASA5618M42 stepper motor, 17/16 bit
#-d   \author Niko Kivel
#-d   \file
#-d   \pre Need the following varibales:
#-d   \pre ECMC_EC_SLAVE_NUM    Slave index
#-d   \pre ECMC_EC_SDO_INDEX    0x8008 for CH1, 0x8018 for CH2
#-d   \note Supply:     4.75..15 V
#-d   \note Resolution: 16 start bits + 17/16 => 49 bits total
#-d */

#- 0x80p8:01: Invert feedback direction (default 0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x1,0,1)"

#- 0x80p8:12: Supply voltage
#- 50: 5V (default)
#- 90: 9V
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x12,50,1)"

#- 0x80p8:13: Clock Frequency
#- 0: 10 MHz (default)
#- 1: 5 MHZ
#- 2: 3.33 MHz
#- 3: 2.5 MHz
#- 4: 2 MHz
#- 9: 1 MHz (Max for SSI)
#- 17: 500 kHz
#- 19: 250 kHz
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x13,9,1)"

#- 0x80p8:14: Coding
#- 0: Dual code active (default)
#- 1: Gray code active
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x14,0,1)"

#- total bit count:
# 16 starting bits
# 16 multi turn bits
# 17 single turn bits
# 2 status bits (which are _NOT_ used by the slave)
#  ==> 49 bits total

#- 0x80p8:15: Multiturn [Bit] Number of multiturn bits (16 start + 16 data)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x15,32,1)"

#- 0x80p8:16: Singleturn [Bit] Number of singleturn bits (17 data)
#- WORKING with 33 bit
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x16,17,1)"

#- 0x80p8:17: Offset LSB Bit [Bit] Number of “right aligned” Offset bits
#- default 0
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x17,0,1)"

#- 0x80p8:18: Mode
#- 0: BiSS-C mode (default)
#- 1: SSI mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x18,1,1)"
