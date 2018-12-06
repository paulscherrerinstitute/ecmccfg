runScript($(ECMC_config_DIR)general)
runScript($(ECMC_config_DIR)diagnostics.cmd)

EthercatMCConfigController ${ECMC_MOTOR_PORT}, "Cfg.SetAppMode(1)"
