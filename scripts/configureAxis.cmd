#===============================================================================
# axis configuration
# Arguments
# [mandatory]
# CONFIG, i.e. axis_1
# DEV, the device name
epicsEnvSet("ECMC_PREFIX"      "$(DEV):")
runScript($(CONFIG))
runScript($(ECMC_CONFIG_ROOT)addAxis.cmd
# reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "$(SM_PREFIX)")
