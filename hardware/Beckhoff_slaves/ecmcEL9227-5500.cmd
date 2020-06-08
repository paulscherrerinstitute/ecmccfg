#-d /**
#-d   \brief hardware script for EL9227-5500
#-d   \details 2 channel fuse terminal, max 10 A, steps of 1 A.
#-d   \author Markus Kristensson
#-d   \file
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: Fuse terminal. 2 channels. Sum channels max 10 A
#-  in steps of 1 A.
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL9227-5500")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x240b3052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

###OCP RxPDO-Map Outputs###

###Trial 1 - Access through Control word###
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x1,16,CH1_CONTROL)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x1,16,CH2_CONTROL)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6000,0x1,32,CH1_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6000,0x21,16,CH1_LOAD)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6000,0x22,16,CH1_CURRENT)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6000,0x23,16,CH1_VOLTAGE_IN)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6000,0x24,16,CH1_VOLTAGE_OUT)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x1,32,CH2_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6010,0x21,16,CH2_LOAD)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6010,0x22,16,CH2_CURRENT)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6010,0x23,16,CH2_VOLTAGE_IN)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1a01,0x6010,0x24,16,CH2_VOLTAGE_OUT)"



#- SM0: PhysAddr 0x1000, DefaultSize  128, ControlRegister 0x26, Enable 1
#-SM1: PhysAddr 0x1080, DefaultSize  128, ControlRegister 0x22, Enable 1
#-SM2: PhysAddr 0x1100, DefaultSize    4, ControlRegister 0x24, Enable 1
#-  RxPDO 0x1600 "OCP RxPDO-Map Outputs Ch.1"
#-    PDO entry 0x7000:01,  1 bit, "Control__Reset"
#-    PDO entry 0x7000:02,  1 bit, "Control__Switch"
#-    PDO entry 0x0000:00, 14 bit, "Gap"
#-  RxPDO 0x1601 "OCP RxPDO-Map Outputs Ch.2"
#-    PDO entry 0x7010:01,  1 bit, "Control__Reset"
#-    PDO entry 0x7010:02,  1 bit, "Control__Switch"
#-    PDO entry 0x0000:00, 14 bit, "Gap"
#-SM3: PhysAddr 0x1180, DefaultSize   24, ControlRegister 0x20, Enable 1
#-  TxPDO 0x1a00 "OCP TxPDO-Map Inputs Ch.1"
#-    PDO entry 0x6000:01,  1 bit, "Enabled"
#-    PDO entry 0x6000:02,  1 bit, "Tripped"
#-    PDO entry 0x6000:03,  1 bit, "Short Circuit"
#-    PDO entry 0x6000:04,  1 bit, "Overload"
#-    PDO entry 0x6000:05,  1 bit, "Hardware Protection"
#-    PDO entry 0x6000:06,  1 bit, "Overvoltage"
#-    PDO entry 0x6000:07,  1 bit, "Undervoltage"
#-    PDO entry 0x6000:08,  1 bit, "Current Level Warning"
#-    PDO entry 0x6000:09,  1 bit, "Cool Down Lock"
#-    PDO entry 0x6000:0a,  1 bit, "Disabled By Switch"
#-    PDO entry 0x6000:0b,  1 bit, "Disabled By DI"
#-    PDO entry 0x6000:0c,  1 bit, "Disabled By Output"
#-    PDO entry 0x6000:0d,  1 bit, "Diag"
#-    PDO entry 0x6000:0e,  1 bit, "TxPDO State"
#-    PDO entry 0x6000:0f,  2 bit, "Input cycle counter"
#-    PDO entry 0x6000:11,  1 bit, "State Device Switch"
#-    PDO entry 0x6000:12,  1 bit, "State Digital Input"
#-    PDO entry 0x6000:13,  1 bit, "Error"
#-    PDO entry 0x6000:14,  1 bit, "State Reset"
#-    PDO entry 0x6000:15,  1 bit, "State Switch"
#-    PDO entry 0x0000:00, 11 bit, "Gap"
#-    PDO entry 0x6000:21, 16 bit, "Load"
#-    PDO entry 0x6000:22, 16 bit, "Current"
#-    PDO entry 0x6000:23, 16 bit, "Voltage In"
#-    PDO entry 0x6000:24, 16 bit, "Voltage Out"
#-  TxPDO 0x1a02 "OCP TxPDO-Map Inputs Ch.2"
#-    PDO entry 0x6010:01,  1 bit, "Enabled"
#-    PDO entry 0x6010:02,  1 bit, "Tripped"
#-    PDO entry 0x6010:03,  1 bit, "Short Circuit"
#-    PDO entry 0x6010:04,  1 bit, "Overload"
#-    PDO entry 0x6010:05,  1 bit, "Hardware Protection"
#-    PDO entry 0x6010:06,  1 bit, "Overvoltage"
#-    PDO entry 0x6010:07,  1 bit, "Undervoltage"
#-    PDO entry 0x6010:08,  1 bit, "Current Level Warning"
#-    PDO entry 0x6010:09,  1 bit, "Cool Down Lock"
#-    PDO entry 0x6010:0a,  1 bit, "Disabled By Switch"
#-    PDO entry 0x6010:0b,  1 bit, "Disabled By DI"
#-    PDO entry 0x6010:0c,  1 bit, "Disabled By Output"
#-    PDO entry 0x6010:0d,  1 bit, "Diag"
#-    PDO entry 0x6010:0e,  1 bit, "TxPDO State"
#-    PDO entry 0x6010:0f,  2 bit, "Input cycle counter"
#-    PDO entry 0x6010:11,  1 bit, "State Device Switch"
#-    PDO entry 0x6010:12,  1 bit, "State Digital Input"
#-    PDO entry 0x6010:13,  1 bit, "Error"
#-    PDO entry 0x6010:14,  1 bit, "State Reset"
#-    PDO entry 0x6010:15,  1 bit, "State Switch"
#-    PDO entry 0x0000:00, 11 bit, "Gap"
#-    PDO entry 0x6010:21, 16 bit, "Load"
#-    PDO entry 0x6010:22, 16 bit, "Current"
#-    PDO entry 0x6010:23, 16 bit, "Voltage In"
#-    PDO entry 0x6010:24, 16 bit, "Voltage Out"
#-