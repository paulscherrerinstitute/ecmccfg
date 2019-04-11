#===============================================================================
# slave config
# Arguments
# [mandatory]
# HW_DESC
# SLAVE_ID

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID}")
epicsEnvSet("HW_DESC",            "${HW_DESC}")

${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}${HW_DESC}${ECMC_GEN_EC_RECORDS}.cmd
#default records
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}slave.cmd
