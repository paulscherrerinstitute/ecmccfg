#-d /**
#-d   \brief generic hardware script for EL3702
#-d   \details 2 channel 16bit analog input differential
#-d   \author Anders Sandstroem
#-d   \file
#-d
#-d   Macros:
#-d     NELM                      : How many samples per EtherCAT cycle (not all values allowed) SAME as OVERSAMPLING_FACTOR
#-d     ECMC_EC_SLAVE_NUM         : Slave number
#-d     ECMC_EC_MASTER_ID         : Master id
#-d     ECMC_EC_SAMPLE_RATE       : EtherCAT sampling rate [Hz] (set in startup.cmd)
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3702")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0e763052")

#- Check valid oversampling factor (NELM) and ECMC_EC_SAMPLE_RATE
ecmcFileExist(${ecmccfg_DIR}chkOverSampFactOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampFactOrDie.cmd, "OVER_SAMP_MAX=100, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############ Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,0,0x1b00,0x6800,0x1,S16,CH1_CYCLE_CNT)"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcEL3702_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcEL3702_loopStep.cmd,"CH_ID=1, PDO_OFFSET=0, PDO_ENTRY_OFFSET=1, SYNC_MAN=0",ECMC_LOOP_IDX,1,${NELM=1},1)

#- ############ Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,1,0x1b01,0x6800,0x2,S16,CH2_CYCLE_CNT)"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcEL3702_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcEL3702_loopStep.cmd,"CH_ID=2, PDO_OFFSET=128, PDO_ENTRY_OFFSET=2, SYNC_MAN=1",ECMC_LOOP_IDX,1,${NELM=1},1)

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

ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,${ECMC_EC_SLAVE_SYNC_0_CYCLE_NS},0,${ECMC_EC_SLAVE_SYNC_1_CYCLE_NS},0)"

#- ############ Add memmaps (each element is 2 bytes (16bits))
ecmcEpicsEnvSetCalc("ECMC_EC_ARRAY_BYTE_SIZE",${NELM=1}*2)

ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH1_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH1_ARRAY)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH2_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH2_ARRAY)"

#- Cleanup
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_0_CYCLE_NS)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_1_CYCLE_NS)
epicsEnvUnset(ECMC_ENTRY_HEX_VALUE)
epicsEnvUnset(ECMC_PDO_HEX_VALUE)
epicsEnvUnset(ECMC_LOOP_IDX)
