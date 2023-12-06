#-d /**
#-d   \brief hardware script for Anybus-CC-ETC-ILK
#-d   \details LLRF ILK cfg of generic 64byte input and output buffers
#-d   \author Anders Sandstroem
#-d   \file
#-d */


#- size of buffer
epicsEnvSet("ECMC_SIZE"     "${NELM=64}")

#- 64byte Output buffer:
#- =============================================================================
#- SyncManager 2
#- =============================================================================
epicsEnvSet("ECMC_EC_SM"    "2")
epicsEnvSet("ECMC_EC_DIR"   "1")
#- 0x1600 (default)
epicsEnvSet("ECMC_EC_PDO"   "0x1600")

#- RxPDO 0x1600 ""
epicsEnvSet("ECMC_EC_ENTRY" "0x2001")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "byteOutput")


ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,${ECMC_SIZE},1)

# Memmap to view buffer
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.${ECMC_EC_KEY}01,${ECMC_SIZE},2,U8,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.${ECMC_EC_KEY}Buff)"

#- 64byte Input buffer:
#- =============================================================================
#- SyncManager 3:
#- =============================================================================
epicsEnvSet("ECMC_EC_SM"    "3")
epicsEnvSet("ECMC_EC_DIR"   "2")
#- 0x1a00 (default)
epicsEnvSet("ECMC_EC_PDO"   "0x1a00")

#- TxPDO 0x1a00 ""
epicsEnvSet("ECMC_EC_ENTRY" "0x2004")
epicsEnvSet("ECMC_EC_TYPE"  "U8")
epicsEnvSet("ECMC_EC_KEY"   "byteInput")
ecmcFileExist(${ecmccfg_DIR}TOBAS_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}TOBAS_loopStep.cmd,"DIR=${ECMC_EC_DIR},SM=${ECMC_EC_SM},PDO=${ECMC_EC_PDO},ENTRY=${ECMC_EC_ENTRY},TYPE=${ECMC_EC_TYPE},KEY=${ECMC_EC_KEY}",IDX,1,${ECMC_SIZE},1)

# Memmap to view buffer
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.${ECMC_EC_KEY}01,${ECMC_SIZE},2,U8,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.${ECMC_EC_KEY}Buff)"


#- kalt_r@sls129-sioc-ecatrilkts:~$ ethercat pdos -p11
#- === Master 0, Slave 11 ===
#- SM0: PhysAddr 0x1c00, DefaultSize 276, ControlRegister 0x26, Enable 1
#- SM1: PhysAddr 0x1e00, DefaultSize 276, ControlRegister 0x22, Enable 1
#- SM2: PhysAddr 0x1000, DefaultSize 64, ControlRegister 0x64, Enable 1
#- RxPDO 0x1600 ""
#- PDO entry 0x2001:01, 8 bit, ""
#- PDO entry 0x2001:02, 8 bit, ""
#- PDO entry 0x2001:03, 8 bit, ""
#- PDO entry 0x2001:04, 8 bit, ""
#- PDO entry 0x2001:05, 8 bit, ""
#- PDO entry 0x2001:06, 8 bit, ""
#- PDO entry 0x2001:07, 8 bit, ""
#- PDO entry 0x2001:08, 8 bit, ""
#- PDO entry 0x2001:09, 8 bit, ""
#- PDO entry 0x2001:0a, 8 bit, ""
#- PDO entry 0x2001:0b, 8 bit, ""
#- PDO entry 0x2001:0c, 8 bit, ""
#- PDO entry 0x2001:0d, 8 bit, ""
#- PDO entry 0x2001:0e, 8 bit, ""
#- PDO entry 0x2001:0f, 8 bit, ""
#- PDO entry 0x2001:10, 8 bit, ""
#- PDO entry 0x2001:11, 8 bit, ""
#- PDO entry 0x2001:12, 8 bit, ""
#- PDO entry 0x2001:13, 8 bit, ""
#- PDO entry 0x2001:14, 8 bit, ""
#- PDO entry 0x2001:15, 8 bit, ""
#- PDO entry 0x2001:16, 8 bit, ""
#- PDO entry 0x2001:17, 8 bit, ""
#- PDO entry 0x2001:18, 8 bit, ""
#- PDO entry 0x2001:19, 8 bit, ""
#- PDO entry 0x2001:1a, 8 bit, ""
#- PDO entry 0x2001:1b, 8 bit, ""
#- PDO entry 0x2001:1c, 8 bit, ""
#- PDO entry 0x2001:1d, 8 bit, ""
#- PDO entry 0x2001:1e, 8 bit, ""
#- PDO entry 0x2001:1f, 8 bit, ""
#- PDO entry 0x2001:20, 8 bit, ""
#- PDO entry 0x2001:21, 8 bit, ""
#- PDO entry 0x2001:22, 8 bit, ""
#- PDO entry 0x2001:23, 8 bit, ""
#- PDO entry 0x2001:24, 8 bit, ""
#- PDO entry 0x2001:25, 8 bit, ""
#- PDO entry 0x2001:26, 8 bit, ""
#- PDO entry 0x2001:27, 8 bit, ""
#- PDO entry 0x2001:28, 8 bit, ""
#- PDO entry 0x2001:29, 8 bit, ""
#- PDO entry 0x2001:2a, 8 bit, ""
#- PDO entry 0x2001:2b, 8 bit, ""
#- PDO entry 0x2001:2c, 8 bit, ""
#- PDO entry 0x2001:2d, 8 bit, ""
#- PDO entry 0x2001:2e, 8 bit, ""
#- PDO entry 0x2001:2f, 8 bit, ""
#- PDO entry 0x2001:30, 8 bit, ""
#- PDO entry 0x2001:31, 8 bit, ""
#- PDO entry 0x2001:32, 8 bit, ""
#- PDO entry 0x2001:33, 8 bit, ""
#- PDO entry 0x2001:34, 8 bit, ""
#- PDO entry 0x2001:35, 8 bit, ""
#- PDO entry 0x2001:36, 8 bit, ""
#- PDO entry 0x2001:37, 8 bit, ""
#- PDO entry 0x2001:38, 8 bit, ""
#- PDO entry 0x2001:39, 8 bit, ""
#- PDO entry 0x2001:3a, 8 bit, ""
#- PDO entry 0x2001:3b, 8 bit, ""
#- PDO entry 0x2001:3c, 8 bit, ""
#- PDO entry 0x2001:3d, 8 bit, ""
#- PDO entry 0x2001:3e, 8 bit, ""
#- PDO entry 0x2001:3f, 8 bit, ""
#- PDO entry 0x2001:40, 8 bit, ""
#- SM3: PhysAddr 0x1600, DefaultSize 64, ControlRegister 0x20, Enable 1
#- TxPDO 0x1a00 ""
#- PDO entry 0x2002:01, 8 bit, ""
#- PDO entry 0x2002:02, 8 bit, ""
#- PDO entry 0x2002:03, 8 bit, ""
#- PDO entry 0x2002:04, 8 bit, ""
#- PDO entry 0x2002:05, 8 bit, ""
#- PDO entry 0x2002:06, 8 bit, ""
#- PDO entry 0x2002:07, 8 bit, ""
#- PDO entry 0x2002:08, 8 bit, ""
#- PDO entry 0x2002:09, 8 bit, ""
#- PDO entry 0x2002:0a, 8 bit, ""
#- PDO entry 0x2002:0b, 8 bit, ""
#- PDO entry 0x2002:0c, 8 bit, ""
#- PDO entry 0x2002:0d, 8 bit, ""
#- PDO entry 0x2002:0e, 8 bit, ""
#- PDO entry 0x2002:0f, 8 bit, ""
#- PDO entry 0x2002:10, 8 bit, ""
#- PDO entry 0x2002:11, 8 bit, ""
#- PDO entry 0x2002:12, 8 bit, ""
#- PDO entry 0x2002:13, 8 bit, ""
#- PDO entry 0x2002:14, 8 bit, ""
#- PDO entry 0x2002:15, 8 bit, ""
#- PDO entry 0x2002:16, 8 bit, ""
#- PDO entry 0x2002:17, 8 bit, ""
#- PDO entry 0x2002:18, 8 bit, ""
#- PDO entry 0x2002:19, 8 bit, ""
#- PDO entry 0x2002:1a, 8 bit, ""
#- PDO entry 0x2002:1b, 8 bit, ""
#- PDO entry 0x2002:1c, 8 bit, ""
#- PDO entry 0x2002:1d, 8 bit, ""
#- PDO entry 0x2002:1e, 8 bit, ""
#- PDO entry 0x2002:1f, 8 bit, ""
#- PDO entry 0x2002:20, 8 bit, ""
#- PDO entry 0x2002:21, 8 bit, ""
#- PDO entry 0x2002:22, 8 bit, ""
#- PDO entry 0x2002:23, 8 bit, ""
#- PDO entry 0x2002:24, 8 bit, ""
#- PDO entry 0x2002:25, 8 bit, ""
#- PDO entry 0x2002:26, 8 bit, ""
#- PDO entry 0x2002:27, 8 bit, ""
#- PDO entry 0x2002:28, 8 bit, ""
#- PDO entry 0x2002:29, 8 bit, ""
#- PDO entry 0x2002:2a, 8 bit, ""
#- PDO entry 0x2002:2b, 8 bit, ""
#- PDO entry 0x2002:2c, 8 bit, ""
#- PDO entry 0x2002:2d, 8 bit, ""
#- PDO entry 0x2002:2e, 8 bit, ""
#- PDO entry 0x2002:2f, 8 bit, ""
#- PDO entry 0x2002:30, 8 bit, ""
#- PDO entry 0x2002:31, 8 bit, ""
#- PDO entry 0x2002:32, 8 bit, ""
#- PDO entry 0x2002:33, 8 bit, ""
#- PDO entry 0x2002:34, 8 bit, ""
#- PDO entry 0x2002:35, 8 bit, ""
#- PDO entry 0x2002:36, 8 bit, ""
#- PDO entry 0x2002:37, 8 bit, ""
#- PDO entry 0x2002:38, 8 bit, ""
#- PDO entry 0x2002:39, 8 bit, ""
#- PDO entry 0x2002:3a, 8 bit, ""
#- PDO entry 0x2002:3b, 8 bit, ""
#- PDO entry 0x2002:3c, 8 bit, ""
#- PDO entry 0x2002:3d, 8 bit, ""
#- PDO entry 0x2002:3e, 8 bit, ""
#- PDO entry 0x2002:3f, 8 bit, ""
#- PDO entry 0x2002:40, 8 bit, ""
#-