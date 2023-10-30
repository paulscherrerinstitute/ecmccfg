#==============================================================================
# addEcDataItem.cmd
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
#-d   \param STRT_ENTRY_S_ID (optional) start entry bus position, defaults to "ECMC_EC_SLAVE_NUM"
#-d   \param STRT_ENTRY_NAME
#-d   \param OFFSET_BYTE (optional) defaults to 0
#-d   \param OFFSET_BITS (optional) defaults to 0
#-d   \param DIR output==1, input==2 (optional) defaults to input == 2
#-d   \param DT  data type
#-d   \param NAME  name to be used for adressing and also suffix of PV name
#-d   \param P_SCRIPT (optional) naming convention prefix script
#-d   \param FIELDS (optional) Additional fileds for init record
#-d   \param REC_TYPE (optional) AO,AI,BI,BO (default depends on DT)
#-d */

epicsEnvSet("P_SCRIPT",           "${P_SCRIPT=${ECMC_P_SCRIPT}}")

ecmcConfigOrDie "Cfg.EcAddDataDT(ec${MASTER_ID=${ECMC_EC_MASTER_ID=0}}.s${STRT_ENTRY_S_ID=${ECMC_EC_SLAVE_NUM}}.${STRT_ENTRY_NAME},${OFFSET_BYTE=0},${OFFSET_BITS=0},${DIR=2},${DT},${NAME})"

ecmcEpicsEnvSetCalcTernary(REC_TYPE_DEFAULT, "'${DIR}'='1'","AO","AI")

ecmcFileExist("ecmcDataItem${REC_TYPE=${REC_TYPE_DEFAULT}}.db",1,1)
dbLoadRecords(ecmcDataItem${REC_TYPE=${REC_TYPE_DEFAULT}}.db,"ECMC_P=${ECMC_P},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},M_ID=${MASTER_ID=${ECMC_EC_MASTER_ID=0}},S_ID=${STRT_ENTRY_S_ID=${ECMC_EC_SLAVE_NUM}},sourceName=${NAME},${FIELDS=""}")

epicsEnvUnset(REC_TYPE_DEFAULT)
