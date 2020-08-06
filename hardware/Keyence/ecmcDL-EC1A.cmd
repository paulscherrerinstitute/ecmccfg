#-d /**
#-d   \brief hardware script for Keyence DL-EC1A
#-d   \details multichannel interface
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "DL-EC1A")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x00000541")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00001194")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ###########################################################
#- ############ Config PDOS:

#- SM2: PhysAddr 0x1c00, DefaultSize    0, ControlRegister 0x24, Enable 1
#-   RxPDO 0x1600 "Input Request 1 RxPDOMap"
#-     PDO entry 0x7000:01, 32 bit, "Request 1"
#-   RxPDO 0x1601 "Input Request 2 RxPDOMap"
#-     PDO entry 0x7000:02, 32 bit, "Request 2"
#-   RxPDO 0x1602 "Input Request 3 RxPDOMap"
#-     PDO entry 0x7000:03, 32 bit, "Request 3"
#-   RxPDO 0x1603 "Input Request 4 RxPDOMap"
#-     PDO entry 0x7000:04, 32 bit, "Request 4"
#-   RxPDO 0x1604 "Input Request 5 RxPDOMap"
#-     PDO entry 0x7000:05, 32 bit, "Request 5"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x1,32,INP_REQ1)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7000,0x2,32,INP_REQ2)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x7000,0x3,32,INP_REQ3)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1603,0x7000,0x4,32,INP_REQ4)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7000,0x5,32,INP_REQ5)"



ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,1,ERR_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x2,1,WRN_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x3,1,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x3,1,VAL_PROP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x4,1,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x5,1,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x7,1,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x8,1,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x9,8,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0xa,16,ERR_CODE)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a20,0x6100,0x01,32,CH1_VALUE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a21,0x6110,0x01,32,CH2_VALUE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a22,0x6120,0x01,32,CH3_VALUE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a23,0x6130,0x01,32,CH4_VALUE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a24,0x6140,0x01,32,CH5_VALUE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a25,0x6150,0x01,32,CH6_VALUE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a26,0x6160,0x01,32,CH7_VALUE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a27,0x6170,0x01,32,CH8_VALUE)"

# TxPDO 0x1a20 "ID01 Current Value  TxPDOMap"
#   PDO entry 0x6100:01, 32 bit, "ID01 Current Value (P.V.)"
# TxPDO 0x1a21 "ID02 Current Value  TxPDOMap"
#   PDO entry 0x6110:01, 32 bit, "ID02 Current Value (P.V.)"
# TxPDO 0x1a22 "ID03 Current Value  TxPDOMap"
#   PDO entry 0x6120:01, 32 bit, "ID03 Current Value (P.V.)"
# TxPDO 0x1a23 "ID04 Current Value  TxPDOMap"
#   PDO entry 0x6130:01, 32 bit, "ID04 Current Value (P.V.)"
# TxPDO 0x1a24 "ID05 Current Value  TxPDOMap"
#   PDO entry 0x6140:01, 32 bit, "ID05 Current Value (P.V.)"
# TxPDO 0x1a25 "ID06 Current Value  TxPDOMap"
#   PDO entry 0x6150:01, 32 bit, "ID06 Current Value (P.V.)"
# TxPDO 0x1a26 "ID07 Current Value  TxPDOMap"
#   PDO entry 0x6160:01, 32 bit, "ID07 Current Value (P.V.)"
# TxPDO 0x1a27 "ID08 Current Value  TxPDOMap"
#   PDO entry 0x6170:01, 32 bit, "ID08 Current Value (P.V.)"
#
# SM3: PhysAddr 0x1800, DefaultSize    0, ControlRegister 0x20, Enable 1
#   TxPDO 0x1a00 "Status of System TxPDOMap"
#     PDO entry 0x6000:01,  1 bit, "Error Status"
#     PDO entry 0x6000:02,  1 bit, "Warning Status"
#     PDO entry 0x6000:03,  1 bit, "Reserved"
#     PDO entry 0x6000:04,  1 bit, "Current Value Property"
#     PDO entry 0x6000:05,  1 bit, "Reserved"
#     PDO entry 0x6000:06,  1 bit, "Reserved"
#     PDO entry 0x6000:07,  1 bit, "Reserved"
#     PDO entry 0x6000:08,  1 bit, "Reserved"
#     PDO entry 0x6000:09,  8 bit, "Reserved"
#     PDO entry 0x6000:0a, 16 bit, "Error Code"
