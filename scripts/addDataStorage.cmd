#===============================================================================
# create Data storage
# Arguments
# [mandatory]
# DS_SIZE  : Size of data buffer.
# [optional]
# DS_ID   = 0
# DS_TYPE = 0
#   0: Normal Buffer. Fill from beginning (index 0). Stop when full.
#   1: Ring Buffer. Fill from beginning (index 0). Start over in beginning when full.
#   2: FIFO Buffer. Fill from end (index size-1). Old values shifted out.
# SAMPLE_RATE_MS = 1
#   -1  : Update records with plc_function (ds_push_asyn())
#   0   : Update records when data storage changes.
#   1.. : Sample rate in ms.

epicsEnvSet("ECMC_STORAGE_INDEX",   "${DS_ID=0}")
epicsEnvSet("ECMC_STORAGE_SIZE",    "${DS_SIZE}")

ecmcConfigOrDie "Cfg.CreateStorage($(ECMC_STORAGE_INDEX),$(ECMC_STORAGE_SIZE),${DS_TYPE=0})"
ecmcConfigOrDie "Cfg.ClearStorage($(ECMC_STORAGE_INDEX))"
ecmcConfigOrDie "Cfg.SetStorageEnablePrintouts($(ECMC_STORAGE_INDEX),1)"

# T_SMP_MS=-1 (trigg data transfer with ds_push_asyn())
dbLoadRecords("ecmcDS.template", "P=$(ECMC_PREFIX), PORT=$(ECMC_ASYN_PORT), ADDR=$(ECMC_ASYN_ADDR), TIMEOUT=$(ECMC_ASYN_TIMEOUT),A=0,Index=$(ECMC_STORAGE_INDEX),NELM=$(ECMC_STORAGE_SIZE),T_SMP_MS=${SAMPLE_RATE_MS=1}")
