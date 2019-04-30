############################################################
############# Information:
# Description: 2 channel 16bit analog input differential (with oversampling)
# Oversampling factor = 10
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3702")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0e763052")

############# Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1b00,0x6800,0x1,16,CH1_CYCLE_CNT)"

#Configure PDO:s but do not update individualy. Update is made by mem map object as an array instead (All entries needs to be configuered anyway but cant be accessed individually)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,16,CH1_VALUE_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6010,0x1,16,CH1_VALUE_2,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a02,0x6020,0x1,16,CH1_VALUE_3,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a03,0x6030,0x1,16,CH1_VALUE_4,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a04,0x6040,0x1,16,CH1_VALUE_5,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a05,0x6050,0x1,16,CH1_VALUE_6,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a06,0x6060,0x1,16,CH1_VALUE_7,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a07,0x6070,0x1,16,CH1_VALUE_8,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a08,0x6080,0x1,16,CH1_VALUE_9,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a09,0x6090,0x1,16,CH1_VALUE_10,0)"

############# Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1b01,0x6800,0x2,16,CH2_CYCLE_CNT)"

#Configure PDO:s but do not update individualy. Update is made by mem map object as an array instead (All entries needs to be configuered anyway but cant be accessed individually)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a80,0x6000,0x2,16,CH2_VALUE_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a81,0x6010,0x2,16,CH2_VALUE_2,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a82,0x6020,0x2,16,CH2_VALUE_3,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a83,0x6030,0x2,16,CH2_VALUE_4,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a84,0x6040,0x2,16,CH2_VALUE_5,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a85,0x6050,0x2,16,CH2_VALUE_6,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a86,0x6060,0x2,16,CH2_VALUE_7,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a87,0x6070,0x2,16,CH2_VALUE_8,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a88,0x6080,0x2,16,CH2_VALUE_9,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a89,0x6090,0x2,16,CH2_VALUE_10,0)"

# Configure DC clock 100000ns update for oversampling (10 values oversampling)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,100000,0,1000000,0)"
