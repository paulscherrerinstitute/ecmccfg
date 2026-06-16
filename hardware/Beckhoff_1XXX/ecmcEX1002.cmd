#- binary inputs
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,B1,${KEY=binaryInput}01)"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},${KEY=binaryInput}01,BI01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6010,0x1,B1,${KEY=binaryInput}02)"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},${KEY=binaryInput}02,BI02)"

