#===============================================================================
# configureSlave.cmd
# Arguments: HW_DESC, [SLAVE_ID], CONFIG

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID=0}")
epicsEnvSet("HW_DESC",            "${HW_DESC}")
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd "SLAVE_ID=${SLAVE_ID}, HW_DESC=${HW_DESC}"
# apply config ${CONFIG} for ${HW_DESC}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}${CONFIG}.cmd
