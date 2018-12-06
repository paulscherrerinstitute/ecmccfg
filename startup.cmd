################################################################################
#-------------- Information:
# Description: ECMC_config startup.script
#
# by Niko Kivel, Paul Scherrer Institute, 2018
# email: niko.kivel@psi.ch
################################################################################
#
# Arguments
# [set by module]
# ECMC_CONFIG_ROOT  ==  $(ECMC_config_DIR)
# ECMC_CONFIG_DB    ==  $(ECMC_config_TEMPLATES)
# [mandatory]
# SYS
# [optional]
# ECMC_VER        = kivel
# EthercatMC_VER  = kivel
# INIT            = initAll
# MASTER_ID       = 0
#
# define default PATH for scripts and database/templates
epicsEnvSet("ECMC_CONFIG_ROOT"  "$(ECMC_config_DIR)")
epicsEnvSet("ECMC_CONFIG_DB"    "$(ECMC_config_TEMPLATES)")
#
# load required modules
require ecmc $(ECMC_VER=kivel)
require EthercatMC $(EthercatMC_VER=kivel)
#
# define IOC Prefix
epicsEnvSet("SM_PREFIX"         "$(SYS):")    # colon added since SYS is _not_ PREFIX
# call init-script --> $(INIT)
runScript($(ECMC_config_DIR)$(INIT=initAll))
# add master ($(MASTER_ID))
runScript($(ECMC_config_DIR)addMaster.cmd, "MASTER_ID=$(MASTER_ID=0)")
