#===============================================================================
# slave config
# Arguments
# [mandatory]
# HW_DESC
# SLAVE_ID

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "$(SLAVE_ID)")

runScript($(ECMC_CONFIG_ROOT)$(HW_DESC)$(ECMC_GEN_EC_RECORDS))
#default records
runScript($(ECMC_CONFIG_ROOT)slave)
