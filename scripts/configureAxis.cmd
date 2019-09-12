#==============================================================================
# configureAxis.cmd
#- Arguments: CONFIG, DEV

#-d /**
#-d   \brief Script for adding an axis with configuration.
#-d   \details Adds an axis to the configuration and applies parameters provided by CONFIG.
#-d   \author Niko Kivel
#-d   \file
#-d   \param CONFIG configuration file, i.e. ./cfg/linear_1.pax
#-d   \param DEV device name, i.e. MOTOR1
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}configureAxis.cmd,            "CONFIG=./cfg/linear_1.pax"
#-d   \endcode
#-d   \post After all axis have been added to the bus configuration, \b applyConfig.cmd has to be called.
#-d */

epicsEnvSet("ECMC_PREFIX"      "${DEV}:")
${SCRIPTEXEC} ${CONFIG}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addAxis.cmd
#- reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")
