#-d /**
#-d   \brief hardware script for EL3604
#-d   \details 4-channel 24bit analog input terminal for Condition Monitoring (IEPE) with oversampling
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3604")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x50219349")

#- Check valid oversampling factor (NELM) and ECMC_EC_SAMPLE_RATE
ecmcFileExist(${ecmccfg_DIR}chkOverSampFactOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampFactOrDie.cmd, "OVER_SAMP_MAX=20, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############################################

#- ############ Add memmaps (each element is 4 bytes (32bits))
ecmcEpicsEnvSetCalc("ECMC_EC_ARRAY_BYTE_SIZE",${NELM=1}*4)

#-  CH 1
#-  Configuration for sync manager 3
epicsEnvSet("ECMC_CH"             "1")
epicsEnvSet("ECMC_EC_PDO"         "0x1a08")
epicsEnvSet("ECMC_EC_ENTRY"       "0x6001")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,S32,CH${ECMC_CH}_STATUS)"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM3604_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM3604_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_EC_PDO}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x1,S64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH${ECMC_CH}_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"

#-  CH 2
#-  Configuration for sync manager 3
epicsEnvSet("ECMC_CH"             "2")
epicsEnvSet("ECMC_EC_PDO"         "0x1a29")
epicsEnvSet("ECMC_EC_ENTRY"       "0x6011")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a21,0x6010,0x1,S32,CH${ECMC_CH}_STATUS)"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM3604_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM3604_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_EC_PDO}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a31,0x6015,0x1,S64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH${ECMC_CH}_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"

#-  CH 3
#-  Configuration for sync manager 3
epicsEnvSet("ECMC_CH"             "3")
epicsEnvSet("ECMC_EC_PDO"         "0x1a4a")
epicsEnvSet("ECMC_EC_ENTRY"       "0x6021")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a42,0x6020,0x1,S32,CH${ECMC_CH}_STATUS)"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM3604_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM3604_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_EC_PDO}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a52,0x6025,0x1,S64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH${ECMC_CH}_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"

#-  CH 4
#-  Configuration for sync manager 3
epicsEnvSet("ECMC_CH"             "4")
epicsEnvSet("ECMC_EC_PDO"         "0x1a6b")
epicsEnvSet("ECMC_EC_ENTRY"       "0x6031")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a63,0x6030,0x1,S32,CH${ECMC_CH}_STATUS)"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM3604_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM3604_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_EC_PDO}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a73,0x6035,0x1,S64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH${ECMC_CH}_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"

#- ############ Configfigure DCs
#-  Cfg.EcSlaveConfigDC(
#-      int slave_bus_position,
#-      uint16_t assign_activate,
#-      uint32_t sync0_cycle,
#-      int32_t sync0_shift,
#-      uint32_t sync1_cycle,
#-      int32_t sync1_shift)
#- 
#- Sync configuration is not the same as in TwinCAT..
#-    sync0_cycle: Sample period in nanoseconds (for each sample). Example: EC_RATE 1000Hz, OVERSAMPLING_FACTOR=100 results in sync0_cycle=10000ns)
#-    sync1_cycle: EtherCAT sample period minus sync0_cycle.  Example: EC_RATE 1000Hz, OVERSAMPLING_FACTOR=100 results in sync1_cycle=990000ns)
#-

ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_SYNC_0_CYCLE_NS",1/${ECMC_EC_SAMPLE_RATE=1000}*1E9/${NELM=1})
ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_SYNC_1_CYCLE_NS",1/${ECMC_EC_SAMPLE_RATE=1000}*1E9-${ECMC_EC_SLAVE_SYNC_0_CYCLE_NS})

#ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,${ECMC_EC_SLAVE_SYNC_0_CYCLE_NS},0,${ECMC_EC_SLAVE_SYNC_1_CYCLE_NS},0)"

#- Cleanup
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_0_CYCLE_NS)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_1_CYCLE_NS)
epicsEnvUnset(ECMC_ENTRY_HEX_VALUE)
epicsEnvUnset(ECMC_PDO_HEX_VALUE)
epicsEnvUnset(ECMC_LOOP_IDX)
