#===============================================================================
# applySlaveConfig.cmd
# Arguments: CONFIG
# apply config ${CONFIG} for ${HW_DESC} at the bus at position ${SLAVE_ID}

#-d /**
#-d   \brief Script for applying a specific slave configuration after the slave had been added manually.
#-d   \author Niko Kivel
#-d   \file
#-d   \note Example call:
#-d   \note call applySlaveConfig with CONFIG
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "CONFIG=-Motor-Nanotec-ST4118L1804-B"
#-d   \endcode
#-d */
#-d   \pre A slave has to added immediately before this script is called by \b addSlave.cmd.

${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}${CONFIG}.cmd
