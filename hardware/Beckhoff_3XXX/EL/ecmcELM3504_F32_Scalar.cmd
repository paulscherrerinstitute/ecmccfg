#-  ecmc hardware config for: ELM3504-0000 4Ch. Bridge Measuring (SG), 24 bit, high precision
#- Oversampling 1 (24Bit)
#- source ESI file: ../../../esi_files/beckhoff_xml/Beckhoff ELM35xx.xml
#- selected slave: type=ELM3504-0000, product=0x50218d09, revision=0x130000
#- selected mapping id: M01 of 26

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3504_F32_Scalar")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x50218d09")
epicsEnvSet("ECMC_EC_REVISION"           "0x130000")

#- TX PDO 0x1a00: PAI Status Channel 1
epicsEnvSet("ECMC_CH"             "01")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x9,U16,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x10,U16,gap${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x1,U32,timestamp${ECMC_CH}_l32)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x2,U32,timestamp${ECMC_CH}_u32)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a21,0x6003,0x1,F32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},analogInput${ECMC_CH},AI${ECMC_CH})"

#- TX PDO 0x1a30: PAI Status Channel 2
epicsEnvSet("ECMC_CH"             "02")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a30,0x6010,0x9,U16,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a30,0x6010,0x10,U16,gap${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a51,0x6013,0x1,F32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},analogInput${ECMC_CH},AI${ECMC_CH})"

#- TX PDO 0x1a60: PAI Status Channel 3
epicsEnvSet("ECMC_CH"             "03")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x7020,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a60,0x6020,0x9,U16,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a60,0x6020,0x10,U16,gap${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x6023,0x1,F32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},analogInput${ECMC_CH},AI${ECMC_CH})"

#- TX PDO 0x1a90: PAI Status Channel 4
epicsEnvSet("ECMC_CH"             "04")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1603,0x7030,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a90,0x6030,0x9,U16,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a90,0x6030,0x10,U16,gap${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1ab1,0x6033,0x1,F32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},analogInput${ECMC_CH},AI${ECMC_CH})"

#- Configure DC clock
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,${ECMC_TEMP_PERIOD_NANO_SECS},${ECMC_SYNC_0_OFFSET_NS=0},${ECMC_SYNC_1_PERIOD_NS=0},${ECMC_SYNC_1_OFFSET_NS=0})"

#- Cleanup
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
epicsEnvUnset(ECMC_CH)

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "ELM3xx4_Scalar")
