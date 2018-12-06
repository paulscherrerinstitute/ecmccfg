# Add ethercat master diagnostics
ecmcAsynPortDriverAddParameter($(ECMC_ASYN_PORT),"ec$(ECMC_EC_MASTER_ID).default","asynInt32",$(ECMC_ASYN_SKIP_CYCLES))
dbLoadRecords("$(ECMC_CONFIG_DB)/ecmcDefaultAsynParamsEc.db","P=$(ECMC_PREFIX),PORT=$(ECMC_ASYN_PORT),ADDR=0,TIMEOUT=1,MASTER_ID=$(ECMC_EC_MASTER_ID)")
#-------------------------------------------------------------------------------
