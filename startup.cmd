#==============================================================================
# startup.cmd
#-------------- Information:
#- Description: ecmccfg startup.script
#-
#- by Niko Kivel, Paul Scherrer Institute, 2018
#- email: niko.kivel@psi.ch
#- and Anders Sandström, ESS, 2020
#- email: anders.sandstrom@ess.eu
#-
#-###############################################################################
#-
#- Arguments
#- [mandatory]
#- SYS
#-
#- [optional]
#- ECMC_VER          = 6.3.2
#- EthercatMC_VER    = 3.0.2
#- INIT              = initAll
#- MASTER_ID         = 0 <-- put negatuve number to disable master, aka non ec-mode
#- SCRIPTEXEC        = iocshLoad
#- EC_RATE           = 1000
#-
#- [set by module]
#- ECMC_CONFIG_ROOT    = root directory of ${MODULE}
#- ECMC_CONFIG_DB      = database directory of ${MODULE}
#- EthercatMC_DB       = database directory of EthercatMC
#- ECMC_EC_SAMPLE_RATE = EtherCAT bus sampling rate [Hz] (1000 default)
#-
#-------------------------------------------------------------------------------
#- Halt on error (dbLoad*)
on error halt
#-
#-------------------------------------------------------------------------------
#- load required modules
require ecmc        "${ECMC_VER=6.3.2}"
#- Require EthercatMC if used.
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "'${ECMC_MR_MODULE=ecmcMotorRecord}'='EthercatMC'", "require  EthercatMC ${EthercatMC_VER=3.0.2} # Using EthercatMC motor record support.","# Using ecmcMotorRecord motor record support.")
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)
#-
#-------------------------------------------------------------------------------
#- define default PATH for scripts and database/templates
epicsEnvSet("ECMC_CONFIG_ROOT",     "${ecmccfg_DIR}")
epicsEnvSet("ECMC_CONFIG_DB",       "${ecmccfg_TEMPLATES}/")
#- define command for script execution, PSI: <3.15 runScript(), else like for ESS: iocshLoad()
epicsEnvSet("SCRIPTEXEC",           "${SCRIPTEXEC=iocshLoad}")
#-
#-------------------------------------------------------------------------------
#- define IOC Prefix
epicsEnvSet("SM_PREFIX",            "${IOC}:")    # colon added since IOC is _not_ PREFIX
#-
#-------------------------------------------------------------------------------
#- define the link to a PV that should be foward-linked after EC-frame is processes
#- This is for deterministic processing of data _after_ ECMC is done
epicsEnvSet("ECMC_PROC_HOOK",       "${PROC_HOOK=''}")
#-
#-------------------------------------------------------------------------------
#- call init-script, defaults to 'initAll'
ecmcFileExist("${ECMC_CONFIG_ROOT}${INIT=initAll}.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}${INIT=initAll}.cmd"
#-
#-------------------------------------------------------------------------------
# Set EtherCAT frequency (defaults to 1000)
ecmcConfigOrDie "Cfg.SetSampleRate(${EC_RATE=1000})"
#-
#- Set current EtherCAT sample rate
#- Note: Not the same as ECMC_SAMPLE_RATE_MS which is for record update
epicsEnvSet("ECMC_EC_SAMPLE_RATE" ,${EC_RATE=1000})
#-
#-------------------------------------------------------------------------------

#- add master (defaults to '0'), no master when MASTER_ID < 0
ecmcEpicsEnvSetCalcTernary(ECMC_MASTER_CMD, "${MASTER_ID=0}>=0", "","#- ")
${ECMC_MASTER_CMD} ecmcFileExist("${ECMC_CONFIG_ROOT}addMaster.cmd",1)
${ECMC_MASTER_CMD} ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}addMaster.cmd", "MASTER_ID=${MASTER_ID=0}"
epicsEnvSet("ECMC_MASTER_ID" ,${MASTER_ID=0})

#- Set default diag params
ecmcFileExist("${ECMC_CONFIG_ROOT}setDiagnostics.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}setDiagnostics.cmd

#-
#- Ensure that this command is not executed twice (ESS vs PSI)
epicsEnvSet("ECMCCFG_INIT" ,"#")
