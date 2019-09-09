#==============================================================================
# applyAxisSynchronization.cmd
#- Arguments: CONFIG

#-d /**
#-d   \brief Script for applying axis synchronization
#-d   \details Adds synchronization parameters to an axis provided by CONFIG.
#-d   \author Niko Kivel
#-d   \file
#-d   \param CONFIG configuration file, i.e. ./cfg/linear_1.sax
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/linear_1.sax"
#-d   \endcode
#-d   \pre A physical/virtual axis has to be added/configured immediately before the call of this script.
#-d */

${SCRIPTEXEC} ${CONFIG}

#- add axis to ECMC
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc_axis_sync.cmd
