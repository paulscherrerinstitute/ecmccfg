#-d /**
#-d   \brief hardware script for EL3742_s2
#-d   \details 2 channel 16bit analog output +-10V (with oversampling factor 2)
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL4732_s2")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x127c3052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############ Next start time
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},0,2,0x1a82,0x1d09,0x98,S32,NEXT_TIME)"

#- ############ Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1680,0x7800,0x1,S16,CH1_CYCLE_CNT)"

#- Configure PDO:s but do not update individualy. Update is made by mem map object as an array instead (All entries needs to be configuered anyway but cant be accessed individually)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1600,0x7000,0x1,S16,CH1_VALUE_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1601,0x7010,0x1,S16,CH1_VALUE_2,0)"

#- ############ Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,1,0x1780,0x7800,0x2,S16,CH2_CYCLE_CNT)"

#- Configure PDO:s but do not update individualy. Update is made by mem map object as an array instead (All entries needs to be configuered anyway but cant be accessed individually)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,1,0x1700,0x7000,0x2,S16,CH2_VALUE_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,1,0x1701,0x7010,0x2,S16,CH2_VALUE_2,0)"

#- Configure DC clock 100000ns update for oversampling (10 values oversampling)
#- NOTE: Not sure why it works with the below settings. Twincat uses 500000 and 1000000. 
#-       If these settings are used here the period will be to long?!
#-       Seems one additional value is output (always zero) if twincat settings are used. Need to look into this..
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,500000,0,500000,0)"

epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "2")    # 10 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "4")    # 20 bytes

ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH1_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),1,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH1_ARRAY)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH2_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),1,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH2_ARRAY)"

epicsEnvUnset(ECMC_EC_ARRAY_SIZE)
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
