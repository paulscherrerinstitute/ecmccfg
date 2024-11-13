epicsEnvSet("ECMC_EC_HWTYPE",        "EP1957-0022")
epicsEnvSet("ECMC_EC_VENDOR_ID",     "0x00000002")
epicsEnvSet("ECMC_EC_PRODUCT_ID",    "0x07a54052")

#- verify slave
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#SM2: PhysAddr 0x1200, DefaultSize    8, ControlRegister 0x24, Enable 1
#  RxPDO 0x17f0 "RxPDO Mapping Standard Inputs"
#    PDO entry 0xf788:00,  8 bit, "Standard Inputs"
#  RxPDO 0x17ff "RxPDO Mapping Device Control"
#    PDO entry 0x0000:00, 16 bit, "Gap"
#SM3: PhysAddr 0x1d00, DefaultSize   10, ControlRegister 0x20, Enable 1
#  TxPDO 0x1bfe "TxPDO Mapping Device Info Data"
#    PDO entry 0xf6c0:01,  1 bit, "Fieldvoltage Underrange"
#    PDO entry 0xf6c0:02,  1 bit, "Fieldvoltage Overrange"
#    PDO entry 0x0000:00,  6 bit, "Gap"
#  TxPDO 0x1bff "TxPDO Mapping Device Status"
#    PDO entry 0xf100:01,  8 bit, "Safe Logic State"
#    PDO entry 0xf100:02,  8 bit, "Cycle Counter"
#SM6: PhysAddr 0x2ffa, DefaultSize    2, ControlRegister 0x24, Enable 1
#  RxPDO 0x17fe "RxPDO Mapping Standard Inputs"
#    PDO entry 0x7003:01,  1 bit, "Standard Output"
#    PDO entry 0x7013:01,  1 bit, "Standard Output"
#    PDO entry 0x7023:01,  1 bit, "Standard Output"
#    PDO entry 0x7033:01,  1 bit, "Standard Output"
#    PDO entry 0x0000:00,  4 bit, "Gap"


#- Standard Inputs
#ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0xf788,0x00,U8,control1)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0x6000,0x00,8,control5)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0xf788,0x01,B1,control5)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0xf788,0x02,B1,control6)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0x0000,0x00,B2,dummy1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0x0000,0x00,B4,dummy2)"

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17ff,0x0000,0x00,U16,dummyStub01)"

#- Standard Inputs
#ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bfe,0xf6c0,0x01,B1,status1)"

#- Device Info Data
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bfe,0xf6c0,0x01,B1,status1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bfe,0xf6c0,0x02,B1,status2)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bfe,0x0000,0x00,B2,dummyStub02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bfe,0x0000,0x00,B4,dummyStub03)"

#- Device Status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bff,0xf100,0x01,U8,status3)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bff,0xf100,0x02,U8,status4)"

#- Standard Inputs SM6
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,6,0x17fe,0x7003,0x01,B1,control1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,6,0x17fe,0x7013,0x01,B1,control2)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,6,0x17fe,0x7023,0x01,B1,control3)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,6,0x17fe,0x7033,0x01,B1,control4)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,6,0x17fe,0x0000,0x00,B4,dummyStub04)"
