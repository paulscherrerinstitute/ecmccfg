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

epicsEnvSet("ECMC_EC_HWTYPE"             "EL5101-0011")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x13ed3052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- Different pdo index depending on sampling rate..
#- NELM    PDO index dec
#- 1       0xA10     10
#- 2       0xA11     11
#- 4       0xA12     12
#- 5       0xA13     13
#- 8       0xA14     14
#- 10      0xA15     15
#- 16      0xA16     16
#- 20      0xA17     17
#- 25      0xA18     18
#- 32      0xA19     19
#- 40      0xA1A     20
#- 50      0xA1B     21
#- 64      0xA1C     22
#- 80      0xA1D     23
#- 100     0xA1E     24
#- Check if valid NELM and set ECMC_PDO_TEMP to correct value according to list
#- Try to simulate switch statement

epicsEnvSet(ECMC_PDO_TEMP,"-1")
epicsEnvSet(ECMC_PDO_NELM_FOUND,"")
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=1 and ${ECMC_PDO_TEMP}==-1", "16","-1")
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=2 and ${ECMC_PDO_TEMP}==-1", "17","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=4 and ${ECMC_PDO_TEMP}==-1", "18","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=5 and ${ECMC_PDO_TEMP}==-1", "19","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=8 and ${ECMC_PDO_TEMP}==-1", "20","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=10 and ${ECMC_PDO_TEMP}==-1", "21","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=16 and ${ECMC_PDO_TEMP}==-1", "22","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=20 and ${ECMC_PDO_TEMP}==-1", "23","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=25 and ${ECMC_PDO_TEMP}==-1", "24","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=32 and ${ECMC_PDO_TEMP}==-1", "25","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=40 and ${ECMC_PDO_TEMP}==-1", "26","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=50 and ${ECMC_PDO_TEMP}==-1", "27","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=64 and ${ECMC_PDO_TEMP}==-1", "28","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=80 and ${ECMC_PDO_TEMP}==-1", "29","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=100 and ${ECMC_PDO_TEMP}==-1", "30","-1")

#- Ensure that ECMC_PDO_TEMP is set
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM and PDO is valid (${ECMC_PDO_TEMP}).","ecmcExit Error: NELM not valid => PDO not set..")
#- Exit if not valid according to
${ECMC_PDO_NELM_FOUND}

#- Convert to hex
ecmcEpicsEnvSetCalc("ECMC_PDO_TEMP",${ECMC_PDO_TEMP},"0x1A%02x")
epicsEnvShow(ECMC_PDO_TEMP)

#- Check valid oversampling factor (NELM) and ECMC_EC_SAMPLE_RATE
ecmcFileExist(${ecmccfg_DIR}chkOverSampFactOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampFactOrDie.cmd, "OVER_SAMP_MAX=100, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x03,16,encoderControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x11,32,encoderValue01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x01,16,encoderStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6000,0x19,64,nextSyncTime)"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcEL5101-0011_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcEL5101-0011_loopStep.cmd,"PDO=${ECMC_PDO_TEMP}",ECMC_LOOP_IDX,1,${NELM=1},1)

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

#- ############ Add memmaps (each element is 4 bytes (32bits))
ecmcEpicsEnvSetCalc("ECMC_EC_ARRAY_BYTE_SIZE",${NELM=1}*4)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.positionActual01_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,U32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.positionActualArray01)"

#- From TC startup list (ensure we use the selected PDO)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x0,0,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x1,0x1600,2)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x0,1,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0xF082,0x1,0,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x0,0,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x1,0x1A00,2)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x2,0x1A01,2)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x3,${ECMC_PDO_TEMP},2)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x0,3,1)"

#- Cleanup
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_0_CYCLE_NS)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_1_CYCLE_NS)
epicsEnvUnset(ECMC_PDO_NELM_FOUND)
epicsEnvUnset(ECMC_PDO_TEMP)
epicsEnvUnset(ECMC_LOOP_IDX)
