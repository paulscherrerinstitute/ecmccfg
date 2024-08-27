#==============================================================================
# startup.cmd
#-------------- Information:
#- Description: ecmccfg startup.script
#-
#- by Niko Kivel, Paul Scherrer Institute, 2018
#- email: niko.kivel@psi.ch
#- and Anders Sandström, ESS, 2020
#- email: anders.sandstroem@psi.ch
#-
#-###############################################################################
#-
#- Arguments
#- [mandatory]
#- SYS
#-
#- [optional]
#- ECMC_VER          = 9.5.4
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
#- TMP_DIR           = directory for temporary files
#- ENG_MODE          = 1/0. If ENG_MODE is set then PVs used for commissioning will be avaialble
#- EC_TOOL_PATH      = Path to ethercat tool defaults to ethercat tool in ECmasterECMC_DIR, 
#- otherwise            "/opt/etherlab/bin/ethercat"
#- MAX_PARAM_COUNT   = Maximum asyn param count, defaults to 1500
#-
#- [set by module]
#- ECMC_CONFIG_ROOT       = root directory of ${MODULE}
#- ECMC_CONFIG_DB         = database directory of ${MODULE}
#- EthercatMC_DB          = database directory of EthercatMC
#- ECMC_EC_MASTER_ID      =  EtherCAT master id in use (for use in later scripts)
#- ECMC_EC_SAMPLE_RATE    = EtherCAT bus sampling rate [Hz] (1000 default)
#- ECMC_EC_SAMPLE_RATE_MS = EtherCAT bus sampling rate [ms] (1 default)
#- ECMC_MODE              = ecmc mode. FULL/DAQ, Defaults to FULL
#- ECMC_PVA               = use pva, default NO
#- ECMC_SUPPORT_MOTION    = Variable to be used to block use of motion (""/empty=support motion or "#-"=disable motion)
#- ECMC_TMP_DIR           = directory for temporary files, defaults to "/tmp/${IOC}/EcMaster_${ECMC_EC_MASTER_ID}}/"
#- ECMC_EC_TOOL_PATH      = path to ethercat tool
#- ECMC_SAMPLE_RATE_MS    = current record update rate in milli seconds
#- ECMC_SAMPLE_RATE_MS_ORIGINAL = ECMC_SAMPLE_RATE_MS (used for restore to default if ECMC_SAMPLE_RATE_MS is changed)
#-
#-------------------------------------------------------------------------------
#- Halt on error (dbLoad*)
on error halt
#-
#-------------------------------------------------------------------------------
#- load required modules
epicsEnvSet(ECMC_VER,${ECMC_VER=9.5.4})
require ecmc "${ECMC_VER}"

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
#- Set max asyn param count ECMC_ASYN_PORT_MAX_PARAMS can override
epicsEnvSet("ECMC_ASYN_PORT_MAX_PARAMS",${ECMC_ASYN_PORT_MAX_PARAMS=${MAX_PARAM_COUNT=1500}})

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
epicsEnvSet(ECMC_SAMPLE_RATE_MS_ORIGINAL,${ECMC_SAMPLE_RATE_MS})

#-
#-------------------------------------------------------------------------------
#- define naming convention script
epicsEnvSet("ECMC_P_SCRIPT",        "${NAMING=mXsXXX}")

#- add master (defaults to '0'), no master when MASTER_ID < 0
ecmcEpicsEnvSetCalcTernary(ECMC_MASTER_CMD, "${MASTER_ID=0}>=0", "","#- ")
${ECMC_MASTER_CMD} ecmcFileExist("${ECMC_CONFIG_ROOT}addMaster.cmd",1)
${ECMC_MASTER_CMD} ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}addMaster.cmd", "MASTER_ID=${MASTER_ID=0}"
epicsEnvSet("ECMC_EC_MASTER_ID" ,${MASTER_ID=0})

#- Commissioning? load commissioning extra records for example controller pid params
ecmcEpicsEnvSetCalcTernary(ECMC_ENG_MODE_CMD, "${ENG_MODE=0}>0", "","#- ")
epicsEnvShow(ECMC_ENG_MODE_CMD)
epicsEnvSet(ECMC_ENG_MODE,${ENG_MODE=0})

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

# Load ecmc inforamtion into record
dbLoadRecords("ecmcMcuInfo.db","P=${SM_PREFIX},ECMC_VER=${ECMC_VER}, M_ID=${ECMC_EC_MASTER_ID}, ,MCU_NAME=${ECMC_P_SCRIPT}, M_RATE=${ECMC_EC_SAMPLE_RATE}, M_TIME=${ECMC_EC_SAMPLE_RATE_MS},PV_TIME=${ECMC_SAMPLE_RATE_MS}, MCU_MODE=${ECMC_MODE},MCU_PVA=${PVA=No},MCU_ENG=${ECMC_ENG_MODE=0}")

#-------------------------------------------------------------------------------
#- Set path to ethercat tool
#- Set default
epicsEnvSet(ECMC_EC_TOOL_PATH,{EC_TOOL_PATH="/opt/etherlab/bin/ethercat"})
#- if ECmasterECMC_DIR is defined then use ethercat tool in installed module
ecmcEpicsEnvSetCalcTernary(ECMC_USE_ECmasterECMC_DIR, "'${ECmasterECMC_DIR='empty'}'=='empty'", "#-","")
${ECMC_USE_ECmasterECMC_DIR}epicsEnvSet(ECMC_EC_TOOL_PATH, "${ECmasterECMC_DIR}bin/${EPICS_HOST_ARCH}/ethercat")
epicsEnvUnset(ECMC_USE_ECmasterECMC_DIR)

#-
#- Ensure that this command is not executed twice (ESS vs PSI)
epicsEnvSet("ECMCCFG_INIT" ,"#")

#- Ensure start of app thread and apply cfg (ESS maybe don't have the atInit command)
on error continue
ecmcFileExist("${ECMC_CONFIG_ROOT}finalize.cmd",1)
atInit "$(SCRIPTEXEC) ($(ECMC_CONFIG_ROOT)finalize.cmd)"
on error halt
