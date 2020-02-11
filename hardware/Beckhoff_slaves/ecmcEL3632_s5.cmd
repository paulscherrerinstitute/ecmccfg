#-d /**
#-d   \brief hardware script for EL3632_s5
#-d   \details 2-channel analog input terminal for Condition Monitoring (IEPE) with oversampling
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: 2-channel analog input terminal for Condition Monitoring (IEPE) with oversampling
#-  Oversampling factor = 5
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3632_s5")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0xe303052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############################################

#-  CH 1
#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,S16,CH1_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6001,0x1,S16,sm3.p1.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6001,0x2,S16,sm3.p2.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6001,0x3,S16,sm3.p3.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6001,0x4,S16,sm3.p4.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6001,0x5,S16,sm3.p5.e0,0)"

#-  CH 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a40,0x6010,0x1,S16,CH2_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6011,0x1,S16,sm3.p52.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a42,0x6011,0x2,S16,sm3.p53.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a43,0x6011,0x3,S16,sm3.p54.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a44,0x6011,0x4,S16,sm3.p55.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a45,0x6011,0x5,S16,sm3.p56.e0,0)"

#- General
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a80,0x6020,0x1,U64,NEXT_SYNC)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x6021,0x1,S16,SAMPLE_COUNT)"

#- Cfg.EcSlaveConfigDC(
#-       int slave_bus_position,
#-       uint16_t assign_activate,
#-       uint32_t sync0_cycle,
#-       int32_t sync0_shift,
#-       uint32_t sync1_cycle,
#-       int32_t sync1_shift )*/
#- Configure DC clock 200000ns update for oversampling (5 values oversampling in 1kHz)
#- ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,200000,0,800000,0)"

epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "5")    # 5  values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "10")   # 10 bytes

ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.sm3.p1.e0,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH1_ARRAY)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.sm3.p52.e0,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH2_ARRAY)"

epicsEnvUnset(ECMC_EC_ARRAY_SIZE)
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
