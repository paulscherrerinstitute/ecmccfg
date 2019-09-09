#===============================================================================
# applyConfig.cfg
#- Arguments: n/a

#-d /**
#-d   \brief Script for applying bus configuration.
#-d   \author Niko Kivel
#-d   \file
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cfg
#-d   \endcode
#-d   \post After the bus configuration was applied, the bus must by set to appMode by calling \b setAppMode.cmd.
#-d */

ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
