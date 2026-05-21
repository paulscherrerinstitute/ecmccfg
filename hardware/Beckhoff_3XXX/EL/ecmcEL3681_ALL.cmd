#-d /**
#-d   \brief hardware script for EL3681
#-d   \details 1 channel digital multimeter terminal
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3681_ALL")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0e613052")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"


#-M2: PhysAddr 0x1100, DefaultSize    2, ControlRegister 0x24, Enable 1
#-  RxPDO 0x1600 "SAI RxPDO-Map Range"
#-    PDO entry 0x7000:01,  1 bit, "Disable autorange"
#-    PDO entry 0x7000:02,  1 bit, "Start calibration"
#-    PDO entry 0x0000:00,  2 bit, "Gap"
#-    PDO entry 0x7000:05,  4 bit, "Mode"
#-    PDO entry 0x7000:09,  8 bit, "Range"
#-SM3: PhysAddr 0x1180, DefaultSize    8, ControlRegister 0x20, Enable 1
#-  TxPDO 0x1a00 "SAI TxPDO-Map Inputs"
#-    PDO entry 0x6000:01,  1 bit, "Underrange"
#-    PDO entry 0x6000:02,  1 bit, "Overrange"
#-    PDO entry 0x6000:03,  1 bit, "Extended range"
#-    PDO entry 0x6000:04,  1 bit, "Data invalid"
#-    PDO entry 0x6000:05,  1 bit, "Range invalid"
#-    PDO entry 0x6000:06,  1 bit, "Autorange disabled"
#-    PDO entry 0x6000:07,  1 bit, "Error"
#-    PDO entry 0x6000:08,  1 bit, "Calibration in progress"
#-    PDO entry 0x0000:00,  6 bit, "Gap"
#-    PDO entry 0x6000:0f,  1 bit, "TxPDO State"
#-    PDO entry 0x6000:10,  1 bit, "TxPDO Toggle"
#-    PDO entry 0x6000:11, 32 bit, "Value"
#-  TxPDO 0x1a01 "SAI TxPDO-Map Range"
#-    PDO entry 0x0000:00,  4 bit, "Gap"
#-    PDO entry 0x6001:05,  4 bit, "Mode"
#-    PDO entry 0x6001:09,  8 bit, "Range"

#- analog input Ch1, mapped as status01
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=01,ECMC_PDO=0x1a00,ECMC_ENTRY=0x6000"

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6001,0x01,U16,modeStatus01)"

#- control
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x01,U16,modeControl01)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "EL3681_ALL")
