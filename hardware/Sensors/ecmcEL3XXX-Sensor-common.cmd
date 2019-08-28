
# Common SDO settings valid for all channels.

# Set filter freq for all channels (Filter settings is only vaild for channel 1 (then used for the rest of the channels))
# 0  = 50Hz (Defualt)
# 1  = 60Hz
# 2  = 100Hz
# 3  = 500Hz
# 4  = 1kHz
# 5  = 2kHz
# 6  = 3,75kHz
# 7  = 7,5kHz
# 8  = 15kHz
# 9  = 30kHz
# 10 = 5Hz
# 11 = 10Hz
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8000")
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x15")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")       # 50Hz
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

