#- Startup-only identity reads. Load static records from the captured values.
#- Revision and serial use existing commands; only strings need new ECMC support.
epicsEnvSet(ECMC_TEMP_SLAVE_FW,"Unknown")
epicsEnvSet(ECMC_TEMP_SLAVE_REV,"Unknown")
epicsEnvSet(ECMC_TEMP_SLAVE_SER,"Unknown")
epicsEnvSet(ECMC_TEMP_SLAVE_ID_STATUS,"Not read")
ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_FW_STATUS,"${ECMC_SDO_STRING_SUPPORTED=0}>0","Not read","Not supported")
ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_SKIP_STATUS,"${READ_IDENTITY=${ECMC_READ_SLAVE_IDENTITY=1}}=0","Disabled","")
ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_SKIP_STATUS,"${ECMC_DEV_MODE=0}>0","Development mode","${ECMC_TEMP_SLAVE_SKIP_STATUS}")
ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_SKIP_STATUS,"${ECMC_SIM=0}>0","Simulation","${ECMC_TEMP_SLAVE_SKIP_STATUS}")
ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_ID_CMD,"'${ECMC_TEMP_SLAVE_SKIP_STATUS}'=''","","#- ")
ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_ID_STATUS,"'${ECMC_TEMP_SLAVE_SKIP_STATUS}'!=''","${ECMC_TEMP_SLAVE_SKIP_STATUS}","${ECMC_TEMP_SLAVE_ID_STATUS}")
ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_FW_STATUS,"'${ECMC_TEMP_SLAVE_SKIP_STATUS}'!=''","${ECMC_TEMP_SLAVE_SKIP_STATUS}","${ECMC_TEMP_SLAVE_FW_STATUS}")

#- Conservatively suppress optional CoE reads when EtherLab discovered no SDOs.
#- This is not an authoritative mailbox flag: CoE slaves without SDO-info
#- enumeration can also report zero and will simply keep firmware as Unknown.
epicsEnvSet(ECMC_TEMP_SLAVE_SDO_READ_SUPPORT,"0")
${ECMC_TEMP_SLAVE_ID_CMD}epicsEnvSet(ECMC_CONFIG_RETURN_VAL,"Error: not read")
${ECMC_TEMP_SLAVE_ID_CMD}ecmcConfig "EcGetSlaveSdoReadSupport(${ECMC_EC_SLAVE_NUM})"
${ECMC_TEMP_SLAVE_ID_CMD}ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_SDO_READ_SUPPORT,"'Error' in '${ECMC_CONFIG_RETURN_VAL=Error}'",0,"${ECMC_CONFIG_RETURN_VAL=0}")
${ECMC_TEMP_SLAVE_ID_CMD}ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_FW_STATUS,"${ECMC_TEMP_SLAVE_SDO_READ_SUPPORT=0}=0","No discovered SDOs","${ECMC_TEMP_SLAVE_FW_STATUS}")

