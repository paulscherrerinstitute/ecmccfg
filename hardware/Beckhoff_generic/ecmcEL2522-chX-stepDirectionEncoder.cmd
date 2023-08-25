#-d /**
#-d   \brief hardware script for EL2522-chX-stepDirectionEncoder
#-d   \details Parametrization Default SDO settings for EL2522 in Encoder mode
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note The variable "ECMC_EC_SDO_INDEX" needs to be set in advance of inlining this snippet.
#-d   \pre Environment variables needed:
#-d   \pre -ECMC_EC_SDO_INDEX "0x80n0" where n is channel 0..1
#-d   \pre -ECMC_EC_SLAVE_NUM = slave number
#-d */

#- Enable C reset
#- The counter is reset via the C-track
#- Setting 0 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x1,0,1)"

#- Enable micro increments
#- Setting 0 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0xA,0,1)"

#- Micro increment bits
#- If 8pp0:0A enabled: number of micro-increment bits
#- Setting 8 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x18,8,2)"

#- Pulses per revolution
#- if C-reset active: Number of increments "per revolution". At 1024 the counter counts
#- Setting 1024 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x19,1024,4)"

#- Autoset treshold
#- If the difference between "Target counter
#- # value" and "Counter value" exceeds this
#- threshold, no output takes place. 0: function
#- for automatic setting is inactive
#- Setting 0 (default)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x1A,0,4)"
