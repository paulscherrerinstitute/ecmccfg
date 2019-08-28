# default SDO index 0x8010 for EL5001
# SDO index for EL5002: ch1=0x8000, ch2=0x8010

epicsEnvSet("ECMC_EC_SDO_INDEX"   "${ECMC_EC_SDO_INDEX=0x8010}")

# Do not supress frame error (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x1,0,1)"

# Disable power failure bit  (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x2,0,1)"

# Disable inhibit bit  (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x3,0,1)"

# Disable test mode  (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x4,0,1)"

# Gray code
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x6,1,1)"

# SSI baud rate 500kBaud=3 (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x9,3,1)"

# SSI frame type variable analysis =2 (default setting)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0xF,2,1)"

# SSI frame size 25bits
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x11,25,2)"

# SSI data length 25bits
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x12,25,2)"
