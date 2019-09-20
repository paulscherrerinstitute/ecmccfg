#-d /**
#-d   \brief hardware script for EL3632_s2
#-d   \details 2-channel analog input terminal for Condition Monitoring (IEPE) with oversampling
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: 2-channel analog input terminal for Condition Monitoring (IEPE) with oversampling
#-  Oversampling factor = 2
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3632_s2")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0xe303052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############################################

#-  CH 1
#-  Configuration for sync manager 3
#-  Configuration for pdoIndex 6656
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,16,CH1_STATUS)"
#-  Configuration for pdoIndex 6657
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6002,0x1,16,sm3.p1.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6003,0x1,16,sm3.p2.e0,0)"

#-  CH 2
#-  Configuration for pdoIndex 6720
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a40,0x6010,0x1,16,CH2_STATUS)"
#-  Configuration for pdoIndex 6721
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6000,0x2,16,sm3.p52.e0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a42,0x6001,0x2,16,sm3.p53.e0,0)"


#- Configure DC clock 20000ns update for oversampling (50 values oversampling in 1kHz)
#- ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,20000,-20000,1000000,0)"

epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "2")    # 2 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "4")    # 4 bytes

ecmcConfigOrDie "Cfg.EcAddMemMap(${ECMC_EC_SLAVE_NUM},sm3.p1.e0,$(ECMC_EC_ARRAY_BYTE_SIZE),2,ec$(ECMC_EC_MASTER_ID).mm.CH1_ARRAY)"
ecmcConfigOrDie "Cfg.EcAddMemMap(${ECMC_EC_SLAVE_NUM},sm3.p52.e0,$(ECMC_EC_ARRAY_BYTE_SIZE),2,ec$(ECMC_EC_MASTER_ID).mm.CH2_ARRAY)"
