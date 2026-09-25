# WARNING: UNTESTED
#- Common input and diagnostic PDOs for ED2504_F32.

#- SM2: mandatory 16-bit device-control PDO. B6 is PWM reset; all other bits
#- are fixed gaps. Pack the complete PDO and select reset with an EPICS mask.
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1700,0xF716,0x07,U16,PWM_Ctrl)"

#- SM3: pack each fixed input PDO (input bit + 15 gap bits) into one U16.
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6010,0x01,U16,binaryInput01)"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},binaryInput01,BI01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a30,0x6030,0x01,U16,binaryInput02)"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},binaryInput02,BI02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a50,0x6050,0x01,U16,binaryInput03)"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},binaryInput03,BI03)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a70,0x6070,0x01,U16,binaryInput04)"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},binaryInput04,BI04)"

#- Pack the complete fixed 0x1b00 diagnostic PDO into one U16. Database records
#- use asyn masks for B5 warning, B6 error, B12 diagnostic, B13 TxPDO state,
#- and B14..15 input cycle counter.
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1b00,0xF616,0x06,U16,PWM_Stat)"

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd
