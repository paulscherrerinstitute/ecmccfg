#-d /**
#-d   \brief generic hardware script for EL2262
#-d   \details 2 channel oversampling digital output (1 MHz)
#-d   \author Anders Sandstroem
#-d   \file
#-d
#-d   Macros:
#-d     NELM                      : Bytes per channel and cycle (8 samples/byte), max 125
#-d     ECMC_EC_SLAVE_NUM         : Slave number
#-d     ECMC_EC_MASTER_ID         : Master id
#-d     ECMC_EC_SAMPLE_RATE       : EtherCAT sampling rate [Hz] (set in startup.cmd)
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2262")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x08d63052")
epicsEnvSet("ECMC_HW_PANEL"              "EL2262")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=false"

#- NELM is a byte count; the terminal oversampling factor is NELM * 8.
ecmcEpicsEnvSetCalc("ECMC_EC_OVER_SAMP_FACTOR",${NELM=1}*8)
ecmcFileExist(${ecmccfg_DIR}chkOverSampFactOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampFactOrDie.cmd, "OVER_SAMP_MAX=1000, OVER_SAMP_REQ=${ECMC_EC_OVER_SAMP_FACTOR}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

#- ############ Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1700,0x7800,0x1,U16,cycleCounter01)"
ecmcFileExist(${ecmccfg_DIR}ecmcEL2262_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcEL2262_loopStep.cmd,"CH_ID=01, PDO_OFFSET=0, PDO_ENTRY_OFFSET=1, SYNC_MAN=0",ECMC_LOOP_IDX,1,${NELM=1},1)

#- ############ Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,1,0x1701,0x7800,0x2,U16,cycleCounter02)"
ecmcFileExist(${ecmccfg_DIR}ecmcEL2262_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcEL2262_loopStep.cmd,"CH_ID=02, PDO_OFFSET=128, PDO_ENTRY_OFFSET=2, SYNC_MAN=1",ECMC_LOOP_IDX,1,${NELM=1},1)

#- ############ Start time of next output cycle
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,2,0x1702,0x1d09,0x98,U32,nextSyncTime)"

#- One Sync0 interrupt per output bit.
ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_SYNC_0_CYCLE_NS",1/${ECMC_EC_SAMPLE_RATE=1000}*1E9/${ECMC_EC_OVER_SAMP_FACTOR})
ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_SYNC_1_CYCLE_NS",1/${ECMC_EC_SAMPLE_RATE=1000}*1E9-${ECMC_EC_SLAVE_SYNC_0_CYCLE_NS})
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,${ECMC_EC_SLAVE_SYNC_0_CYCLE_NS},${ECMC_SYNC_0_OFFSET_NS=0},${ECMC_EC_SLAVE_SYNC_1_CYCLE_NS},${ECMC_SYNC_1_OFFSET_NS=0})"

#- Contiguous byte arrays for the two output channels.
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.binaryOutputArray01_1,${NELM=1},1,U8,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.binaryOutputArray01)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.binaryOutputArray02_1,${NELM=1},1,U8,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.binaryOutputArray02)"

#- Cleanup
epicsEnvUnset(ECMC_EC_OVER_SAMP_FACTOR)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_0_CYCLE_NS)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_1_CYCLE_NS)
epicsEnvUnset(ECMC_ENTRY_HEX_VALUE)
epicsEnvUnset(ECMC_PDO_HEX_VALUE)
epicsEnvUnset(ECMC_LOOP_IDX)
