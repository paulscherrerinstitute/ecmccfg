#===============================================================================
# create PLC from file
# Arguments
# [mandatory]
# FILE
# [optional]
# PLC_ID = 0
# SKIP_CYCLES = 99
epicsEnvSet("ECMC_PLC_ID",        "$(PLC_ID=0)")
epicsEnvSet("ECMC_PLC_SKIP_CYCLES","$(SKIP_CYCLES=99)")
EthercatMCConfigController "${ECMC_MOTOR_PORT}", "Cfg.CreatePLC(${ECMC_PLC_ID},${ECMC_PLC_SKIP_CYCLES})"
EthercatMCConfigController "${ECMC_MOTOR_PORT}", "Cfg.LoadPLCFile(${ECMC_PLC_ID},$(FILE))"
