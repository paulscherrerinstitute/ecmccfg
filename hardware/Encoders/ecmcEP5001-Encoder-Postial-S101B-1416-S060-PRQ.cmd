#-d /**
#-d   \brief hardware script for Postial-S101B-1416-S060-PRQ
#-d   \details 16/14-bit, SSI, approx. 5.5e-3 deg/ticks
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8000")

#- Gray code OFF
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x6,0,1)"

#- SSI baud rate 500kBaud=3 (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x9,3,1)"

#- SSI frame type variable analysis =2 (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0xF,2,1)"

#- SSI frame size 30 bit
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x11,30,2)"

#- SSI data length 30 bit
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x12,30,2)"
