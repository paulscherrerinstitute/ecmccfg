#==============================================================================
# generalDiagnostics.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for enabling general diagnostics
#-d   \author Niko Kivel, Anders Sandstroem
#-d   \file
#-d */

ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(100)"
