#-d /**
#-d   \brief hardware script for Anybus-CC-ETC-TOBAS
#-d   \details LLRF ToBas
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "TOBAS")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x00505349")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00010000")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- =============================================================================
#- SyncManager 2
#- =============================================================================
epicsEnvSet("ECMC_EC_SM"    "2")
epicsEnvSet("ECMC_EC_DIR"   "1")
#- 0x1600 (default)
epicsEnvSet("ECMC_EC_PDO"   "0x1600")

#- SDO 0x2003, "3rd ADI - Enable"
epicsEnvSet("ECMC_EC_ENTRY" "0x2003")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "enable")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,40,1)

#- SDO 0x2004, "4th ADI - Alarm High"
epicsEnvSet("ECMC_EC_ENTRY" "0x2004")
epicsEnvSet("ECMC_EC_TYPE"  "U16")
epicsEnvSet("ECMC_EC_KEY"   "alarmHigh")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,40,1)

#- SDO 0x2005, "5th ADI - Alarm Low"
epicsEnvSet("ECMC_EC_ENTRY" "0x2005")
epicsEnvSet("ECMC_EC_TYPE"  "U16")
epicsEnvSet("ECMC_EC_KEY"   "alarmLow")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,40,1)

#- SDO 0x200b, "11th ADI - Spare Input"
epicsEnvSet("ECMC_EC_ENTRY" "0x200b")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "spareInput")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,20,1)

#- SDO 0x200c, "13th ADI - Mode/Calib"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x200c,0x0,U8,modeCalib01)"

#- =============================================================================
#- SyncManager 3
#- =============================================================================
epicsEnvSet("ECMC_EC_SM"    "3")
epicsEnvSet("ECMC_EC_DIR"   "2")
#- 0x1a00 (default)
epicsEnvSet("ECMC_EC_PDO"   "0x1a00")

#- SDO 0x2001, "1st ADI - Temperature"
epicsEnvSet("ECMC_EC_ENTRY" "0x2001")
epicsEnvSet("ECMC_EC_TYPE"  "U32")
epicsEnvSet("ECMC_EC_KEY"   "Rtd")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,40,1)

#- SDO 0x2002, "2nd ADI - Status"
epicsEnvSet("ECMC_EC_ENTRY" "0x2002")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "status")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,40,1)

#- SDO 0x2006, "6th ADI - SUM ILK"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x2006,0x0,U8,sumILK01)"

#- SDO 0x2007, "7th ADI - Identification"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x2007,0x0,U8,identification01)"

#- SDO 0x2008, "8th ADI - Revision"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x2008,0x0,U32,revision01)"

#- SDO 0x2009, "9th ADI - ExtSens Val"
epicsEnvSet("ECMC_EC_ENTRY" "0x2009")
epicsEnvSet("ECMC_EC_TYPE"  "U32")
epicsEnvSet("ECMC_EC_KEY"   "extSensorVal")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,12,1)

#- SDO 0x200a, "10th ADI - ExtSens Stat"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x200a,0x0,U8,extSensorstatus01)"
