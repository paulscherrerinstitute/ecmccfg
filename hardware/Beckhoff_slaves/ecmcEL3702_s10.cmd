#-d /**
#-d   \brief hardware script for EL3702_s10
#-d   \details 2 channel 16bit analog input differential (with oversampling)
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: 2 channel 16bit analog input differential (with oversampling)
#-  Oversampling factor = 10
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3702_s10")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0e763052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############ Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1b00,0x6800,0x1,S16,CH1_CYCLE_CNT)"

#- Configure PDO:s but do not update individualy. Update is made by mem map object as an array instead (All entries needs to be configuered anyway but cant be accessed individually)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,S16,CH1_VALUE_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6010,0x1,S16,CH1_VALUE_2,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a02,0x6020,0x1,S16,CH1_VALUE_3,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a03,0x6030,0x1,S16,CH1_VALUE_4,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a04,0x6040,0x1,S16,CH1_VALUE_5,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a05,0x6050,0x1,S16,CH1_VALUE_6,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a06,0x6060,0x1,S16,CH1_VALUE_7,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a07,0x6070,0x1,S16,CH1_VALUE_8,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a08,0x6080,0x1,S16,CH1_VALUE_9,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a09,0x6090,0x1,S16,CH1_VALUE_10,0)"

#- ############ Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1b01,0x6800,0x2,S16,CH2_CYCLE_CNT)"

#- Configure PDO:s but do not update individualy. Update is made by mem map object as an array instead (All entries needs to be configuered anyway but cant be accessed individually)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a80,0x6000,0x2,S16,CH2_VALUE_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a81,0x6010,0x2,S16,CH2_VALUE_2,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a82,0x6020,0x2,S16,CH2_VALUE_3,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a83,0x6030,0x2,S16,CH2_VALUE_4,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a84,0x6040,0x2,S16,CH2_VALUE_5,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a85,0x6050,0x2,S16,CH2_VALUE_6,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a86,0x6060,0x2,S16,CH2_VALUE_7,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a87,0x6070,0x2,S16,CH2_VALUE_8,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a88,0x6080,0x2,S16,CH2_VALUE_9,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a89,0x6090,0x2,S16,CH2_VALUE_10,0)"

#-  Configure DC clock 100000ns update for oversampling (10 values oversampling)
#- NOTE: Not sure why it works with the below settings. Twincat uses 100000 and 1000000. 
#-       If these settings are used here the period will be 100000ns to long?!
#-       Seems one additional value is output (always zero) if twincat settings are used. Need to look into this..
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,100000,0,900000,0)"

epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "10")    # 10 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "20")    # 20 bytes

ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH1_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH1_ARRAY)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH2_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH2_ARRAY)"

epicsEnvUnset(ECMC_EC_ARRAY_SIZE)
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
