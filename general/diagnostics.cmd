#Add ecmc general records
ecmcAsynPortDriverAddParameter($(ECMC_ASYN_PORT),"ecmc.default","asynInt32",$(ECMC_ASYN_SKIP_CYCLES))
dbLoadRecords("$(ECMC_CONFIG_DB)/ecmcAsynControllerGeneral.db","P=$(ECMC_PREFIX),PORT=$(ECMC_ASYN_PORT),ADDR=0,TIMEOUT=1")
