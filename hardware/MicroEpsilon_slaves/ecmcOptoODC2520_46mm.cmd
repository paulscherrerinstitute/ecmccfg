#-d /**
#-d   \brief hardware script for ODC2520_46mm
#-d   \details MICRO-EPSILON ODC2520 laser micro meter sensor 46mm range.
#-d   \author Anders Sandstrom
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "OptoODC2520_46mm")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x00000607")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0041eefd")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- Config PDOS:
# SM3: PhysAddr 0x1280, DefaultSize    4, ControlRegister 0x20, Enable 1
#   TxPDO 0x1a00 "Sample 0"
#     PDO entry 0x6065:01, 32 bit, "Position of the first high-low edge"

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6065,0x1,S32,analogInput01,1)"
