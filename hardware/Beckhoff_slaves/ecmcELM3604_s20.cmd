#-d /**
#-d   \brief hardware script for EL3604_s20
#-d   \details 4-channel 24bit analog input terminal for Condition Monitoring (IEPE) with oversampling (20)
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3604_s20")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x50219349")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############################################

epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "20")    # 20 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "80")    # 80 bytes (20*32bit)

#-  CH 1
#-  Configuration for sync manager 3
epicsEnvSet("ECMC_CH"             "1")
epicsEnvSet("ECMC_EC_PDO"         "0x1a08")
epicsEnvSet("ECMC_EC_ENTRY"       "0x6001")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,32,CH${ECMC_CH}_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x1,32,sm3.p1.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x2,32,sm3.p2.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x3,32,sm3.p3.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x4,32,sm3.p4.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x5,32,sm3.p5.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x6,32,sm3.p6.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x7,32,sm3.p7.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x8,32,sm3.p8.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x9,32,sm3.p9.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xa,32,sm3.p10.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xb,32,sm3.p11.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xc,32,sm3.p12.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xd,32,sm3.p13.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xe,32,sm3.p14.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xf,32,sm3.p15.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x10,32,sm3.p16.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x11,32,sm3.p17.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x12,32,sm3.p18.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x13,32,sm3.p19.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x14,32,sm3.p20.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x1,64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddMemMap(${ECMC_EC_SLAVE_NUM},sm3.p1.e0_${ECMC_CH},$(ECMC_EC_ARRAY_BYTE_SIZE),2,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"

#-  CH 2
#-  Configuration for sync manager 3
epicsEnvSet("ECMC_CH"             "2")
epicsEnvSet("ECMC_EC_PDO"         "0x1a29")
epicsEnvSet("ECMC_EC_ENTRY"       "0x6011")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a21,0x6010,0x1,32,CH${ECMC_CH}_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x1,32,sm3.p1.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x2,32,sm3.p2.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x3,32,sm3.p3.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x4,32,sm3.p4.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x5,32,sm3.p5.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x6,32,sm3.p6.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x7,32,sm3.p7.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x8,32,sm3.p8.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x9,32,sm3.p9.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xa,32,sm3.p10.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xb,32,sm3.p11.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xc,32,sm3.p12.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xd,32,sm3.p13.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xe,32,sm3.p14.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xf,32,sm3.p15.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x10,32,sm3.p16.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x11,32,sm3.p17.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x12,32,sm3.p18.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x13,32,sm3.p19.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x14,32,sm3.p20.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a31,0x6015,0x1,64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddMemMap(${ECMC_EC_SLAVE_NUM},sm3.p1.e0_${ECMC_CH},$(ECMC_EC_ARRAY_BYTE_SIZE),2,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"

#-  CH 3
#-  Configuration for sync manager 3
epicsEnvSet("ECMC_CH"             "3")
epicsEnvSet("ECMC_EC_PDO"         "0x1a4a")
epicsEnvSet("ECMC_EC_ENTRY"       "0x6021")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a42,0x6020,0x1,32,CH${ECMC_CH}_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x1,32,sm3.p1.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x2,32,sm3.p2.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x3,32,sm3.p3.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x4,32,sm3.p4.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x5,32,sm3.p5.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x6,32,sm3.p6.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x7,32,sm3.p7.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x8,32,sm3.p8.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x9,32,sm3.p9.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xa,32,sm3.p10.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xb,32,sm3.p11.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xc,32,sm3.p12.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xd,32,sm3.p13.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xe,32,sm3.p14.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xf,32,sm3.p15.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x10,32,sm3.p16.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x11,32,sm3.p17.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x12,32,sm3.p18.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x13,32,sm3.p19.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x14,32,sm3.p20.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a52,0x6025,0x1,64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.sm3.p1.e0_${ECMC_CH},$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"

#-  CH 4
#-  Configuration for sync manager 3
epicsEnvSet("ECMC_CH"             "4")
epicsEnvSet("ECMC_EC_PDO"         "0x1a6b")
epicsEnvSet("ECMC_EC_ENTRY"       "0x6031")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a63,0x6030,0x1,32,CH${ECMC_CH}_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x1,32,sm3.p1.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x2,32,sm3.p2.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x3,32,sm3.p3.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x4,32,sm3.p4.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x5,32,sm3.p5.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x6,32,sm3.p6.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x7,32,sm3.p7.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x8,32,sm3.p8.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x9,32,sm3.p9.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xa,32,sm3.p10.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xb,32,sm3.p11.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xc,32,sm3.p12.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xd,32,sm3.p13.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xe,32,sm3.p14.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0xf,32,sm3.p15.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x10,32,sm3.p16.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x11,32,sm3.p17.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x12,32,sm3.p18.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x13,32,sm3.p19.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_EC_PDO},${ECMC_EC_ENTRY},0x14,32,sm3.p20.e0_${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a73,0x6035,0x1,64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.sm3.p1.e0_${ECMC_CH},$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"

#- Configure DC clock 50000ns update for oversampling (20 values oversampling in 1kHz)
#- ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,50000,0,950000,0)"
