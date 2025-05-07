#==============================================================================
# setDiagnostics.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for enabling default diagnostics.
#-d   \author Niko Kivel
#-d   \file
#-d */

ecmcConfigOrDie "Cfg.EcSetDiagnostics(${DIAG=1})"
ecmcConfigOrDie "Cfg.EcEnablePrintouts(${PRINTOUT=0})"
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(${FAILEDCYCLES=100})"
