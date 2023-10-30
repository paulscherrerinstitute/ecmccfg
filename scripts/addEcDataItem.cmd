#==============================================================================
# addEcSdoRT.cmd
#-d /**
#-d   \brief Script for adding a ethercat data item.
#-d    
#-d   The ethercat data item allows for accessing alreday configured ethercat domain data in a flexible 
#-d   way by defining:
#-d    1. start ethercat entry, defineing start adress in domian mem area. (ec0.s1.positionActual01)
#-d    2. offset in bytes (0..x)
#-d    3. offset in bits  (0..7)
#-d    4. Direction: 1==output, 2==input- Should be same as direction for ethercat start entry 
#-d    5. DataType of ethercat data: (S32)
#-d                B1:  1-bit
#-d                B2:  2-bits (lsb)
#-d                B3:  3-bits (lsb)
#-d                B4:  4-bits (lsb)
#-d                U8:  Unsigned 8-bit
#-d                S8:  Signed 8-bit
#-d                U16: Unsigned 16-bit
#-d                S16: Signed 16-bit
#-d                U32: Unsigned 32-bit
#-d                S32: Signed 32-bit
#-d                U64: Unsigned 64-bit
#-d                S64: Signed 64-bit
#-d                F32: Real 32-bit
#-d                F64: Double 64-bit
#-d    6. Name-suffix of data item/asyn parameter. "ec<x>.s<y>" will be taken from the start entry. ("pos_act_b1")
#-d
#-d   \author Anders Sandström
#-d   \file
#-d   \param SLAVE_ID (optional) bus position, defaults to "ECMC_EC_SLAVE_NUM"
#-d   \param START_ENTRY
#-d   \param OFFSET_BYTE (optional) defaults to 0
#-d   \param OFFSET_BITS (optional) defaults to 0
#-d   \param DIR output==1, input==2 (optional) defaults to input == 2
#-d   \param DT  data type
#-d   \param NAME  name to be used for adressing and also suffix of PV name
#-d   \param P_SCRIPT (optional) naming convention prefix script
#-d   \param FIELDS (optional) Additional fileds for init record
#-d */

epicsEnvSet("P_SCRIPT",           "${P_SCRIPT=${ECMC_P_SCRIPT}}")

# Take first 4bits of encoder value
ecmcConfigOrDie "Cfg.EcAddDataDT(ec${MASTER_ID=${ECMC_EC_MASTER_ID=0}}.s${SLAVE_ID=${ECMC_EC_SLAVE_ID}}.${START_ENTRY},${OFFSET_BYTE=0},${OFFSET_BITS=0},${DIR=2},${DT},${NAME})"

ecmcEpicsEnvSetCalcTernary(IS_INPUT, "'${DIR}'='2'","","#-")
ecmcEpicsEnvSetCalcTernary(IS_OUTPUT, "'${DIR}'='1'","","#-")


${IS_INPUT}dbLoadRecords(./ecmcDataItemAI.db,"ECMC_P=${ECMC_P},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},M_ID=${MASTER_ID=${ECMC_EC_MASTER_ID=0}},S_ID=${SLAVE_ID=${ECMC_EC_SLAVE_ID}},sourceName=${NAME},${FIELDS=""}")
${IS_OUTPUT}dbLoadRecords(./ecmcDataItemAO.db,"ECMC_P=${ECMC_P},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},M_ID=${MASTER_ID=${ECMC_EC_MASTER_ID=0}},S_ID=${SLAVE_ID=${ECMC_EC_SLAVE_ID}},sourceName=${NAME},${FIELDS=""}")

epicsEnvUnset(IS_INPUT)
epicsEnvUnset(IS_OUTPUT)

# Add async SDO 
#ecmcConfigOrDie "Cfg.EcAddSdoAsync(${SLAVE_ID=0},${INDEX},${SUBINDEX},${DT},${NAME})"
#
## deduce what the prefix should be
#ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd",1)
#${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd" "MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},HWTYPE=${ECMC_EC_HWTYPE}"
#
##- Load SDO control and status records
#dbLoadRecords("ecmcSDOAsync.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
#
##- Load SDO value record based on datatype
#ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD_FLOAT, "'${DT}'='F32' or '${DT}'='F64' ","","#-")
#ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD_INT, "'${DT}'='F32' or '${DT}'='F64' ","#-","")
#${ECMC_EXE_CMD_INT}dbLoadRecords("ecmcSDOAsyncInt.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
#${ECMC_EXE_CMD_FLOAT}dbLoadRecords("ecmcSDOAsyncFloat.template","ECMC_P=${ECMC_P},MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${SLAVE_ID=0},NAME=${NAME},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
#epicsEnvUnset(ECMC_EXE_CMD_INT)
#epicsEnvUnset(ECMC_EXE_CMD_FLOAT)
