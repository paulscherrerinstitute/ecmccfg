#==============================================================================
# configureAxis.cmd
#- Arguments: CONFIG, [DEV], [CLEAR_VARS_CMD]

#-d /**
#-d   \brief Script for adding an axis with configuration.
#-d   \details Adds an axis to the configuration and applies parameters provided by CONFIG.
#-d   \author Niko Kivel
#-d   \file
#-d   \param CONFIG configuration file, i.e. ./cfg/linear_1.pax
#-d   \param DEV (optional) device name, i.e. MOTOR1
#-d   \param CLEAR_VARS_CMD (optional) Set to "empty" for not clear env vars (if vars needed for later use).
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}configureAxis.cmd,            "CONFIG=./cfg/linear_1.pax"
#-d   \endcode
#-d   \post After all axis have been added to the bus configuration, \b applyConfig.cmd has to be called.
#-d */

#- set device name, default to ${IOC}
epicsEnvSet("ECMC_PREFIX"      "${DEV=${IOC}}:")
${SCRIPTEXEC} ${CONFIG}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addAxis.cmd
#- Clear env vars
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}${CLEAR_VARS_CMD="ecmc_axis_unset"}.cmd
#- reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")
