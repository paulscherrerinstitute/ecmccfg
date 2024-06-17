#==============================================================================
# addEcDataItem.cmd
#-d /**
#-d   \brief Script for adding a ethercat data item.
#-d    

#-d   The ethercat data item allows for accessing alreday configured ethercat domain data in a flexible 
#-d   way by defining a start entry, byte and bit offset and data type.
#-d
#-d   \author Anders Sandström
#-d   \file
#-d   \param STRT_ENTRY_S_ID :  (optional) start entry bus position, defaults to "ECMC_EC_SLAVE_NUM"
#-d   \param STRT_ENTRY_NAME :  Name of start entry "positionActual01"
#-d   \param OFFSET_BYTE     :  (optional) Byte offset from start entry, defaults to 0
#-d   \param OFFSET_BITS     :  (optional) Bit offset from start entry, defaults to 0
#-d   \param RW              :  Read or write. Write=1, Read=2 (optional) defaults to Read == 2
#-d   \param DT              :  Data type:
#-d                                     B1:  1-bit
#-d                                     B2:  2-bits (lsb)
#-d                                     B3:  3-bits (lsb)
#-d                                     B4:  4-bits (lsb)
#-d                                     U8:  Unsigned 8-bit
#-d                                     S8:  Signed 8-bit
#-d                                     U16: Unsigned 16-bit
#-d                                     S16: Signed 16-bit
#-d                                     U32: Unsigned 32-bit
#-d                                     S32: Signed 32-bit
#-d                                     U64: Unsigned 64-bit
#-d                                     S64: Signed 64-bit
#-d                                     F32: Real 32-bit
#-d                                     F64: Double 64-bit
#-d   \param NAME            :  Name  of this data item (to be used for adressing and also suffix of PV name)
#-d   \param P_SCRIPT        :  (optional) naming convention prefix script
#-d   \param REC_FIELDS      :  (optional) Additional fileds for record
#-d   \param REC_TYPE        :  (optional) AO,AI,BI,BO,LONGIN,LONGOUT,
#-d                                        MBBI,MBBO,MBBIDIRECT,MBBODIRECT (default AI or AO depending on RW)
#-d   \param INIT_VAL        :  (optional) Value of data item
#-d   \param LOAD_RECS       :  (optional) Records will be loaded as default else set to "#-" 
#-d */

epicsEnvSet("P_SCRIPT",           "${P_SCRIPT=${ECMC_P_SCRIPT}}")

#- deduce what the prefix should be
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd" "MASTER_ID=${ECMC_EC_MASTER_ID=0},SLAVE_POS=${STRT_ENTRY_S_ID=${ECMC_EC_SLAVE_NUM}},HWTYPE=${ECMC_EC_HWTYPE=""}"

#- deduce what the prefix should be
ecmcConfigOrDie "Cfg.EcAddDataDT(ec${MASTER_ID=${ECMC_EC_MASTER_ID=0}}.s${STRT_ENTRY_S_ID=${ECMC_EC_SLAVE_NUM}}.${STRT_ENTRY_NAME},${OFFSET_BYTE=0},${OFFSET_BITS=0},${RW=2},${DT},${NAME})"

ecmcEpicsEnvSetCalcTernary(WRITE_INIT_VAL,"'${INIT_VAL=NaN}'='NaN'","#-","")
${WRITE_INIT_VAL}ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${STRT_ENTRY_S_ID=${ECMC_EC_SLAVE_NUM}},${NAME},${INIT_VAL=0})"
epicsEnvUnset(WRITE_INIT_VAL)

ecmcEpicsEnvSetCalcTernary(REC_TYPE_DEFAULT, "'${RW=2}'='1'","AO","AI")

${LOAD_RECS=}ecmcFileExist("ecmcDataItem${REC_TYPE=${REC_TYPE_DEFAULT}}.db",1,1)
${LOAD_RECS=}dbLoadRecords(ecmcDataItem${REC_TYPE=${REC_TYPE_DEFAULT}}.db,"ECMC_P=${ECMC_P},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},M_ID=${MASTER_ID=${ECMC_EC_MASTER_ID=0}},S_ID=${STRT_ENTRY_S_ID=${ECMC_EC_SLAVE_NUM}},sourceName=${NAME},${REC_FIELDS=""}")

epicsEnvUnset(REC_TYPE_DEFAULT)
