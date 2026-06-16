#==============================================================================
# addEcSlaveAxisName.cmd
#- Arguments: EC_PATH, ROLE, AX_NAME

#-d /**
#-d   \brief Add an axis-name marker record below the slave prefix.
#-d   \details The slave id and channel id are derived from the EtherCAT link.
#-d   \file
#-d   \param EC_PATH EtherCAT entry path, for example ec0.s7.velocitySetpoint01
#-d   \param ROLE    Channel role, normally Drv or Enc
#-d   \param AX_NAME Axis name using this slave channel
#-d */

ecmcGetSlaveIdFromEcPath(${EC_PATH}, ECMC_AXNAME_SID)
ecmcGetEcEntryChannelFromEcPath(${EC_PATH}, ECMC_AXNAME_CH_ID)

ecmcIf("${ECMC_AXNAME_SID=-2}>=0 and '${ECMC_AXNAME_CH_ID=-2}'!='-2'", ECMC_AXNAME_VALID_TRUE, ECMC_AXNAME_VALID_FALSE)
${ECMC_AXNAME_VALID_TRUE}epicsEnvSet(ECMC_AXNAME_PREFIX, "${ECMC_S${ECMC_AXNAME_SID}_PREFIX=}")
${ECMC_AXNAME_VALID_TRUE}ecmcIf("'${ECMC_AXNAME_PREFIX=}'!=''", ECMC_AXNAME_PREFIX_TRUE, ECMC_AXNAME_PREFIX_FALSE)

${ECMC_AXNAME_PREFIX_TRUE}ecmcIf("'${ECMC_S${ECMC_AXNAME_SID}_${ROLE}${ECMC_AXNAME_CH_ID}_AXNAME_LOADED=0}'='0'", ECMC_AXNAME_LOAD_TRUE, ECMC_AXNAME_LOAD_FALSE)
${ECMC_AXNAME_LOAD_TRUE}ecmcFileExist("ecmcEcSlaveAxisName.template",1,1)
${ECMC_AXNAME_LOAD_TRUE}dbLoadRecords("ecmcEcSlaveAxisName.template","ECMC_P=${ECMC_AXNAME_PREFIX},ROLE=${ROLE},CH_ID=${ECMC_AXNAME_CH_ID},AX_PREFIX=${ECMC_PREFIX=},AX_NAME=${AX_NAME}")
${ECMC_AXNAME_LOAD_TRUE}epicsEnvSet(ECMC_S${ECMC_AXNAME_SID}_${ROLE}${ECMC_AXNAME_CH_ID}_AXNAME_LOADED,1)

${ECMC_AXNAME_PREFIX_TRUE}ecmcEndIf(ECMC_AXNAME_LOAD_TRUE, ECMC_AXNAME_LOAD_FALSE)
${ECMC_AXNAME_VALID_TRUE}ecmcEndIf(ECMC_AXNAME_PREFIX_TRUE, ECMC_AXNAME_PREFIX_FALSE)
ecmcEndIf(ECMC_AXNAME_VALID_TRUE, ECMC_AXNAME_VALID_FALSE)

epicsEnvUnset(ECMC_AXNAME_SID)
epicsEnvUnset(ECMC_AXNAME_CH_ID)
epicsEnvUnset(ECMC_AXNAME_PREFIX)
