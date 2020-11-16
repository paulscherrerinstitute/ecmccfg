#-d /**
#-d   \brief hardware script for el2252
#-d   \details 2ch digital output (with timestamp)
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2252")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x08cc3052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- SM0: PhysAddr 0x0981, DefaultSize    0, ControlRegister 0x00, Enable 12
#-   TxPDO 0x1602 "DC Sync Activate"
#-     PDO entry 0x1d09:81,  8 bit, "Activate"
#- SM1: PhysAddr 0x0990, DefaultSize    0, ControlRegister 0x00, Enable 4
#-   TxPDO 0x1603 "DC Sync Start"
#-     PDO entry 0x1d09:90, 64 bit, "StartTime"
#- SM2: PhysAddr 0x0f00, DefaultSize    0, ControlRegister 0x44, Enable 9
#-   RxPDO 0x1600 "Channel 1"
#-     PDO entry 0x7000:01,  1 bit, "Output"
#-     PDO entry 0x7000:02,  1 bit, "TriState"
#-   RxPDO 0x1601 "Channel 2"
#-     PDO entry 0x7010:01,  1 bit, "Output"
#-     PDO entry 0x7010:02,  1 bit, "TriState"
#-     PDO entry 0x0000:00,  4 bit, ""
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x1,1,BO_1)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x2,1,TRISTATE_1)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x1,1,BO_2)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x2,1,TRISTATE_2)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1602,0x1d09,0x81,8,ACTIVATE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,1,0x1603,0x1d09,0x90,64,STARTTIME)"

#-  Configure DC clock 100000ns update for oversampling (10 values oversampling)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x300,1000000,0,0,0)"
