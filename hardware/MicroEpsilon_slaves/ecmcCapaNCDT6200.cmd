#-d /**
#-d   \brief hardware script for CapaNCDT6200
#-d   \details MICRO-EPSILON CapaNCDT6200 Capacitive position sensor amplifier.
#-d   \author Anders Sandstrom
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "CapaNCDT6200")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x0000065e")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x003ea349")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#-ethercat pdos -p12
#- SM0: PhysAddr 0x1000, DefaultSize  128, ControlRegister 0x26, Enable 1
#- SM1: PhysAddr 0x1400, DefaultSize  128, ControlRegister 0x22, Enable 1
#- SM2: PhysAddr 0x1800, DefaultSize    0, ControlRegister 0x64, Enable 0
#- SM3: PhysAddr 0x1c00, DefaultSize   22, ControlRegister 0x20, Enable 1
#-   TxPDO 0x1a00 "TxPDO Mapping"
#-     PDO entry 0x0000:00, 16 bit, "Gap"
#-     PDO entry 0x6020:03, 32 bit, "Counter"
#-     PDO entry 0x6020:08, 32 bit, "Channel 1"
#-     PDO entry 0x6020:09, 32 bit, "Channel 2"
#-     PDO entry 0x6020:0a, 32 bit, "Channel 3"
#-     PDO entry 0x6020:0b, 32 bit, "Channel 4"
#- 

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x0,0x00,S16,gap01,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6020,0x03,S32,counter01,1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6020,0x08,F32,analogInput01,1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6020,0x09,F32,analogInput02,1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6020,0x0a,F32,analogInput03,1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6020,0x0b,F32,analogInput04,1)"
