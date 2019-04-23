#===============================================================================
# create PLC from file
# Arguments
# [mandatory]
# FILE
# [optional]
# PLC_ID = 0
# SKIP_CYCLES = 99
epicsEnvSet("ECMC_PLC_ID",          "${PLC_ID=0}")
epicsEnvSet("ECMC_PLC_SKIP_CYCLES", "${SKIP_CYCLES=99}")
ecmcConfigOrDie "Cfg.CreatePLC(${ECMC_PLC_ID},${ECMC_PLC_SKIP_CYCLES})"
ecmcConfigOrDie "Cfg.LoadPLCFile(${ECMC_PLC_ID},${FILE})"
