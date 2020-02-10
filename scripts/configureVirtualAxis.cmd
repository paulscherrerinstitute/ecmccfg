#==============================================================================
# configureVirtualAxis.cmd
#- Arguments: CONFIG, [DEV], [CLEAR_VARS_CMD]

#-d /**
#-d   \brief Script for adding a virtual axis with configuration.
#-d   \details Adds a virtual axis to the configuration and applies parameters provided by CONFIG.
#-d   \author Niko Kivel
#-d   \file
#-d   \param CONFIG configuration file, i.e. ./cfg/linear_11.vax
#-d   \param DEV (optional) device name, i.e. GAP
#-d   \param CLEAR_VARS_CMD (optional) Set to "empty" for not clear env vars (if needed vars for later use).
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}configureVirtualAxis.cmd,     "CONFIG=./cfg/linear_11.vax"
#-d   \endcode
#-d   \post After all axis have been added to the bus configuration, \b applyConfig.cmd has to be called.
#-d */

#- set device name, default to ${IOC}
epicsEnvSet("ECMC_PREFIX"      "${DEV=${IOC}}:")
${SCRIPTEXEC} ${CONFIG}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addVirtualAxis.cmd
#- Clear env vars
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}${CLEAR_VARS_CMD="ecmc_virt_axis_unset"}.cmd
# reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")
