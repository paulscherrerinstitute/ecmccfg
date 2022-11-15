#-d /**
#-d   \brief hardware script for Postial-S101B-1216-HES0-PRQ
#-d   \details 16/12-bit, SSI, approx. 0.088 deg/tick
#-d   \author Istvan Mohacsi
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8000")

#- Gray code OFF
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x6,0,1)"

#- SSI baud rate 500kBaud=3 (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x9,3,1)"

#- SSI frame type variable analysis =2 (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0xF,2,1)"

#- SSI frame size 28 bit
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x11,28,2)"

#- SSI data length 28 bit
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x12,28,2)"


