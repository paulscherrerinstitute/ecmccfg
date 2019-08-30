#===============================================================================
# addSlave.cmd
# Arguments: HW_DESC, [SLAVE_ID]

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID=0}")
epicsEnvSet("HW_DESC",            "${HW_DESC}")
# add ${HW_DESC} to the bus at position ${SLAVE_ID}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}slave.cmd
# increment SLAVE_ID
epicsEnvSet("SLAVE_ID",           "$(${ECMC_EC_SLAVE_NUM}+1)")
