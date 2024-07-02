#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex10x8")

#- binary inputs
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SM=0},0x1a00,0x6000,0x1,B1,${KEY=binaryInput}01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SM=0},0x1a01,0x6010,0x1,B1,${KEY=binaryInput}02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SM=0},0x1a02,0x6020,0x1,B1,${KEY=binaryInput}03)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SM=0},0x1a03,0x6030,0x1,B1,${KEY=binaryInput}04)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SM=0},0x1a04,0x6040,0x1,B1,${KEY=binaryInput}05)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SM=0},0x1a05,0x6050,0x1,B1,${KEY=binaryInput}06)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SM=0},0x1a06,0x6060,0x1,B1,${KEY=binaryInput}07)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SM=0},0x1a07,0x6070,0x1,B1,${KEY=binaryInput}08)"
