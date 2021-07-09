#-d /**
#-d   \brief hardware script for EL6002
#-d   \details 2 channel RS232
#-d   \author Anders Sandstroem, Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL6002")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x17723052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- ###########################################################
#- ############ Config PDOS: Inputs

#-SM3: PhysAddr 0x1220, DefaultSize   48, ControlRegister 0x20, Enable 1
#-  TxPDO 0x1a04 "COM TxPDO-Map Inputs Ch.1"
#-    PDO entry 0x6001:01, 16 bit, "Status"
#-    PDO entry 0x6000:11,  8 bit, "Data In 0"
#-    PDO entry 0x6000:12,  8 bit, "Data In 1"
#-    PDO entry 0x6000:13,  8 bit, "Data In 2"
#-    PDO entry 0x6000:14,  8 bit, "Data In 3"
#-    PDO entry 0x6000:15,  8 bit, "Data In 4"
#-    PDO entry 0x6000:16,  8 bit, "Data In 5"
#-    PDO entry 0x6000:17,  8 bit, "Data In 6"
#-    PDO entry 0x6000:18,  8 bit, "Data In 7"
#-    PDO entry 0x6000:19,  8 bit, "Data In 8"
#-    PDO entry 0x6000:1a,  8 bit, "Data In 9"
#-    PDO entry 0x6000:1b,  8 bit, "Data In 10"
#-    PDO entry 0x6000:1c,  8 bit, "Data In 11"
#-    PDO entry 0x6000:1d,  8 bit, "Data In 12"
#-    PDO entry 0x6000:1e,  8 bit, "Data In 13"
#-    PDO entry 0x6000:1f,  8 bit, "Data In 14"
#-    PDO entry 0x6000:20,  8 bit, "Data In 15"
#-    PDO entry 0x6000:21,  8 bit, "Data In 16"
#-    PDO entry 0x6000:22,  8 bit, "Data In 17"
#-    PDO entry 0x6000:23,  8 bit, "Data In 18"
#-    PDO entry 0x6000:24,  8 bit, "Data In 19"
#-    PDO entry 0x6000:25,  8 bit, "Data In 20"
#-    PDO entry 0x6000:26,  8 bit, "Data In 21"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6001,0x1,16,status01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x11,8,inputData01_0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x12,8,inputData01_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x13,8,inputData01_2,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x14,8,inputData01_3,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x15,8,inputData01_4,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x16,8,inputData01_5,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x17,8,inputData01_6,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x18,8,inputData01_7,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x19,8,inputData01_8,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x1a,8,inputData01_9,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x1b,8,inputData01_10,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x1c,8,inputData01_11,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x1d,8,inputData01_12,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x1e,8,inputData01_13,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x1f,8,inputData01_14,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x20,8,inputData01_15,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x21,8,inputData01_16,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x22,8,inputData01_17,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x23,8,inputData01_18,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x24,8,inputData01_19,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x25,8,inputData01_20,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6000,0x26,8,inputData01_21,0)"


epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "22")    # 22 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "22")    # 22 bytes
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.inputData01_0,$(ECMC_EC_ARRAY_BYTE_SIZE),2,U8,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.inputDataArray01)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6011,0x1,16,status02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x11,8,inputData02_0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x12,8,inputData02_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,8,inputData02_2,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x14,8,inputData02_3,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x15,8,inputData02_4,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x16,8,inputData02_5,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x17,8,inputData02_6,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x18,8,inputData02_7,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x19,8,inputData02_8,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x1a,8,inputData02_9,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x1b,8,inputData02_10,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x1c,8,inputData02_11,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x1d,8,inputData02_12,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x1e,8,inputData02_13,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x1f,8,inputData02_14,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x20,8,inputData02_15,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x21,8,inputData02_16,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x22,8,inputData02_17,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x23,8,inputData02_18,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x24,8,inputData02_19,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x25,8,inputData02_20,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x26,8,inputData02_21,0)"
epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "22")    # 22 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "22")    # 22 bytes
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.inputData02_0,$(ECMC_EC_ARRAY_BYTE_SIZE),2,U8,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.inputDataArray02)"

#- ###########################################################
#- ############ Config PDOS: Outputs

