#===============================================================================
# slave config
# Arguments
# [mandatory]
# HW_DESC, i.e. ecmcEL5001
# SLAVE_ID
# CONFIG, i.e. -Baumer-BMMH30D1G24C1213 !!! with leading hyphen '-' !!!

epicsEnvSet("ECMC_EC_SLAVE_NUM" "${SLAVE_ID}")
epicsEnvSet("HW_DESC"           "${HW_DESC}")

${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd "SLAVE_ID=${SLAVE_ID}, HW_DESC=${HW_DESC}"

${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}${CONFIG}.cmd
