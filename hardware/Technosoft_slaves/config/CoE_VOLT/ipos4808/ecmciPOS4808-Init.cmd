#-d /**
#-d   \brief hardware script for iPOS8020-Init
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d */

############################################################
############# General:
# This file is only used to download the basic setup to an technosoft drive.
# Normally this is done from Technosoft EasySetup or EasyMotion Studio.
# The setup information can be downloaded via SDO access (after parsing to ecmc format)
# Parsing tool can be found in ecmctraining/V2/startup/hardware/technosoft
# This procedure should only be needed to perform once (new drive or replacing of drive)
# Please ensure that the online cheksum corresponds to the offline checksum (see logfile printouts)
############################################################

# ECMC config
# Arguments
# [set by module]
# ECMC_CONFIG_ROOT  ==  $(ecmccfg_DIR)
# ECMC_CONFIG_DB    ==  $(ECMC_config_TEMPLATES)
# [mandatory]
# SYS
# [optional]
# ECMC_VER        = 6.0.0
# EthercatMC_VER  = 3.0.0
# INIT            = initAll
# MASTER_ID       = 0
#
# calls initAll by default, which calls init
# calls 'add_master.cmd'
#require ecmccfg develop "SYS=STEST_KN82,SCRIPTEXEC=runScript"

epicsEnvSet("IOC" ,"${IOC="IOC_TEST"}")

require ecmccfg sandst_a "MASTER_ID=1"

##############################################################################
## Config hardware:

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=6,HW_DESC=iPOS4808BX_VOLT"

# Download base config (parsed from Techosoft EasySetup configuration): Only needed first time a drive is used..
${SCRIPTEXEC} ./4808_BRUSHDC_VOLT_48V_20A_plusTML.cmd

# Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"

##############################################################################
############# Configure diagnostics:

ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(100)"

# go active
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
