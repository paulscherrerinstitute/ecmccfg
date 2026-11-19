#==============================================================================
# addEcSdoRT.cmd
#-d /**
#-d   \brief Script for adding asyn SDO object (access to SDO:s in realtime)
#-d   \details Add SDO for async access during realtime operation
#-d   \author Anders Sandström
#-d   \file
#-d   \param SLAVE_ID (optional) bus position
#-d   \param INDEX  sdo index
#-d   \param SUBINDEX  sdo subindex
#-d   \param DT  scalar data type (required when BYTE_SIZE is omitted or zero)
#-d   \param BYTE_SIZE (optional, default 0) nonzero selects a byte-array SDO; valid range 1..1048576
#-d   \param WRITE_ON_VAL optional 0/1, default 0; a scalar Val write also submits a write
#-d   \param PREOP_ONLY optional 0/1, default 0; reject writes after master activation
#-d   Scalar requests are automatically queued and writes are read back/verified.
#-d   Accepted write snapshots can be autosaved and restored before activation.
#-d   \param NAME  name to be used for addressing and suffix of PV name
#-d   \param P_SCRIPT (optional) naming convention prefix script
#-d
#-d   Array mode (BYTE_SIZE > 0):
#-d   - Transfers one raw byte payload at INDEX/SUBINDEX on SLAVE_ID.
#-d     Does not iterate subindices or perform SDO Complete Access.
#-d   - DT is ignored and may be omitted. Both EPICS waveform records use
#-d     FTVL=UCHAR (unsigned bytes, 0..255) and NELM=BYTE_SIZE.
#-d     BYTE_SIZE counts bytes, not multibyte integer/float elements.
#-d   - Data-RB uses DTYP=asynInt8ArrayIn; Data uses DTYP=asynInt8ArrayOut.
#-d     Despite the asyn Int8 name, FTVL=UCHAR exposes unsigned byte values.
#-d   - Multibyte integers, floats and strings require caller-side encoding/
#-d     decoding in the device's format and byte order; no conversion is done.
#-d
#-d   Array PV suffixes (after the resolved prefix plus SDO-<NAME>-):
#-d   - Data: stage exactly BYTE_SIZE bytes for download (IOC to slave).
#-d     Writing this waveform does not start an SDO transfer. After a successful
#-d     staging write, write 1 to WrtCmd to download the staged bytes.
#-d     Partial/oversized staging writes and staging while busy are rejected.
#-d   - RdCmd: write 1 to upload from the slave into Data-RB (slave to IOC).
#-d   - Data-RB: last successful upload; NORD is the actual received byte count,
#-d     which may be smaller than NELM. Uploads do not change staged Data.
#-d   - Bytes-RB: actual length of the last successful EtherCAT upload, even
#-d     if it exceeded BYTE_SIZE. An oversized response sets ErrId and leaves
#-d     Data-RB unchanged; it is not silently truncated.
#-d   - Bsy / ErrId: wait for Bsy to clear and check ErrId before using the
#-d     result or issuing another transfer. RdCmd/WrtCmd reset automatically.
#-d   - Downloads always send exactly BYTE_SIZE bytes, even after a shorter
#-d     upload. Configure the endpoint before entering runtime.
#-d
#-d   Example array arguments (no DT needed):
#-d     SLAVE_ID=3,INDEX=0x2000,SUBINDEX=0x01,BYTE_SIZE=4096,NAME=payload
#-d   NAME is an endpoint alias used in parameter/PV names, not payload data.
#-d   For large CA waveforms, set EPICS_CA_MAX_ARRAY_BYTES on the IOC and client
#-d   above BYTE_SIZE, allowing protocol overhead.
#-d
#-d   Backward compatibility: omit BYTE_SIZE or set it to 0 to use the existing
#-d   scalar SDO command and integer/float PV templates; DT is then required.
#-d */

# Simulation has no asynchronous SDO transport or asyn SDO records.
ecmcIf("${ECMC_SIM=0}==1")
${IF_TRUE}exit
ecmcEndIf()

# Scalar objects always serialize requests and support startup restore. Val
# still only stages data unless WRITE_ON_VAL is explicitly enabled.
ecmcEpicsEnvSetCalcTernary(ECMC_SDO_BAD_OPTIONS,"('${WRITE_ON_VAL=0}'!='0' and '${WRITE_ON_VAL=0}'!='1') or ('${PREOP_ONLY=0}'!='0' and '${PREOP_ONLY=0}'!='1')","","#-")
${ECMC_SDO_BAD_OPTIONS}ecmcExit Error: WRITE_ON_VAL and PREOP_ONLY must be 0 or 1
ecmcEpicsEnvSetCalcTernary(ECMC_SDO_BAD_OPTIONS,"${BYTE_SIZE=0}!=0 and (${WRITE_ON_VAL=0}=1 or ${PREOP_ONLY=0}=1)","","#-")
${ECMC_SDO_BAD_OPTIONS}ecmcExit Error: WRITE_ON_VAL and PREOP_ONLY are scalar options; BYTE_SIZE must be 0
epicsEnvUnset(ECMC_SDO_BAD_OPTIONS)
ecmcEpicsEnvSetCalcTernary(ECMC_SDO_EXE_QUEUED,"${BYTE_SIZE=0}=0","","#-")
epicsEnvSet("P_SCRIPT",           "${P_SCRIPT=${ECMC_P_SCRIPT}}")

