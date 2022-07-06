require ecmccfg jinja2, "ECMC_VER=master,EC_RATE=500"

${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=8, HW_DESC=EP7047-1032, CONFIG=-Motor-Owis-SM24x"
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=9, HW_DESC=EP5001, CONFIG=-Encoder-LA11D01_06_26-bit_SSI"

${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}loadYamlAxis.cmd, "FILE=cfg/clStepper.yaml"
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}loadYamlAxis.cmd, "FILE=cfg/internalCounter.yaml"

# Apply hardware configuration
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd

##############################################################################
############# Configure diagnostics:

#ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
#ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
#ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(100)"
#ecmcConfigOrDie "Cfg.SetDiagAxisIndex(1)"
#ecmcConfigOrDie "Cfg.SetDiagAxisFreq(2)"
#ecmcConfigOrDie "Cfg.SetDiagAxisEnable(1)"

# go active
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
