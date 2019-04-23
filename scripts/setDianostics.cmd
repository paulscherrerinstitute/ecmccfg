##############################################################################
############# Configure diagnostics:

ecmcConfigOrDie "Cfg.EcSetDiagnostics(${DIAG=1})"
ecmcConfigOrDie "Cfg.EcEnablePrintouts(${PRINTOUT=0}"
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(${FAILEDCYCLES=100})"
#EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.SetDiagAxisIndex(1)"
#EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.SetDiagAxisFreq(2)"
#EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.SetDiagAxisEnable(0)"