# Keep the legacy scalar path unless BYTE_SIZE is nonzero.
# Negative/out-of-range sizes are passed to the array command for validation.
ecmcEpicsEnvSetCalcTernary(ECMC_SDO_EXE_ARRAY, "${BYTE_SIZE=0}!=0", "", "#-")
ecmcEpicsEnvSetCalcTernary(ECMC_SDO_EXE_SCALAR, "${BYTE_SIZE=0}=0", "", "#-")
${ECMC_SDO_EXE_SCALAR}ecmcConfigOrDie "Cfg.EcAddSdoAsync(${SLAVE_ID=0},${INDEX},${SUBINDEX},${DT=},${NAME})"
${ECMC_SDO_EXE_ARRAY}ecmcConfigOrDie "Cfg.EcAddSdoAsyncArray(${SLAVE_ID=0},${INDEX},${SUBINDEX},${BYTE_SIZE=0},${NAME})"
${ECMC_SDO_EXE_QUEUED}ecmcConfigOrDie "Cfg.EcConfigureSdoQueue(${SLAVE_ID=0},${NAME},${WRITE_ON_VAL=0},${PREOP_ONLY=0})"
# Any queued object defers activation to the existing EPICS-first worker so
# requests made during record initialization can finish before the bus goes OP.
${ECMC_SDO_EXE_QUEUED}epicsEnvSet(ECMC_SDO_QUEUE_IN_USE,1)


# deduce what the prefix should be
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd" "MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},HWTYPE=${ECMC_EC_HWTYPE}"

#- Load SDO control and status records
${ECMC_SDO_EXE_SCALAR}ecmcFileExist("ecmcSDOAsync.template",1,1)
${ECMC_SDO_EXE_SCALAR}dbLoadRecords("ecmcSDOAsync.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")

#- Load SDO value record based on datatype
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD_FLOAT, "${BYTE_SIZE=0}=0 and ('${DT=}'='F32' or '${DT=}'='F64')","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD_INT, "${BYTE_SIZE=0}=0 and ('${DT=}'!='F32' and '${DT=}'!='F64') and '${DT=}'!='U64' and '${DT=}'!='S64' and '${DT=}'!='S64_TO_U64'","","#-")
${ECMC_EXE_CMD_INT}ecmcFileExist("ecmcSDOAsyncInt.template",1,1)
${ECMC_EXE_CMD_INT}dbLoadRecords("ecmcSDOAsyncInt.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
${ECMC_EXE_CMD_FLOAT}ecmcFileExist("ecmcSDOAsyncFloat.template",1,1)
${ECMC_EXE_CMD_FLOAT}dbLoadRecords("ecmcSDOAsyncFloat.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
# Exact native 64-bit staging and actual readback for scalar objects.
ecmcEpicsEnvSetCalcTernary(ECMC_SDO_EXE_INT64,"${BYTE_SIZE=0}=0 and ('${DT=}'='U64' or '${DT=}'='S64' or '${DT=}'='S64_TO_U64')","","#-")
${ECMC_SDO_EXE_INT64}ecmcFileExist("ecmcSDOAsyncInt64.template",1,1)
${ECMC_SDO_EXE_INT64}dbLoadRecords("ecmcSDOAsyncInt64.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
${ECMC_SDO_EXE_INT64}dbLoadRecords("ecmcSDOQueuedReadbackInt64.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
ecmcEpicsEnvSetCalcTernary(ECMC_SDO_RB_INTERFACE,"'${DT=}'='F32' or '${DT=}'='F64'","asynFloat64","asynInt32")
ecmcEpicsEnvSetCalcTernary(ECMC_SDO_EXE_SMALL_RB,"${BYTE_SIZE=0}=0 and '${DT=}'!='U64' and '${DT=}'!='S64' and '${DT=}'!='S64_TO_U64'","","#-")
${ECMC_SDO_EXE_SMALL_RB}ecmcFileExist("ecmcSDOQueuedReadback.template",1,1)
${ECMC_SDO_EXE_SMALL_RB}dbLoadRecords("ecmcSDOQueuedReadback.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},INTERFACE=${ECMC_SDO_RB_INTERFACE}")
# Autosave this one request snapshot, not WrtCmd/RdCmd or an uninitialized Val.
# Its zero/empty state means no SDO write was requested and is skipped on restore.
${ECMC_SDO_EXE_QUEUED}ecmcFileExist("ecmcSDOQueuedStartup.template",1,1)
${ECMC_SDO_EXE_QUEUED}dbLoadRecords("ecmcSDOQueuedStartup.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
${ECMC_SDO_EXE_QUEUED}ecmcSdoRegisterRestore(${SLAVE_ID=0},${NAME},"${ECMC_P}SDO-${NAME}-StartupData_")

# The array template includes both waveform and control/status records.
${ECMC_SDO_EXE_ARRAY}ecmcFileExist("ecmcSDOAsyncArray.template",1,1)
${ECMC_SDO_EXE_ARRAY}dbLoadRecords("ecmcSDOAsyncArray.template","P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},NELM=${BYTE_SIZE=0}")

epicsEnvUnset(ECMC_SDO_EXE_ARRAY)
epicsEnvUnset(ECMC_SDO_EXE_SCALAR)
epicsEnvUnset(ECMC_EXE_CMD_INT)
epicsEnvUnset(ECMC_EXE_CMD_FLOAT)


epicsEnvUnset(ECMC_SDO_EXE_QUEUED)
epicsEnvUnset(ECMC_SDO_EXE_INT64)
epicsEnvUnset(ECMC_SDO_EXE_SMALL_RB)
epicsEnvUnset(ECMC_SDO_RB_INTERFACE)
