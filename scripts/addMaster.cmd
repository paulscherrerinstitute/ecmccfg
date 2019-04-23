#===============================================================================
# master config
# Arguments
# [optional]
# MASTER_ID = 0

epicsEnvSet("ECMC_EC_MASTER_ID"          "${MASTER_ID=0}")
#Choose master
ecmcConfigOrDie "Cfg.EcSetMaster(${ECMC_EC_MASTER_ID})"