#- RxPDO 0x1604 "COM RxPDO-Map Outputs Ch.1"
#-    PDO entry 0x7001:01, 16 bit, "Ctrl"
#-    PDO entry 0x7000:11,  8 bit, "Data Out 0"
#-    PDO entry 0x7000:12,  8 bit, "Data Out 1"
#-    PDO entry 0x7000:13,  8 bit, "Data Out 2"
#-    PDO entry 0x7000:14,  8 bit, "Data Out 3"
#-    PDO entry 0x7000:15,  8 bit, "Data Out 4"
#-    PDO entry 0x7000:16,  8 bit, "Data Out 5"
#-    PDO entry 0x7000:17,  8 bit, "Data Out 6"
#-    PDO entry 0x7000:18,  8 bit, "Data Out 7"
#-    PDO entry 0x7000:19,  8 bit, "Data Out 8"
#-    PDO entry 0x7000:1a,  8 bit, "Data Out 9"
#-    PDO entry 0x7000:1b,  8 bit, "Data Out 10"
#-    PDO entry 0x7000:1c,  8 bit, "Data Out 11"
#-    PDO entry 0x7000:1d,  8 bit, "Data Out 12"
#-    PDO entry 0x7000:1e,  8 bit, "Data Out 13"
#-    PDO entry 0x7000:1f,  8 bit, "Data Out 14"
#-    PDO entry 0x7000:20,  8 bit, "Data Out 15"
#-    PDO entry 0x7000:21,  8 bit, "Data Out 16"
#-    PDO entry 0x7000:22,  8 bit, "Data Out 17"
#-    PDO entry 0x7000:23,  8 bit, "Data Out 18"
#-    PDO entry 0x7000:24,  8 bit, "Data Out 19"
#-    PDO entry 0x7000:25,  8 bit, "Data Out 20"
#-    PDO entry 0x7000:26,  8 bit, "Data Out 21"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7001,0x1,16,control01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x11,8,outputData01_0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x12,8,outputData01_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x13,8,outputData01_2,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x14,8,outputData01_3,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x15,8,outputData01_4,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x16,8,outputData01_5,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x17,8,outputData01_6,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x18,8,outputData01_7,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x19,8,outputData01_8,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x1a,8,outputData01_9,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x1b,8,outputData01_10,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x1c,8,outputData01_11,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x1d,8,outputData01_12,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x1e,8,outputData01_13,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x1f,8,outputData01_14,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x20,8,outputData01_15,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x21,8,outputData01_16,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x22,8,outputData01_17,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x23,8,outputData01_18,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x24,8,outputData01_19,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x25,8,outputData01_20,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x26,8,outputData01_21,0)"

epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "22")    # 22 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "22")    # 22 bytes
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.outputData01_0,$(ECMC_EC_ARRAY_BYTE_SIZE),1,U8,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.outputDataArray01)"

#- ############ Config PDOS: Channel 2

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7011,0x1,16,control02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x11,8,outputData02_0,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x12,8,outputData02_1,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x13,8,outputData02_2,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x14,8,outputData02_3,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x15,8,outputData02_4,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x16,8,outputData02_5,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x17,8,outputData02_6,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x18,8,outputData02_7,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x19,8,outputData02_8,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x1a,8,outputData02_9,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x1b,8,outputData02_10,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x1c,8,outputData02_11,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x1d,8,outputData02_12,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x1e,8,outputData02_13,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x1f,8,outputData02_14,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x20,8,outputData02_15,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x21,8,outputData02_16,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x22,8,outputData02_17,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x23,8,outputData02_18,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x24,8,outputData02_19,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x25,8,outputData02_20,0)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7010,0x26,8,outputData02_21,0)"

epicsEnvSet("ECMC_EC_ARRAY_SIZE"             "22")    # 22 values
epicsEnvSet("ECMC_EC_ARRAY_BYTE_SIZE"        "22")    # 22 bytes
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.outputData02_0,$(ECMC_EC_ARRAY_BYTE_SIZE),1,U8,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.outputDataArray02)"

#- DC
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x0,${ECMC_TEMP_PERIOD_NANO_SECS},0,0,0)"
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
