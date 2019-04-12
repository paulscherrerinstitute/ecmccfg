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
# ECMC_VER          = 5.3
# EthercatMC_VER    = 2.1
# INIT              = initAll
# MASTER_ID         = 0
# SCRIPTEXEC        = iocshLoad
#
# [set by module]
# ECMC_CONFIG_ROOT  = root directory of ${MODULE}
# ECMC_CONFIG_DB    = database directory of ${MODULE}
# EthercatMC_DB     = database directory of EthercatMC
#
#-------------------------------------------------------------------------------
# load required modules
require ecmc        "${ECMC_VER=5.3}"
require EthercatMC  "${EthercatMC_VER=2.1}"
require stream      "${stream_VER=kivel}"
#
#-------------------------------------------------------------------------------
# define default PATH for scripts and database/templates
epicsEnvSet("ECMC_CONFIG_ROOT",     "${ECMC_config_DIR}")
epicsEnvSet("ECMC_CONFIG_DB",       "${ECMC_config_TEMPLATES}/")
epicsEnvSet("EthercatMC_DB",        "${EthercatMC_TEMPLATES}/")
epicsEnvSet("STREAM_PROTOCOL_PATH", "${STREAM_PROTOCOL_PATH=""}:${ECMC_CONFIG_ROOT}")
# define command for script execution, PSI: <3.15 runScript(), else like for ESS: iocshLoad()
epicsEnvSet("SCRIPTEXEC",           "${SCRIPTEXEC=iocshLoad}")
#
#-------------------------------------------------------------------------------
# define IOC Prefix
epicsEnvSet("SM_PREFIX",            "${IOC}:")    # colon added since IOC is _not_ PREFIX
#-------------------------------------------------------------------------------
# call init-script, defaults to 'initAll'
${SCRIPTEXEC} "${ECMC_config_DIR}${INIT=initAll}.cmd"
#
#-------------------------------------------------------------------------------
# add master (defaults to '0')
${SCRIPTEXEC} "${ECMC_config_DIR}addMaster.cmd", "MASTER_ID=${MASTER_ID=0}"
#
