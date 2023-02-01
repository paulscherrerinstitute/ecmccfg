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
#- ECMC_VER          = 8
#- EthercatMC_VER    = 3.0.2 (obsolete)
#- INIT              = initAll
#- MASTER_ID         = 0 <-- put negatuve number to disable master, aka non ec-mode
#- SCRIPTEXEC        = iocshLoad
#- NAMING            = mXsXXX (default), ClassicNaming, ESSnaming
#- EC_RATE           = 1000
#- MODE              = FULL / DAQ
#-    FULL:  Init ecmc with support for both motion and DAQ (DEFAULT)
#-    DAQ:   Init ecmc with support for only daq (not motion)
#-    NO_MR: Init ecmc with support for motion (without motor record) and DAQ
#- PVA               = YES / NO
#- TMP_DIR      = directory for temporary files
#-
#- [set by module]
#- ECMC_CONFIG_ROOT       = root directory of ${MODULE}
#- ECMC_CONFIG_DB         = database directory of ${MODULE}
#- EthercatMC_DB          = database directory of EthercatMC
#- ECMC_EC_SAMPLE_RATE    = EtherCAT bus sampling rate [Hz] (1000 default)
#- ECMC_EC_SAMPLE_RATE_MS = EtherCAT bus sampling rate [ms] (1 default)
#- ECMC_MODE              = ecmc mode. FULL/DAQ, Defaults to FULL
#- ECMC_PVA               = use pva, default NO
#- ECMC_SUPPORT_MOTION    = Variable to be used to block use of motion (""/empty=support motion or "#-"=disable motion)
#- ECMC_TMP_DIR           = directory for temporary files, defaults to "/tmp/${IOC}/EcMaster_${ECMC_EC_MASTER_ID}}/"

#-
#-------------------------------------------------------------------------------
#- Halt on error (dbLoad*)
on error halt
#-
#-------------------------------------------------------------------------------
#- load required modules
require ecmc        "${ECMC_VER=8.0.0}"
#- Require EthercatMC if used.
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "'${ECMC_MR_MODULE=ecmcMotorRecord}'='EthercatMC'", "require  EthercatMC ${EthercatMC_VER=3.0.2} # Using EthercatMC motor record support.","# Using ecmcMotorRecord motor record support.")
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)
#-
#-------------------------------------------------------------------------------
#- define default PATH for scripts and database/templates
epicsEnvSet("ECMC_CONFIG_ROOT",     "${ecmccfg_DIR}")
epicsEnvSet("ECMC_CONFIG_DB",       "${ecmccfg_DB}")
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

epicsEnvSet(ECMC_MODE, ${MODE=FULL})
ecmcEpicsEnvSetCalcTernary(ECMC_SUPPORT_MOTION, "'${ECMC_MODE=FULL}'!='DAQ'","","# MODE == DAQ, DISABLING MOTION.")
epicsEnvShow(ECMC_SUPPORT_MOTION)
ecmcEpicsEnvSetCalcTernary(ECMC_USE_MOTOR_RECORD, "'${ECMC_MODE=FULL}'=='FULL'","","# MODE != FULL, DISABLING MOTOR RECORD.")
epicsEnvShow(ECMC_USE_MOTOR_RECORD)
ecmcFileExist("${ECMC_CONFIG_ROOT}${INIT=initAll}.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}${INIT=initAll}.cmd"

#-
#-------------------------------------------------------------------------------
# suffix for pva enabled scripts, templates and substitutions
ecmcEpicsEnvSetCalcTernary(ECMC_PVA, "${PVA=0}", "Pva","")

#-
#-------------------------------------------------------------------------------
# Set EtherCAT frequency (defaults to 1000)
ecmcConfigOrDie "Cfg.SetSampleRate(${EC_RATE=1000})"
#-
#- Set current EtherCAT sample rate
#- Note: Not the same as ECMC_SAMPLE_RATE_MS which is for record update
epicsEnvSet("ECMC_EC_SAMPLE_RATE" ,   ${EC_RATE=1000})
ecmcEpicsEnvSetCalc("ECMC_EC_SAMPLE_RATE_MS" ,1000/${ECMC_EC_SAMPLE_RATE=1000})

# Update records in 10ms (100Hz) for FULL MODE and in EC_RATE for DAQ mode
ecmcEpicsEnvSetCalcTernary(ECMC_SAMPLE_RATE_MS, "'${ECMC_MODE=FULL}'=='DAQ'","${ECMC_EC_SAMPLE_RATE_MS}","10")
#-
#-------------------------------------------------------------------------------
#- define naming convention script
epicsEnvSet("ECMC_P_SCRIPT",        "${NAMING=mXsXXX}")

#- add master (defaults to '0'), no master when MASTER_ID < 0
ecmcEpicsEnvSetCalcTernary(ECMC_MASTER_CMD, "${MASTER_ID=0}>=0", "","#- ")
${ECMC_MASTER_CMD} ecmcFileExist("${ECMC_CONFIG_ROOT}addMaster.cmd",1)
${ECMC_MASTER_CMD} ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}addMaster.cmd", "MASTER_ID=${MASTER_ID=0}"
epicsEnvSet("ECMC_EC_MASTER_ID" ,${MASTER_ID=0})

#-------------------------------------------------------------------------------
#- temp dir for file output
epicsEnvSet("ECMC_TMP_DIR",         "${TMP_DIR=/tmp/${IOC}/EcMaster_${ECMC_EC_MASTER_ID}}/")
system "mkdir -p ${ECMC_TMP_DIR}"

#-------------------------------------------------------------------------------
#- temp dir for file output
epicsEnvSet("ECMC_TMP_DIR",         "${TMP_DIR=/tmp/${IOC}/EcMaster_${ECMC_EC_MASTER_ID}}/")
system "mkdir -p ${ECMC_TMP_DIR}"

#-------------------------------------------------------------------------------
#- Set default diag params
ecmcFileExist("${ECMC_CONFIG_ROOT}setDiagnostics.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}setDiagnostics.cmd

#-
#- Ensure that this command is not executed twice (ESS vs PSI)
epicsEnvSet("ECMCCFG_INIT" ,"#")
