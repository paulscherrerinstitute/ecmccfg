#-d /**
#-d   \brief hardware script for EL3742
#-d   \details 2 channel 16bit analog output differential +-10V
#-d   \author Anders Sandstroem
#-d   \file
#-d   Macros:
#-d     NELM                      : How many samples per EtherCAT cycle (not all values allowed) SAME as OVERSAMPLING_FACTOR
#-d     ECMC_EC_SLAVE_NUM         : Slave number
#-d     ECMC_EC_MASTER_ID         : Master id
#-d     ECMC_EC_SAMPLE_RATE       : EtherCAT sampling rate [Hz] (set in startup.cmd)
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL4732")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x127c3052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- Check valid oversampling factor (NELM) and ECMC_EC_SAMPLE_RATE
ecmcFileExist(${ecmccfg_DIR}chkOverSampFactOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampFactOrDie.cmd, "OVER_SAMP_MAX=100, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

#- ############ Next start time
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,2,0x1a82,0x1d09,0x98,S32,nextSyncTime)"

#- ############ Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,0,0x1680,0x7800,0x1,S16,cycleCounter01)"

#- Inflate all pdos with a for loop (PDO Offset =1536dec=600Hex)
ecmcFileExist(${ecmccfg_DIR}ecmcEL4732_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcEL4732_loopStep.cmd,"CH_ID=01, PDO_OFFSET=1536, PDO_ENTRY_OFFSET=1, SYNC_MAN=0",ECMC_LOOP_IDX,1,${NELM=1},1)

#- ############ Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,1,0x1780,0x7800,0x2,S16,cycleCounter02)"

#- Inflate all pdos with a for loop (PDO Offset =1792dec=700Hex)
ecmcFileExist(${ecmccfg_DIR}ecmcEL4732_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcEL4732_loopStep.cmd,"CH_ID=02, PDO_OFFSET=1792, PDO_ENTRY_OFFSET=2, SYNC_MAN=1",ECMC_LOOP_IDX,1,${NELM=1},1)

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

ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogOutput01_1,$(ECMC_EC_ARRAY_BYTE_SIZE),1,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogOutputArray01)"
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogOutput02_1,$(ECMC_EC_ARRAY_BYTE_SIZE),1,S16,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogOutputArray02)"

#- Cleanup
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_0_CYCLE_NS)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_1_CYCLE_NS)
epicsEnvUnset(ECMC_ENTRY_HEX_VALUE)
epicsEnvUnset(ECMC_PDO_HEX_VALUE)
epicsEnvUnset(ECMC_LOOP_IDX)
