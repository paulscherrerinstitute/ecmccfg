# Panel 
```
caqtdm -macro "MasterID=0,SlaveID=022,IOC=c6025a-04" ecmcEP1918_0002.ui 
caqtdm -macro "MasterID=0,SlaveID=023,IOC=c6025a-04" ecmcEP1957_0022.ui 
```

# Twinsafe project
Needs to be downloaded with twincat or twinsafe loader.

# Operation
The STD-Vars two LSB bits are linked to run and error ack.

In the example "STD-vars" has the following meaning:
* Bit 0 : Error ack
* Bit 1 : Run cmd

After a IOC start the following needs to be done:
* First set the error ack bit to 1 and the back to 0 (set STD-vars byte to 1 and then 0)
* Set run bit (set STD-vars byte to 2 or 3)
* The Cmd should then go to 54 on both slaves.
* Data is 12 on master and 0 on slave
* In the example the state of EP1918 BI03 and BI04 are mirrored on BO03 and BO04 on EP1957.

If problems then try same to acknowledge eror again.

Can take a little time before the system is operational...

If the jumper on the inputs are removed then the output goes low and data field of master is set to 0 (instead of 12)

Cycle counter is not working...

## Log
```
sandst_a@c6025a-04:/ioc/MTEST04-MTN-C6025A/ecmc_twinsafe/iocsh$ sudo iocsh startup.cmd 
/usr/local/epics/base-7.0.8/bin/deb10-x86_64/softIocPVA -D /usr/local/epics/base-7.0.8/dbd/softIocPVA.dbd /tmp/iocsh.startup.4484
# date="Tue Nov 12 16:42:58 CET 2024"
# user="root"
# IOC="c6025a-04"
# PWD="/gfa/.mounts/sls_ioc/MTEST04-MTN-C6025A/ecmc_twinsafe/iocsh"
# BASE="7.0.8"
# EPICS_HOST_ARCH="deb10-x86_64"
# SHELLBOX=""
# EPICS_CA_ADDR_LIST=""
# EPICS_DRIVER_PATH=".:bin/deb10-x86_64:bin:snl:../snl:O.7.0.8_deb10-x86_64:src/O.7.0.8_deb10-x86_64:snl/O.7.0.8_deb10-x86_64:../snl/O.7.0.8_deb10-x86_64:/ioc/modules:/work/iocBoot/R7.0.8/deb10-x86_64"
# PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/epics:/usr/local/bin:/work/iocBoot/R7.0.8/deb10-x86_64:/usr/local/epics/base-7.0.8/bin/deb10-x86_64:/usr/local/epics/base-7.0.8/../seq/bin/deb10-x86_64"
# LD_LIBRARY_PATH=""
dlload /usr/local/epics/base-7.0.8/lib/deb10-x86_64/libnt.so
dlload /usr/local/epics/base-7.0.8/lib/deb10-x86_64/libpvDatabase.so
dlload /ioc/modules/require/3.3.3/R7.0.8/lib/deb10-x86_64/librequire.so
dbLoadDatabase /ioc/modules/require/3.3.3/R7.0.8/dbd/require.dbd
require_registerRecordDeviceDriver
Loading module info records for require
require misc ifexists
Module misc version 2.17.0 found in /ioc/modules/misc/2.17.0/
Loading library /ioc/modules/misc/2.17.0/R7.0.8/lib/deb10-x86_64/libmisc.so
Loaded misc version 2.17.0
Loading dbd file /ioc/modules/misc/2.17.0/R7.0.8/dbd/misc.dbd
Calling function misc_registerRecordDeviceDriver
Loading module info records for misc
iocshLoad 'startup.cmd',''
##############################################################################
## Example config for EL7041 and EL5042
require ecmccfg twinsafe "ENG_MODE=1"
Module ecmccfg version twinsafe found in /ioc/modules/ecmccfg/twinsafe/
Loading library /ioc/modules/ecmccfg/twinsafe/R7.0.8/lib/deb10-x86_64/libecmccfg.so
Loaded ecmccfg version twinsafe
Loading dbd file /ioc/modules/ecmccfg/twinsafe/R7.0.8/dbd/ecmccfg.dbd
Calling function ecmccfg_registerRecordDeviceDriver
Loading module info records for ecmccfg
Executing /ioc/modules/ecmccfg/twinsafe/R7.0.8/startup.cmd with "ENG_MODE=1"
#==============================================================================
# startup.cmd
on error halt
epicsEnvSet(ECMC_VER,9.6.2)
require ecmc "9.6.2"
Module ecmc version 9.6.2 found in /ioc/modules/ecmc/9.6.2/
Module ecmc depends on ECmasterECMC v1.1.0
Module ECmasterECMC version v1.1.0 found in /ioc/modules/ECmasterECMC/v1.1.0/
Dependency file /ioc/modules/ECmasterECMC/v1.1.0/R7.0.8/ECmasterECMC.dep not found
Module ECmasterECMC is architecture independent
Loading module info records for ECmasterECMC
Module ecmc depends on asyn 4.45
Module asyn version 4.45.2 found in /ioc/modules/asyn/4.45.2/
Module asyn depends on calc 3.7
Module calc version 3.7.6 found in /ioc/modules/calc/3.7.6/
Loading library /ioc/modules/calc/3.7.6/R7.0.8/lib/deb10-x86_64/libcalc.so
Loaded calc version 3.7.6
Loading dbd file /ioc/modules/calc/3.7.6/R7.0.8/dbd/calc.dbd
Calling function calc_registerRecordDeviceDriver
Loading module info records for calc
Loading library /ioc/modules/asyn/4.45.2/R7.0.8/lib/deb10-x86_64/libasyn.so
Loaded asyn version 4.45.2
Loading dbd file /ioc/modules/asyn/4.45.2/R7.0.8/dbd/asyn.dbd
Calling function asyn_registerRecordDeviceDriver
Loading module info records for asyn
Module ecmc depends on motorECMC 7.0.9-ESS
Module motorECMC version 7.0.9-ESS found in /ioc/modules/motorECMC/7.0.9-ESS/
Module motorECMC depends on asyn 4.45
Module asyn version 4.45.2 already loaded
Loading library /ioc/modules/motorECMC/7.0.9-ESS/R7.0.8/lib/deb10-x86_64/libmotorECMC.so
Loaded motorECMC version 7.0.9-ESS
Loading dbd file /ioc/modules/motorECMC/7.0.9-ESS/R7.0.8/dbd/motorECMC.dbd
Calling function motorECMC_registerRecordDeviceDriver
Loading module info records for motorECMC
Module ecmc depends on ruckig 0.6
Module ruckig version 0.6.3 found in /ioc/modules/ruckig/0.6.3/
Loading library /ioc/modules/ruckig/0.6.3/R7.0.8/lib/deb10-x86_64/libruckig.so
Loaded ruckig version 0.6.3
ruckig has no dbd file
Loading module info records for ruckig
Loading library /ioc/modules/ecmc/9.6.2/R7.0.8/lib/deb10-x86_64/libecmc.so
Loaded ecmc version 9.6.2
Loading dbd file /ioc/modules/ecmc/9.6.2/R7.0.8/dbd/ecmc.dbd
Calling function ecmc_registerRecordDeviceDriver
Loading module info records for ecmc

ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "'ecmcMotorRecord'='EthercatMC'", "require  EthercatMC 3.0.2 # Using EthercatMC motor record support.","# Using ecmcMotorRecord motor record support.")
# Using ecmcMotorRecord motor record support.
epicsEnvUnset(ECMC_EXE_CMD)
epicsEnvSet("ECMC_CONFIG_ROOT",     "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/")
epicsEnvSet("ECMC_CONFIG_DB",       "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/db/")
epicsEnvSet("SCRIPTEXEC",           "iocshLoad")
epicsEnvSet("SM_PREFIX",            "c6025a-04:")    # colon added since IOC is _not_ PREFIX

epicsEnvSet("ECMC_PROC_HOOK",       "")

epicsEnvSet("ECMC_ASYN_PORT_MAX_PARAMS",1500)


epicsEnvSet(ECMC_MODE, FULL)
ecmcEpicsEnvSetCalcTernary(ECMC_SUPPORT_MOTION, "'FULL'!='DAQ'","","# MODE == DAQ, DISABLING MOTION.")
epicsEnvShow(ECMC_SUPPORT_MOTION)
ECMC_SUPPORT_MOTION=
ecmcEpicsEnvSetCalcTernary(ECMC_USE_MOTOR_RECORD, "'FULL'=='FULL'","","# MODE != FULL, DISABLING MOTOR RECORD.")
epicsEnvShow(ECMC_USE_MOTOR_RECORD)
ECMC_USE_MOTOR_RECORD=
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/initAll.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/initAll.cmd"
#==============================================================================
# initAll.cmd
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/init.cmd",1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/init.cmd
#==============================================================================
# init.cmd
epicsEnvSet("ECMC_ASYN_TIMEOUT",      1)                   # Asyn timeout
epicsEnvSet("ECMC_ASYN_ADDR",         0)                   # Asyn Address
epicsEnvSet("ECMC_MOTOR_PORT",        "NOT SET")
epicsEnvSet("ECMC_ASYN_PORT",         "NOT SET")
epicsEnvSet("ECMC_PREFIX",            "NOT SET")
epicsEnvSet("ECMC_GEN_EC_RECORDS",    "NOT SET")
epicsEnvSet("ECMC_GEN_AX_RECORDS",    "NOT SET")
epicsEnvSet("ECMC_EC_AXIS_HEALTH",    "NOT SET")
epicsEnvSet("ECMC_PLC_SAMPLE_RATE_MS", "NOT SET")
epicsEnvSet("ECMC_TSE",               0)
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/initAxis.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/initAxis.cmd"
#==============================================================================
# initAxis.cmd
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmc_axis_unset.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmc_axis_unset.cmd"
#==============================================================================
# ecmc_axis_unset.cmd
epicsEnvUnset(ECMC_AXISCONFIG)
epicsEnvUnset(ECMC_AXISFIELDINIT)
epicsEnvUnset(ECMC_PREC)
epicsEnvUnset(ECMC_EGU)
epicsEnvUnset(ECMC_DESC)
epicsEnvUnset(ECMC_R)
epicsEnvUnset(ECMC_EC_AXIS_HEALTH)
epicsEnvUnset(ECMC_MOD_RANGE)
epicsEnvUnset(ECMC_MOD_TYPE)
epicsEnvUnset(ECMC_EMERG_DECEL)
epicsEnvUnset(ECMC_VELO)
epicsEnvUnset(ECMC_ACCL)
epicsEnvUnset(ECMC_ACCS_EGU_PER_S2)
epicsEnvUnset(ECMC_HOME_VEL_TO)
epicsEnvUnset(ECMC_HOME_VEL_FRM)
epicsEnvUnset(ECMC_CNTRL_KP)
epicsEnvUnset(ECMC_CNTRL_KI)
epicsEnvUnset(ECMC_CNTRL_KD)
epicsEnvUnset(ECMC_CNTRL_KFF)
epicsEnvUnset(ECMC_EC_ENC_ACTPOS)
epicsEnvUnset(ECMC_EC_ENC_LATCHPOS)
epicsEnvUnset(ECMC_EC_ENC_LATCH_CONTROL)
epicsEnvUnset(ECMC_EC_ENC_LATCH_STATUS)
epicsEnvUnset(ECMC_HOME_LATCH_COUNT_OFFSET)
epicsEnvUnset(ECMC_ENC_SCALE_DENOM)
epicsEnvUnset(ECMC_ENC_SCALE_NUM)
epicsEnvUnset(ECMC_ENC_TYPE)
epicsEnvUnset(ECMC_ENC_BITS)
epicsEnvUnset(ECMC_ENC_ABS_BITS)
epicsEnvUnset(ECMC_ENC_ABS_OFFSET)
epicsEnvUnset(ECMC_ENC_VEL_FILTER_SIZE)
epicsEnvUnset(ECMC_ENC_POS_FILTER_SIZE)
epicsEnvUnset(ECMC_ENC_POS_FILTER_ENABLE)
epicsEnvUnset(ECMC_ENC_REF_TO_ENC_AT_STARTUP_ID)
epicsEnvUnset(ECMC_ENC_HOME_ID)
epicsEnvUnset(ECMC_ENC_PRIMARY_ID)
epicsEnvUnset(ECMC_ENC_CFG_ID)
epicsEnvUnset(ECMC_ENC_MAX_DIFF_TO_PRIM_ENC)
epicsEnvUnset(ECMC_EC_ENC_RESET)
epicsEnvUnset(ECMC_EC_ENC_ALARM_0)
epicsEnvUnset(ECMC_EC_ENC_ALARM_1)
epicsEnvUnset(ECMC_EC_ENC_ALARM_2)
epicsEnvUnset(ECMC_EC_ENC_WARNING)
epicsEnvUnset(ECMC_EC_DRV_CONTROL)
epicsEnvUnset(ECMC_EC_DRV_STATUS)
epicsEnvUnset(ECMC_EC_DRV_VELOCITY)
epicsEnvUnset(ECMC_EC_DRV_BRAKE)
epicsEnvUnset(ECMC_EC_DRV_REDUCE_TORQUE)
epicsEnvUnset(ECMC_EC_DRV_RESET)
epicsEnvUnset(ECMC_EC_DRV_ALARM_0)
epicsEnvUnset(ECMC_EC_DRV_ALARM_1)
epicsEnvUnset(ECMC_EC_DRV_ALARM_2)
epicsEnvUnset(ECMC_EC_DRV_WARNING)
epicsEnvUnset(ECMC_EC_ENC_READY)
epicsEnvUnset(ECMC_DRV_SCALE_DENOM)
epicsEnvUnset(ECMC_DRV_SCALE_NUM)
epicsEnvUnset(ECMC_DRV_BRAKE_OPEN_DLY_TIME)
epicsEnvUnset(ECMC_DRV_BRAKE_CLOSE_AHEAD_TIME)
epicsEnvUnset(ECMC_DXLM_ENABLE)
epicsEnvUnset(ECMC_EC_MON_LOWLIM)
epicsEnvUnset(ECMC_EC_MON_HIGHLIM)
epicsEnvUnset(ECMC_EC_MON_HOME_SWITCH)
epicsEnvUnset(ECMC_EC_MON_EXT_INTERLOCK)
epicsEnvUnset(ECMC_MON_AT_TARGET_TOL)
epicsEnvUnset(ECMC_MON_AT_TARGET_TIME)
epicsEnvUnset(ECMC_MON_AT_TARGET_ENA)
epicsEnvUnset(ECMC_MON_LAG_MON_TOL)
epicsEnvUnset(ECMC_MON_LAG_MON_TIME)
epicsEnvUnset(ECMC_MON_LAG_MON_ENA)
epicsEnvUnset(ECMC_MON_VELO_MAX)
epicsEnvUnset(ECMC_MON_VELO_MAX_ENA)
epicsEnvUnset(ECMC_MON_VELO_MAX_DRV_TIME)
epicsEnvUnset(ECMC_MON_VELO_MAX_TRAJ_TIME)
epicsEnvUnset(ECMC_JOG_VEL)
epicsEnvUnset(ECMC_JAR)
epicsEnvUnset(ECMC_HOME_PROC)
epicsEnvUnset(ECMC_HOME_POS)
epicsEnvUnset(ECMC_HOME_ACC)
epicsEnvUnset(ECMC_DRV_TYPE)
epicsEnvUnset(ECMC_SOFT_LOW_LIM)
epicsEnvUnset(ECMC_SOFT_HIGH_LIM)
epicsEnvUnset(ECMC_HOME_POS_MOVE_ENA)
epicsEnvUnset(ECMC_HOME_POS_MOVE_TARG_POS)
epicsEnvUnset(ECMC_TRAJ_TYPE)
epicsEnvUnset(ECMC_JERK)
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmc_axis_sync_unset.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmc_axis_sync_unset.cmd"
#==============================================================================
# ecmc_axis_sync_unset.cmd
epicsEnvUnset(ECMC_CMD_FRM_OTHER_PLC_ENABLE)
epicsEnvUnset(ECMC_CMD_AXIS_PLC_ENABLE)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_1)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_2)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_3)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_4)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_5)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_6)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_7)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_8)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_9)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_10)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_11)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_12)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_13)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_14)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_15)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_16)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_17)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_18)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_19)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_20)
epicsEnvUnset(ECMC_ENC_VELO_FILT_SIZE)
epicsEnvUnset(ECMC_ENC_VELO_FILT_ENABLE)
epicsEnvUnset(ECMC_ENC_SOURCE)
epicsEnvUnset(ECMC_TRAJ_VELO_FILT_SIZE)
epicsEnvUnset(ECMC_TRAJ_VELO_FILT_ENABLE)
epicsEnvUnset(ECMC_TRAJ_SOURCE)
############################################################
############# ASYN Configuration:
epicsEnvSet("ECMC_MOTOR_PORT"     "MCU1")
epicsEnvSet("ECMC_ASYN_PORT"      "MC_CPU1")
epicsEnvSet("ECMC_PREFIX"         "c6025a-04:")
ecmcAsynPortDriverConfigure(MC_CPU1,1500,0,0,100)
ecmcAsynPortDriverConfigure: portName = MC_CPU1, paramTableSize = 1500, disableAutoConnect = 0, priority = 0, defaultSampleRateMS = 100.000000
asynOctetSetOutputEos(MC_CPU1, -1, ";\n")
asynOctetSetInputEos(MC_CPU1, -1, ";\n")
asynSetTraceMask(MC_CPU1, -1, 0x41)
asynSetTraceIOMask(MC_CPU1, -1, 6)
asynSetTraceInfoMask(MC_CPU1, -1, 1)
ecmcMotorRecordCreateController(MCU1, MC_CPU1, "64", 200, 1000, "")
############################################################
############# Misc settings:
# Disable function call trace printouts
ecmcConfigOrDie "Cfg.SetEnableFuncCallDiag(0)"
2024/11/12 16:42:58.374 
ECMC Initializes.............
2024/11/12 16:42:58.374 ESS Open Source EtherCAT Motion Control Epics Module2024/11/12 16:42:58.374 
Mode: Configuration
SEM object created: 0x7f0ee2c65000.
OK
# Disable on change printouts from objects (enable for easy logging)
ecmcConfigOrDie "Cfg.SetTraceMaskBit(15,0)"
OK
# Choose to generate EPICS-records for EtherCAT-entries
# (For records use ECMC_GEN_EC_RECORDS="-records" otherwise ECMC_GEN_EC_RECORDS="")
epicsEnvSet("ECMC_GEN_EC_RECORDS",          "-records")
# Choose to generate EPICS-records for ax-entries (PosAct, SetPos,..)
# (For records use ECMC_GEN_AX_RECORDS="-records" otherwise ECMC_GEN_AX_RECORDS="")
epicsEnvSet("ECMC_GEN_AX_RECORDS",          "-records")

# suffix for pva enabled scripts, templates and substitutions
ecmcEpicsEnvSetCalcTernary(ECMC_PVA, "0", "Pva","")

# Set EtherCAT frequency (defaults to 1000)
ecmcConfigOrDie "Cfg.SetSampleRate(1000)"
OK
epicsEnvSet("ECMC_EC_SAMPLE_RATE" ,   1000)
ecmcEpicsEnvSetCalc("ECMC_EC_SAMPLE_RATE_MS" ,1000/1000)

# Update records in 10ms (100Hz) for FULL MODE and in EC_RATE for DAQ mode
ecmcEpicsEnvSetCalcTernary(ECMC_SAMPLE_RATE_MS, "'FULL'=='DAQ'","1","10")
epicsEnvSet(ECMC_SAMPLE_RATE_MS_ORIGINAL,10)

epicsEnvSet("ECMC_P_SCRIPT",        "mXsXXX")

ecmcEpicsEnvSetCalcTernary(ECMC_MASTER_CMD, "0>=0", "","#- ")
 ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/addMaster.cmd",1)
 iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/addMaster.cmd", "MASTER_ID=0"
#===============================================================================
# addMaster.cfg
epicsEnvSet("ECMC_EC_MASTER_ID"          "0")
# Claim master
ecmcConfigOrDie "Cfg.EcSetMaster(0)"
OK
epicsEnvSet("ECMC_EC_MASTER_ID" ,0)

ecmcEpicsEnvSetCalcTernary(ECMC_ENG_MODE_CMD, "1>0", "","#- ")
epicsEnvShow(ECMC_ENG_MODE_CMD)
ECMC_ENG_MODE_CMD=
epicsEnvSet(ECMC_ENG_MODE,1)

epicsEnvSet("ECMC_TMP_DIR",         "/tmp/c6025a-04/EcMaster_0/")
system "mkdir -p /tmp/c6025a-04/EcMaster_0/"

epicsEnvSet("ECMC_TMP_DIR",         "/tmp/c6025a-04/EcMaster_0/")
system "mkdir -p /tmp/c6025a-04/EcMaster_0/"

ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/setDiagnostics.cmd",1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/setDiagnostics.cmd
#==============================================================================
# setDiagnostics.cmd
ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
OK
ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
OK
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(100)"
OK

# Load ecmc inforamtion into record
dbLoadRecords("ecmcMcuInfo.db","P=c6025a-04:,ECMC_VER=9.6.2, M_ID=0, ,MCU_NAME=mXsXXX, M_RATE=1000, M_TIME=1,PV_TIME=10, MCU_MODE=FULL,MCU_PVA=No,MCU_ENG=1")

ecmcFileExist(ecmcAxFirstAxis.db,1,1)
dbLoadRecords(ecmcAxFirstAxis.db,"P=c6025a-04:")

ecmcFileExist(ecmcEcFirstSlave.db,1,1)
dbLoadRecords(ecmcEcFirstSlave.db,"P=c6025a-04:")

ecmcFileExist(ecmcPlcFirstPlc.db,1,1)
dbLoadRecords(ecmcPlcFirstPlc.db,"P=c6025a-04:")

ecmcFileExist(ecmcPlgFirstPlg.db,1,1)
dbLoadRecords(ecmcPlgFirstPlg.db,"P=c6025a-04:")

ecmcFileExist(ecmcDsFirstDs.db,1,1)
dbLoadRecords(ecmcDsFirstDs.db,"P=c6025a-04:")

epicsEnvSet(ECMC_EC_TOOL_PATH,{EC_TOOL_PATH="/opt/etherlab/bin/ethercat"})
ecmcEpicsEnvSetCalcTernary(ECMC_USE_ECmasterECMC_DIR, "'/gfa/.mounts/sls_ioc/modules/ECmasterECMC/v1.1.0/R7.0.8/'=='empty'", "#-","")
epicsEnvSet(ECMC_EC_TOOL_PATH, "/gfa/.mounts/sls_ioc/modules/ECmasterECMC/v1.1.0/R7.0.8/bin/deb10-x86_64/ethercat")
epicsEnvUnset(ECMC_USE_ECmasterECMC_DIR)

epicsEnvSet("ECMCCFG_INIT" ,"#")

on error continue
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/finalize.cmd",1)
atInit "iocshLoad (/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/finalize.cmd)"
on error halt
Done with /ioc/modules/ecmccfg/twinsafe/R7.0.8/startup.cmd
require ecmccomp
Module ecmccomp version 0.1.18 found in /ioc/modules/ecmccomp/0.1.18/
Module ecmccomp has no library
Loading module info records for ecmccomp
Executing /ioc/modules/ecmccomp/0.1.18/R7.0.8/startup.cmd
#==============================================================================
# startup.cmd

epicsEnvSet(ECMC_COMP_SUBST_OLD_S_ID,-2)
Done with /ioc/modules/ecmccomp/0.1.18/R7.0.8/startup.cmd
# 22  0:22  PREOP  +  EP1918, 8K. Safety Eingang 24V, TwinSAFE
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/addSlave.cmd,         "SLAVE_ID=22,HW_DESC=EP1918-0002_ASM"
#==============================================================================
# addSlave.cmd
ecmcIf("'NAN'!='NAN' and 0!=1")
ecmcEndIf()
epicsEnvUnset(ECMC_HW_PANEL)
epicsEnvSet("ECMC_EC_SLAVE_NUM",  "22")
epicsEnvSet("HW_DESC",            "EP1918-0002_ASM")
epicsEnvSet("P_SCRIPT",           "mXsXXX")
epicsEnvUnset(ECMC_EC_COMP_TYPE)
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmcEP1918-0002_ASM.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmcEP1918-0002_ASM.cmd" "NELM=1"
epicsEnvSet("ECMC_EC_HWTYPE",        "EP1918-0002_ASM")
epicsEnvSet("ECMC_EC_VENDOR_ID",     "0x00000002")
epicsEnvSet("ECMC_EC_PRODUCT_ID",    "0x077e4052")
ecmcFileExist(/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/slaveVerify.cmd,0)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/slaveVerify.cmd
ecmcEpicsEnvSetCalcTernary(SLAVE_VERIFY, "0==0","","#- ")
ecmcConfigOrDie "Cfg.EcSlaveVerify(0,22,0x00000002,0x077e4052)"
OK
ecmcEpicsEnvSetCalcTernary(SLAVE_RESET, "0>0","","#- ")
epicsEnvSet(ECMC_EC_SLAVE_FW, "0x0000")
ecmcEpicsEnvSetCalcTernary(SLAVE_FW, "0>0","","#- ")
epicsEnvUnset(SLAVE_VERIFY)
epicsEnvUnset(SLAVE_RESET)
epicsEnvUnset(SLAVE_FW)
#***************** OUTPUTS FROM MASTER
# FSoE_Command
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,1,2,0x1600,0x7040,0x01,U8,fsoe_cmd_out_01)"
OK
# FSoE Data
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,1,2,0x1600,0x7002,0x01,U8,fsoe_data_out_01)"
OK
# FSoE CRC
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,1,2,0x1600,0x7040,0x03,U16,fsoe_crc_out_01)"
OK
# FSoE ConnectionID
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,1,2,0x1600,0x7040,0x02,U16,fsoe_conn_id_out_01)"
OK
# Standard in var 1 and 4 
#ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0xf788,0x00,U8,std_vars_out_01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,1,2,0x17f0,0x6000,0x01,U8,std_vars_out_01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,1,2,0x17ff,0x0000,0x00,U16,fsoe_logic_out_01)"
OK
#***************** INPUTS TO MASTER
# FSoE Command
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,2,3,0x1a00,0x6040,0x01,U8,fsoe_cmd_in_01)"
OK
# FSoE Data: Module 1 Channel 1/2 Input, Module Fault
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,2,3,0x1a00,0x6041,0x01,U8,fsoe_data_in_01)"
OK
# FSoE CRC
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,2,3,0x1a00,0x6040,0x03,U16,fsoe_crc_in_01)"
OK
# FSoE Connection ID
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,2,3,0x1a00,0x6040,0x02,U16,fsoe_conn_id_in_01)"
OK
# FSoE Device Status: SafeLogicState and CycleCounter
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,2,3,0x1bff,0xf100,0x01,U8,fsoe_state_in_01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(22,0x00000002,0x077e4052,2,3,0x1bff,0xf100,0x02,U8,fsoe_cycle_counter_in_01)"
OK
epicsEnvSet("ECMC_HW_PANEL"              "EP1918-0002")
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmcmXsXXX.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmcmXsXXX.cmd" "MASTER_ID=0,SLAVE_POS=22,HWTYPE=EP1918-0002_ASM"
#==============================================================================
# ecmcmXsXXX.cmd
ecmcEpicsEnvSetCalc("sid", "22","%03d")
ecmcEpicsEnvSetCalc("mid", "0","%01d")
epicsEnvSet("ECMC_G",            "c6025a-04:m0s022")
epicsEnvSet("ECMC_P",            "c6025a-04:m0s022-")
epicsEnvUnset(sid)
epicsEnvUnset(mid)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SUBS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/applySubstitutions.cmd" "SUBST_FILE=ecmcEP1918-0002_ASM.substitutions,ECMC_P=c6025a-04:m0s022-"
#==============================================================================
# applySubstitutions.cmd
ecmcFileExist(ecmcEP1918-0002_ASM.substitutions,1,1)
dbLoadTemplate(ecmcEP1918-0002_ASM.substitutions,"ECMC_P=c6025a-04:m0s022-,ECMC_G=c6025a-04:m0s022,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=22,HWTYPE=EP1918-0002_ASM,T_SMP_MS=10,TSE=0,NELM=1")
epicsEnvUnset(DEFAULT_SUBS)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SLAVE_PVS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=c6025a-04:m0s022-,ECMC_G=c6025a-04:m0s022"
#==============================================================================
# applyTemplate.cmd
ecmcFileExist(ecmcEcSlave.template,1,1)
dbLoadRecords("ecmcEcSlave.template", "ECMC_P=c6025a-04:m0s022-,ECMC_G=c6025a-04:m0s022,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=22,HWTYPE=EP1918-0002_ASM,T_SMP_MS=10,TSE=0,, PREV_SLAVE_NUM=-1,PANEL=EP1918-0002")
epicsEnvUnset(DEFAULT_SLAVE_PVS)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_SLV,"-1>=0", "","#- ")
epicsEnvUnset(ECMC_EXE_NEXT_SLV)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_SLAVE,"-1<0", "","#- ")
dbLoadRecords(ecmcEcFirstSlave.db,"P=c6025a-04:,FIRST_SLAVE_ID=22")
epicsEnvUnset(ECMC_EXE_FIRST_SLAVE)
epicsEnvSet(ECMC_PREV_ECMC_P,c6025a-04:m0s022-)
epicsEnvSet(ECMC_EC_PREV_SLAVE_NUM,22)
# increment SLAVE_ID
ecmcEpicsEnvSetCalc("SLAVE_ID", "22+1","%d")
ecmcEpicsEnvSetCalc(ECMC_ECSLAVE_COUNT, "0+1")
# 23  0:23  PREOP  +  EP1957, 8Ch. Safety Input 24V, 4Ch. Safety Output 24V, 0.5A, Tw
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/addSlave.cmd,         "HW_DESC=EP1957-0022_ASM"
#==============================================================================
# addSlave.cmd
ecmcIf("'NAN'!='NAN' and 0!=1")
ecmcEndIf()
epicsEnvUnset(ECMC_HW_PANEL)
epicsEnvSet("ECMC_EC_SLAVE_NUM",  "23")
epicsEnvSet("HW_DESC",            "EP1957-0022_ASM")
epicsEnvSet("P_SCRIPT",           "mXsXXX")
epicsEnvUnset(ECMC_EC_COMP_TYPE)
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmcEP1957-0022_ASM.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmcEP1957-0022_ASM.cmd" "NELM=1"
epicsEnvSet("ECMC_EC_HWTYPE",        "EP1957-0022_ASM")
epicsEnvSet("ECMC_EC_VENDOR_ID",     "0x00000002")
epicsEnvSet("ECMC_EC_PRODUCT_ID",    "0x07a54052")
ecmcFileExist(/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/slaveVerify.cmd,1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/slaveVerify.cmd
ecmcEpicsEnvSetCalcTernary(SLAVE_VERIFY, "0==0","","#- ")
ecmcConfigOrDie "Cfg.EcSlaveVerify(0,23,0x00000002,0x07a54052)"
OK
ecmcEpicsEnvSetCalcTernary(SLAVE_RESET, "0>0","","#- ")
epicsEnvSet(ECMC_EC_SLAVE_FW, "0x0000")
ecmcEpicsEnvSetCalcTernary(SLAVE_FW, "0>0","","#- ")
epicsEnvUnset(SLAVE_VERIFY)
epicsEnvUnset(SLAVE_RESET)
epicsEnvUnset(SLAVE_FW)
#***************** OUTPUTS FROM MASTER
# FSoE_Command
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,1,2,0x1600,0x7080,0x01,U8,fsoe_cmd_out_01)"
OK
# FSoE Data
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,1,2,0x1600,0x7081,0x01,U8,fsoe_data_out_01)"
OK
# FSoE CRC
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,1,2,0x1600,0x7080,0x03,U16,fsoe_crc_out_01)"
OK
# FSoE ConnectionID
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,1,2,0x1600,0x7080,0x02,U16,fsoe_conn_id_out_01)"
OK
# Standard in var 1 and 4 
#ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0xf788,0x00,U8,std_vars_out_01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,1,2,0x17f0,0x6000,0x01,U8,std_vars_out_01)"
OK
# logic out
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,1,2,0x17ff,0x0000,0x00,U16,fsoe_logic_out_01)"
OK
#***************** INPUTS TO MASTER
# FSoE Command
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,2,3,0x1a00,0x6040,0x01,U8,fsoe_cmd_in_01)"
OK
# FSoE Data: Module 1 Channel 1/2 Input, Module Fault
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,2,3,0x1a00,0x6041,0x01,U8,fsoe_data_in_01)"
OK
# FSoE CRC
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,2,3,0x1a00,0x6040,0x03,U16,fsoe_crc_in_01)"
OK
# FSoE Connection ID
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,2,3,0x1a00,0x6040,0x02,U16,fsoe_conn_id_in_01)"
OK
# Field voltage status
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,2,3,0x1bfe,0xf6c0,0x01,U8,volt_stat_in_01)"
OK
# FSoE Device Status: SafeLogicState and CycleCounter
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,2,3,0x1bff,0xf100,0x01,U8,fsoe_state_in_01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(23,0x00000002,0x07a54052,2,3,0x1bff,0xf100,0x02,U8,fsoe_cycle_counter_in_01)"
OK
epicsEnvSet("ECMC_HW_PANEL"              "EP1957-0022")
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmcmXsXXX.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/ecmcmXsXXX.cmd" "MASTER_ID=0,SLAVE_POS=23,HWTYPE=EP1957-0022_ASM"
#==============================================================================
# ecmcmXsXXX.cmd
ecmcEpicsEnvSetCalc("sid", "23","%03d")
ecmcEpicsEnvSetCalc("mid", "0","%01d")
epicsEnvSet("ECMC_G",            "c6025a-04:m0s023")
epicsEnvSet("ECMC_P",            "c6025a-04:m0s023-")
epicsEnvUnset(sid)
epicsEnvUnset(mid)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SUBS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/applySubstitutions.cmd" "SUBST_FILE=ecmcEP1957-0022_ASM.substitutions,ECMC_P=c6025a-04:m0s023-"
#==============================================================================
# applySubstitutions.cmd
ecmcFileExist(ecmcEP1957-0022_ASM.substitutions,1,1)
dbLoadTemplate(ecmcEP1957-0022_ASM.substitutions,"ECMC_P=c6025a-04:m0s023-,ECMC_G=c6025a-04:m0s023,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=23,HWTYPE=EP1957-0022_ASM,T_SMP_MS=10,TSE=0,NELM=1")
epicsEnvUnset(DEFAULT_SUBS)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SLAVE_PVS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=c6025a-04:m0s023-,ECMC_G=c6025a-04:m0s023"
#==============================================================================
# applyTemplate.cmd
ecmcFileExist(ecmcEcSlave.template,1,1)
dbLoadRecords("ecmcEcSlave.template", "ECMC_P=c6025a-04:m0s023-,ECMC_G=c6025a-04:m0s023,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=23,HWTYPE=EP1957-0022_ASM,T_SMP_MS=10,TSE=0,, PREV_SLAVE_NUM=22,PANEL=EP1957-0022")
epicsEnvUnset(DEFAULT_SLAVE_PVS)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_SLV,"22>=0", "","#- ")
dbLoadRecords(ecmcEcPrevSlave.db,"NEXT_SLAVE_ID=23,PREV_ECMC_P=c6025a-04:m0s022-")
epicsEnvUnset(ECMC_EXE_NEXT_SLV)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_SLAVE,"22<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_SLAVE)
epicsEnvSet(ECMC_PREV_ECMC_P,c6025a-04:m0s023-)
epicsEnvSet(ECMC_EC_PREV_SLAVE_NUM,23)
# increment SLAVE_ID
ecmcEpicsEnvSetCalc("SLAVE_ID", "23+1","%d")
ecmcEpicsEnvSetCalc(ECMC_ECSLAVE_COUNT, "1+1")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/loadPLCFile.cmd,      "FILE=cfg/safe.plc"
#==============================================================================
# loadPLCFile.cmd
epicsEnvSet("ECMC_PLC_ID",              "0")
ecmcEpicsEnvSetCalc(ECMC_PLC_RATE_, "1000/1000", "%f")
epicsEnvSet("ECMC_PLC_SAMPLE_RATE_MS",  "0")
ecmcEpicsEnvSetCalcTernary(ECMC_PLC_SAMPLE_RATE_MS, "0>0", "0","1.000000")
epicsEnvUnset(ECMC_PLC_RATE_) # clean up, temp variable
epicsEnvSet("ECMC_TMP_FILE",            "/tmp/PLC0.plc")
epicsEnvSet("PLC_MACROS",              "SELF_ID=0, SELF='plc0', M_ID=0, M='ec0', ")
ecmcFileExist("cfg/safe.plc",1)
system "msi -I . -V -M 'SELF_ID=0, SELF=plc0, M_ID=0, M=ec0, ' -o /tmp/PLC0.plc cfg/safe.plc"
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, 1=1,"", "#-"  )
########### Parsed PLC file:
system "cat /tmp/PLC0.plc"
#
# Macros:  
#  SAF_M : Safety master index (EL1918)
#  SAF_S : Safety slave index  (EP1957)
#

# Slave <-> Master
ec0.s22.fsoe_cmd_out_01:=ec0.s23.fsoe_cmd_in_01
ec0.s22.fsoe_data_out_01:=ec0.s23.fsoe_data_in_01
ec0.s22.fsoe_crc_out_01:=ec0.s23.fsoe_crc_in_01
ec0.s22.fsoe_conn_id_out_01:=ec0.s23.fsoe_conn_id_in_01

# Master <-> Slave
ec0.s23.fsoe_cmd_out_01:=ec0.s22.fsoe_cmd_in_01
ec0.s23.fsoe_data_out_01:=ec0.s22.fsoe_data_in_01
ec0.s23.fsoe_crc_out_01:=ec0.s22.fsoe_crc_in_01
ec0.s23.fsoe_conn_id_out_01:=ec0.s22.fsoe_conn_id_in_01

############ PLC file end
#
epicsEnvUnset(ECMC_EXE_CMD)
ecmcFileExist("/tmp/PLC0.plc",1)
ecmcConfigOrDie "Cfg.CreatePLC(0,1.000000)"
OK
ecmcConfigOrDie "Cfg.LoadPLCFile(0,/tmp/PLC0.plc)"
OK
system "rm -f /tmp/PLC0.plc"
ecmcFileExist(ecmcPlc.substitutions,1,1)
ecmcEpicsEnvSetCalc(ECMC_PLC_ID_2_CHARS, "0", "%02d")
dbLoadTemplate(ecmcPlc.substitutions, "PORT=MC_CPU1,A=0,P=c6025a-04:,Index=0,Name=c6025a-04:,Index2Char=00,T_SMP_MS=10,PREV_OBJ_ID=-1, DESC='PLC_0'")
epicsEnvUnset(ECMC_PLC_ID_2_CHARS)
# Do not set NxtObj "pointer" if this is the first PLC (ECMC_PREV_PLC_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_PLC,"-1>=0", "","#- ")
epicsEnvUnset(ECMC_EXE_NEXT_PLC)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_PLC,"-1<0", "","#- ")
ecmcFileExist(ecmcPlcFirstPlc.db,1,1)
dbLoadRecords(ecmcPlcFirstPlc.db,"P=c6025a-04:,FIRST_OBJ_ID=0")
epicsEnvUnset(ECMC_EXE_FIRST_PLC)
epicsEnvSet(ECMC_PREV_PLC_P,"c6025a-04:MCU-Cfg-PLC0-")
epicsEnvSet(ECMC_PREV_PLC_OBJ_ID,0)
ecmcEpicsEnvSetCalc(ECMC_PLC_COUNT, "0+1")
ecmcEpicsEnvSetCalc("PLC_ID", "0+1","%d")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/applyConfig.cmd
#===============================================================================
# applyConfig.cfg
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
OK
epicsEnvSet(ECMC_EC_APPLY_CFG_DONE,1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/setAppMode.cmd
#==============================================================================
# setAppMode.cmd
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/general.cmd",1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/general.cmd
#==============================================================================
# general.cmd
ecmcFileExist("ecmcGeneral.db",1,1)
dbLoadRecords("ecmcGeneral.db","P=c6025a-04:,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,ECMC_PROC_HOOK=")
ecmcFileExist("ecmcMcuInfoLast.db",1,1)
dbLoadRecords("ecmcMcuInfoLast.db","P=c6025a-04:,AXIS_COUNT=0,PLC_COUNT=1,PLUGIN_COUNT=0,DS_COUNT=0,ECDOMAIN_COUNT=1,ECSLAVE_COUNT=2")
# Examples of commands for info:
# ecmcReport <level> or asynReport <level>
# ecmcReport 3
# ecmcGrepParam <pattern>
# List all ecmc params for ethercat slave 2:
# ecmcGrepParam *s2*
#
ecmcEpicsEnvSetCalcTernary(ECMC_MASTER_CMD, "0>=0", "","#- ")
 ecmcFileExist("ecmcEc.db",1,1)
 dbLoadRecords("ecmcEc.db","P=c6025a-04:,ECMC_EC_MP=m,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,T_SMP_MS=10,TSE=0")
ecmcConfigOrDie "Cfg.SetAppMode(1)"
2024/11/12 16:43:00.127 EtherCAT bus ready (not scaning).
2024/11/12 16:43:00.132 INFO: Locking memory
2024/11/12 16:43:00.158 Starting up EtherCAT bus: 0 second(s). Max wait time 30 second(s).
2024/11/12 16:43:00.228 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:380: ERROR: Slave 22: Not operational (0x24011).
2024/11/12 16:43:00.228 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:385: ERROR_EC_SLAVE_NOT_OPERATIONAL (0x24011).
2024/11/12 16:43:00.228 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:380: ERROR: Slave 23: Not operational (0x24011).
2024/11/12 16:43:00.228 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:385: ERROR_EC_SLAVE_NOT_OPERATIONAL (0x24011).
2024/11/12 16:43:00.532 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:124: NO_ERROR (0x0).
2024/11/12 16:43:02.158 EtherCAT bus started!
OK
epicsEnvSet(ECMC_SET_APP_MODE_DONE,1)
iocInit
Starting iocInit
iocshLoad (/gfa/.mounts/sls_ioc/modules/ecmccfg/twinsafe/R7.0.8/finalize.cmd)
#==============================================================================
# finalize.cmd
ecmcIf("0==1")
ecmcEndIf()
epicsEnvUnset(ECMC_OVERRIDE_FINALIZE)
ecmcIf("1!=1")
ecmcEndIf()
epicsEnvUnset(ECMC_EC_APPLY_CFG_DONE)
ecmcIf("1!=1")
ecmcEndIf()
epicsEnvUnset(ECMC_SET_APP_MODE_DONE)
############################################################################
## EPICS R7.0.8.2-DEV-2024-09-06
## Rev. PSI-7.0.8.2-1-0-g52b349608
## Rev. Date Git: 2024-09-06 16:55:30 +0200
############################################################################
2024/11/12 16:43:02.197 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s22.fsoe_cycle_counter_01 not found (drvInfo=T_SMP_MS=10/TYPE=asynUInt32Digital/ec0.s22.fsoe_cycle_counter_01?).
c6025a-04:m0s022-FSoE-CycCntIn01 devAsynUInt32Digital::initCommon drvUserCreate 
2024/11/12 16:43:02.201 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s23.fsoe_cycle_counter_01 not found (drvInfo=T_SMP_MS=10/TYPE=asynUInt32Digital/ec0.s23.fsoe_cycle_counter_01?).
c6025a-04:m0s023-FSoE-CycCntIn01 devAsynUInt32Digital::initCommon drvUserCreate 
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"c6025a-04> "
c6025a-04> pwd
/gfa/.mounts/sls_ioc/MTEST04-MTN-C6025A/ecmc_twinsafe/iocsh
```
