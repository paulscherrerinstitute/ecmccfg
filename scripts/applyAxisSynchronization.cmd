#===============================================================================
# synchronization configuration
# Arguments
# [mandatory]
# CONFIG, i.e. axis_1_sync

${SCRIPTEXEC} ${CONFIG}

# add axis to ECMC
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc_axis_sync
