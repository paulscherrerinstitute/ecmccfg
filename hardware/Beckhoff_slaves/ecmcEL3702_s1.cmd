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

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3702_s1")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0e763052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############ Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1b00,0x6800,0x1,S16,CH1_CYCLE_CNT)"

#- Configure PDO:s but do not update individualy. Update is made by mem map object as an array instead (All entries needs to be configuered anyway but cant be accessed individually)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a00,0x6000,0x1,S16,CH1_VALUE_1,0)"

#- ############ Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1b01,0x6800,0x2,S16,CH2_CYCLE_CNT)"

#- Configure PDO:s but do not update individualy. Update is made by mem map object as an array instead (All entries needs to be configuered anyway but cant be accessed individually)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1a80,0x6000,0x2,S16,CH2_VALUE_1,0)"

#-  Configure DC clock 100000ns update for oversampling (10 values oversampling)
#- NOTE: Not sure why it works with the below settings. Twincat uses 100000 and 1000000. 
#-       If these settings are used here the period will be 100000ns to long?!
#-       Seems one additional value is output (always zero) if twincat settings are used. Need to look into this..
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,1000000,0,0,0)"

epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "1")    # 1 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "2")    # 2 bytes

ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH1_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH1_ARRAY)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH2_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH2_ARRAY)"

epicsEnvUnset(ECMC_EC_ARRAY_SIZE)
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
