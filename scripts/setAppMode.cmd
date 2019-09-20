#==============================================================================
# setAppMode.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for switching to operational mode.
#-d   \author Niko Kivel
#-d   \file
#-d */

${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}generalDiagnostics.cmd
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}general.cmd

ecmcConfigOrDie "Cfg.SetAppMode(1)"