#- Keep a failed command from reusing the preceding slave's result.
${ECMC_TEMP_SLAVE_ID_CMD}epicsEnvSet(ECMC_CONFIG_RETURN_VAL,"Error: not read")
${ECMC_TEMP_SLAVE_ID_CMD}ecmcConfig "EcGetSlaveRevisionNum(${ECMC_EC_SLAVE_NUM})"
${ECMC_TEMP_SLAVE_ID_CMD}ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_REV_OK,"'Error' in '${ECMC_CONFIG_RETURN_VAL=0}'",0,1)
${ECMC_TEMP_SLAVE_ID_CMD}ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_NUM_CMD,"${ECMC_TEMP_SLAVE_REV_OK=0}>0","","#- ")
#- The calculator formats integer results as int32: map unsigned values into
#- its signed range first, then print the identical 32-bit hexadecimal pattern.
${ECMC_TEMP_SLAVE_ID_CMD}${ECMC_TEMP_SLAVE_NUM_CMD=#- }ecmcEpicsEnvSetCalc(ECMC_TEMP_SLAVE_REV,"${ECMC_CONFIG_RETURN_VAL=0}-4294967296*(${ECMC_CONFIG_RETURN_VAL=0}>2147483647)","0x%08x")

${ECMC_TEMP_SLAVE_ID_CMD}epicsEnvSet(ECMC_CONFIG_RETURN_VAL,"Error: not read")
${ECMC_TEMP_SLAVE_ID_CMD}ecmcConfig "EcGetSlaveSerialNum(${ECMC_EC_SLAVE_NUM})"
${ECMC_TEMP_SLAVE_ID_CMD}ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_SER_OK,"'Error' in '${ECMC_CONFIG_RETURN_VAL=0}'",0,1)
${ECMC_TEMP_SLAVE_ID_CMD}ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_NUM_CMD,"${ECMC_TEMP_SLAVE_SER_OK=0}>0","","#- ")
#- Preserve unsigned decimal text, including values above INT32_MAX and zero.
${ECMC_TEMP_SLAVE_ID_CMD}${ECMC_TEMP_SLAVE_NUM_CMD=#- }epicsEnvSet(ECMC_TEMP_SLAVE_SER,"${ECMC_CONFIG_RETURN_VAL=0}")
${ECMC_TEMP_SLAVE_ID_CMD}ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_ID_STATUS,"${ECMC_TEMP_SLAVE_REV_OK=0}>0 and ${ECMC_TEMP_SLAVE_SER_OK=0}>0","Available","Read failed")

ecmcEpicsEnvSetCalcTernary(ECMC_TEMP_SLAVE_FW_CMD,"'${ECMC_TEMP_SLAVE_SKIP_STATUS}'='' and ${ECMC_SDO_STRING_SUPPORTED=0}>0 and ${ECMC_TEMP_SLAVE_SDO_READ_SUPPORT=0}>0","","#- ")
${ECMC_TEMP_SLAVE_FW_CMD}ecmcEpicsEnvSetSdoString(ECMC_TEMP_SLAVE_SDO,${ECMC_EC_SLAVE_NUM},0x100a,0,39)
${ECMC_TEMP_SLAVE_FW_CMD}epicsEnvSet(ECMC_TEMP_SLAVE_FW,"${ECMC_TEMP_SLAVE_SDO_DB_VALUE=Unknown}")
${ECMC_TEMP_SLAVE_FW_CMD}epicsEnvSet(ECMC_TEMP_SLAVE_FW_STATUS,"${ECMC_TEMP_SLAVE_SDO_STATUS=Not read}")

${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=${ECMC_P},ECMC_G=${ECMC_G=},PARAM='HWFw=${ECMC_TEMP_SLAVE_FW},HWRev=${ECMC_TEMP_SLAVE_REV},HWSer=${ECMC_TEMP_SLAVE_SER},HWFwStat=${ECMC_TEMP_SLAVE_FW_STATUS},HWIdStat=${ECMC_TEMP_SLAVE_ID_STATUS}'"

epicsEnvUnset(ECMC_TEMP_SLAVE_FW)
epicsEnvUnset(ECMC_TEMP_SLAVE_REV)
epicsEnvUnset(ECMC_TEMP_SLAVE_SER)
epicsEnvUnset(ECMC_TEMP_SLAVE_FW_STATUS)
epicsEnvUnset(ECMC_TEMP_SLAVE_ID_STATUS)
epicsEnvUnset(ECMC_TEMP_SLAVE_SKIP_STATUS)
epicsEnvUnset(ECMC_TEMP_SLAVE_ID_CMD)
epicsEnvUnset(ECMC_TEMP_SLAVE_NUM_CMD)
epicsEnvUnset(ECMC_TEMP_SLAVE_FW_CMD)
epicsEnvUnset(ECMC_TEMP_SLAVE_REV_OK)
epicsEnvUnset(ECMC_TEMP_SLAVE_SER_OK)
epicsEnvUnset(ECMC_TEMP_SLAVE_SDO_READ_SUPPORT)
epicsEnvUnset(ECMC_TEMP_SLAVE_SDO)
epicsEnvUnset(ECMC_TEMP_SLAVE_SDO_DB_VALUE)
epicsEnvUnset(ECMC_TEMP_SLAVE_SDO_STATUS)
