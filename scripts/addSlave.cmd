#===============================================================================
# slave config
# Arguments
# [mandatory]
# HW_DESC
# [optional]
# SLAVE_ID

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID=0}")
epicsEnvSet("HW_DESC",            "${HW_DESC}")

${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd
#default records
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}slave.cmd

NEXT_SID=${ECMC_EC_SLAVE_NUM}+1
epicsEnvSet("SLAVE_ID",           "${NEXT_SID}")
