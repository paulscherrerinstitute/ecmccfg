#===============================================================================
# create PLC from file
# Arguments
# [mandatory]
# FILE
# [optional]
# PLC_ID = 0
# SAMPLE_RATE_MS = 1

#Create a new PLC 0 (Motion: Direct access through variables, I/O, global var, plc enable)
epicsEnvSet("ECMC_PLC_ID",          "${PLC_ID=0}")
epicsEnvSet("ECMC_PLC_SAMPLE_RATE_MS","${SAMPLE_RATE_MS=1}") # execute in 1000Hz
ecmcConfigOrDie "Cfg.CreatePLC(${ECMC_PLC_ID},${ECMC_PLC_SAMPLE_RATE_MS})"
ecmcConfigOrDie "Cfg.LoadPLCFile(${ECMC_PLC_ID},${FILE}"
