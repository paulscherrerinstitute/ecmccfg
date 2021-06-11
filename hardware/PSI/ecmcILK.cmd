#-d /**
#-d   \brief hardware script for Anybus-CC-ETC-ILK
#-d   \details LLRF ILK
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ILK")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x00505349")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00020000")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- =============================================================================
#- SyncManager 2
#- =============================================================================
epicsEnvSet("ECMC_EC_SM"    "2")
epicsEnvSet("ECMC_EC_DIR"   "1")
#- 0x1600 (default)
epicsEnvSet("ECMC_EC_PDO"   "0x1600")

#- SDO 0x2001, "SPI_RD"
epicsEnvSet("ECMC_EC_ENTRY" "0x2001")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "spiRd")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,36,1)

#- SDO 0x2002, "DIGINP"
epicsEnvSet("ECMC_EC_ENTRY" "0x2002")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "digInp")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,10,1)

#- SDO 0x2003, "AN_INP"
epicsEnvSet("ECMC_EC_ENTRY" "0x2003")
epicsEnvSet("ECMC_EC_TYPE"  "U16")
epicsEnvSet("ECMC_EC_KEY"   "ecmc_analogOutput")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,59,1)

#- =============================================================================
#- SyncManager 3
#- =============================================================================
epicsEnvSet("ECMC_EC_SM"    "3")
epicsEnvSet("ECMC_EC_DIR"   "2")
#- 0x1a00 (default)
epicsEnvSet("ECMC_EC_PDO"   "0x1a00")

#- SDO 0x2004, "SII_WR"
epicsEnvSet("ECMC_EC_ENTRY" "0x2004")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "siiWr")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,33,1)

#- SDO 0x2005, "SIGN__"
epicsEnvSet("ECMC_EC_ENTRY" "0x2005")
epicsEnvSet("ECMC_EC_TYPE"  "U32")
epicsEnvSet("ECMC_EC_KEY"   "signal")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,2,1)

#- SDO 0x2006, "DIGOUT"
epicsEnvSet("ECMC_EC_ENTRY" "0x2006")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "binaryInputArray")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,22,1)

#- SDO 0x2007, "AN_OUT"
epicsEnvSet("ECMC_EC_ENTRY" "0x2007")
epicsEnvSet("ECMC_EC_TYPE"  "U16")
epicsEnvSet("ECMC_EC_KEY"   "analogInput")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,11,1)
