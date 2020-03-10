#- Commands tp execute in each loop of example ecmcForLoop.script
ecmcEpicsEnvSetCalc("TESTING",${ECMC_LOOP_IDX}*10)
epicsEnvShow("TESTING")
