################################################################################
#-------------- Information:
# Description: ECMC_config startup.script
#
# by Niko Kivel, Paul Scherrer Institute, 2018
# email: niko.kivel@psi.ch
################################################################################
#
# Arguments
# [mandatory]
# SYS
#
# [optional]
# ECMC_VER          = kivel
# EthercatMC_VER    = kivel
# INIT              = initAll
# MASTER_ID         = 0
#
# [set by module]
# ECMC_CONFIG_ROOT  = $(ECMC_config_DIR)
# ECMC_CONFIG_DB    = $(ECMC_config_TEMPLATES)
# EthercatMC_DB     = $(EthercatMC_TEMPLATES)

#
# load required modules
require ecmc $(ECMC_VER=kivel)
require EthercatMC $(EthercatMC_VER=kivel)
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# $(MODULE_DIR)
# $(MODULE_TEMPLATES)
# $(MODULE_DB)
# $(EthercatMC_TEMPLATES)
# $(EthercatMC_DB)
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
require stream
#
# define default PATH for scripts and database/templates
epicsEnvSet("ECMC_CONFIG_ROOT"      "$(ECMC_config_DIR)")
epicsEnvSet("ECMC_CONFIG_DB"        "$(ECMC_config_TEMPLATES)/")
epicsEnvSet("EthercatMC_DB"         "$(EthercatMC_TEMPLATES)/")
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(STREAM_PROTOCOL_PATH=""):$(ECMC_CONFIG_ROOT)")
# define command for script execution, PSI: <3.15 runScript(), else like ESS: iocshLoad()
#epicsEnvSet("SCRIPTEXEC"      "$(SCRIPTEXEC=runScript)")
epicsEnvSet("SCRIPTEXEC"      "$(SCRIPTEXEC=iocshLoad)")
#
# define IOC Prefix
epicsEnvSet("SM_PREFIX"         "$(SYS):")    # colon added since SYS is _not_ PREFIX
# call init-script --> $(INIT)
$(SCRIPTEXEC)($(ECMC_config_DIR)$(INIT=initAll))
# add master ($(MASTER_ID))
$(SCRIPTEXEC)($(ECMC_config_DIR)addMaster.cmd, "MASTER_ID=$(MASTER_ID=0)")
