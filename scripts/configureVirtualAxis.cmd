#===============================================================================
# axis configuration
# Arguments
# [mandatory]
# CONFIG, i.e. axis_1
# DEV, the device name
epicsEnvSet("ECMC_PREFIX"      "${DEV}:")
${SCRIPTEXEC} ${CONFIG}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addVirtualAxis.cmd
# reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")
