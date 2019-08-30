#===============================================================================
# applySlaveConfig.cmd
# Arguments: CONFIG
# apply config ${CONFIG} for ${HW_DESC} at the bus at position ${SLAVE_ID}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}${CONFIG}.cmd
