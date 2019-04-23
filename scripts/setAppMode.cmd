${SCRIPTEXEC} ${ECMC_config_DIR}general.cmd
${SCRIPTEXEC} ${ECMC_config_DIR}diagnostics.cmd

ecmcConfigOrDie "Cfg.SetAppMode(1)"
