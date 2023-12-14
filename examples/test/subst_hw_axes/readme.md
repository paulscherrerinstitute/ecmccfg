# Load multiple axes based on subst and template file 

The command loadMultiAxis.cmd will configure axes based on a substitution file by use of msi.
The template file has to have the format of a normal ecmccfg yaml-axis. Loading of axes is made with the normal loadYamlAxis.cmd.

## Example

```
${SCRIPTEXEC} ${ecmccfg_DIR}loadMultiAxis.cmd, "FILE=./test.subst"
```

## Subst file

Global section can be used for settings applicable for all axes (that are not already default in template).

```
global
{
    UNIT    =   "mm",
    KP      =    100,
}

file "ax.template.yaml"{
  pattern {  AX_ID, ENC_NUM, ENC_DEN, ENC_SID, KD   }
          {  1,     10,      110,     2,       5.1  }
          {  2,     20,      120,     4,       5.2  }
          {  3,     30,      130,     2,       5.3  }
          {  4,     40,      140,     4,       5.4  }
          {  5,     50,      150,     2,       5.5  }
          {  6,     60,      160,     4,       5.6  }
          {  7,     70,      170,     2,       5.7  }
          {  8,     80,      180,     4,       5.8  }
}

```

## Axis template file
```
axis:
  id: ${AX_ID=1}
  type: ${AX_TYP=joint}   # this is for future selection of axis type
  parameters: powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;

epics:
  name: ${NAME=M${AX_ID=1}}
  precision: ${PREC=3}
  unit: ${UNIT=mm}
  motorRecord:
    enable: ${MR_ENA=yes}
    description: ${DESC=Motor ${AX_ID=1}}
    fieldInit: "VMAX=1000"

drive:
  numerator: ${DRV_NUM=3600}     # Fastest speed in engineering units
  denominator: ${DRV_NUM=32768}  # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET
  type: ${DRV_TYP=0}             # Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives)
  control: ec0.s${DRV_SID}.driveControl${DRV_CH=01}
  enable: 0           # Enbale bit
  status: ec0.s${DRV_SID}.driveStatus${DRV_CH=01}
  enabled: 1          # Enbaled bit
  setpoint: ec0.s${DRV_SID}.velocitySetpoint${DRV_CH=01}
  reduceTorqueEnable: yes
  reduceTorque: 2  # Reduce torque bit in drive control word
  reset: 1        # Reset   (if no drive reset bit then leave empty)
  warning: 2      # Warning (if no drive warning bit then leave empty)
  error:          # max 3
    - 3           # Error 0 (if no drive error bit then leave empty)
    - 7           # Error 0 (if no drive error bit then leave empty)
    - 14          # Error 0 (if no drive error bit then leave empty)

encoder:
  unit: ${UNIT=mm}
  desc: openloop1
  numerator: ${ENC_NUM=360}
  denominator: ${ENC_DEN=12800}
  type: ${ENC_TYP=0}          # Type: 0=Incremental, 1=Absolute
  bits: ${ENC_BITS=16}        # Total bit count of encoder raw data
  absBits: ${ENC_ABS_BITS=0}      # Total bit count of encoder raw data
  absOffset: ${ENC_ABS=0}    # Encoder offset in eng units (for absolute encoders)
  position: ec0.s${ENC_SID}.positionActual${ENC_CH=01}  # Ethercat entry for act-pos (encoder)
  homing:
    type: ${ENC_HME_SEQ=15}

controller:
  Kp: ${CNTR_KP=10}
  Ki: ${CNTR_KI=0.01}
  Kd: ${CNTR_KD=0}
  inner:
    Kp: ${CNTR_KP_i=10}
    Ki: ${CNTR_KI_i=0.01}
    Kd: ${CNTR_KD_i=1}
  deadband:
    tol: ${CNTR_DB_TOL=0.01}
    time: ${CNTR_DB_TIME=100}

trajectory:
  axis:
    velocity: ${TRJ_VEL=720}
    acceleration: ${TRJ_ACC=720}

input:
  limit:
    forward: ${LIM_FWD=ec0.s${DRV_SID}.ONE.0}    #  Ethercat entry for low limit switch input
    backward: ${LIM_BWD=ec0.s${DRV_SID}.ONE.1}   #  Ethercat entry for high limit switch input
  home: ${HME_SWT=ec0.s${DRV_SID}.ONE.2}        #  Ethercat entry for home switch input
  interlock: ${IL_SWT=ec0.s${DRV_SID}.ONE.3}   #  Ethercat entry for interlock switch input

softlimits:
  enable: ${SFT_ENA=True}
  backwardEnable: ${SFT_FWD_ENA=True}
  forwardEnable: ${SFT_BWD_ENA=True}
  forward: ${SFT_FWD=1000}
  backward: ${SFT_BWD=-1000}

monitoring:
  lag:
    enable: ${MON_LAG_ENA=True}
    tolerance: ${MON_LAG_TOL=1}
    time: ${MON_LAG_TIME=100}
  target:
    enable: ${MON_TRG_ENA=True}
    tolerance: ${MON_TRG_TOL=0.1}
    time: ${MON_TRG_TIME=100}
  velocity:
    enable: ${MON_VEL_ENA=True}
    max: ${MON_VEL_MAX=1000}
    time:
      trajectory: ${MON_VEL_TTIME=100}
      drive: ${MON_VEL_DTIME=200}
```

## IOC shell output
```
andst_a@c6025a:/ioc/c6025a/ecmccfg/examples/test/test_msi_for_axis$ sudo iocsh -7.0.6 startup.script 
/usr/local/epics/base-7.0.6/bin/deb10-x86_64/softIocPVA -D /usr/local/epics/base-7.0.6/dbd/softIocPVA.dbd /tmp/iocsh.startup.4730
# date="Wed Dec 13 10:54:44 CET 2023"
# user="root"
# IOC="c6025a"
# PWD="/gfa/.mounts/sls_ioc/c6025a/ecmccfg/examples/test/test_msi_for_axis"
# BASE="7.0.6"
# EPICS_HOST_ARCH="deb10-x86_64"
# SHELLBOX=""
# EPICS_CA_ADDR_LIST=""
# EPICS_DRIVER_PATH=".:bin/deb10-x86_64:bin:snl:../snl:O.7.0.6_deb10-x86_64:src/O.7.0.6_deb10-x86_64:snl/O.7.0.6_deb10-x86_64:../snl/O.7.0.6_deb10-x86_64:/ioc/modules:/work/iocBoot/R7.0.6/deb10-x86_64"
# PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/epics:/usr/local/bin:/work/iocBoot/R7.0.6/deb10-x86_64:/usr/local/epics/base-7.0.6/bin/deb10-x86_64:/usr/local/epics/base-7.0.6/../seq/bin/deb10-x86_64"
# LD_LIBRARY_PATH=""
dlload /usr/local/epics/base-7.0.6/lib/deb10-x86_64/libnt.so
dlload /usr/local/epics/base-7.0.6/lib/deb10-x86_64/libpvDatabase.so
dlload /ioc/modules/require/3.3.1/R7.0.6/lib/deb10-x86_64/librequire.so
dbLoadDatabase /ioc/modules/require/3.3.1/R7.0.6/dbd/require.dbd
require_registerRecordDeviceDriver
Loading module info records for require
require misc ifexists
Module misc version 2.15.0 found in /ioc/modules/misc/2.15.0/
Loading library /ioc/modules/misc/2.15.0/R7.0.6/lib/deb10-x86_64/libmisc.so
Loaded misc version 2.15.0
Loading dbd file /ioc/modules/misc/2.15.0/R7.0.6/dbd/misc.dbd
Calling function misc_registerRecordDeviceDriver
Loading module info records for misc
iocshLoad 'startup.script',''
require ecmccfg,sandst_a,"ECMC_VER=sandst_a,MASTER_ID=0"
Module ecmccfg version sandst_a found in /ioc/modules/ecmccfg/sandst_a/
Loading library /ioc/modules/ecmccfg/sandst_a/R7.0.6/lib/deb10-x86_64/libecmccfg.so
Loaded ecmccfg version sandst_a
Loading dbd file /ioc/modules/ecmccfg/sandst_a/R7.0.6/dbd/ecmccfg.dbd
Calling function ecmccfg_registerRecordDeviceDriver
Loading module info records for ecmccfg
Executing /ioc/modules/ecmccfg/sandst_a/R7.0.6/startup.cmd with "ECMC_VER=sandst_a,MASTER_ID=0"
#==============================================================================
# startup.cmd

on error halt
epicsEnvSet(ECMC_VER,sandst_a)
require ecmc "sandst_a"
Module ecmc version sandst_a found in /ioc/modules/ecmc/sandst_a/
Module ecmc depends on ECmasterECMC v1.1.0
Module ECmasterECMC version v1.1.0 found in /ioc/modules/ECmasterECMC/v1.1.0/
Dependency file /ioc/modules/ECmasterECMC/v1.1.0/R7.0.6/ECmasterECMC.dep not found
Module ECmasterECMC is architecture independent
Loading module info records for ECmasterECMC
Module ecmc depends on asyn 4.42
Module asyn version 4.42.2 found in /ioc/modules/asyn/4.42.2/
Module asyn depends on calc 3.7
Module calc version 3.7.6 found in /ioc/modules/calc/3.7.6/
Loading library /ioc/modules/calc/3.7.6/R7.0.6/lib/deb10-x86_64/libcalc.so
Loaded calc version 3.7.6
Loading dbd file /ioc/modules/calc/3.7.6/R7.0.6/dbd/calc.dbd
Calling function calc_registerRecordDeviceDriver
Loading module info records for calc
Loading library /ioc/modules/asyn/4.42.2/R7.0.6/lib/deb10-x86_64/libasyn.so
Loaded asyn version 4.42.2
Loading dbd file /ioc/modules/asyn/4.42.2/R7.0.6/dbd/asyn.dbd
Calling function asyn_registerRecordDeviceDriver
Loading module info records for asyn
Module ecmc depends on motorECMC 7.0.7-ESS
Module motorECMC version 7.0.7-ESS found in /ioc/modules/motorECMC/7.0.7-ESS/
Module motorECMC depends on asyn 4.42
Module asyn version 4.42.2 already loaded
Loading library /ioc/modules/motorECMC/7.0.7-ESS/R7.0.6/lib/deb10-x86_64/libmotorECMC.so
Loaded motorECMC version 7.0.7-ESS
Loading dbd file /ioc/modules/motorECMC/7.0.7-ESS/R7.0.6/dbd/motorECMC.dbd
Calling function motorECMC_registerRecordDeviceDriver
Loading module info records for motorECMC
Module ecmc depends on ruckig 0.6
Module ruckig version 0.6.3 found in /ioc/modules/ruckig/0.6.3/
Loading library /ioc/modules/ruckig/0.6.3/R7.0.6/lib/deb10-x86_64/libruckig.so
Loaded ruckig version 0.6.3
ruckig has no dbd file
Loading module info records for ruckig
Loading library /ioc/modules/ecmc/sandst_a/R7.0.6/lib/deb10-x86_64/libecmc.so
Loaded ecmc version sandst_a
Loading dbd file /ioc/modules/ecmc/sandst_a/R7.0.6/dbd/ecmc.dbd
Calling function ecmc_registerRecordDeviceDriver
Loading module info records for ecmc

ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "'ecmcMotorRecord'='EthercatMC'", "require  EthercatMC 3.0.2 # Using EthercatMC motor record support.","# Using ecmcMotorRecord motor record support.")
# Using ecmcMotorRecord motor record support.
epicsEnvUnset(ECMC_EXE_CMD)
epicsEnvSet("ECMC_CONFIG_ROOT",     "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/")
epicsEnvSet("ECMC_CONFIG_DB",       "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/db/")
epicsEnvSet("SCRIPTEXEC",           "iocshLoad")
epicsEnvSet("SM_PREFIX",            "c6025a:")    # colon added since IOC is _not_ PREFIX

epicsEnvSet("ECMC_PROC_HOOK",       "")

epicsEnvSet(ECMC_MODE, FULL)
ecmcEpicsEnvSetCalcTernary(ECMC_SUPPORT_MOTION, "'FULL'!='DAQ'","","# MODE == DAQ, DISABLING MOTION.")
epicsEnvShow(ECMC_SUPPORT_MOTION)
ECMC_SUPPORT_MOTION=
ecmcEpicsEnvSetCalcTernary(ECMC_USE_MOTOR_RECORD, "'FULL'=='FULL'","","# MODE != FULL, DISABLING MOTOR RECORD.")
epicsEnvShow(ECMC_USE_MOTOR_RECORD)
ECMC_USE_MOTOR_RECORD=
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/initAll.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/initAll.cmd"
#==============================================================================
# initAll.cmd
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/init.cmd",1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/init.cmd
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
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/initAxis.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/initAxis.cmd"
#==============================================================================
# initAxis.cmd
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmc_axis_unset.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmc_axis_unset.cmd"
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
epicsEnvUnset(ECMC_HOME_DEC)
epicsEnvUnset(ECMC_DRV_TYPE)
epicsEnvUnset(ECMC_SOFT_LOW_LIM)
epicsEnvUnset(ECMC_SOFT_HIGH_LIM)
epicsEnvUnset(ECMC_HOME_POS_MOVE_ENA)
epicsEnvUnset(ECMC_HOME_POS_MOVE_TARG_POS)
epicsEnvUnset(ECMC_TRAJ_TYPE)
epicsEnvUnset(ECMC_JERK)
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmc_axis_sync_unset.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmc_axis_sync_unset.cmd"
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
epicsEnvSet("ECMC_PREFIX"         "c6025a:")
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
2023/12/13 10:54:44.503 
ECMC Initializes.............
2023/12/13 10:54:44.503 ESS Open Source EtherCAT Motion Control Epics Module2023/12/13 10:54:44.503 
Mode: Configuration
SEM object created: 0x7f5c15261000.
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
 ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/addMaster.cmd",1)
 iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/addMaster.cmd", "MASTER_ID=0"
#===============================================================================
# addMaster.cfg
epicsEnvSet("ECMC_EC_MASTER_ID"          "0")
# Claim master
ecmcConfigOrDie "Cfg.EcSetMaster(0)"
OK
epicsEnvSet("ECMC_EC_MASTER_ID" ,0)

ecmcEpicsEnvSetCalcTernary(ECMC_ENG_MODE_CMD, "0>0", "","#- ")
epicsEnvShow(ECMC_ENG_MODE_CMD)
ECMC_ENG_MODE_CMD=#- 
epicsEnvSet(ECMC_ENG_MODE,0)

epicsEnvSet("ECMC_TMP_DIR",         "/tmp/c6025a/EcMaster_0/")
system "mkdir -p /tmp/c6025a/EcMaster_0/"

epicsEnvSet("ECMC_TMP_DIR",         "/tmp/c6025a/EcMaster_0/")
system "mkdir -p /tmp/c6025a/EcMaster_0/"

ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/setDiagnostics.cmd",1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/setDiagnostics.cmd
#==============================================================================
# setDiagnostics.cmd
ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
OK
ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
OK
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(100)"
OK

# Load ecmc inforamtion into record
dbLoadRecords("ecmcMcuInfo.db","P=c6025a:,ECMC_VER=sandst_a, M_ID=0, ,MCU_NAME=mXsXXX, M_RATE=1000, M_TIME=1,PV_TIME=10, MCU_MODE=FULL,MCU_PVA=No,MCU_ENG=0")

epicsEnvSet(ECMC_EC_TOOL_PATH,{EC_TOOL_PATH="/opt/etherlab/bin/ethercat"})
ecmcEpicsEnvSetCalcTernary(ECMC_USE_ECmasterECMC_DIR, "'/gfa/.mounts/sls_ioc/modules/ECmasterECMC/v1.1.0/R7.0.6/'=='empty'", "#-","")
epicsEnvSet(ECMC_EC_TOOL_PATH, "/gfa/.mounts/sls_ioc/modules/ECmasterECMC/v1.1.0/R7.0.6/bin/deb10-x86_64/ethercat")
epicsEnvUnset(ECMC_USE_ECmasterECMC_DIR)

epicsEnvSet("ECMCCFG_INIT" ,"#")
Done with /ioc/modules/ecmccfg/sandst_a/R7.0.6/startup.cmd
# Configure hardware
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/addSlave.cmd, "SLAVE_ID=1, HW_DESC=EL3004"
#==============================================================================
# addSlave.cmd
epicsEnvSet("ECMC_EC_SLAVE_NUM",  "1")
epicsEnvSet("HW_DESC",            "EL3004")
epicsEnvSet("P_SCRIPT",           "mXsXXX")
# add ${HW_DESC} to the bus at position ${SLAVE_ID}
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL3004.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL3004.cmd" "NELM=1"
epicsEnvSet("ECMC_EC_HWTYPE"             "EL3004")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0bbc3052")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/slaveVerify.cmd "RESET=true"
ecmcEpicsEnvSetCalcTernary(SLAVE_VERIFY, "0==0","","#- ")
ecmcConfigOrDie "Cfg.EcSlaveVerify(0,1,0x2,0x0bbc3052)"
OK
ecmcEpicsEnvSetCalcTernary(SLAVE_RESET, "true>0","","#- ")
ecmcConfigOrDie "Cfg.EcWriteSdo(1,0x1011,0x1,1684107116,4)"
OK
epicsEnvSet(ECMC_EC_SLAVE_FW, "0x0000")
ecmcEpicsEnvSetCalcTernary(SLAVE_FW, "0>0","","#- ")
epicsEnvUnset(SLAVE_VERIFY)
epicsEnvUnset(SLAVE_RESET)
epicsEnvUnset(SLAVE_FW)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcAnalogInput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1a00,ECMC_ENTRY=0x6000"
ecmcEpicsEnvSetCalc("ECMC_CHANNEL",01,"%02x")
ecmcConfigOrDie "Cfg.EcAddEntryDT(1,0x2,0x0bbc3052,2,3,0x1a00,0x6000,0x01,U16,status01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(1,0x2,0x0bbc3052,2,3,0x1a00,0x6000,0x11,S16,analogInput01)"
OK
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcAnalogInput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1a02,ECMC_ENTRY=0x6010"
ecmcEpicsEnvSetCalc("ECMC_CHANNEL",02,"%02x")
ecmcConfigOrDie "Cfg.EcAddEntryDT(1,0x2,0x0bbc3052,2,3,0x1a02,0x6010,0x01,U16,status02)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(1,0x2,0x0bbc3052,2,3,0x1a02,0x6010,0x11,S16,analogInput02)"
OK
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcAnalogInput_16bit.cmd "CH_ID=03,ECMC_PDO=0x1a04,ECMC_ENTRY=0x6020"
ecmcEpicsEnvSetCalc("ECMC_CHANNEL",03,"%02x")
ecmcConfigOrDie "Cfg.EcAddEntryDT(1,0x2,0x0bbc3052,2,3,0x1a04,0x6020,0x01,U16,status03)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(1,0x2,0x0bbc3052,2,3,0x1a04,0x6020,0x11,S16,analogInput03)"
OK
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcAnalogInput_16bit.cmd "CH_ID=04,ECMC_PDO=0x1a06,ECMC_ENTRY=0x6030"
ecmcEpicsEnvSetCalc("ECMC_CHANNEL",04,"%02x")
ecmcConfigOrDie "Cfg.EcAddEntryDT(1,0x2,0x0bbc3052,2,3,0x1a06,0x6030,0x01,U16,status04)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(1,0x2,0x0bbc3052,2,3,0x1a06,0x6030,0x11,S16,analogInput04)"
OK
# deduce what the prefix should be
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcmXsXXX.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcmXsXXX.cmd" "MASTER_ID=0,SLAVE_POS=1,HWTYPE=EL3004"
#==============================================================================
# ecmcmXsXXX.cmd
ecmcEpicsEnvSetCalc("sid", "1","%03d")
ecmcEpicsEnvSetCalc("mid", "0","%01d")
epicsEnvSet("ECMC_G",            "c6025a:m0s001")
epicsEnvSet("ECMC_P",            "c6025a:m0s001-")
epicsEnvUnset(sid)
epicsEnvUnset(mid)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SUBS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/applySubstitutions.cmd" "SUBST_FILE=ecmcEL3004.substitutions,ECMC_P=c6025a:m0s001-"
#==============================================================================
# applySubstitutions.cmd
ecmcFileExist(ecmcEL3004.substitutions,1,1)
dbLoadTemplate(ecmcEL3004.substitutions,"ECMC_P=c6025a:m0s001-,ECMC_G=c6025a:m0s001,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=1,HWTYPE=EL3004,T_SMP_MS=10,TSE=0,NELM=1")
epicsEnvUnset(DEFAULT_SUBS)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SLAVE_PVS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=c6025a:m0s001-,ECMC_G=c6025a:m0s001"
#==============================================================================
# applyTemplate.cmd
ecmcFileExist(ecmcEcSlave.template,1,1)
dbLoadRecords("ecmcEcSlave.template", "ECMC_P=c6025a:m0s001-,ECMC_G=c6025a:m0s001,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=1,HWTYPE=EL3004,T_SMP_MS=10,TSE=0,")
epicsEnvUnset(DEFAULT_SLAVE_PVS)
# Do not set NxtSlv "pointer" if this is the first slave (ECMC_EC_PREVIOUS_SLAVE==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_SLV,"-1>=0", "","#- ")
epicsEnvUnset(ECMC_EXE_NEXT_SLV)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_SLAVE,"-1<0", "","#- ")
dbLoadRecords(ecmcEcFirstSlave.db,"P=c6025a:,FIRST_SLAVE_ID=1")
epicsEnvUnset(ECMC_EXE_FIRST_SLAVE)
epicsEnvSet(ECMC_PREV_ECMC_P,c6025a:m0s001-)
epicsEnvSet(ECMC_EC_PREV_SLAVE_NUM,1)
# increment SLAVE_ID
ecmcEpicsEnvSetCalc("SLAVE_ID", "1+1","%d")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/addSlave.cmd, "SLAVE_ID=2, HW_DESC=EL5001"
#==============================================================================
# addSlave.cmd
epicsEnvSet("ECMC_EC_SLAVE_NUM",  "2")
epicsEnvSet("HW_DESC",            "EL5001")
epicsEnvSet("P_SCRIPT",           "mXsXXX")
# add ${HW_DESC} to the bus at position ${SLAVE_ID}
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL5001.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL5001.cmd" "NELM=1"
epicsEnvSet("ECMC_EC_HWTYPE"             "EL5001")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x13893052")
ecmcFileExist(/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/slaveVerify.cmd,1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/slaveVerify.cmd "RESET=true"
ecmcEpicsEnvSetCalcTernary(SLAVE_VERIFY, "0==0","","#- ")
ecmcConfigOrDie "Cfg.EcSlaveVerify(0,2,0x2,0x13893052)"
OK
ecmcEpicsEnvSetCalcTernary(SLAVE_RESET, "true>0","","#- ")
ecmcConfigOrDie "Cfg.EcWriteSdo(2,0x1011,0x1,1684107116,4)"
OK
epicsEnvSet(ECMC_EC_SLAVE_FW, "0x0000")
ecmcEpicsEnvSetCalcTernary(SLAVE_FW, "0>0","","#- ")
epicsEnvUnset(SLAVE_VERIFY)
epicsEnvUnset(SLAVE_RESET)
epicsEnvUnset(SLAVE_FW)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(2,0x2,0x13893052,2,3,0x1a00,0x6010,0x1,8,encoderStatus01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryComplete(2,0x2,0x13893052,2,3,0x1a00,0x6010,0x11,32,positionActual01)"
OK
# deduce what the prefix should be
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcmXsXXX.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcmXsXXX.cmd" "MASTER_ID=0,SLAVE_POS=2,HWTYPE=EL5001"
#==============================================================================
# ecmcmXsXXX.cmd
ecmcEpicsEnvSetCalc("sid", "2","%03d")
ecmcEpicsEnvSetCalc("mid", "0","%01d")
epicsEnvSet("ECMC_G",            "c6025a:m0s002")
epicsEnvSet("ECMC_P",            "c6025a:m0s002-")
epicsEnvUnset(sid)
epicsEnvUnset(mid)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SUBS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/applySubstitutions.cmd" "SUBST_FILE=ecmcEL5001.substitutions,ECMC_P=c6025a:m0s002-"
#==============================================================================
# applySubstitutions.cmd
ecmcFileExist(ecmcEL5001.substitutions,1,1)
dbLoadTemplate(ecmcEL5001.substitutions,"ECMC_P=c6025a:m0s002-,ECMC_G=c6025a:m0s002,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=2,HWTYPE=EL5001,T_SMP_MS=10,TSE=0,NELM=1")
epicsEnvUnset(DEFAULT_SUBS)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SLAVE_PVS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=c6025a:m0s002-,ECMC_G=c6025a:m0s002"
#==============================================================================
# applyTemplate.cmd
ecmcFileExist(ecmcEcSlave.template,1,1)
dbLoadRecords("ecmcEcSlave.template", "ECMC_P=c6025a:m0s002-,ECMC_G=c6025a:m0s002,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=2,HWTYPE=EL5001,T_SMP_MS=10,TSE=0,")
epicsEnvUnset(DEFAULT_SLAVE_PVS)
# Do not set NxtSlv "pointer" if this is the first slave (ECMC_EC_PREVIOUS_SLAVE==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_SLV,"1>=0", "","#- ")
dbLoadRecords(ecmcEcPrevSlave.db,"NEXT_SLAVE_ID=2,PREV_ECMC_P=c6025a:m0s001-")
epicsEnvUnset(ECMC_EXE_NEXT_SLV)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_SLAVE,"1<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_SLAVE)
epicsEnvSet(ECMC_PREV_ECMC_P,c6025a:m0s002-)
epicsEnvSet(ECMC_EC_PREV_SLAVE_NUM,2)
# increment SLAVE_ID
ecmcEpicsEnvSetCalc("SLAVE_ID", "2+1","%d")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/addSlave.cmd, "SLAVE_ID=3, HW_DESC=EL1008"
#==============================================================================
# addSlave.cmd
epicsEnvSet("ECMC_EC_SLAVE_NUM",  "3")
epicsEnvSet("HW_DESC",            "EL1008")
epicsEnvSet("P_SCRIPT",           "mXsXXX")
# add ${HW_DESC} to the bus at position ${SLAVE_ID}
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL1008.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL1008.cmd" "NELM=1"
epicsEnvSet("ECMC_EC_HWTYPE"             "EL1008")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x03f03052")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/slaveVerify.cmd
ecmcEpicsEnvSetCalcTernary(SLAVE_VERIFY, "0==0","","#- ")
ecmcConfigOrDie "Cfg.EcSlaveVerify(0,3,0x2,0x03f03052)"
OK
ecmcEpicsEnvSetCalcTernary(SLAVE_RESET, "0>0","","#- ")
epicsEnvSet(ECMC_EC_SLAVE_FW, "0x0000")
ecmcEpicsEnvSetCalcTernary(SLAVE_FW, "0>0","","#- ")
epicsEnvUnset(SLAVE_VERIFY)
epicsEnvUnset(SLAVE_RESET)
epicsEnvUnset(SLAVE_FW)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEX1008.cmd
ecmcConfigOrDie "Cfg.EcAddEntryDT(3,0x2,0x03f03052,2,0,0x1a00,0x6000,0x1,B1,binaryInput01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(3,0x2,0x03f03052,2,0,0x1a01,0x6010,0x1,B1,binaryInput02)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(3,0x2,0x03f03052,2,0,0x1a02,0x6020,0x1,B1,binaryInput03)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(3,0x2,0x03f03052,2,0,0x1a03,0x6030,0x1,B1,binaryInput04)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(3,0x2,0x03f03052,2,0,0x1a04,0x6040,0x1,B1,binaryInput05)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(3,0x2,0x03f03052,2,0,0x1a05,0x6050,0x1,B1,binaryInput06)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(3,0x2,0x03f03052,2,0,0x1a06,0x6060,0x1,B1,binaryInput07)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryDT(3,0x2,0x03f03052,2,0,0x1a07,0x6070,0x1,B1,binaryInput08)"
OK
# deduce what the prefix should be
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcmXsXXX.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcmXsXXX.cmd" "MASTER_ID=0,SLAVE_POS=3,HWTYPE=EL1008"
#==============================================================================
# ecmcmXsXXX.cmd
ecmcEpicsEnvSetCalc("sid", "3","%03d")
ecmcEpicsEnvSetCalc("mid", "0","%01d")
epicsEnvSet("ECMC_G",            "c6025a:m0s003")
epicsEnvSet("ECMC_P",            "c6025a:m0s003-")
epicsEnvUnset(sid)
epicsEnvUnset(mid)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SUBS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/applySubstitutions.cmd" "SUBST_FILE=ecmcEL1008.substitutions,ECMC_P=c6025a:m0s003-"
#==============================================================================
# applySubstitutions.cmd
ecmcFileExist(ecmcEL1008.substitutions,1,1)
dbLoadTemplate(ecmcEL1008.substitutions,"ECMC_P=c6025a:m0s003-,ECMC_G=c6025a:m0s003,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=3,HWTYPE=EL1008,T_SMP_MS=10,TSE=0,NELM=1")
epicsEnvUnset(DEFAULT_SUBS)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SLAVE_PVS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=c6025a:m0s003-,ECMC_G=c6025a:m0s003"
#==============================================================================
# applyTemplate.cmd
ecmcFileExist(ecmcEcSlave.template,1,1)
dbLoadRecords("ecmcEcSlave.template", "ECMC_P=c6025a:m0s003-,ECMC_G=c6025a:m0s003,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=3,HWTYPE=EL1008,T_SMP_MS=10,TSE=0,")
epicsEnvUnset(DEFAULT_SLAVE_PVS)
# Do not set NxtSlv "pointer" if this is the first slave (ECMC_EC_PREVIOUS_SLAVE==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_SLV,"2>=0", "","#- ")
dbLoadRecords(ecmcEcPrevSlave.db,"NEXT_SLAVE_ID=3,PREV_ECMC_P=c6025a:m0s002-")
epicsEnvUnset(ECMC_EXE_NEXT_SLV)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_SLAVE,"2<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_SLAVE)
epicsEnvSet(ECMC_PREV_ECMC_P,c6025a:m0s003-)
epicsEnvSet(ECMC_EC_PREV_SLAVE_NUM,3)
# increment SLAVE_ID
ecmcEpicsEnvSetCalc("SLAVE_ID", "3+1","%d")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/configureSlave.cmd, "SLAVE_ID=4, HW_DESC=EL7031, CONFIG=-Motor-Trinamic-QMot-QSH4218-41-10-035"
#==============================================================================
# configureSlave.cmd
epicsEnvSet("ECMC_EC_SLAVE_NUM",  "4")
epicsEnvSet("HW_DESC",            "EL7031")
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/addSlave.cmd",1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/addSlave.cmd "SLAVE_ID=4, HW_DESC=EL7031, NELM=1"
#==============================================================================
# addSlave.cmd
epicsEnvSet("ECMC_EC_SLAVE_NUM",  "4")
epicsEnvSet("HW_DESC",            "EL7031")
epicsEnvSet("P_SCRIPT",           "mXsXXX")
# add ${HW_DESC} to the bus at position ${SLAVE_ID}
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL7031.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL7031.cmd" "NELM=1"
epicsEnvSet("ECMC_EC_HWTYPE"             "EL7031")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b773052")
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/slaveVerify.cmd "RESET=true"
ecmcEpicsEnvSetCalcTernary(SLAVE_VERIFY, "0==0","","#- ")
ecmcConfigOrDie "Cfg.EcSlaveVerify(0,4,0x2,0x1b773052)"
OK
ecmcEpicsEnvSetCalcTernary(SLAVE_RESET, "true>0","","#- ")
ecmcConfigOrDie "Cfg.EcWriteSdo(4,0x1011,0x1,1684107116,4)"
OK
epicsEnvSet(ECMC_EC_SLAVE_FW, "0x0000")
ecmcEpicsEnvSetCalcTernary(SLAVE_FW, "0>0","","#- ")
epicsEnvUnset(SLAVE_VERIFY)
epicsEnvUnset(SLAVE_RESET)
epicsEnvUnset(SLAVE_FW)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEX70XX.cmd
ecmcConfigOrDie "Cfg.EcAddEntryComplete(4,0x2,0x1b773052,1,2,0x1600,0x7000,0x01,16,encoderControl01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryComplete(4,0x2,0x1b773052,1,2,0x1600,0x7000,0x11,16,encoderValue01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryComplete(4,0x2,0x1b773052,1,2,0x1602,0x7010,0x1,16,driveControl01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryComplete(4,0x2,0x1b773052,1,2,0x1604,0x7010,0x21,16,1,velocitySetpoint01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryComplete(4,0x2,0x1b773052,2,3,0x1a00,0x6000,0x0,16,encoderStatus01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryComplete(4,0x2,0x1b773052,2,3,0x1a00,0x6000,0x11,16,positionActual01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryComplete(4,0x2,0x1b773052,2,3,0x1a00,0x6000,0x12,16,encoderLatchPostion01)"
OK
ecmcConfigOrDie "Cfg.EcAddEntryComplete(4,0x2,0x1b773052,2,3,0x1a03,0x6010,0x1,16,driveStatus01)"
OK
ecmcConfigOrDie "Cfg.EcAddSdo(4,0x8012,0x5,1,1)"
OK
ecmcConfigOrDie "Cfg.EcAddSdo(4,0x8012,0x9,0,1)"
OK
# deduce what the prefix should be
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcmXsXXX.cmd",1)
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcmXsXXX.cmd" "MASTER_ID=0,SLAVE_POS=4,HWTYPE=EL7031"
#==============================================================================
# ecmcmXsXXX.cmd
ecmcEpicsEnvSetCalc("sid", "4","%03d")
ecmcEpicsEnvSetCalc("mid", "0","%01d")
epicsEnvSet("ECMC_G",            "c6025a:m0s004")
epicsEnvSet("ECMC_P",            "c6025a:m0s004-")
epicsEnvUnset(sid)
epicsEnvUnset(mid)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SUBS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/applySubstitutions.cmd" "SUBST_FILE=ecmcEL7031.substitutions,ECMC_P=c6025a:m0s004-"
#==============================================================================
# applySubstitutions.cmd
ecmcFileExist(ecmcEL7031.substitutions,1,1)
dbLoadTemplate(ecmcEL7031.substitutions,"ECMC_P=c6025a:m0s004-,ECMC_G=c6025a:m0s004,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=4,HWTYPE=EL7031,T_SMP_MS=10,TSE=0,NELM=1")
epicsEnvUnset(DEFAULT_SUBS)
ecmcEpicsEnvSetCalcTernary(DEFAULT_SLAVE_PVS, "True", "","#- ")
iocshLoad "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=c6025a:m0s004-,ECMC_G=c6025a:m0s004"
#==============================================================================
# applyTemplate.cmd
ecmcFileExist(ecmcEcSlave.template,1,1)
dbLoadRecords("ecmcEcSlave.template", "ECMC_P=c6025a:m0s004-,ECMC_G=c6025a:m0s004,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,SLAVE_POS=4,HWTYPE=EL7031,T_SMP_MS=10,TSE=0,")
epicsEnvUnset(DEFAULT_SLAVE_PVS)
# Do not set NxtSlv "pointer" if this is the first slave (ECMC_EC_PREVIOUS_SLAVE==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_SLV,"3>=0", "","#- ")
dbLoadRecords(ecmcEcPrevSlave.db,"NEXT_SLAVE_ID=4,PREV_ECMC_P=c6025a:m0s003-")
epicsEnvUnset(ECMC_EXE_NEXT_SLV)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_SLAVE,"3<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_SLAVE)
epicsEnvSet(ECMC_PREV_ECMC_P,c6025a:m0s004-)
epicsEnvSet(ECMC_EC_PREV_SLAVE_NUM,4)
# increment SLAVE_ID
ecmcEpicsEnvSetCalc("SLAVE_ID", "4+1","%d")
# apply config ${CONFIG} for ${HW_DESC}
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL7031-Motor-Trinamic-QMot-QSH4218-41-10-035.cmd",1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ecmcEL7031-Motor-Trinamic-QMot-QSH4218-41-10-035.cmd ""
ecmcConfigOrDie "Cfg.EcAddSdo(4,0x8010,0x1,1000,2)"
OK
ecmcConfigOrDie "Cfg.EcAddSdo(4,0x8010,0x2,100,2)"
OK
ecmcConfigOrDie "Cfg.EcAddSdo(4,0x8010,0x3,24000,2)"
OK
ecmcConfigOrDie "Cfg.EcAddSdo(4,0x8010,0x4,450,2)"
OK
ecmcConfigOrDie "Cfg.EcAddSdo(4,0x8010,0x6,200,2)"
OK
epicsEnvSet(DRV_SID, 4)
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
OK
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadMultiAxis.cmd, "FILE=./test.subst"
#==============================================================================
# loadMultiAxis.cmd
system "/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/multiAxis.sh ./test.subst /tmp/c6025a/EcMaster_0/ tempFile.ax /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/"
Start parsing axes data (output from msi).
Write axis file: /tmp/c6025a/EcMaster_0/tempFile.ax1
Write axis file: /tmp/c6025a/EcMaster_0/tempFile.ax2
Write axis file: /tmp/c6025a/EcMaster_0/tempFile.ax3
Write axis file: /tmp/c6025a/EcMaster_0/tempFile.ax4
Write axis file: /tmp/c6025a/EcMaster_0/tempFile.ax5
Write axis file: /tmp/c6025a/EcMaster_0/tempFile.ax6
Write axis file: /tmp/c6025a/EcMaster_0/tempFile.ax7
Write axis file: /tmp/c6025a/EcMaster_0/tempFile.ax8
Generated 8 files + ecmc cmd file.
system "ls /tmp/c6025a/EcMaster_0/"
tempFile.ax.exe.cmd  tempFile.ax1  tempFile.ax2  tempFile.ax3  tempFile.ax4  tempFile.ax5  tempFile.ax6  tempFile.ax7  tempFile.ax8  tmp
iocshLoad /tmp/c6025a/EcMaster_0/tempFile.ax.exe.cmd
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadYamlAxis.cmd FILE=/tmp/c6025a/EcMaster_0/tempFile.ax1
on error halt
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/pythonVenv.sh -d /tmp/c6025a/EcMaster_0/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/axisYamlJinja2.py -d /tmp/c6025a/EcMaster_0/ -T /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ -D /tmp/c6025a/EcMaster_0/tempFile.ax1 -o /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax1.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
ecmcFileExist("/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax1.axis",1)
iocshLoad "/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax1.axis"
epicsEnvSet(ECMC_AXIS_NO,1)
ecmcConfigOrDie "Cfg.CreateAxis(1,1,0,0)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("","ax1.health")"
OK
ecmcConfig "GetAxisEncConfigIndex(1)"
1
# Current encoder index beeing configured
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1
epicsEnvSet(ECMC_ENC_CFG_ID,1)
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s2.positionActual01","ax1.enc.actpos")"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(1,110.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(1,10.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(1,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncType(1,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncBits(1,16)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncOffset(1,0)"
OK
        epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_DESC,'openloop1')
        ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup(1,-1)"
OK
        epicsEnvSet(REF_STRT, -1)
        ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome(1,0)"
OK
        epicsEnvSet(REF_HME, 0)
        ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc(1,0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisHomeSeqId(1,15)"
OK
        epicsEnvSet(HOME_PROC, 15)
    
    
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.0","ax1.drv.control")"
OK
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.1","ax1.drv.status")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.velocitySetpoint01","ax1.drv.velocity")"
OK
        ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.2","ax1.drv.reducetorque")"
OK
        ecmcConfigOrDie "Cfg.SetAxisDrvReduceTorqueEnable(1, 1)"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.1","ax1.drv.reset")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.2","ax1.drv.warning")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.3","ax1.drv.alarm0")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.7","ax1.drv.alarm1")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.14","ax1.drv.alarm2")"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(1,3600)"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(1,32768)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(1,10)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(1,0.01)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(1,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(1,1.0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisCntrlInnerParams(1,10,0.01,1,0.0)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadband(1,0.01)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadbandTime(1,100)"
OK
    
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(1,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJerk(1,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisAcc(1,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisDec(1,720.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisVel(1,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(1,7200.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJogVel(1,720)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.0,"ax1.mon.highlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.1,"ax1.mon.lowlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.2,"ax1.mon.homesensor")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.3,"ax1.mon.extinterlock")"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(1,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(1,1000)"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(1,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(1,-1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(1,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(1,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(1,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(1,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(1,0.1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(1,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(1,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(1,1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(1,100)"
OK
            ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(1,200)"
OK
ecmcFileExist("ecmcAxis.db",1,1)
ecmcEpicsEnvSetCalcTernary(V_DRVL,"1>0",-1000 ,0)
ecmcEpicsEnvSetCalcTernary(V_DRVH,"1>0",1000 ,0)
dbLoadRecords("ecmcAxis.db","P=c6025a:,AXIS_NAME='M1',EGU='mm',PREC=3,AXIS_NO=1,HOMEPROC=0,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,VELO=720,V_DRVL=-1000,V_DRVH=1000")
epicsEnvUnset(V_DRVL)
epicsEnvUnset(V_DRVH)
# Add encoder PVS (always encoder number 1 (first encoder))
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=c6025a:,AXIS_NAME='M1',AXIS_NO=1,ENC_NO=1,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,EGU=mm,DESC=openloop1,HOME_PROC=15,VEL_TO_CAM=0,VEL_FRM_CAM=0,ACC=-1,DEC=-1,REF_HME=0,REF_STRT=-1,POST_ENA=-1,POST_POS=0,POS=0")
epicsEnvSet(ECMC_MOTOR_NAME, M1)
ecmcFileExist("ecmcAxisType.db",1,1)
   dbLoadRecords("ecmcAxisType.db","P=c6025a:,AXIS_NAME='M1',AXIS_TYPE=1,DRV_TYPE=0,TRAJ_TYPE=0")
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=c6025a:,DEV=c6025a:,AXIS_NAME='M1',AXIS_NO=1")
epicsEnvSet(ECMC_AXIS_NO,1)
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"-1>=0", "","#- ")
epicsEnvUnset(ECMC_EXE_NEXT_AX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"-1<0", "","#- ")
ecmcFileExist(ecmcAxFirstAxis.db,1,1)
dbLoadRecords(ecmcAxFirstAxis.db,"P=c6025a:,FIRST_OBJ_ID=1")
epicsEnvUnset(ECMC_EXE_FIRST_AX)
epicsEnvSet(ECMC_PREV_AXIS_P,"c6025a:MCU-Cfg-AX1-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,1)
ecmcMotorRecordCreateAxis(MCU1, 1, 6, "powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;")
2023/12/13 10:54:45.487 ecmcMotorRecord:: setIntegerParam(1 motorPowerAutoOnOff_)=2
2023/12/13 10:54:45.487 ecmcMotorRecord:: setDoubleParam(1 motorPowerOnDelay_)=6
2023/12/13 10:54:45.488 ecmcMotorRecord:: setDoubleParam(1 motorPowerOffDelay_=-1
2023/12/13 10:54:45.488 ecmcMotorRecord:: setIntegerParam(1 motorPowerAutoOnOff_)=2
2023/12/13 10:54:45.488 ecmcMotorRecord:: updateCfgValue(1) oldpowerOffDelay=-1.000000 newpowerOffDelay=2.000000
2023/12/13 10:54:45.488 ecmcMotorRecord:: udateMotorLimitsRO(1) enabledHighAndLow=1 valid=1 fValueHigh=1000 fValueLow=-1000
2023/12/13 10:54:45.488 ecmcMotorRecord:: connected(1)
2023/12/13 10:54:45.488 ecmcMotorRecord:: initialPoll(1) status=0
ecmcFileExist(ecmcMotorRecord.template,1,1)
dbLoadRecords(ecmcMotorRecord.template,"PREFIX=c6025a:,MOTOR_NAME=M1,MOTOR_PORT=MCU1,AXIS_NO=1,DESC='Motor 1',EGU=mm,PREC=3,VELO=720,JVEL=72.0,JAR=720,ACCS=720,RDBD=0.1,DLLM=-1000.0,DHLM=1000.0,HOMEPROC=0,SREV=32768,UREV=3600.0,VMAX=1000")
epicsEnvUnset(VEL_FRM_CAM)
epicsEnvUnset(VEL_TO_CAM)
epicsEnvUnset(HOME_PROC)
epicsEnvUnset(HOME_POS)
epicsEnvUnset(ACC)
epicsEnvUnset(DEC)
epicsEnvUnset(REF_HME)
epicsEnvUnset(REF_STRT)
epicsEnvUnset(POST_ENA)
epicsEnvUnset(POST_POS)
epicsEnvUnset(ENC_EGU)
system "rm -rf /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax1.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax1"
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadYamlAxis.cmd FILE=/tmp/c6025a/EcMaster_0/tempFile.ax2
on error halt
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/pythonVenv.sh -d /tmp/c6025a/EcMaster_0/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/axisYamlJinja2.py -d /tmp/c6025a/EcMaster_0/ -T /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ -D /tmp/c6025a/EcMaster_0/tempFile.ax2 -o /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax2.axis"
2023/12/13 10:54:45.903 ecmcMotorRecord:: poll(1) mvnNRdy=1 bBusy=0 bExecute=0 bEnabled=0 atTarget=0 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000034
2023/12/13 10:54:45.903 ecmcMotorRecord:: poll(1) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:45.903 ecmcMotorRecord:: poll(1) callParamCallbacksUpdateError Error=4 old=-1 ErrID=0x0 old=0x0 Warn=0 nCmd=0 old=0 txt=NULL
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
ecmcFileExist("/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax2.axis",1)
iocshLoad "/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax2.axis"
epicsEnvSet(ECMC_AXIS_NO,2)
ecmcConfigOrDie "Cfg.CreateAxis(2,1,0,0)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("","ax2.health")"
OK
ecmcConfig "GetAxisEncConfigIndex(2)"
1
# Current encoder index beeing configured
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1
epicsEnvSet(ECMC_ENC_CFG_ID,1)
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.positionActual01","ax2.enc.actpos")"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(2,120.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(2,20.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(2,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncType(2,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncBits(2,16)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncOffset(2,0)"
OK
        epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_DESC,'openloop1')
        ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup(2,-1)"
OK
        epicsEnvSet(REF_STRT, -1)
        ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome(2,0)"
OK
        epicsEnvSet(REF_HME, 0)
        ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc(2,0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisHomeSeqId(2,15)"
OK
        epicsEnvSet(HOME_PROC, 15)
    
    
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.0","ax2.drv.control")"
OK
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.1","ax2.drv.status")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.velocitySetpoint01","ax2.drv.velocity")"
OK
        ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.2","ax2.drv.reducetorque")"
OK
        ecmcConfigOrDie "Cfg.SetAxisDrvReduceTorqueEnable(2, 1)"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.1","ax2.drv.reset")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.2","ax2.drv.warning")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.3","ax2.drv.alarm0")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.7","ax2.drv.alarm1")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.14","ax2.drv.alarm2")"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(2,3600)"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(2,32768)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(2,10)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(2,0.01)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(2,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(2,1.0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisCntrlInnerParams(2,10,0.01,1,0.0)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadband(2,0.01)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadbandTime(2,100)"
OK
    
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(2,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJerk(2,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisAcc(2,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisDec(2,720.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisVel(2,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(2,7200.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJogVel(2,720)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.0,"ax2.mon.highlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.1,"ax2.mon.lowlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.2,"ax2.mon.homesensor")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.3,"ax2.mon.extinterlock")"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(2,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(2,1000)"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(2,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(2,-1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(2,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(2,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(2,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(2,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(2,0.1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(2,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(2,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(2,1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(2,100)"
OK
            ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(2,200)"
OK
ecmcFileExist("ecmcAxis.db",1,1)
ecmcEpicsEnvSetCalcTernary(V_DRVL,"1>0",-1000 ,0)
ecmcEpicsEnvSetCalcTernary(V_DRVH,"1>0",1000 ,0)
dbLoadRecords("ecmcAxis.db","P=c6025a:,AXIS_NAME='M2',EGU='mm',PREC=3,AXIS_NO=2,HOMEPROC=0,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,VELO=720,V_DRVL=-1000,V_DRVH=1000")
epicsEnvUnset(V_DRVL)
epicsEnvUnset(V_DRVH)
# Add encoder PVS (always encoder number 1 (first encoder))
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=c6025a:,AXIS_NAME='M2',AXIS_NO=2,ENC_NO=1,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,EGU=mm,DESC=openloop1,HOME_PROC=15,VEL_TO_CAM=0,VEL_FRM_CAM=0,ACC=-1,DEC=-1,REF_HME=0,REF_STRT=-1,POST_ENA=-1,POST_POS=0,POS=0")
epicsEnvSet(ECMC_MOTOR_NAME, M2)
ecmcFileExist("ecmcAxisType.db",1,1)
   dbLoadRecords("ecmcAxisType.db","P=c6025a:,AXIS_NAME='M2',AXIS_TYPE=1,DRV_TYPE=0,TRAJ_TYPE=0")
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=c6025a:,DEV=c6025a:,AXIS_NAME='M2',AXIS_NO=2")
epicsEnvSet(ECMC_AXIS_NO,2)
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"1>=0", "","#- ")
ecmcFileExist(ecmcAxPrevAxis.db,1,1)
dbLoadRecords(ecmcAxPrevAxis.db,"NEXT_OBJ_ID=2,PREV_ECMC_P=c6025a:MCU-Cfg-AX1-")
epicsEnvUnset(ECMC_EXE_NEXT_AX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"1<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_AX)
epicsEnvSet(ECMC_PREV_AXIS_P,"c6025a:MCU-Cfg-AX2-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,2)
ecmcMotorRecordCreateAxis(MCU1, 2, 6, "powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;")
2023/12/13 10:54:46.123 ecmcMotorRecord:: setIntegerParam(2 motorPowerAutoOnOff_)=2
2023/12/13 10:54:46.123 ecmcMotorRecord:: setDoubleParam(2 motorPowerOnDelay_)=6
2023/12/13 10:54:46.123 ecmcMotorRecord:: setDoubleParam(2 motorPowerOffDelay_=-1
2023/12/13 10:54:46.123 ecmcMotorRecord:: setIntegerParam(2 motorPowerAutoOnOff_)=2
2023/12/13 10:54:46.123 ecmcMotorRecord:: updateCfgValue(2) oldpowerOffDelay=-1.000000 newpowerOffDelay=2.000000
2023/12/13 10:54:46.123 ecmcMotorRecord:: udateMotorLimitsRO(2) enabledHighAndLow=1 valid=1 fValueHigh=1000 fValueLow=-1000
2023/12/13 10:54:46.123 ecmcMotorRecord:: connected(2)
2023/12/13 10:54:46.123 ecmcMotorRecord:: initialPoll(2) status=0
ecmcFileExist(ecmcMotorRecord.template,1,1)
dbLoadRecords(ecmcMotorRecord.template,"PREFIX=c6025a:,MOTOR_NAME=M2,MOTOR_PORT=MCU1,AXIS_NO=2,DESC='Motor 2',EGU=mm,PREC=3,VELO=720,JVEL=72.0,JAR=720,ACCS=720,RDBD=0.1,DLLM=-1000.0,DHLM=1000.0,HOMEPROC=0,SREV=32768,UREV=3600.0,VMAX=1000")
epicsEnvUnset(VEL_FRM_CAM)
epicsEnvUnset(VEL_TO_CAM)
epicsEnvUnset(HOME_PROC)
epicsEnvUnset(HOME_POS)
epicsEnvUnset(ACC)
epicsEnvUnset(DEC)
epicsEnvUnset(REF_HME)
epicsEnvUnset(REF_STRT)
epicsEnvUnset(POST_ENA)
epicsEnvUnset(POST_POS)
epicsEnvUnset(ENC_EGU)
system "rm -rf /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax2.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax2"
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadYamlAxis.cmd FILE=/tmp/c6025a/EcMaster_0/tempFile.ax3
on error halt
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/pythonVenv.sh -d /tmp/c6025a/EcMaster_0/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/axisYamlJinja2.py -d /tmp/c6025a/EcMaster_0/ -T /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ -D /tmp/c6025a/EcMaster_0/tempFile.ax3 -o /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax3.axis"
2023/12/13 10:54:46.303 ecmcMotorRecord:: poll(2) mvnNRdy=1 bBusy=0 bExecute=0 bEnabled=0 atTarget=0 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000020
2023/12/13 10:54:46.303 ecmcMotorRecord:: poll(2) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:46.303 ecmcMotorRecord:: poll(2) callParamCallbacksUpdateError Error=4 old=-1 ErrID=0x0 old=0x0 Warn=0 nCmd=0 old=0 txt=NULL
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
ecmcFileExist("/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax3.axis",1)
iocshLoad "/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax3.axis"
epicsEnvSet(ECMC_AXIS_NO,3)
ecmcConfigOrDie "Cfg.CreateAxis(3,1,0,0)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("","ax3.health")"
OK
ecmcConfig "GetAxisEncConfigIndex(3)"
1
# Current encoder index beeing configured
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1
epicsEnvSet(ECMC_ENC_CFG_ID,1)
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s2.positionActual01","ax3.enc.actpos")"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(3,130.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(3,30.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(3,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncType(3,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncBits(3,16)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncOffset(3,0)"
OK
        epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_DESC,'openloop1')
        ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup(3,-1)"
OK
        epicsEnvSet(REF_STRT, -1)
        ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome(3,0)"
OK
        epicsEnvSet(REF_HME, 0)
        ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc(3,0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisHomeSeqId(3,15)"
OK
        epicsEnvSet(HOME_PROC, 15)
    
    
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.0","ax3.drv.control")"
OK
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.1","ax3.drv.status")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.velocitySetpoint01","ax3.drv.velocity")"
OK
        ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.2","ax3.drv.reducetorque")"
OK
        ecmcConfigOrDie "Cfg.SetAxisDrvReduceTorqueEnable(3, 1)"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.1","ax3.drv.reset")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.2","ax3.drv.warning")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.3","ax3.drv.alarm0")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.7","ax3.drv.alarm1")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.14","ax3.drv.alarm2")"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(3,3600)"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(3,32768)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(3,10)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(3,0.01)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(3,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(3,1.0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisCntrlInnerParams(3,10,0.01,1,0.0)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadband(3,0.01)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadbandTime(3,100)"
OK
    
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(3,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJerk(3,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisAcc(3,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisDec(3,720.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisVel(3,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(3,7200.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJogVel(3,720)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.0,"ax3.mon.highlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.1,"ax3.mon.lowlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.2,"ax3.mon.homesensor")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.3,"ax3.mon.extinterlock")"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(3,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(3,1000)"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(3,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(3,-1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(3,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(3,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(3,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(3,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(3,0.1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(3,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(3,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(3,1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(3,100)"
OK
            ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(3,200)"
OK
ecmcFileExist("ecmcAxis.db",1,1)
ecmcEpicsEnvSetCalcTernary(V_DRVL,"1>0",-1000 ,0)
ecmcEpicsEnvSetCalcTernary(V_DRVH,"1>0",1000 ,0)
dbLoadRecords("ecmcAxis.db","P=c6025a:,AXIS_NAME='M3',EGU='mm',PREC=3,AXIS_NO=3,HOMEPROC=0,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,VELO=720,V_DRVL=-1000,V_DRVH=1000")
epicsEnvUnset(V_DRVL)
epicsEnvUnset(V_DRVH)
# Add encoder PVS (always encoder number 1 (first encoder))
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=c6025a:,AXIS_NAME='M3',AXIS_NO=3,ENC_NO=1,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,EGU=mm,DESC=openloop1,HOME_PROC=15,VEL_TO_CAM=0,VEL_FRM_CAM=0,ACC=-1,DEC=-1,REF_HME=0,REF_STRT=-1,POST_ENA=-1,POST_POS=0,POS=0")
epicsEnvSet(ECMC_MOTOR_NAME, M3)
ecmcFileExist("ecmcAxisType.db",1,1)
   dbLoadRecords("ecmcAxisType.db","P=c6025a:,AXIS_NAME='M3',AXIS_TYPE=1,DRV_TYPE=0,TRAJ_TYPE=0")
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=c6025a:,DEV=c6025a:,AXIS_NAME='M3',AXIS_NO=3")
epicsEnvSet(ECMC_AXIS_NO,3)
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"2>=0", "","#- ")
ecmcFileExist(ecmcAxPrevAxis.db,1,1)
dbLoadRecords(ecmcAxPrevAxis.db,"NEXT_OBJ_ID=3,PREV_ECMC_P=c6025a:MCU-Cfg-AX2-")
epicsEnvUnset(ECMC_EXE_NEXT_AX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"2<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_AX)
epicsEnvSet(ECMC_PREV_AXIS_P,"c6025a:MCU-Cfg-AX3-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,3)
ecmcMotorRecordCreateAxis(MCU1, 3, 6, "powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;")
2023/12/13 10:54:46.754 ecmcMotorRecord:: setIntegerParam(3 motorPowerAutoOnOff_)=2
2023/12/13 10:54:46.754 ecmcMotorRecord:: setDoubleParam(3 motorPowerOnDelay_)=6
2023/12/13 10:54:46.754 ecmcMotorRecord:: setDoubleParam(3 motorPowerOffDelay_=-1
2023/12/13 10:54:46.754 ecmcMotorRecord:: setIntegerParam(3 motorPowerAutoOnOff_)=2
2023/12/13 10:54:46.754 ecmcMotorRecord:: updateCfgValue(3) oldpowerOffDelay=-1.000000 newpowerOffDelay=2.000000
2023/12/13 10:54:46.755 ecmcMotorRecord:: udateMotorLimitsRO(3) enabledHighAndLow=1 valid=1 fValueHigh=1000 fValueLow=-1000
2023/12/13 10:54:46.755 ecmcMotorRecord:: connected(3)
2023/12/13 10:54:46.755 ecmcMotorRecord:: initialPoll(3) status=0
ecmcFileExist(ecmcMotorRecord.template,1,1)
dbLoadRecords(ecmcMotorRecord.template,"PREFIX=c6025a:,MOTOR_NAME=M3,MOTOR_PORT=MCU1,AXIS_NO=3,DESC='Motor 3',EGU=mm,PREC=3,VELO=720,JVEL=72.0,JAR=720,ACCS=720,RDBD=0.1,DLLM=-1000.0,DHLM=1000.0,HOMEPROC=0,SREV=32768,UREV=3600.0,VMAX=1000")
epicsEnvUnset(VEL_FRM_CAM)
epicsEnvUnset(VEL_TO_CAM)
epicsEnvUnset(HOME_PROC)
epicsEnvUnset(HOME_POS)
epicsEnvUnset(ACC)
epicsEnvUnset(DEC)
epicsEnvUnset(REF_HME)
epicsEnvUnset(REF_STRT)
epicsEnvUnset(POST_ENA)
epicsEnvUnset(POST_POS)
epicsEnvUnset(ENC_EGU)
system "rm -rf /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax3.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax3"
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadYamlAxis.cmd FILE=/tmp/c6025a/EcMaster_0/tempFile.ax4
on error halt
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/pythonVenv.sh -d /tmp/c6025a/EcMaster_0/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/axisYamlJinja2.py -d /tmp/c6025a/EcMaster_0/ -T /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ -D /tmp/c6025a/EcMaster_0/tempFile.ax4 -o /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax4.axis"
2023/12/13 10:54:46.904 ecmcMotorRecord:: poll(3) mvnNRdy=1 bBusy=0 bExecute=0 bEnabled=0 atTarget=0 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000031
2023/12/13 10:54:46.904 ecmcMotorRecord:: poll(3) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:46.904 ecmcMotorRecord:: poll(3) callParamCallbacksUpdateError Error=4 old=-1 ErrID=0x0 old=0x0 Warn=0 nCmd=0 old=0 txt=NULL
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
ecmcFileExist("/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax4.axis",1)
iocshLoad "/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax4.axis"
epicsEnvSet(ECMC_AXIS_NO,4)
ecmcConfigOrDie "Cfg.CreateAxis(4,1,0,0)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("","ax4.health")"
OK
ecmcConfig "GetAxisEncConfigIndex(4)"
1
# Current encoder index beeing configured
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1
epicsEnvSet(ECMC_ENC_CFG_ID,1)
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.positionActual01","ax4.enc.actpos")"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(4,140.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(4,40.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(4,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncType(4,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncBits(4,16)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncOffset(4,0)"
OK
        epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_DESC,'openloop1')
        ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup(4,-1)"
OK
        epicsEnvSet(REF_STRT, -1)
        ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome(4,0)"
OK
        epicsEnvSet(REF_HME, 0)
        ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc(4,0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisHomeSeqId(4,15)"
OK
        epicsEnvSet(HOME_PROC, 15)
    
    
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.0","ax4.drv.control")"
OK
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.1","ax4.drv.status")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.velocitySetpoint01","ax4.drv.velocity")"
OK
        ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.2","ax4.drv.reducetorque")"
OK
        ecmcConfigOrDie "Cfg.SetAxisDrvReduceTorqueEnable(4, 1)"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.1","ax4.drv.reset")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.2","ax4.drv.warning")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.3","ax4.drv.alarm0")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.7","ax4.drv.alarm1")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.14","ax4.drv.alarm2")"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(4,3600)"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(4,32768)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(4,10)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(4,0.01)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(4,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(4,1.0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisCntrlInnerParams(4,10,0.01,1,0.0)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadband(4,0.01)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadbandTime(4,100)"
OK
    
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(4,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJerk(4,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisAcc(4,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisDec(4,720.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisVel(4,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(4,7200.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJogVel(4,720)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.0,"ax4.mon.highlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.1,"ax4.mon.lowlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.2,"ax4.mon.homesensor")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.3,"ax4.mon.extinterlock")"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(4,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(4,1000)"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(4,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(4,-1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(4,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(4,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(4,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(4,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(4,0.1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(4,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(4,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(4,1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(4,100)"
OK
            ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(4,200)"
OK
ecmcFileExist("ecmcAxis.db",1,1)
ecmcEpicsEnvSetCalcTernary(V_DRVL,"1>0",-1000 ,0)
ecmcEpicsEnvSetCalcTernary(V_DRVH,"1>0",1000 ,0)
dbLoadRecords("ecmcAxis.db","P=c6025a:,AXIS_NAME='M4',EGU='mm',PREC=3,AXIS_NO=4,HOMEPROC=0,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,VELO=720,V_DRVL=-1000,V_DRVH=1000")
epicsEnvUnset(V_DRVL)
epicsEnvUnset(V_DRVH)
# Add encoder PVS (always encoder number 1 (first encoder))
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=c6025a:,AXIS_NAME='M4',AXIS_NO=4,ENC_NO=1,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,EGU=mm,DESC=openloop1,HOME_PROC=15,VEL_TO_CAM=0,VEL_FRM_CAM=0,ACC=-1,DEC=-1,REF_HME=0,REF_STRT=-1,POST_ENA=-1,POST_POS=0,POS=0")
epicsEnvSet(ECMC_MOTOR_NAME, M4)
ecmcFileExist("ecmcAxisType.db",1,1)
   dbLoadRecords("ecmcAxisType.db","P=c6025a:,AXIS_NAME='M4',AXIS_TYPE=1,DRV_TYPE=0,TRAJ_TYPE=0")
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=c6025a:,DEV=c6025a:,AXIS_NAME='M4',AXIS_NO=4")
epicsEnvSet(ECMC_AXIS_NO,4)
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"3>=0", "","#- ")
ecmcFileExist(ecmcAxPrevAxis.db,1,1)
dbLoadRecords(ecmcAxPrevAxis.db,"NEXT_OBJ_ID=4,PREV_ECMC_P=c6025a:MCU-Cfg-AX3-")
epicsEnvUnset(ECMC_EXE_NEXT_AX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"3<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_AX)
epicsEnvSet(ECMC_PREV_AXIS_P,"c6025a:MCU-Cfg-AX4-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,4)
ecmcMotorRecordCreateAxis(MCU1, 4, 6, "powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;")
2023/12/13 10:54:47.387 ecmcMotorRecord:: setIntegerParam(4 motorPowerAutoOnOff_)=2
2023/12/13 10:54:47.387 ecmcMotorRecord:: setDoubleParam(4 motorPowerOnDelay_)=6
2023/12/13 10:54:47.387 ecmcMotorRecord:: setDoubleParam(4 motorPowerOffDelay_=-1
2023/12/13 10:54:47.387 ecmcMotorRecord:: setIntegerParam(4 motorPowerAutoOnOff_)=2
2023/12/13 10:54:47.387 ecmcMotorRecord:: updateCfgValue(4) oldpowerOffDelay=-1.000000 newpowerOffDelay=2.000000
2023/12/13 10:54:47.388 ecmcMotorRecord:: udateMotorLimitsRO(4) enabledHighAndLow=1 valid=1 fValueHigh=1000 fValueLow=-1000
2023/12/13 10:54:47.388 ecmcMotorRecord:: connected(4)
2023/12/13 10:54:47.388 ecmcMotorRecord:: initialPoll(4) status=0
ecmcFileExist(ecmcMotorRecord.template,1,1)
dbLoadRecords(ecmcMotorRecord.template,"PREFIX=c6025a:,MOTOR_NAME=M4,MOTOR_PORT=MCU1,AXIS_NO=4,DESC='Motor 4',EGU=mm,PREC=3,VELO=720,JVEL=72.0,JAR=720,ACCS=720,RDBD=0.1,DLLM=-1000.0,DHLM=1000.0,HOMEPROC=0,SREV=32768,UREV=3600.0,VMAX=1000")
epicsEnvUnset(VEL_FRM_CAM)
epicsEnvUnset(VEL_TO_CAM)
epicsEnvUnset(HOME_PROC)
epicsEnvUnset(HOME_POS)
epicsEnvUnset(ACC)
epicsEnvUnset(DEC)
epicsEnvUnset(REF_HME)
epicsEnvUnset(REF_STRT)
epicsEnvUnset(POST_ENA)
epicsEnvUnset(POST_POS)
epicsEnvUnset(ENC_EGU)
system "rm -rf /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax4.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax4"
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadYamlAxis.cmd FILE=/tmp/c6025a/EcMaster_0/tempFile.ax5
on error halt
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/pythonVenv.sh -d /tmp/c6025a/EcMaster_0/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/axisYamlJinja2.py -d /tmp/c6025a/EcMaster_0/ -T /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ -D /tmp/c6025a/EcMaster_0/tempFile.ax5 -o /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax5.axis"
2023/12/13 10:54:47.504 ecmcMotorRecord:: poll(4) mvnNRdy=1 bBusy=0 bExecute=0 bEnabled=0 atTarget=0 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000018
2023/12/13 10:54:47.504 ecmcMotorRecord:: poll(4) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:47.504 ecmcMotorRecord:: poll(4) callParamCallbacksUpdateError Error=4 old=-1 ErrID=0x0 old=0x0 Warn=0 nCmd=0 old=0 txt=NULL
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
ecmcFileExist("/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax5.axis",1)
iocshLoad "/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax5.axis"
epicsEnvSet(ECMC_AXIS_NO,5)
ecmcConfigOrDie "Cfg.CreateAxis(5,1,0,0)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("","ax5.health")"
OK
ecmcConfig "GetAxisEncConfigIndex(5)"
1
# Current encoder index beeing configured
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1
epicsEnvSet(ECMC_ENC_CFG_ID,1)
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s2.positionActual01","ax5.enc.actpos")"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(5,150.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(5,50.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(5,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncType(5,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncBits(5,16)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncOffset(5,0)"
OK
        epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_DESC,'openloop1')
        ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup(5,-1)"
OK
        epicsEnvSet(REF_STRT, -1)
        ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome(5,0)"
OK
        epicsEnvSet(REF_HME, 0)
        ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc(5,0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisHomeSeqId(5,15)"
OK
        epicsEnvSet(HOME_PROC, 15)
    
    
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.0","ax5.drv.control")"
OK
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.1","ax5.drv.status")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.velocitySetpoint01","ax5.drv.velocity")"
OK
        ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.2","ax5.drv.reducetorque")"
OK
        ecmcConfigOrDie "Cfg.SetAxisDrvReduceTorqueEnable(5, 1)"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.1","ax5.drv.reset")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.2","ax5.drv.warning")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.3","ax5.drv.alarm0")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.7","ax5.drv.alarm1")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.14","ax5.drv.alarm2")"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(5,3600)"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(5,32768)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(5,10)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(5,0.01)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(5,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(5,1.0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisCntrlInnerParams(5,10,0.01,1,0.0)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadband(5,0.01)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadbandTime(5,100)"
OK
    
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(5,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJerk(5,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisAcc(5,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisDec(5,720.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisVel(5,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(5,7200.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJogVel(5,720)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.0,"ax5.mon.highlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.1,"ax5.mon.lowlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.2,"ax5.mon.homesensor")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.3,"ax5.mon.extinterlock")"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(5,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(5,1000)"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(5,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(5,-1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(5,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(5,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(5,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(5,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(5,0.1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(5,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(5,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(5,1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(5,100)"
OK
            ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(5,200)"
OK
ecmcFileExist("ecmcAxis.db",1,1)
ecmcEpicsEnvSetCalcTernary(V_DRVL,"1>0",-1000 ,0)
ecmcEpicsEnvSetCalcTernary(V_DRVH,"1>0",1000 ,0)
dbLoadRecords("ecmcAxis.db","P=c6025a:,AXIS_NAME='M5',EGU='mm',PREC=3,AXIS_NO=5,HOMEPROC=0,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,VELO=720,V_DRVL=-1000,V_DRVH=1000")
epicsEnvUnset(V_DRVL)
epicsEnvUnset(V_DRVH)
# Add encoder PVS (always encoder number 1 (first encoder))
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=c6025a:,AXIS_NAME='M5',AXIS_NO=5,ENC_NO=1,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,EGU=mm,DESC=openloop1,HOME_PROC=15,VEL_TO_CAM=0,VEL_FRM_CAM=0,ACC=-1,DEC=-1,REF_HME=0,REF_STRT=-1,POST_ENA=-1,POST_POS=0,POS=0")
epicsEnvSet(ECMC_MOTOR_NAME, M5)
ecmcFileExist("ecmcAxisType.db",1,1)
   dbLoadRecords("ecmcAxisType.db","P=c6025a:,AXIS_NAME='M5',AXIS_TYPE=1,DRV_TYPE=0,TRAJ_TYPE=0")
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=c6025a:,DEV=c6025a:,AXIS_NAME='M5',AXIS_NO=5")
epicsEnvSet(ECMC_AXIS_NO,5)
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"4>=0", "","#- ")
ecmcFileExist(ecmcAxPrevAxis.db,1,1)
dbLoadRecords(ecmcAxPrevAxis.db,"NEXT_OBJ_ID=5,PREV_ECMC_P=c6025a:MCU-Cfg-AX4-")
epicsEnvUnset(ECMC_EXE_NEXT_AX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"4<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_AX)
epicsEnvSet(ECMC_PREV_AXIS_P,"c6025a:MCU-Cfg-AX5-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,5)
ecmcMotorRecordCreateAxis(MCU1, 5, 6, "powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;")
2023/12/13 10:54:48.018 ecmcMotorRecord:: setIntegerParam(5 motorPowerAutoOnOff_)=2
2023/12/13 10:54:48.018 ecmcMotorRecord:: setDoubleParam(5 motorPowerOnDelay_)=6
2023/12/13 10:54:48.019 ecmcMotorRecord:: setDoubleParam(5 motorPowerOffDelay_=-1
2023/12/13 10:54:48.019 ecmcMotorRecord:: setIntegerParam(5 motorPowerAutoOnOff_)=2
2023/12/13 10:54:48.019 ecmcMotorRecord:: updateCfgValue(5) oldpowerOffDelay=-1.000000 newpowerOffDelay=2.000000
2023/12/13 10:54:48.019 ecmcMotorRecord:: udateMotorLimitsRO(5) enabledHighAndLow=1 valid=1 fValueHigh=1000 fValueLow=-1000
2023/12/13 10:54:48.019 ecmcMotorRecord:: connected(5)
2023/12/13 10:54:48.019 ecmcMotorRecord:: initialPoll(5) status=0
ecmcFileExist(ecmcMotorRecord.template,1,1)
dbLoadRecords(ecmcMotorRecord.template,"PREFIX=c6025a:,MOTOR_NAME=M5,MOTOR_PORT=MCU1,AXIS_NO=5,DESC='Motor 5',EGU=mm,PREC=3,VELO=720,JVEL=72.0,JAR=720,ACCS=720,RDBD=0.1,DLLM=-1000.0,DHLM=1000.0,HOMEPROC=0,SREV=32768,UREV=3600.0,VMAX=1000")
epicsEnvUnset(VEL_FRM_CAM)
epicsEnvUnset(VEL_TO_CAM)
epicsEnvUnset(HOME_PROC)
epicsEnvUnset(HOME_POS)
epicsEnvUnset(ACC)
epicsEnvUnset(DEC)
epicsEnvUnset(REF_HME)
epicsEnvUnset(REF_STRT)
epicsEnvUnset(POST_ENA)
epicsEnvUnset(POST_POS)
epicsEnvUnset(ENC_EGU)
system "rm -rf /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax5.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax5"
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadYamlAxis.cmd FILE=/tmp/c6025a/EcMaster_0/tempFile.ax6
on error halt
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/pythonVenv.sh -d /tmp/c6025a/EcMaster_0/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/axisYamlJinja2.py -d /tmp/c6025a/EcMaster_0/ -T /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ -D /tmp/c6025a/EcMaster_0/tempFile.ax6 -o /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax6.axis"
2023/12/13 10:54:48.104 ecmcMotorRecord:: poll(5) mvnNRdy=1 bBusy=0 bExecute=0 bEnabled=0 atTarget=0 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000029
2023/12/13 10:54:48.104 ecmcMotorRecord:: poll(5) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:48.104 ecmcMotorRecord:: poll(5) callParamCallbacksUpdateError Error=4 old=-1 ErrID=0x0 old=0x0 Warn=0 nCmd=0 old=0 txt=NULL
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
ecmcFileExist("/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax6.axis",1)
iocshLoad "/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax6.axis"
epicsEnvSet(ECMC_AXIS_NO,6)
ecmcConfigOrDie "Cfg.CreateAxis(6,1,0,0)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("","ax6.health")"
OK
ecmcConfig "GetAxisEncConfigIndex(6)"
1
# Current encoder index beeing configured
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1
epicsEnvSet(ECMC_ENC_CFG_ID,1)
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.positionActual01","ax6.enc.actpos")"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(6,160.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(6,60.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(6,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncType(6,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncBits(6,16)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncOffset(6,0)"
OK
        epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_DESC,'openloop1')
        ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup(6,-1)"
OK
        epicsEnvSet(REF_STRT, -1)
        ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome(6,0)"
OK
        epicsEnvSet(REF_HME, 0)
        ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc(6,0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisHomeSeqId(6,15)"
OK
        epicsEnvSet(HOME_PROC, 15)
    
    
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.0","ax6.drv.control")"
OK
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.1","ax6.drv.status")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.velocitySetpoint01","ax6.drv.velocity")"
OK
        ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.2","ax6.drv.reducetorque")"
OK
        ecmcConfigOrDie "Cfg.SetAxisDrvReduceTorqueEnable(6, 1)"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.1","ax6.drv.reset")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.2","ax6.drv.warning")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.3","ax6.drv.alarm0")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.7","ax6.drv.alarm1")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.14","ax6.drv.alarm2")"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(6,3600)"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(6,32768)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(6,10)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(6,0.01)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(6,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(6,1.0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisCntrlInnerParams(6,10,0.01,1,0.0)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadband(6,0.01)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadbandTime(6,100)"
OK
    
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(6,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJerk(6,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisAcc(6,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisDec(6,720.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisVel(6,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(6,7200.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJogVel(6,720)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.0,"ax6.mon.highlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.1,"ax6.mon.lowlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.2,"ax6.mon.homesensor")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.3,"ax6.mon.extinterlock")"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(6,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(6,1000)"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(6,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(6,-1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(6,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(6,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(6,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(6,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(6,0.1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(6,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(6,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(6,1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(6,100)"
OK
            ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(6,200)"
OK
ecmcFileExist("ecmcAxis.db",1,1)
ecmcEpicsEnvSetCalcTernary(V_DRVL,"1>0",-1000 ,0)
ecmcEpicsEnvSetCalcTernary(V_DRVH,"1>0",1000 ,0)
dbLoadRecords("ecmcAxis.db","P=c6025a:,AXIS_NAME='M6',EGU='mm',PREC=3,AXIS_NO=6,HOMEPROC=0,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,VELO=720,V_DRVL=-1000,V_DRVH=1000")
epicsEnvUnset(V_DRVL)
epicsEnvUnset(V_DRVH)
# Add encoder PVS (always encoder number 1 (first encoder))
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=c6025a:,AXIS_NAME='M6',AXIS_NO=6,ENC_NO=1,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,EGU=mm,DESC=openloop1,HOME_PROC=15,VEL_TO_CAM=0,VEL_FRM_CAM=0,ACC=-1,DEC=-1,REF_HME=0,REF_STRT=-1,POST_ENA=-1,POST_POS=0,POS=0")
epicsEnvSet(ECMC_MOTOR_NAME, M6)
ecmcFileExist("ecmcAxisType.db",1,1)
   dbLoadRecords("ecmcAxisType.db","P=c6025a:,AXIS_NAME='M6',AXIS_TYPE=1,DRV_TYPE=0,TRAJ_TYPE=0")
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=c6025a:,DEV=c6025a:,AXIS_NAME='M6',AXIS_NO=6")
epicsEnvSet(ECMC_AXIS_NO,6)
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"5>=0", "","#- ")
ecmcFileExist(ecmcAxPrevAxis.db,1,1)
dbLoadRecords(ecmcAxPrevAxis.db,"NEXT_OBJ_ID=6,PREV_ECMC_P=c6025a:MCU-Cfg-AX5-")
epicsEnvUnset(ECMC_EXE_NEXT_AX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"5<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_AX)
epicsEnvSet(ECMC_PREV_AXIS_P,"c6025a:MCU-Cfg-AX6-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,6)
ecmcMotorRecordCreateAxis(MCU1, 6, 6, "powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;")
2023/12/13 10:54:48.650 ecmcMotorRecord:: setIntegerParam(6 motorPowerAutoOnOff_)=2
2023/12/13 10:54:48.650 ecmcMotorRecord:: setDoubleParam(6 motorPowerOnDelay_)=6
2023/12/13 10:54:48.650 ecmcMotorRecord:: setDoubleParam(6 motorPowerOffDelay_=-1
2023/12/13 10:54:48.650 ecmcMotorRecord:: setIntegerParam(6 motorPowerAutoOnOff_)=2
2023/12/13 10:54:48.651 ecmcMotorRecord:: updateCfgValue(6) oldpowerOffDelay=-1.000000 newpowerOffDelay=2.000000
2023/12/13 10:54:48.651 ecmcMotorRecord:: udateMotorLimitsRO(6) enabledHighAndLow=1 valid=1 fValueHigh=1000 fValueLow=-1000
2023/12/13 10:54:48.651 ecmcMotorRecord:: connected(6)
2023/12/13 10:54:48.651 ecmcMotorRecord:: initialPoll(6) status=0
ecmcFileExist(ecmcMotorRecord.template,1,1)
dbLoadRecords(ecmcMotorRecord.template,"PREFIX=c6025a:,MOTOR_NAME=M6,MOTOR_PORT=MCU1,AXIS_NO=6,DESC='Motor 6',EGU=mm,PREC=3,VELO=720,JVEL=72.0,JAR=720,ACCS=720,RDBD=0.1,DLLM=-1000.0,DHLM=1000.0,HOMEPROC=0,SREV=32768,UREV=3600.0,VMAX=1000")
epicsEnvUnset(VEL_FRM_CAM)
epicsEnvUnset(VEL_TO_CAM)
epicsEnvUnset(HOME_PROC)
epicsEnvUnset(HOME_POS)
epicsEnvUnset(ACC)
epicsEnvUnset(DEC)
epicsEnvUnset(REF_HME)
epicsEnvUnset(REF_STRT)
epicsEnvUnset(POST_ENA)
epicsEnvUnset(POST_POS)
epicsEnvUnset(ENC_EGU)
system "rm -rf /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax6.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax6"
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadYamlAxis.cmd FILE=/tmp/c6025a/EcMaster_0/tempFile.ax7
on error halt
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/pythonVenv.sh -d /tmp/c6025a/EcMaster_0/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/axisYamlJinja2.py -d /tmp/c6025a/EcMaster_0/ -T /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ -D /tmp/c6025a/EcMaster_0/tempFile.ax7 -o /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax7.axis"
2023/12/13 10:54:48.705 ecmcMotorRecord:: poll(6) mvnNRdy=1 bBusy=0 bExecute=0 bEnabled=0 atTarget=0 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000020
2023/12/13 10:54:48.705 ecmcMotorRecord:: poll(6) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:48.705 ecmcMotorRecord:: poll(6) callParamCallbacksUpdateError Error=4 old=-1 ErrID=0x0 old=0x0 Warn=0 nCmd=0 old=0 txt=NULL
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
ecmcFileExist("/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax7.axis",1)
iocshLoad "/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax7.axis"
epicsEnvSet(ECMC_AXIS_NO,7)
ecmcConfigOrDie "Cfg.CreateAxis(7,1,0,0)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("","ax7.health")"
OK
ecmcConfig "GetAxisEncConfigIndex(7)"
1
# Current encoder index beeing configured
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1
epicsEnvSet(ECMC_ENC_CFG_ID,1)
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s2.positionActual01","ax7.enc.actpos")"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(7,170.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(7,70.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(7,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncType(7,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncBits(7,16)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncOffset(7,0)"
OK
        epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_DESC,'openloop1')
        ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup(7,-1)"
OK
        epicsEnvSet(REF_STRT, -1)
        ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome(7,0)"
OK
        epicsEnvSet(REF_HME, 0)
        ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc(7,0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisHomeSeqId(7,15)"
OK
        epicsEnvSet(HOME_PROC, 15)
    
    
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.0","ax7.drv.control")"
OK
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.1","ax7.drv.status")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.velocitySetpoint01","ax7.drv.velocity")"
OK
        ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.2","ax7.drv.reducetorque")"
OK
        ecmcConfigOrDie "Cfg.SetAxisDrvReduceTorqueEnable(7, 1)"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.1","ax7.drv.reset")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.2","ax7.drv.warning")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.3","ax7.drv.alarm0")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.7","ax7.drv.alarm1")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.14","ax7.drv.alarm2")"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(7,3600)"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(7,32768)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(7,10)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(7,0.01)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(7,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(7,1.0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisCntrlInnerParams(7,10,0.01,1,0.0)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadband(7,0.01)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadbandTime(7,100)"
OK
    
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(7,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJerk(7,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisAcc(7,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisDec(7,720.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisVel(7,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(7,7200.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJogVel(7,720)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.0,"ax7.mon.highlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.1,"ax7.mon.lowlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.2,"ax7.mon.homesensor")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.3,"ax7.mon.extinterlock")"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(7,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(7,1000)"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(7,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(7,-1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(7,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(7,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(7,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(7,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(7,0.1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(7,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(7,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(7,1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(7,100)"
OK
            ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(7,200)"
OK
ecmcFileExist("ecmcAxis.db",1,1)
ecmcEpicsEnvSetCalcTernary(V_DRVL,"1>0",-1000 ,0)
ecmcEpicsEnvSetCalcTernary(V_DRVH,"1>0",1000 ,0)
dbLoadRecords("ecmcAxis.db","P=c6025a:,AXIS_NAME='M7',EGU='mm',PREC=3,AXIS_NO=7,HOMEPROC=0,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,VELO=720,V_DRVL=-1000,V_DRVH=1000")
epicsEnvUnset(V_DRVL)
epicsEnvUnset(V_DRVH)
# Add encoder PVS (always encoder number 1 (first encoder))
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=c6025a:,AXIS_NAME='M7',AXIS_NO=7,ENC_NO=1,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,EGU=mm,DESC=openloop1,HOME_PROC=15,VEL_TO_CAM=0,VEL_FRM_CAM=0,ACC=-1,DEC=-1,REF_HME=0,REF_STRT=-1,POST_ENA=-1,POST_POS=0,POS=0")
epicsEnvSet(ECMC_MOTOR_NAME, M7)
ecmcFileExist("ecmcAxisType.db",1,1)
   dbLoadRecords("ecmcAxisType.db","P=c6025a:,AXIS_NAME='M7',AXIS_TYPE=1,DRV_TYPE=0,TRAJ_TYPE=0")
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=c6025a:,DEV=c6025a:,AXIS_NAME='M7',AXIS_NO=7")
epicsEnvSet(ECMC_AXIS_NO,7)
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"6>=0", "","#- ")
ecmcFileExist(ecmcAxPrevAxis.db,1,1)
dbLoadRecords(ecmcAxPrevAxis.db,"NEXT_OBJ_ID=7,PREV_ECMC_P=c6025a:MCU-Cfg-AX6-")
epicsEnvUnset(ECMC_EXE_NEXT_AX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"6<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_AX)
epicsEnvSet(ECMC_PREV_AXIS_P,"c6025a:MCU-Cfg-AX7-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,7)
ecmcMotorRecordCreateAxis(MCU1, 7, 6, "powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;")
2023/12/13 10:54:49.281 ecmcMotorRecord:: setIntegerParam(7 motorPowerAutoOnOff_)=2
2023/12/13 10:54:49.281 ecmcMotorRecord:: setDoubleParam(7 motorPowerOnDelay_)=6
2023/12/13 10:54:49.281 ecmcMotorRecord:: setDoubleParam(7 motorPowerOffDelay_=-1
2023/12/13 10:54:49.281 ecmcMotorRecord:: setIntegerParam(7 motorPowerAutoOnOff_)=2
2023/12/13 10:54:49.281 ecmcMotorRecord:: updateCfgValue(7) oldpowerOffDelay=-1.000000 newpowerOffDelay=2.000000
2023/12/13 10:54:49.282 ecmcMotorRecord:: udateMotorLimitsRO(7) enabledHighAndLow=1 valid=1 fValueHigh=1000 fValueLow=-1000
2023/12/13 10:54:49.282 ecmcMotorRecord:: connected(7)
2023/12/13 10:54:49.282 ecmcMotorRecord:: initialPoll(7) status=0
ecmcFileExist(ecmcMotorRecord.template,1,1)
dbLoadRecords(ecmcMotorRecord.template,"PREFIX=c6025a:,MOTOR_NAME=M7,MOTOR_PORT=MCU1,AXIS_NO=7,DESC='Motor 7',EGU=mm,PREC=3,VELO=720,JVEL=72.0,JAR=720,ACCS=720,RDBD=0.1,DLLM=-1000.0,DHLM=1000.0,HOMEPROC=0,SREV=32768,UREV=3600.0,VMAX=1000")
epicsEnvUnset(VEL_FRM_CAM)
epicsEnvUnset(VEL_TO_CAM)
epicsEnvUnset(HOME_PROC)
epicsEnvUnset(HOME_POS)
epicsEnvUnset(ACC)
epicsEnvUnset(DEC)
epicsEnvUnset(REF_HME)
epicsEnvUnset(REF_STRT)
epicsEnvUnset(POST_ENA)
epicsEnvUnset(POST_POS)
epicsEnvUnset(ENC_EGU)
system "rm -rf /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax7.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax7"
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/loadYamlAxis.cmd FILE=/tmp/c6025a/EcMaster_0/tempFile.ax8
on error halt
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/pythonVenv.sh -d /tmp/c6025a/EcMaster_0/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/axisYamlJinja2.py -d /tmp/c6025a/EcMaster_0/ -T /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/ -D /tmp/c6025a/EcMaster_0/tempFile.ax8 -o /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax8.axis"
2023/12/13 10:54:49.305 ecmcMotorRecord:: poll(7) mvnNRdy=1 bBusy=0 bExecute=0 bEnabled=0 atTarget=0 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000020
2023/12/13 10:54:49.305 ecmcMotorRecord:: poll(7) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:49.305 ecmcMotorRecord:: poll(7) callParamCallbacksUpdateError Error=4 old=-1 ErrID=0x0 old=0x0 Warn=0 nCmd=0 old=0 txt=NULL
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
ecmcFileExist("/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax8.axis",1)
iocshLoad "/tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax8.axis"
epicsEnvSet(ECMC_AXIS_NO,8)
ecmcConfigOrDie "Cfg.CreateAxis(8,1,0,0)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("","ax8.health")"
OK
ecmcConfig "GetAxisEncConfigIndex(8)"
1
# Current encoder index beeing configured
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1
epicsEnvSet(ECMC_ENC_CFG_ID,1)
ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.positionActual01","ax8.enc.actpos")"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(8,180.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(8,80.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(8,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncType(8,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncBits(8,16)"
OK
ecmcConfigOrDie "Cfg.SetAxisEncOffset(8,0)"
OK
        epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_EGU,'mm')
    epicsEnvSet(ENC_DESC,'openloop1')
        ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup(8,-1)"
OK
        epicsEnvSet(REF_STRT, -1)
        ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome(8,0)"
OK
        epicsEnvSet(REF_HME, 0)
        ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc(8,0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisHomeSeqId(8,15)"
OK
        epicsEnvSet(HOME_PROC, 15)
    
    
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.0","ax8.drv.control")"
OK
       ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.1","ax8.drv.status")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.velocitySetpoint01","ax8.drv.velocity")"
OK
        ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.2","ax8.drv.reducetorque")"
OK
        ecmcConfigOrDie "Cfg.SetAxisDrvReduceTorqueEnable(8, 1)"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveControl01.1","ax8.drv.reset")"
OK
    ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.2","ax8.drv.warning")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.3","ax8.drv.alarm0")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.7","ax8.drv.alarm1")"
OK
            ecmcConfigOrDie "Cfg.LinkEcEntryToObject("ec0.s4.driveStatus01.14","ax8.drv.alarm2")"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(8,3600)"
OK
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(8,32768)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(8,10)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(8,0.01)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(8,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(8,1.0)"
OK
        ecmcConfigOrDie "Cfg.SetAxisCntrlInnerParams(8,10,0.01,1,0.0)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadband(8,0.01)"
OK
    ecmcConfigOrDie "Cfg.SetAxisCntrlDeadbandTime(8,100)"
OK
    
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(8,0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJerk(8,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisAcc(8,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisDec(8,720.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisVel(8,720)"
OK
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(8,7200.0)"
OK
ecmcConfigOrDie "Cfg.SetAxisJogVel(8,720)"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.0,"ax8.mon.highlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.1,"ax8.mon.lowlim")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.2,"ax8.mon.homesensor")"
OK
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s4.ONE.3,"ax8.mon.extinterlock")"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(8,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(8,1000)"
OK
            ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(8,1)"
OK
            ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(8,-1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(8,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(8,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(8,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(8,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(8,0.1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(8,100)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(8,1)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(8,1000)"
OK
        ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(8,100)"
OK
            ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(8,200)"
OK
ecmcFileExist("ecmcAxis.db",1,1)
ecmcEpicsEnvSetCalcTernary(V_DRVL,"1>0",-1000 ,0)
ecmcEpicsEnvSetCalcTernary(V_DRVH,"1>0",1000 ,0)
dbLoadRecords("ecmcAxis.db","P=c6025a:,AXIS_NAME='M8',EGU='mm',PREC=3,AXIS_NO=8,HOMEPROC=0,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,VELO=720,V_DRVL=-1000,V_DRVH=1000")
epicsEnvUnset(V_DRVL)
epicsEnvUnset(V_DRVH)
# Add encoder PVS (always encoder number 1 (first encoder))
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=c6025a:,AXIS_NAME='M8',AXIS_NO=8,ENC_NO=1,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,EGU=mm,DESC=openloop1,HOME_PROC=15,VEL_TO_CAM=0,VEL_FRM_CAM=0,ACC=-1,DEC=-1,REF_HME=0,REF_STRT=-1,POST_ENA=-1,POST_POS=0,POS=0")
epicsEnvSet(ECMC_MOTOR_NAME, M8)
ecmcFileExist("ecmcAxisType.db",1,1)
   dbLoadRecords("ecmcAxisType.db","P=c6025a:,AXIS_NAME='M8',AXIS_TYPE=1,DRV_TYPE=0,TRAJ_TYPE=0")
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=c6025a:,DEV=c6025a:,AXIS_NAME='M8',AXIS_NO=8")
epicsEnvSet(ECMC_AXIS_NO,8)
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"7>=0", "","#- ")
ecmcFileExist(ecmcAxPrevAxis.db,1,1)
dbLoadRecords(ecmcAxPrevAxis.db,"NEXT_OBJ_ID=8,PREV_ECMC_P=c6025a:MCU-Cfg-AX7-")
epicsEnvUnset(ECMC_EXE_NEXT_AX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"7<0", "","#- ")
epicsEnvUnset(ECMC_EXE_FIRST_AX)
epicsEnvSet(ECMC_PREV_AXIS_P,"c6025a:MCU-Cfg-AX8-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,8)
ecmcMotorRecordCreateAxis(MCU1, 8, 6, "powerAutoOnOff=2;powerOnDelay=6.0;powerOffDelay=2.0;")
2023/12/13 10:54:49.913 ecmcMotorRecord:: setIntegerParam(8 motorPowerAutoOnOff_)=2
2023/12/13 10:54:49.914 ecmcMotorRecord:: setDoubleParam(8 motorPowerOnDelay_)=6
2023/12/13 10:54:49.914 ecmcMotorRecord:: setDoubleParam(8 motorPowerOffDelay_=-1
2023/12/13 10:54:49.914 ecmcMotorRecord:: setIntegerParam(8 motorPowerAutoOnOff_)=2
2023/12/13 10:54:49.914 ecmcMotorRecord:: updateCfgValue(8) oldpowerOffDelay=-1.000000 newpowerOffDelay=2.000000
2023/12/13 10:54:49.914 ecmcMotorRecord:: udateMotorLimitsRO(8) enabledHighAndLow=1 valid=1 fValueHigh=1000 fValueLow=-1000
2023/12/13 10:54:49.914 ecmcMotorRecord:: connected(8)
2023/12/13 10:54:49.914 ecmcMotorRecord:: initialPoll(8) status=0
ecmcFileExist(ecmcMotorRecord.template,1,1)
dbLoadRecords(ecmcMotorRecord.template,"PREFIX=c6025a:,MOTOR_NAME=M8,MOTOR_PORT=MCU1,AXIS_NO=8,DESC='Motor 8',EGU=mm,PREC=3,VELO=720,JVEL=72.0,JAR=720,ACCS=720,RDBD=0.1,DLLM=-1000.0,DHLM=1000.0,HOMEPROC=0,SREV=32768,UREV=3600.0,VMAX=1000")
epicsEnvUnset(VEL_FRM_CAM)
epicsEnvUnset(VEL_TO_CAM)
epicsEnvUnset(HOME_PROC)
epicsEnvUnset(HOME_POS)
epicsEnvUnset(ACC)
epicsEnvUnset(DEC)
epicsEnvUnset(REF_HME)
epicsEnvUnset(REF_STRT)
epicsEnvUnset(POST_ENA)
epicsEnvUnset(POST_POS)
epicsEnvUnset(ENC_EGU)
system "rm -rf /tmp/c6025a/EcMaster_0//tmp/c6025a/EcMaster_0/tempFile.ax8.axis"
epicsEnvSet("ECMC_PREFIX"      "c6025a:")
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax8"
system "rm /tmp/c6025a/EcMaster_0/tempFile.ax.exe.cmd"
# go active
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/setAppMode.cmd
#==============================================================================
# setAppMode.cmd
ecmcFileExist("/gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/general.cmd",1)
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/sandst_a/R7.0.6/general.cmd
#==============================================================================
# general.cmd
ecmcFileExist("ecmcGeneral.db",1,1)
dbLoadRecords("ecmcGeneral.db","P=c6025a:,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,T_SMP_MS=10,TSE=0,ECMC_PROC_HOOK=")
# Examples of commands for info:
# ecmcReport <level> or asynReport <level>
# ecmcReport 3
# ecmcGrepParam <pattern>
# List all ecmc params for ethercat slave 2:
# ecmcGrepParam *s2*
#
ecmcEpicsEnvSetCalcTernary(ECMC_MASTER_CMD, "0>=0", "","#- ")
 ecmcFileExist("ecmcEc.db",1,1)
 dbLoadRecords("ecmcEc.db","P=c6025a:,ECMC_EC_MP=m,PORT=MC_CPU1,ADDR=0,TIMEOUT=1,MASTER_ID=0,T_SMP_MS=10,TSE=0")
ecmcConfigOrDie "Cfg.SetAppMode(1)"
2023/12/13 10:54:50.106 ecmcMotorRecord:: poll(8) mvnNRdy=1 bBusy=0 bExecute=0 bEnabled=0 atTarget=0 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000018
2023/12/13 10:54:50.106 ecmcMotorRecord:: poll(8) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:50.106 ecmcMotorRecord:: poll(8) callParamCallbacksUpdateError Error=4 old=-1 ErrID=0x0 old=0x0 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:50.963 EtherCAT bus ready (not scaning).
2023/12/13 10:54:50.966 INFO: Locking memory
2023/12/13 10:54:50.990 Starting up EtherCAT bus: 0 second(s). Max wait time 30 second(s).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:189: INFO (axis 1): Motion interlocked (type 16).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/ethercat/ecmcEcEntryLink.cpp/readEcEntryValue:126: ERROR_EC_ENTRY_EC_DOMAIN_ERROR (0x2100e).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisReal.cpp/execute:202: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:189: INFO (axis 2): Motion interlocked (type 16).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/ethercat/ecmcEcEntryLink.cpp/readEcEntryValue:126: ERROR_EC_ENTRY_EC_DOMAIN_ERROR (0x2100e).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisReal.cpp/execute:202: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:189: INFO (axis 3): Motion interlocked (type 16).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/ethercat/ecmcEcEntryLink.cpp/readEcEntryValue:126: ERROR_EC_ENTRY_EC_DOMAIN_ERROR (0x2100e).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisReal.cpp/execute:202: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:189: INFO (axis 4): Motion interlocked (type 16).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/ethercat/ecmcEcEntryLink.cpp/readEcEntryValue:126: ERROR_EC_ENTRY_EC_DOMAIN_ERROR (0x2100e).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisReal.cpp/execute:202: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:189: INFO (axis 5): Motion interlocked (type 16).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/ethercat/ecmcEcEntryLink.cpp/readEcEntryValue:126: ERROR_EC_ENTRY_EC_DOMAIN_ERROR (0x2100e).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisReal.cpp/execute:202: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:189: INFO (axis 6): Motion interlocked (type 16).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/ethercat/ecmcEcEntryLink.cpp/readEcEntryValue:126: ERROR_EC_ENTRY_EC_DOMAIN_ERROR (0x2100e).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisReal.cpp/execute:202: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:189: INFO (axis 7): Motion interlocked (type 16).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/ethercat/ecmcEcEntryLink.cpp/readEcEntryValue:126: ERROR_EC_ENTRY_EC_DOMAIN_ERROR (0x2100e).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisReal.cpp/execute:202: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:189: INFO (axis 8): Motion interlocked (type 16).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/ethercat/ecmcEcEntryLink.cpp/readEcEntryValue:126: ERROR_EC_ENTRY_EC_DOMAIN_ERROR (0x2100e).
2023/12/13 10:54:51.064 ../ecmc/devEcmcSup/motion/ecmcAxisReal.cpp/execute:202: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315).
2023/12/13 10:54:51.065 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:380: ERROR: Slave 1: Not operational (0x24011).
2023/12/13 10:54:51.065 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:385: ERROR_EC_SLAVE_NOT_OPERATIONAL (0x24011).
2023/12/13 10:54:51.065 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:380: ERROR: Slave 2: Not operational (0x24011).
2023/12/13 10:54:51.065 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:385: ERROR_EC_SLAVE_NOT_OPERATIONAL (0x24011).
2023/12/13 10:54:51.065 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:380: ERROR: Slave 3: Not operational (0x24011).
2023/12/13 10:54:51.065 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:385: ERROR_EC_SLAVE_NOT_OPERATIONAL (0x24011).
2023/12/13 10:54:51.065 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:380: ERROR: Slave 4: Not operational (0x24011).
2023/12/13 10:54:51.065 ../ecmc/devEcmcSup/ethercat/ecmcEcSlave.cpp/checkConfigState:385: ERROR_EC_SLAVE_NOT_OPERATIONAL (0x24011).
2023/12/13 10:54:51.065 ecmc::  Ax     PosSet     PosAct     PosErr    PosTarg   DistLeft    CntrOut   VelFFSet     VelAct   VelFFRaw VelRaw  Error Co CD St IL LI TS ES En Ex Bu Ta Hd L- L+ Ho
2023/12/13 10:54:51.065 ecmc::   8      0.000      0.000      0.000      0.000      0.000      0.000      0.000      0.000      0.000      0  14315  0  0  0 16 16  0  0 00  0  1  1  0  1  1  1
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(1) LLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(1) HLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(1) mvnNRdy=1 bBusy=1 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000027
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(1) bError=1 drvlocal.statusBinData.onChangeData.error=0x14315
2023/12/13 10:54:51.106 ecmcMotorRecord:: sErrorMessage(1)="ERROR_AXIS_HARDWARE_STATUS_NOT_OK"
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(1) callParamCallbacksUpdateError Error=1 old=4 ErrID=0x14315 old=0x0 Warn=0 nCmd=0 old=0 txt=E: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315)
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(2) LLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(2) HLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(2) mvnNRdy=1 bBusy=1 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000011
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(2) bError=1 drvlocal.statusBinData.onChangeData.error=0x14315
2023/12/13 10:54:51.106 ecmcMotorRecord:: sErrorMessage(2)="ERROR_AXIS_HARDWARE_STATUS_NOT_OK"
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(2) callParamCallbacksUpdateError Error=1 old=4 ErrID=0x14315 old=0x0 Warn=0 nCmd=0 old=0 txt=E: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315)
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(3) LLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(3) HLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(3) mvnNRdy=1 bBusy=1 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000010
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(3) bError=1 drvlocal.statusBinData.onChangeData.error=0x14315
2023/12/13 10:54:51.106 ecmcMotorRecord:: sErrorMessage(3)="ERROR_AXIS_HARDWARE_STATUS_NOT_OK"
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(3) callParamCallbacksUpdateError Error=1 old=4 ErrID=0x14315 old=0x0 Warn=0 nCmd=0 old=0 txt=E: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315)
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(4) LLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(4) HLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(4) mvnNRdy=1 bBusy=1 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000010
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(4) bError=1 drvlocal.statusBinData.onChangeData.error=0x14315
2023/12/13 10:54:51.106 ecmcMotorRecord:: sErrorMessage(4)="ERROR_AXIS_HARDWARE_STATUS_NOT_OK"
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(4) callParamCallbacksUpdateError Error=1 old=4 ErrID=0x14315 old=0x0 Warn=0 nCmd=0 old=0 txt=E: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315)
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(5) LLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(5) HLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(5) mvnNRdy=1 bBusy=1 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000010
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(5) bError=1 drvlocal.statusBinData.onChangeData.error=0x14315
2023/12/13 10:54:51.106 ecmcMotorRecord:: sErrorMessage(5)="ERROR_AXIS_HARDWARE_STATUS_NOT_OK"
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(5) callParamCallbacksUpdateError Error=1 old=4 ErrID=0x14315 old=0x0 Warn=0 nCmd=0 old=0 txt=E: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315)
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(6) LLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(6) HLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(6) mvnNRdy=1 bBusy=1 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000010
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(6) bError=1 drvlocal.statusBinData.onChangeData.error=0x14315
2023/12/13 10:54:51.106 ecmcMotorRecord:: sErrorMessage(6)="ERROR_AXIS_HARDWARE_STATUS_NOT_OK"
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(6) callParamCallbacksUpdateError Error=1 old=4 ErrID=0x14315 old=0x0 Warn=0 nCmd=0 old=0 txt=E: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315)
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(7) LLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(7) HLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(7) mvnNRdy=1 bBusy=1 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000010
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(7) bError=1 drvlocal.statusBinData.onChangeData.error=0x14315
2023/12/13 10:54:51.106 ecmcMotorRecord:: sErrorMessage(7)="ERROR_AXIS_HARDWARE_STATUS_NOT_OK"
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(7) callParamCallbacksUpdateError Error=1 old=4 ErrID=0x14315 old=0x0 Warn=0 nCmd=0 old=0 txt=E: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315)
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(8) LLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(8) HLS=0
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(8) mvnNRdy=1 bBusy=1 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000010
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(8) bError=1 drvlocal.statusBinData.onChangeData.error=0x14315
2023/12/13 10:54:51.106 ecmcMotorRecord:: sErrorMessage(8)="ERROR_AXIS_HARDWARE_STATUS_NOT_OK"
2023/12/13 10:54:51.106 ecmcMotorRecord:: poll(8) callParamCallbacksUpdateError Error=1 old=4 ErrID=0x14315 old=0x0 Warn=0 nCmd=0 old=0 txt=E: ERROR_AXIS_HARDWARE_STATUS_NOT_OK (0x14315)
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:195: INFO (axis 1): Motion interlock cleared.
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:195: INFO (axis 2): Motion interlock cleared.
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:195: INFO (axis 3): Motion interlock cleared.
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:195: INFO (axis 4): Motion interlock cleared.
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:195: INFO (axis 5): Motion interlock cleared.
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:195: INFO (axis 6): Motion interlock cleared.
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:195: INFO (axis 7): Motion interlock cleared.
2023/12/13 10:54:51.671 ../ecmc/devEcmcSup/motion/ecmcAxisData.cpp/refreshInterlocks:195: INFO (axis 8): Motion interlock cleared.
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/motion/ecmcEncoder.cpp/readHwActPos:419: INFO (axis 1): Encoder initialized (domain==true ).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/motion/ecmcEncoder.cpp/readHwActPos:419: INFO (axis 2): Encoder initialized (domain==true ).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/motion/ecmcEncoder.cpp/readHwActPos:419: INFO (axis 3): Encoder initialized (domain==true ).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/motion/ecmcEncoder.cpp/readHwActPos:419: INFO (axis 4): Encoder initialized (domain==true ).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/motion/ecmcEncoder.cpp/readHwActPos:419: INFO (axis 5): Encoder initialized (domain==true ).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/motion/ecmcEncoder.cpp/readHwActPos:419: INFO (axis 6): Encoder initialized (domain==true ).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/motion/ecmcEncoder.cpp/readHwActPos:419: INFO (axis 7): Encoder initialized (domain==true ).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/motion/ecmcEncoder.cpp/readHwActPos:419: INFO (axis 8): Encoder initialized (domain==true ).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.672 ../ecmc/devEcmcSup/main/ecmcError.cpp/errorReset:118: NO_ERROR (0x0).
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(1) mvnNRdy=0 bBusy=0 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000003
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(1) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(1) callParamCallbacksUpdateError Error=4 old=1 ErrID=0x0 old=0x14315 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(2) mvnNRdy=0 bBusy=0 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000002
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(2) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(2) callParamCallbacksUpdateError Error=4 old=1 ErrID=0x0 old=0x14315 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(3) mvnNRdy=0 bBusy=0 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000001
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(3) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(3) callParamCallbacksUpdateError Error=4 old=1 ErrID=0x0 old=0x14315 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:51.706 ecmcMotorRecord:: poll(4) mvnNRdy=0 bBusy=0 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000001
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(4) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(4) callParamCallbacksUpdateError Error=4 old=1 ErrID=0x0 old=0x14315 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(5) mvnNRdy=0 bBusy=0 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000002
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(5) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(5) callParamCallbacksUpdateError Error=4 old=1 ErrID=0x0 old=0x14315 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(6) mvnNRdy=0 bBusy=0 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000002
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(6) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(6) callParamCallbacksUpdateError Error=4 old=1 ErrID=0x0 old=0x14315 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(7) mvnNRdy=0 bBusy=0 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000001
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(7) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(7) callParamCallbacksUpdateError Error=4 old=1 ErrID=0x0 old=0x14315 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(8) mvnNRdy=0 bBusy=0 bExecute=0 bEnabled=0 atTarget=1 wf=0 ENC=0 fPos=0 fActPosition=0 time=0.000002
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(8) bError=0 drvlocal.statusBinData.onChangeData.error=0x0
2023/12/13 10:54:51.707 ecmcMotorRecord:: poll(8) callParamCallbacksUpdateError Error=4 old=1 ErrID=0x0 old=0x14315 Warn=0 nCmd=0 old=0 txt=NULL
2023/12/13 10:54:51.771 ecmc::   8      0.000      0.000      0.000      0.000      0.000      0.000      0.000      0.000      0.000      0      0  0  0  0  0  0  0  0 00  0  0  1  0  1  1  1
2023/12/13 10:54:52.990 EtherCAT bus started!
OK
iocInit
2023/12/13 10:54:52.991 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAtIocBuild (0). Allow callbacks: true.
Starting iocInit
2023/12/13 10:54:52.991 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAtBeginning (1). Allow callbacks: true.
############################################################################
## EPICS R7.0.6-2022-11-16
## Rev. PSI-7.0.6.1-8-0-g565ccae
############################################################################
2023/12/13 10:54:52.995 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterCallbackInit (2). Allow callbacks: true.
2023/12/13 10:54:52.997 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterCaLinkInit (3). Allow callbacks: true.
2023/12/13 10:54:52.997 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterInitDrvSup (4). Allow callbacks: true.
2023/12/13 10:54:52.998 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterInitRecSup (5). Allow callbacks: true.
2023/12/13 10:54:52.999 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterInitDevSup (6). Allow callbacks: true.
2023/12/13 10:54:53.003 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.error.reset linked to record (asyn reason 1).
2023/12/13 10:54:53.003 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.command linked to record (asyn reason 2).
2023/12/13 10:54:53.004 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.primencid linked to record (asyn reason 3).
2023/12/13 10:54:53.005 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.command linked to record (asyn reason 4).
2023/12/13 10:54:53.006 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.primencid linked to record (asyn reason 5).
2023/12/13 10:54:53.006 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.command linked to record (asyn reason 6).
2023/12/13 10:54:53.007 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.primencid linked to record (asyn reason 7).
2023/12/13 10:54:53.008 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.command linked to record (asyn reason 8).
2023/12/13 10:54:53.009 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.primencid linked to record (asyn reason 9).
2023/12/13 10:54:53.009 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.command linked to record (asyn reason 10).
2023/12/13 10:54:53.010 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.primencid linked to record (asyn reason 11).
2023/12/13 10:54:53.011 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.command linked to record (asyn reason 12).
2023/12/13 10:54:53.012 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.primencid linked to record (asyn reason 13).
2023/12/13 10:54:53.012 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.command linked to record (asyn reason 14).
2023/12/13 10:54:53.013 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.primencid linked to record (asyn reason 15).
2023/12/13 10:54:53.014 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.command linked to record (asyn reason 16).
2023/12/13 10:54:53.015 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.primencid linked to record (asyn reason 17).
2023/12/13 10:54:53.016 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.driveControl01 linked to record (asyn reason 18).
2023/12/13 10:54:53.016 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.velocitySetpoint01 linked to record (asyn reason 19).
2023/12/13 10:54:53.017 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.encoderControl01 linked to record (asyn reason 20).
2023/12/13 10:54:53.018 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.encoderValue01 linked to record (asyn reason 21).
2023/12/13 10:54:53.018 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.targpos linked to record (asyn reason 22).
2023/12/13 10:54:53.019 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.targvelo linked to record (asyn reason 23).
2023/12/13 10:54:53.020 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.targpos linked to record (asyn reason 24).
2023/12/13 10:54:53.020 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.targvelo linked to record (asyn reason 25).
2023/12/13 10:54:53.021 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.targpos linked to record (asyn reason 26).
2023/12/13 10:54:53.022 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.targvelo linked to record (asyn reason 27).
2023/12/13 10:54:53.023 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.targpos linked to record (asyn reason 28).
2023/12/13 10:54:53.023 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.targvelo linked to record (asyn reason 29).
2023/12/13 10:54:53.024 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.targpos linked to record (asyn reason 30).
2023/12/13 10:54:53.025 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.targvelo linked to record (asyn reason 31).
2023/12/13 10:54:53.026 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.targpos linked to record (asyn reason 32).
2023/12/13 10:54:53.027 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.targvelo linked to record (asyn reason 33).
2023/12/13 10:54:53.028 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.targpos linked to record (asyn reason 34).
2023/12/13 10:54:53.028 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.targvelo linked to record (asyn reason 35).
2023/12/13 10:54:53.029 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.targpos linked to record (asyn reason 36).
2023/12/13 10:54:53.030 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.targvelo linked to record (asyn reason 37).
2023/12/13 10:54:53.031 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.status01 linked to record (asyn reason 38).
2023/12/13 10:54:53.032 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.status02 linked to record (asyn reason 39).
2023/12/13 10:54:53.033 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.status03 linked to record (asyn reason 40).
2023/12/13 10:54:53.033 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.status04 linked to record (asyn reason 41).
2023/12/13 10:54:53.034 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s2.encoderStatus01 linked to record (asyn reason 42).
2023/12/13 10:54:53.035 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.driveStatus01 linked to record (asyn reason 43).
2023/12/13 10:54:53.036 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.encoderStatus01 linked to record (asyn reason 44).
2023/12/13 10:54:53.037 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.status linked to record (asyn reason 45).
2023/12/13 10:54:53.037 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.diagnostic linked to record (asyn reason 46).
2023/12/13 10:54:53.038 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.plc.expression linked to record (asyn reason 47).
2023/12/13 10:54:53.039 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.diagnostic linked to record (asyn reason 48).
2023/12/13 10:54:53.039 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.plc.expression linked to record (asyn reason 49).
2023/12/13 10:54:53.040 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.diagnostic linked to record (asyn reason 50).
2023/12/13 10:54:53.041 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.plc.expression linked to record (asyn reason 51).
2023/12/13 10:54:53.041 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.diagnostic linked to record (asyn reason 52).
2023/12/13 10:54:53.042 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.plc.expression linked to record (asyn reason 53).
2023/12/13 10:54:53.043 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.diagnostic linked to record (asyn reason 54).
2023/12/13 10:54:53.043 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.plc.expression linked to record (asyn reason 55).
2023/12/13 10:54:53.044 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.diagnostic linked to record (asyn reason 56).
2023/12/13 10:54:53.045 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.plc.expression linked to record (asyn reason 57).
2023/12/13 10:54:53.045 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.diagnostic linked to record (asyn reason 58).
2023/12/13 10:54:53.046 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.plc.expression linked to record (asyn reason 59).
2023/12/13 10:54:53.047 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.diagnostic linked to record (asyn reason 60).
2023/12/13 10:54:53.047 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.plc.expression linked to record (asyn reason 61).
2023/12/13 10:54:53.048 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.error.msg linked to record (asyn reason 62).
2023/12/13 10:54:53.049 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.updated linked to record (asyn reason 63).
2023/12/13 10:54:53.049 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.slavestatus linked to record (asyn reason 64).
2023/12/13 10:54:53.050 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s2.slavestatus linked to record (asyn reason 65).
2023/12/13 10:54:53.051 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.slavestatus linked to record (asyn reason 66).
2023/12/13 10:54:53.052 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.slavestatus linked to record (asyn reason 67).
2023/12/13 10:54:53.053 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.status linked to record (asyn reason 68).
2023/12/13 10:54:53.054 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.errorid linked to record (asyn reason 69).
2023/12/13 10:54:53.055 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.warningid linked to record (asyn reason 70).
2023/12/13 10:54:53.056 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.status linked to record (asyn reason 71).
2023/12/13 10:54:53.057 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.errorid linked to record (asyn reason 72).
2023/12/13 10:54:53.058 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.warningid linked to record (asyn reason 73).
2023/12/13 10:54:53.059 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.status linked to record (asyn reason 74).
2023/12/13 10:54:53.060 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.errorid linked to record (asyn reason 75).
2023/12/13 10:54:53.061 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.warningid linked to record (asyn reason 76).
2023/12/13 10:54:53.062 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.status linked to record (asyn reason 77).
2023/12/13 10:54:53.063 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.errorid linked to record (asyn reason 78).
2023/12/13 10:54:53.064 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.warningid linked to record (asyn reason 79).
2023/12/13 10:54:53.065 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.status linked to record (asyn reason 80).
2023/12/13 10:54:53.067 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.errorid linked to record (asyn reason 81).
2023/12/13 10:54:53.068 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.warningid linked to record (asyn reason 82).
2023/12/13 10:54:53.069 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.status linked to record (asyn reason 83).
2023/12/13 10:54:53.070 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.errorid linked to record (asyn reason 84).
2023/12/13 10:54:53.071 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.warningid linked to record (asyn reason 85).
2023/12/13 10:54:53.072 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.status linked to record (asyn reason 86).
2023/12/13 10:54:53.073 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.errorid linked to record (asyn reason 87).
2023/12/13 10:54:53.074 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.warningid linked to record (asyn reason 88).
2023/12/13 10:54:53.076 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.status linked to record (asyn reason 89).
2023/12/13 10:54:53.077 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.errorid linked to record (asyn reason 90).
2023/12/13 10:54:53.078 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.warningid linked to record (asyn reason 91).
2023/12/13 10:54:53.079 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.masterstatus linked to record (asyn reason 92).
2023/12/13 10:54:53.080 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.slavecounter linked to record (asyn reason 93).
2023/12/13 10:54:53.081 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.memmapcounter linked to record (asyn reason 94).
2023/12/13 10:54:53.083 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.entrycounter linked to record (asyn reason 95).
2023/12/13 10:54:53.084 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.dom0.domainfailcountertotal linked to record (asyn reason 96).
2023/12/13 10:54:53.085 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.dom0.domainstatus linked to record (asyn reason 97).
2023/12/13 10:54:53.086 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.binaryInput01 linked to record (asyn reason 98).
2023/12/13 10:54:53.088 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.binaryInput02 linked to record (asyn reason 99).
2023/12/13 10:54:53.089 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.binaryInput03 linked to record (asyn reason 100).
2023/12/13 10:54:53.091 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.binaryInput04 linked to record (asyn reason 101).
2023/12/13 10:54:53.093 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.binaryInput05 linked to record (asyn reason 102).
2023/12/13 10:54:53.094 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.binaryInput06 linked to record (asyn reason 103).
2023/12/13 10:54:53.096 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.binaryInput07 linked to record (asyn reason 104).
2023/12/13 10:54:53.098 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.binaryInput08 linked to record (asyn reason 105).
2023/12/13 10:54:53.100 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax1.plc.enable linked to record (asyn reason 106).
2023/12/13 10:54:53.101 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax1.plc.firstscan linked to record (asyn reason 107).
2023/12/13 10:54:53.103 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax2.plc.enable linked to record (asyn reason 108).
2023/12/13 10:54:53.105 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax2.plc.firstscan linked to record (asyn reason 109).
2023/12/13 10:54:53.107 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax3.plc.enable linked to record (asyn reason 110).
2023/12/13 10:54:53.109 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax3.plc.firstscan linked to record (asyn reason 111).
2023/12/13 10:54:53.111 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax4.plc.enable linked to record (asyn reason 112).
2023/12/13 10:54:53.113 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax4.plc.firstscan linked to record (asyn reason 113).
2023/12/13 10:54:53.115 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax5.plc.enable linked to record (asyn reason 114).
2023/12/13 10:54:53.117 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax5.plc.firstscan linked to record (asyn reason 115).
2023/12/13 10:54:53.119 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax6.plc.enable linked to record (asyn reason 116).
2023/12/13 10:54:53.121 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax6.plc.firstscan linked to record (asyn reason 117).
2023/12/13 10:54:53.124 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax7.plc.enable linked to record (asyn reason 118).
2023/12/13 10:54:53.126 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax7.plc.firstscan linked to record (asyn reason 119).
2023/12/13 10:54:53.128 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax8.plc.enable linked to record (asyn reason 120).
2023/12/13 10:54:53.131 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax8.plc.firstscan linked to record (asyn reason 121).
2023/12/13 10:54:53.133 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.ok linked to record (asyn reason 122).
2023/12/13 10:54:53.135 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.control linked to record (asyn reason 123).
2023/12/13 10:54:53.137 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.control linked to record (asyn reason 124).
2023/12/13 10:54:53.139 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.control linked to record (asyn reason 125).
2023/12/13 10:54:53.141 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.control linked to record (asyn reason 126).
2023/12/13 10:54:53.143 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.control linked to record (asyn reason 127).
2023/12/13 10:54:53.145 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.control linked to record (asyn reason 128).
2023/12/13 10:54:53.147 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.control linked to record (asyn reason 129).
2023/12/13 10:54:53.149 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.control linked to record (asyn reason 130).
2023/12/13 10:54:53.151 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.ONE linked to record (asyn reason 131).
2023/12/13 10:54:53.153 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.ZERO linked to record (asyn reason 132).
2023/12/13 10:54:53.155 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s2.ONE linked to record (asyn reason 133).
2023/12/13 10:54:53.157 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s2.ZERO linked to record (asyn reason 134).
2023/12/13 10:54:53.159 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.ONE linked to record (asyn reason 135).
2023/12/13 10:54:53.160 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s3.ZERO linked to record (asyn reason 136).
2023/12/13 10:54:53.162 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.ONE linked to record (asyn reason 137).
2023/12/13 10:54:53.164 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.ZERO linked to record (asyn reason 138).
2023/12/13 10:54:53.166 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.cmddata linked to record (asyn reason 139).
2023/12/13 10:54:53.168 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.cmddata linked to record (asyn reason 140).
2023/12/13 10:54:53.170 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.cmddata linked to record (asyn reason 141).
2023/12/13 10:54:53.172 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.cmddata linked to record (asyn reason 142).
2023/12/13 10:54:53.175 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.cmddata linked to record (asyn reason 143).
2023/12/13 10:54:53.177 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.cmddata linked to record (asyn reason 144).
2023/12/13 10:54:53.179 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.cmddata linked to record (asyn reason 145).
2023/12/13 10:54:53.181 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.cmddata linked to record (asyn reason 146).
2023/12/13 10:54:53.183 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.analogInput01 linked to record (asyn reason 147).
2023/12/13 10:54:53.185 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.analogInput02 linked to record (asyn reason 148).
2023/12/13 10:54:53.187 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.analogInput03 linked to record (asyn reason 149).
2023/12/13 10:54:53.189 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s1.analogInput04 linked to record (asyn reason 150).
2023/12/13 10:54:53.192 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s2.positionActual01 linked to record (asyn reason 151).
2023/12/13 10:54:53.196 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.positionActual01 linked to record (asyn reason 152).
2023/12/13 10:54:53.198 ecmcAsynPortDriver:drvUserCreate: Parameter ec0.s4.encoderLatchPostion01 linked to record (asyn reason 153).
2023/12/13 10:54:53.203 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.actpos linked to record (asyn reason 154).
2023/12/13 10:54:53.205 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.actvel linked to record (asyn reason 155).
2023/12/13 10:54:53.207 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.setpos linked to record (asyn reason 156).
2023/12/13 10:54:53.209 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.poserr linked to record (asyn reason 157).
2023/12/13 10:54:53.211 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax1.plc.error linked to record (asyn reason 158).
2023/12/13 10:54:53.213 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.actpos1 linked to record (asyn reason 159).
2023/12/13 10:54:53.215 ecmcAsynPortDriver:drvUserCreate: Parameter ax1.actvel1 linked to record (asyn reason 160).
2023/12/13 10:54:53.218 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.actpos linked to record (asyn reason 161).
2023/12/13 10:54:53.220 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.actvel linked to record (asyn reason 162).
2023/12/13 10:54:53.222 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.setpos linked to record (asyn reason 163).
2023/12/13 10:54:53.224 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.poserr linked to record (asyn reason 164).
2023/12/13 10:54:53.226 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax2.plc.error linked to record (asyn reason 165).
2023/12/13 10:54:53.229 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.actpos1 linked to record (asyn reason 166).
2023/12/13 10:54:53.231 ecmcAsynPortDriver:drvUserCreate: Parameter ax2.actvel1 linked to record (asyn reason 167).
2023/12/13 10:54:53.233 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.actpos linked to record (asyn reason 168).
2023/12/13 10:54:53.236 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.actvel linked to record (asyn reason 169).
2023/12/13 10:54:53.238 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.setpos linked to record (asyn reason 170).
2023/12/13 10:54:53.240 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.poserr linked to record (asyn reason 171).
2023/12/13 10:54:53.242 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax3.plc.error linked to record (asyn reason 172).
2023/12/13 10:54:53.245 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.actpos1 linked to record (asyn reason 173).
2023/12/13 10:54:53.247 ecmcAsynPortDriver:drvUserCreate: Parameter ax3.actvel1 linked to record (asyn reason 174).
2023/12/13 10:54:53.249 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.actpos linked to record (asyn reason 175).
2023/12/13 10:54:53.252 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.actvel linked to record (asyn reason 176).
2023/12/13 10:54:53.254 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.setpos linked to record (asyn reason 177).
2023/12/13 10:54:53.257 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.poserr linked to record (asyn reason 178).
2023/12/13 10:54:53.259 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax4.plc.error linked to record (asyn reason 179).
2023/12/13 10:54:53.262 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.actpos1 linked to record (asyn reason 180).
2023/12/13 10:54:53.264 ecmcAsynPortDriver:drvUserCreate: Parameter ax4.actvel1 linked to record (asyn reason 181).
2023/12/13 10:54:53.267 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.actpos linked to record (asyn reason 182).
2023/12/13 10:54:53.269 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.actvel linked to record (asyn reason 183).
2023/12/13 10:54:53.272 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.setpos linked to record (asyn reason 184).
2023/12/13 10:54:53.274 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.poserr linked to record (asyn reason 185).
2023/12/13 10:54:53.277 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax5.plc.error linked to record (asyn reason 186).
2023/12/13 10:54:53.279 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.actpos1 linked to record (asyn reason 187).
2023/12/13 10:54:53.282 ecmcAsynPortDriver:drvUserCreate: Parameter ax5.actvel1 linked to record (asyn reason 188).
2023/12/13 10:54:53.285 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.actpos linked to record (asyn reason 189).
2023/12/13 10:54:53.287 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.actvel linked to record (asyn reason 190).
2023/12/13 10:54:53.290 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.setpos linked to record (asyn reason 191).
2023/12/13 10:54:53.292 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.poserr linked to record (asyn reason 192).
2023/12/13 10:54:53.295 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax6.plc.error linked to record (asyn reason 193).
2023/12/13 10:54:53.297 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.actpos1 linked to record (asyn reason 194).
2023/12/13 10:54:53.300 ecmcAsynPortDriver:drvUserCreate: Parameter ax6.actvel1 linked to record (asyn reason 195).
2023/12/13 10:54:53.303 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.actpos linked to record (asyn reason 196).
2023/12/13 10:54:53.306 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.actvel linked to record (asyn reason 197).
2023/12/13 10:54:53.308 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.setpos linked to record (asyn reason 198).
2023/12/13 10:54:53.311 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.poserr linked to record (asyn reason 199).
2023/12/13 10:54:53.314 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax7.plc.error linked to record (asyn reason 200).
2023/12/13 10:54:53.316 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.actpos1 linked to record (asyn reason 201).
2023/12/13 10:54:53.319 ecmcAsynPortDriver:drvUserCreate: Parameter ax7.actvel1 linked to record (asyn reason 202).
2023/12/13 10:54:53.322 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.actpos linked to record (asyn reason 203).
2023/12/13 10:54:53.325 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.actvel linked to record (asyn reason 204).
2023/12/13 10:54:53.328 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.setpos linked to record (asyn reason 205).
2023/12/13 10:54:53.330 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.poserr linked to record (asyn reason 206).
2023/12/13 10:54:53.333 ecmcAsynPortDriver:drvUserCreate: Parameter plcs.ax8.plc.error linked to record (asyn reason 207).
2023/12/13 10:54:53.336 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.actpos1 linked to record (asyn reason 208).
2023/12/13 10:54:53.339 ecmcAsynPortDriver:drvUserCreate: Parameter ax8.actvel1 linked to record (asyn reason 209).
2023/12/13 10:54:53.342 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.appmode linked to record (asyn reason 210).
2023/12/13 10:54:53.345 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.error.id linked to record (asyn reason 211).
2023/12/13 10:54:53.348 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.latency.min linked to record (asyn reason 212).
2023/12/13 10:54:53.351 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.latency.max linked to record (asyn reason 213).
2023/12/13 10:54:53.353 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.period.min linked to record (asyn reason 214).
2023/12/13 10:54:53.356 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.period.max linked to record (asyn reason 215).
2023/12/13 10:54:53.359 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.execute.min linked to record (asyn reason 216).
2023/12/13 10:54:53.362 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.execute.max linked to record (asyn reason 217).
2023/12/13 10:54:53.365 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.send.min linked to record (asyn reason 218).
2023/12/13 10:54:53.368 ecmcAsynPortDriver:drvUserCreate: Parameter ecmc.thread.send.max linked to record (asyn reason 219).
2023/12/13 10:54:53.369 [devMotorAsyn.c:439  c6025a:M1] init_record c6025a:M1 position=0.000000 encoderPos=0.000000 velocity=0.000000 MSTAstatus=0x0b0a flagsValue=0x3f flagsWritten=0x3f pmr->mflg=0x0
2023/12/13 10:54:53.370 [devMotorAsyn.c:185  c6025a:M1] init_controller c6025a:M1 set encoder ratio=1.000000 status=0
2023/12/13 10:54:53.370 [devMotorAsyn.c:266  c6025a:M1] update_soft_limits c6025a:M1 RawHLM_RO=1000.000000 RawLLM_RO=-1000.000000 valid=1 DHLM_RO=1000.000000 DLLM_RO=-1000.000000
2023/12/13 10:54:53.370 [motorDevSup.c:327  c6025a:M1] PositionRestoreNeeded c6025a:M1 rstm=2 dval=0.000000 drbv=0.000000 pmr->rdbd=0.100000 rdbd=0.109863 pmr->mres=0.109863 pmr->mflg=0x3f dval_non_zero_pos_near_zero=0 ret=0
2023/12/13 10:54:53.370 [motorRecord.cc:782  c6025a:M1] init_re_init start neverPolled=0 stat=17 nsta=0
2023/12/13 10:54:53.370 [motorRecord.cc:720  c6025a:M1] enforceMinRetryDeadband spdb=0.100000 rdbd=0.100000 mres=0.109863
2023/12/13 10:54:53.370 [motorRecord.cc:4484 c6025a:M1] pmr->dhlm=1000 softLimitRO=1000
2023/12/13 10:54:53.370 [motorRecord.cc:4545 c6025a:M1] pmr->dllm=-1000 softLimitRO=-1000
2023/12/13 10:54:53.370 [motorRecord.cc:833  c6025a:M1] init_re_init  end dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000
2023/12/13 10:54:53.370 ecmcMotorRecord:: setIntegerParam(1 motorUpdateStatus_)=0
2023/12/13 10:54:53.370 [motorRecord.cc:968  c6025a:M1] init_record process_reason="callbackdata + soft limits" dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000 stat=0 msta=0xb0a neverPolled=0
2023/12/13 10:54:53.370 [devMotorAsyn.c:439  c6025a:M2] init_record c6025a:M2 position=0.000000 encoderPos=0.000000 velocity=0.000000 MSTAstatus=0x0b0a flagsValue=0x3f flagsWritten=0x3f pmr->mflg=0x0
2023/12/13 10:54:53.370 [devMotorAsyn.c:185  c6025a:M2] init_controller c6025a:M2 set encoder ratio=1.000000 status=0
2023/12/13 10:54:53.370 [devMotorAsyn.c:266  c6025a:M2] update_soft_limits c6025a:M2 RawHLM_RO=1000.000000 RawLLM_RO=-1000.000000 valid=1 DHLM_RO=1000.000000 DLLM_RO=-1000.000000
2023/12/13 10:54:53.371 [motorDevSup.c:327  c6025a:M2] PositionRestoreNeeded c6025a:M2 rstm=2 dval=0.000000 drbv=0.000000 pmr->rdbd=0.100000 rdbd=0.109863 pmr->mres=0.109863 pmr->mflg=0x3f dval_non_zero_pos_near_zero=0 ret=0
2023/12/13 10:54:53.371 [motorRecord.cc:782  c6025a:M2] init_re_init start neverPolled=0 stat=17 nsta=0
2023/12/13 10:54:53.371 [motorRecord.cc:720  c6025a:M2] enforceMinRetryDeadband spdb=0.100000 rdbd=0.100000 mres=0.109863
2023/12/13 10:54:53.371 [motorRecord.cc:4484 c6025a:M2] pmr->dhlm=1000 softLimitRO=1000
2023/12/13 10:54:53.371 [motorRecord.cc:4545 c6025a:M2] pmr->dllm=-1000 softLimitRO=-1000
2023/12/13 10:54:53.371 [motorRecord.cc:833  c6025a:M2] init_re_init  end dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000
2023/12/13 10:54:53.371 ecmcMotorRecord:: setIntegerParam(2 motorUpdateStatus_)=0
2023/12/13 10:54:53.371 [motorRecord.cc:968  c6025a:M2] init_record process_reason="callbackdata + soft limits" dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000 stat=0 msta=0xb0a neverPolled=0
2023/12/13 10:54:53.371 [devMotorAsyn.c:439  c6025a:M3] init_record c6025a:M3 position=0.000000 encoderPos=0.000000 velocity=0.000000 MSTAstatus=0x0b0a flagsValue=0x3f flagsWritten=0x3f pmr->mflg=0x0
2023/12/13 10:54:53.371 [devMotorAsyn.c:185  c6025a:M3] init_controller c6025a:M3 set encoder ratio=1.000000 status=0
2023/12/13 10:54:53.371 [devMotorAsyn.c:266  c6025a:M3] update_soft_limits c6025a:M3 RawHLM_RO=1000.000000 RawLLM_RO=-1000.000000 valid=1 DHLM_RO=1000.000000 DLLM_RO=-1000.000000
2023/12/13 10:54:53.371 [motorDevSup.c:327  c6025a:M3] PositionRestoreNeeded c6025a:M3 rstm=2 dval=0.000000 drbv=0.000000 pmr->rdbd=0.100000 rdbd=0.109863 pmr->mres=0.109863 pmr->mflg=0x3f dval_non_zero_pos_near_zero=0 ret=0
2023/12/13 10:54:53.371 [motorRecord.cc:782  c6025a:M3] init_re_init start neverPolled=0 stat=17 nsta=0
2023/12/13 10:54:53.371 [motorRecord.cc:720  c6025a:M3] enforceMinRetryDeadband spdb=0.100000 rdbd=0.100000 mres=0.109863
2023/12/13 10:54:53.372 [motorRecord.cc:4484 c6025a:M3] pmr->dhlm=1000 softLimitRO=1000
2023/12/13 10:54:53.372 [motorRecord.cc:4545 c6025a:M3] pmr->dllm=-1000 softLimitRO=-1000
2023/12/13 10:54:53.372 [motorRecord.cc:833  c6025a:M3] init_re_init  end dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000
2023/12/13 10:54:53.372 ecmcMotorRecord:: setIntegerParam(3 motorUpdateStatus_)=0
2023/12/13 10:54:53.372 [motorRecord.cc:968  c6025a:M3] init_record process_reason="callbackdata + soft limits" dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000 stat=0 msta=0xb0a neverPolled=0
2023/12/13 10:54:53.372 [devMotorAsyn.c:439  c6025a:M4] init_record c6025a:M4 position=0.000000 encoderPos=0.000000 velocity=0.000000 MSTAstatus=0x0b0a flagsValue=0x3f flagsWritten=0x3f pmr->mflg=0x0
2023/12/13 10:54:53.372 [devMotorAsyn.c:185  c6025a:M4] init_controller c6025a:M4 set encoder ratio=1.000000 status=0
2023/12/13 10:54:53.372 [devMotorAsyn.c:266  c6025a:M4] update_soft_limits c6025a:M4 RawHLM_RO=1000.000000 RawLLM_RO=-1000.000000 valid=1 DHLM_RO=1000.000000 DLLM_RO=-1000.000000
2023/12/13 10:54:53.372 [motorDevSup.c:327  c6025a:M4] PositionRestoreNeeded c6025a:M4 rstm=2 dval=0.000000 drbv=0.000000 pmr->rdbd=0.100000 rdbd=0.109863 pmr->mres=0.109863 pmr->mflg=0x3f dval_non_zero_pos_near_zero=0 ret=0
2023/12/13 10:54:53.372 [motorRecord.cc:782  c6025a:M4] init_re_init start neverPolled=0 stat=17 nsta=0
2023/12/13 10:54:53.372 [motorRecord.cc:720  c6025a:M4] enforceMinRetryDeadband spdb=0.100000 rdbd=0.100000 mres=0.109863
2023/12/13 10:54:53.372 [motorRecord.cc:4484 c6025a:M4] pmr->dhlm=1000 softLimitRO=1000
2023/12/13 10:54:53.372 [motorRecord.cc:4545 c6025a:M4] pmr->dllm=-1000 softLimitRO=-1000
2023/12/13 10:54:53.372 [motorRecord.cc:833  c6025a:M4] init_re_init  end dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000
2023/12/13 10:54:53.373 ecmcMotorRecord:: setIntegerParam(4 motorUpdateStatus_)=0
2023/12/13 10:54:53.373 [motorRecord.cc:968  c6025a:M4] init_record process_reason="callbackdata + soft limits" dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000 stat=0 msta=0xb0a neverPolled=0
2023/12/13 10:54:53.373 [devMotorAsyn.c:439  c6025a:M5] init_record c6025a:M5 position=0.000000 encoderPos=0.000000 velocity=0.000000 MSTAstatus=0x0b0a flagsValue=0x3f flagsWritten=0x3f pmr->mflg=0x0
2023/12/13 10:54:53.373 [devMotorAsyn.c:185  c6025a:M5] init_controller c6025a:M5 set encoder ratio=1.000000 status=0
2023/12/13 10:54:53.373 [devMotorAsyn.c:266  c6025a:M5] update_soft_limits c6025a:M5 RawHLM_RO=1000.000000 RawLLM_RO=-1000.000000 valid=1 DHLM_RO=1000.000000 DLLM_RO=-1000.000000
2023/12/13 10:54:53.373 [motorDevSup.c:327  c6025a:M5] PositionRestoreNeeded c6025a:M5 rstm=2 dval=0.000000 drbv=0.000000 pmr->rdbd=0.100000 rdbd=0.109863 pmr->mres=0.109863 pmr->mflg=0x3f dval_non_zero_pos_near_zero=0 ret=0
2023/12/13 10:54:53.373 [motorRecord.cc:782  c6025a:M5] init_re_init start neverPolled=0 stat=17 nsta=0
2023/12/13 10:54:53.373 [motorRecord.cc:720  c6025a:M5] enforceMinRetryDeadband spdb=0.100000 rdbd=0.100000 mres=0.109863
2023/12/13 10:54:53.373 [motorRecord.cc:4484 c6025a:M5] pmr->dhlm=1000 softLimitRO=1000
2023/12/13 10:54:53.373 [motorRecord.cc:4545 c6025a:M5] pmr->dllm=-1000 softLimitRO=-1000
2023/12/13 10:54:53.373 [motorRecord.cc:833  c6025a:M5] init_re_init  end dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000
2023/12/13 10:54:53.373 ecmcMotorRecord:: setIntegerParam(5 motorUpdateStatus_)=0
2023/12/13 10:54:53.373 [motorRecord.cc:968  c6025a:M5] init_record process_reason="callbackdata + soft limits" dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000 stat=0 msta=0xb0a neverPolled=0
2023/12/13 10:54:53.373 [devMotorAsyn.c:439  c6025a:M6] init_record c6025a:M6 position=0.000000 encoderPos=0.000000 velocity=0.000000 MSTAstatus=0x0b0a flagsValue=0x3f flagsWritten=0x3f pmr->mflg=0x0
2023/12/13 10:54:53.374 [devMotorAsyn.c:185  c6025a:M6] init_controller c6025a:M6 set encoder ratio=1.000000 status=0
2023/12/13 10:54:53.374 [devMotorAsyn.c:266  c6025a:M6] update_soft_limits c6025a:M6 RawHLM_RO=1000.000000 RawLLM_RO=-1000.000000 valid=1 DHLM_RO=1000.000000 DLLM_RO=-1000.000000
2023/12/13 10:54:53.374 [motorDevSup.c:327  c6025a:M6] PositionRestoreNeeded c6025a:M6 rstm=2 dval=0.000000 drbv=0.000000 pmr->rdbd=0.100000 rdbd=0.109863 pmr->mres=0.109863 pmr->mflg=0x3f dval_non_zero_pos_near_zero=0 ret=0
2023/12/13 10:54:53.374 [motorRecord.cc:782  c6025a:M6] init_re_init start neverPolled=0 stat=17 nsta=0
2023/12/13 10:54:53.374 [motorRecord.cc:720  c6025a:M6] enforceMinRetryDeadband spdb=0.100000 rdbd=0.100000 mres=0.109863
2023/12/13 10:54:53.374 [motorRecord.cc:4484 c6025a:M6] pmr->dhlm=1000 softLimitRO=1000
2023/12/13 10:54:53.374 [motorRecord.cc:4545 c6025a:M6] pmr->dllm=-1000 softLimitRO=-1000
2023/12/13 10:54:53.374 [motorRecord.cc:833  c6025a:M6] init_re_init  end dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000
2023/12/13 10:54:53.374 ecmcMotorRecord:: setIntegerParam(6 motorUpdateStatus_)=0
2023/12/13 10:54:53.374 [motorRecord.cc:968  c6025a:M6] init_record process_reason="callbackdata + soft limits" dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000 stat=0 msta=0xb0a neverPolled=0
2023/12/13 10:54:53.374 [devMotorAsyn.c:439  c6025a:M7] init_record c6025a:M7 position=0.000000 encoderPos=0.000000 velocity=0.000000 MSTAstatus=0x0b0a flagsValue=0x3f flagsWritten=0x3f pmr->mflg=0x0
2023/12/13 10:54:53.374 [devMotorAsyn.c:185  c6025a:M7] init_controller c6025a:M7 set encoder ratio=1.000000 status=0
2023/12/13 10:54:53.374 [devMotorAsyn.c:266  c6025a:M7] update_soft_limits c6025a:M7 RawHLM_RO=1000.000000 RawLLM_RO=-1000.000000 valid=1 DHLM_RO=1000.000000 DLLM_RO=-1000.000000
2023/12/13 10:54:53.374 [motorDevSup.c:327  c6025a:M7] PositionRestoreNeeded c6025a:M7 rstm=2 dval=0.000000 drbv=0.000000 pmr->rdbd=0.100000 rdbd=0.109863 pmr->mres=0.109863 pmr->mflg=0x3f dval_non_zero_pos_near_zero=0 ret=0
2023/12/13 10:54:53.374 [motorRecord.cc:782  c6025a:M7] init_re_init start neverPolled=0 stat=17 nsta=0
2023/12/13 10:54:53.375 [motorRecord.cc:720  c6025a:M7] enforceMinRetryDeadband spdb=0.100000 rdbd=0.100000 mres=0.109863
2023/12/13 10:54:53.375 [motorRecord.cc:4484 c6025a:M7] pmr->dhlm=1000 softLimitRO=1000
2023/12/13 10:54:53.375 [motorRecord.cc:4545 c6025a:M7] pmr->dllm=-1000 softLimitRO=-1000
2023/12/13 10:54:53.375 [motorRecord.cc:833  c6025a:M7] init_re_init  end dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000
2023/12/13 10:54:53.375 ecmcMotorRecord:: setIntegerParam(7 motorUpdateStatus_)=0
2023/12/13 10:54:53.375 [motorRecord.cc:968  c6025a:M7] init_record process_reason="callbackdata + soft limits" dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000 stat=0 msta=0xb0a neverPolled=0
2023/12/13 10:54:53.375 [devMotorAsyn.c:439  c6025a:M8] init_record c6025a:M8 position=0.000000 encoderPos=0.000000 velocity=0.000000 MSTAstatus=0x0b0a flagsValue=0x3f flagsWritten=0x3f pmr->mflg=0x0
2023/12/13 10:54:53.375 [devMotorAsyn.c:185  c6025a:M8] init_controller c6025a:M8 set encoder ratio=1.000000 status=0
2023/12/13 10:54:53.375 [devMotorAsyn.c:266  c6025a:M8] update_soft_limits c6025a:M8 RawHLM_RO=1000.000000 RawLLM_RO=-1000.000000 valid=1 DHLM_RO=1000.000000 DLLM_RO=-1000.000000
2023/12/13 10:54:53.375 [motorDevSup.c:327  c6025a:M8] PositionRestoreNeeded c6025a:M8 rstm=2 dval=0.000000 drbv=0.000000 pmr->rdbd=0.100000 rdbd=0.109863 pmr->mres=0.109863 pmr->mflg=0x3f dval_non_zero_pos_near_zero=0 ret=0
2023/12/13 10:54:53.375 [motorRecord.cc:782  c6025a:M8] init_re_init start neverPolled=0 stat=17 nsta=0
2023/12/13 10:54:53.375 [motorRecord.cc:720  c6025a:M8] enforceMinRetryDeadband spdb=0.100000 rdbd=0.100000 mres=0.109863
2023/12/13 10:54:53.375 [motorRecord.cc:4484 c6025a:M8] pmr->dhlm=1000 softLimitRO=1000
2023/12/13 10:54:53.376 [motorRecord.cc:4545 c6025a:M8] pmr->dllm=-1000 softLimitRO=-1000
2023/12/13 10:54:53.376 [motorRecord.cc:833  c6025a:M8] init_re_init  end dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000
2023/12/13 10:54:53.376 ecmcMotorRecord:: setIntegerParam(8 motorUpdateStatus_)=0
2023/12/13 10:54:53.376 [motorRecord.cc:968  c6025a:M8] init_record process_reason="callbackdata + soft limits" dval=0.000000 drbv=0.000000 rdbd=0.100000 spdb=0.100000 stat=0 msta=0xb0a neverPolled=0
2023/12/13 10:54:53.386 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterInitDatabase (7). Allow callbacks: true.
2023/12/13 10:54:53.386 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterFinishDevSup (8). Allow callbacks: true.
2023/12/13 10:54:53.898 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterScanInit (9). Allow callbacks: true.
2023/12/13 10:54:53.902 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterInitialProcess (10). Allow callbacks: true.
2023/12/13 10:54:53.904 ecmcAsynPortDriver:getEpicsState: EPICS state: Unknown state (11). Allow callbacks: true.
2023/12/13 10:54:53.904 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterIocBuilt (12). Allow callbacks: true.
2023/12/13 10:54:53.912 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAtIocRun (13). Allow callbacks: true.
2023/12/13 10:54:53.914 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterDatabaseRunning (14). Allow callbacks: true.
2023/12/13 10:54:53.917 ../ecmc/devEcmcSup/motion/ecmcAxisBase.cpp/axisAsynWriteCmdData:2620: INFO (axis 1): Write: Command Data = 0x0.
2023/12/13 10:54:53.917 ../ecmc/devEcmcSup/motion/ecmcAxisBase.cpp/axisAsynWriteCmdData:2620: INFO (axis 2): Write: Command Data = 0x0.
2023/12/13 10:54:53.917 ../ecmc/devEcmcSup/motion/ecmcAxisBase.cpp/axisAsynWriteCmdData:2620: INFO (axis 3): Write: Command Data = 0x0.
2023/12/13 10:54:53.917 ../ecmc/devEcmcSup/motion/ecmcAxisBase.cpp/axisAsynWriteCmdData:2620: INFO (axis 4): Write: Command Data = 0x0.
2023/12/13 10:54:53.917 ../ecmc/devEcmcSup/motion/ecmcAxisBase.cpp/axisAsynWriteCmdData:2620: INFO (axis 5): Write: Command Data = 0x0.
2023/12/13 10:54:53.917 ../ecmc/devEcmcSup/motion/ecmcAxisBase.cpp/axisAsynWriteCmdData:2620: INFO (axis 6): Write: Command Data = 0x0.
2023/12/13 10:54:53.917 ../ecmc/devEcmcSup/motion/ecmcAxisBase.cpp/axisAsynWriteCmdData:2620: INFO (axis 7): Write: Command Data = 0x0.
2023/12/13 10:54:53.917 ../ecmc/devEcmcSup/motion/ecmcAxisBase.cpp/axisAsynWriteCmdData:2620: INFO (axis 8): Write: Command Data = 0x0.
2023/12/13 10:54:53.918 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterInterruptAccept (28). Allow callbacks: true.
2023/12/13 10:54:53.919 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterCaServerRunning (15). Allow callbacks: true.
2023/12/13 10:54:53.919 ecmcAsynPortDriver:getEpicsState: EPICS state: Unknown state (29). Allow callbacks: true.
iocRun: All initialization complete
2023/12/13 10:54:53.928 ecmcAsynPortDriver:getEpicsState: EPICS state: initHookAfterIocRunning (16). Allow callbacks: true.
epicsEnvSet IOCSH_PS1,"c6025a> "
c6025a> dbl
c6025a:m0s004-Enc01-LtchAutRst
c6025a:M1-MtnCmd_
c6025a:M2-MtnCmd_
c6025a:M3-MtnCmd_
c6025a:M4-MtnCmd_
c6025a:M5-MtnCmd_
c6025a:M6-MtnCmd_
c6025a:M7-MtnCmd_
c6025a:M8-MtnCmd_
c6025a:m0s004-Enc01-LtchRst
c6025a:MCU-Cfg-Info
c6025a:MCU-Cfg-Naming
c6025a:MCU-Cfg-Mode
c6025a:MCU-Cfg-PVA
c6025a:MCU-Cfg-AX1-Pfx
c6025a:MCU-Cfg-AX1-Nam
c6025a:MCU-Cfg-AX1-PfxNam
c6025a:M1-DbgStrToLOG
c6025a:MCU-Cfg-AX2-Pfx
c6025a:MCU-Cfg-AX2-Nam
c6025a:MCU-Cfg-AX2-PfxNam
c6025a:M2-DbgStrToLOG
c6025a:MCU-Cfg-AX3-Pfx
c6025a:MCU-Cfg-AX3-Nam
c6025a:MCU-Cfg-AX3-PfxNam
c6025a:M3-DbgStrToLOG
c6025a:MCU-Cfg-AX4-Pfx
c6025a:MCU-Cfg-AX4-Nam
c6025a:MCU-Cfg-AX4-PfxNam
c6025a:M4-DbgStrToLOG
c6025a:MCU-Cfg-AX5-Pfx
c6025a:MCU-Cfg-AX5-Nam
c6025a:MCU-Cfg-AX5-PfxNam
c6025a:M5-DbgStrToLOG
c6025a:MCU-Cfg-AX6-Pfx
c6025a:MCU-Cfg-AX6-Nam
c6025a:MCU-Cfg-AX6-PfxNam
c6025a:M6-DbgStrToLOG
c6025a:MCU-Cfg-AX7-Pfx
c6025a:MCU-Cfg-AX7-Nam
c6025a:MCU-Cfg-AX7-PfxNam
c6025a:M7-DbgStrToLOG
c6025a:MCU-Cfg-AX8-Pfx
c6025a:MCU-Cfg-AX8-Nam
c6025a:MCU-Cfg-AX8-PfxNam
c6025a:M8-DbgStrToLOG
c6025a:MCU-Cfg-Eng-Mode
c6025a:m0s004-Enc01-LchAutRstSp
c6025a:M1-EnaCmd
c6025a:M1-ExeCmd
c6025a:M1-StpCmd
c6025a:M1-RstCmd
c6025a:M1-EncSrcTyp-Cmd
c6025a:M1-TrjSrcTyp-Cmd
c6025a:M1-PLC-EnaCmd
c6025a:M1-CmdFrmPLCCmd
c6025a:M1-SftLimBwdEna
c6025a:M1-SftLimFwdEna
c6025a:M2-EnaCmd
c6025a:M2-ExeCmd
c6025a:M2-StpCmd
c6025a:M2-RstCmd
c6025a:M2-EncSrcTyp-Cmd
c6025a:M2-TrjSrcTyp-Cmd
c6025a:M2-PLC-EnaCmd
c6025a:M2-CmdFrmPLCCmd
c6025a:M2-SftLimBwdEna
c6025a:M2-SftLimFwdEna
c6025a:M3-EnaCmd
c6025a:M3-ExeCmd
c6025a:M3-StpCmd
c6025a:M3-RstCmd
c6025a:M3-EncSrcTyp-Cmd
c6025a:M3-TrjSrcTyp-Cmd
c6025a:M3-PLC-EnaCmd
c6025a:M3-CmdFrmPLCCmd
c6025a:M3-SftLimBwdEna
c6025a:M3-SftLimFwdEna
c6025a:M4-EnaCmd
c6025a:M4-ExeCmd
c6025a:M4-StpCmd
c6025a:M4-RstCmd
c6025a:M4-EncSrcTyp-Cmd
c6025a:M4-TrjSrcTyp-Cmd
c6025a:M4-PLC-EnaCmd
c6025a:M4-CmdFrmPLCCmd
c6025a:M4-SftLimBwdEna
c6025a:M4-SftLimFwdEna
c6025a:M5-EnaCmd
c6025a:M5-ExeCmd
c6025a:M5-StpCmd
c6025a:M5-RstCmd
c6025a:M5-EncSrcTyp-Cmd
c6025a:M5-TrjSrcTyp-Cmd
c6025a:M5-PLC-EnaCmd
c6025a:M5-CmdFrmPLCCmd
c6025a:M5-SftLimBwdEna
c6025a:M5-SftLimFwdEna
c6025a:M6-EnaCmd
c6025a:M6-ExeCmd
c6025a:M6-StpCmd
c6025a:M6-RstCmd
c6025a:M6-EncSrcTyp-Cmd
c6025a:M6-TrjSrcTyp-Cmd
c6025a:M6-PLC-EnaCmd
c6025a:M6-CmdFrmPLCCmd
c6025a:M6-SftLimBwdEna
c6025a:M6-SftLimFwdEna
c6025a:M7-EnaCmd
c6025a:M7-ExeCmd
c6025a:M7-StpCmd
c6025a:M7-RstCmd
c6025a:M7-EncSrcTyp-Cmd
c6025a:M7-TrjSrcTyp-Cmd
c6025a:M7-PLC-EnaCmd
c6025a:M7-CmdFrmPLCCmd
c6025a:M7-SftLimBwdEna
c6025a:M7-SftLimFwdEna
c6025a:M8-EnaCmd
c6025a:M8-ExeCmd
c6025a:M8-StpCmd
c6025a:M8-RstCmd
c6025a:M8-EncSrcTyp-Cmd
c6025a:M8-TrjSrcTyp-Cmd
c6025a:M8-PLC-EnaCmd
c6025a:M8-CmdFrmPLCCmd
c6025a:M8-SftLimBwdEna
c6025a:M8-SftLimFwdEna
c6025a:MCU-ErrRst
c6025a:M1-Enc01-HmeProc
c6025a:M1-Type
c6025a:M1-DrvType
c6025a:M1-TrajType
c6025a:M1-HomProc-RB
c6025a:M2-Enc01-HmeProc
c6025a:M2-Type
c6025a:M2-DrvType
c6025a:M2-TrajType
c6025a:M2-HomProc-RB
c6025a:M3-Enc01-HmeProc
c6025a:M3-Type
c6025a:M3-DrvType
c6025a:M3-TrajType
c6025a:M3-HomProc-RB
c6025a:M4-Enc01-HmeProc
c6025a:M4-Type
c6025a:M4-DrvType
c6025a:M4-TrajType
c6025a:M4-HomProc-RB
c6025a:M5-Enc01-HmeProc
c6025a:M5-Type
c6025a:M5-DrvType
c6025a:M5-TrajType
c6025a:M5-HomProc-RB
c6025a:M6-Enc01-HmeProc
c6025a:M6-Type
c6025a:M6-DrvType
c6025a:M6-TrajType
c6025a:M6-HomProc-RB
c6025a:M7-Enc01-HmeProc
c6025a:M7-Type
c6025a:M7-DrvType
c6025a:M7-TrajType
c6025a:M7-HomProc-RB
c6025a:M8-Enc01-HmeProc
c6025a:M8-Type
c6025a:M8-DrvType
c6025a:M8-TrajType
c6025a:M8-HomProc-RB
c6025a:m0s004-Enc01-LtchCmd
c6025a:M1-MtnCmd
c6025a:M1-movVelCmd
c6025a:M1-movRelCmd
c6025a:M1-movAbsCmd
c6025a:M1-movHomCmd
c6025a:M1-SetEncIdCmd-RB
c6025a:M2-MtnCmd
c6025a:M2-movVelCmd
c6025a:M2-movRelCmd
c6025a:M2-movAbsCmd
c6025a:M2-movHomCmd
c6025a:M2-SetEncIdCmd-RB
c6025a:M3-MtnCmd
c6025a:M3-movVelCmd
c6025a:M3-movRelCmd
c6025a:M3-movAbsCmd
c6025a:M3-movHomCmd
c6025a:M3-SetEncIdCmd-RB
c6025a:M4-MtnCmd
c6025a:M4-movVelCmd
c6025a:M4-movRelCmd
c6025a:M4-movAbsCmd
c6025a:M4-movHomCmd
c6025a:M4-SetEncIdCmd-RB
c6025a:M5-MtnCmd
c6025a:M5-movVelCmd
c6025a:M5-movRelCmd
c6025a:M5-movAbsCmd
c6025a:M5-movHomCmd
c6025a:M5-SetEncIdCmd-RB
c6025a:M6-MtnCmd
c6025a:M6-movVelCmd
c6025a:M6-movRelCmd
c6025a:M6-movAbsCmd
c6025a:M6-movHomCmd
c6025a:M6-SetEncIdCmd-RB
c6025a:M7-MtnCmd
c6025a:M7-movVelCmd
c6025a:M7-movRelCmd
c6025a:M7-movAbsCmd
c6025a:M7-movHomCmd
c6025a:M7-SetEncIdCmd-RB
c6025a:M8-MtnCmd
c6025a:M8-movVelCmd
c6025a:M8-movRelCmd
c6025a:M8-movAbsCmd
c6025a:M8-movHomCmd
c6025a:M8-SetEncIdCmd-RB
c6025a:MCU-Cfg-EC-Mst
c6025a:MCU-Cfg-Rate
c6025a:MCU-Cfg-Time
c6025a:MCU-Cfg-PV-Time
c6025a:m0s001-NxtObjId
c6025a:MCU-Cfg-EC-FrstObjId
c6025a:m0s002-NxtObjId
c6025a:m0s003-NxtObjId
c6025a:m0s004-Drv01-Cmd
c6025a:m0s004-Drv01-Spd
c6025a:m0s004-Enc01-Cmd
c6025a:m0s004-Enc01-PosCmd
c6025a:m0s004-NxtObjId
c6025a:M1-TgtPosCmd
c6025a:M1-TgtVelCmd
c6025a:M1-Id
c6025a:MCU-Cfg-AX1-NxtObjId
c6025a:MCU-Cfg-AX-FrstObjId
c6025a:M1-OFF_
c6025a:M1-MRES_
c6025a:M2-TgtPosCmd
c6025a:M2-TgtVelCmd
c6025a:M2-Id
c6025a:MCU-Cfg-AX2-NxtObjId
c6025a:M2-OFF_
c6025a:M2-MRES_
c6025a:M3-TgtPosCmd
c6025a:M3-TgtVelCmd
c6025a:M3-Id
c6025a:MCU-Cfg-AX3-NxtObjId
c6025a:M3-OFF_
c6025a:M3-MRES_
c6025a:M4-TgtPosCmd
c6025a:M4-TgtVelCmd
c6025a:M4-Id
c6025a:MCU-Cfg-AX4-NxtObjId
c6025a:M4-OFF_
c6025a:M4-MRES_
c6025a:M5-TgtPosCmd
c6025a:M5-TgtVelCmd
c6025a:M5-Id
c6025a:MCU-Cfg-AX5-NxtObjId
c6025a:M5-OFF_
c6025a:M5-MRES_
c6025a:M6-TgtPosCmd
c6025a:M6-TgtVelCmd
c6025a:M6-Id
c6025a:MCU-Cfg-AX6-NxtObjId
c6025a:M6-OFF_
c6025a:M6-MRES_
c6025a:M7-TgtPosCmd
c6025a:M7-TgtVelCmd
c6025a:M7-Id
c6025a:MCU-Cfg-AX7-NxtObjId
c6025a:M7-OFF_
c6025a:M7-MRES_
c6025a:M8-TgtPosCmd
c6025a:M8-TgtVelCmd
c6025a:M8-Id
c6025a:MCU-Cfg-AX8-NxtObjId
c6025a:M8-OFF_
c6025a:M8-MRES_
c6025a:m0s001-AI01-Stat
c6025a:m0s001-AI02-Stat
c6025a:m0s001-AI03-Stat
c6025a:m0s001-AI04-Stat
c6025a:m0s001-Stat_
c6025a:m0s002-Enc01-Stat
c6025a:m0s002-Stat_
c6025a:m0s003-Stat_
c6025a:m0s004-Drv01-Stat
c6025a:m0s004-Enc01-Stat
c6025a:m0s004-Stat_
c6025a:M1-Stat_
c6025a:M1-Stat2_
c6025a:M2-Stat_
c6025a:M2-Stat2_
c6025a:M3-Stat_
c6025a:M3-Stat2_
c6025a:M4-Stat_
c6025a:M4-Stat2_
c6025a:M5-Stat_
c6025a:M5-Stat2_
c6025a:M6-Stat_
c6025a:M6-Stat2_
c6025a:M7-Stat_
c6025a:M7-Stat2_
c6025a:M8-Stat_
c6025a:M8-Stat2_
c6025a:ThdRTStat_
c6025a:m0-Stat_
c6025a:m0-Dom-Stat_
c6025a:MODULES
c6025a:VERSIONS
c6025a:MOD_VER
c6025a:require_ORIGIN
c6025a:misc_ORIGIN
c6025a:ecmccfg_ORIGIN
c6025a:ECmasterECMC_ORIGIN
c6025a:calc_ORIGIN
c6025a:asyn_ORIGIN
c6025a:motorECMC_ORIGIN
c6025a:ruckig_ORIGIN
c6025a:ecmc_ORIGIN
c6025a:M1-Arr-Stat
c6025a:M1-PLC-Expr-RB
c6025a:M2-Arr-Stat
c6025a:M2-PLC-Expr-RB
c6025a:M3-Arr-Stat
c6025a:M3-PLC-Expr-RB
c6025a:M4-Arr-Stat
c6025a:M4-PLC-Expr-RB
c6025a:M5-Arr-Stat
c6025a:M5-PLC-Expr-RB
c6025a:M6-Arr-Stat
c6025a:M6-PLC-Expr-RB
c6025a:M7-Arr-Stat
c6025a:M7-PLC-Expr-RB
c6025a:M8-Arr-Stat
c6025a:M8-PLC-Expr-RB
c6025a:MCU-ErrMsg
c6025a:MCU-Updated
c6025a:m0s001-Stat
c6025a:m0s002-Stat
c6025a:m0s003-Stat
c6025a:m0s004-Stat
c6025a:M1-Stat
c6025a:M1-ErrId
c6025a:M1-WrnId
c6025a:M1-EncCnt
c6025a:M1-MR-ErrId
c6025a:M1-CfgRDBD-En-RB
c6025a:M1-CfgPOSLAG-En-RB
c6025a:M1-CfgDHLM-En-RB
c6025a:M1-CfgDLLM-En-RB
c6025a:M2-Stat
c6025a:M2-ErrId
c6025a:M2-WrnId
c6025a:M2-EncCnt
c6025a:M2-MR-ErrId
c6025a:M2-CfgRDBD-En-RB
c6025a:M2-CfgPOSLAG-En-RB
c6025a:M2-CfgDHLM-En-RB
c6025a:M2-CfgDLLM-En-RB
c6025a:M3-Stat
c6025a:M3-ErrId
c6025a:M3-WrnId
c6025a:M3-EncCnt
c6025a:M3-MR-ErrId
c6025a:M3-CfgRDBD-En-RB
c6025a:M3-CfgPOSLAG-En-RB
c6025a:M3-CfgDHLM-En-RB
c6025a:M3-CfgDLLM-En-RB
c6025a:M4-Stat
c6025a:M4-ErrId
c6025a:M4-WrnId
c6025a:M4-EncCnt
c6025a:M4-MR-ErrId
c6025a:M4-CfgRDBD-En-RB
c6025a:M4-CfgPOSLAG-En-RB
c6025a:M4-CfgDHLM-En-RB
c6025a:M4-CfgDLLM-En-RB
c6025a:M5-Stat
c6025a:M5-ErrId
c6025a:M5-WrnId
c6025a:M5-EncCnt
c6025a:M5-MR-ErrId
c6025a:M5-CfgRDBD-En-RB
c6025a:M5-CfgPOSLAG-En-RB
c6025a:M5-CfgDHLM-En-RB
c6025a:M5-CfgDLLM-En-RB
c6025a:M6-Stat
c6025a:M6-ErrId
c6025a:M6-WrnId
c6025a:M6-EncCnt
c6025a:M6-MR-ErrId
c6025a:M6-CfgRDBD-En-RB
c6025a:M6-CfgPOSLAG-En-RB
c6025a:M6-CfgDHLM-En-RB
c6025a:M6-CfgDLLM-En-RB
c6025a:M7-Stat
c6025a:M7-ErrId
c6025a:M7-WrnId
c6025a:M7-EncCnt
c6025a:M7-MR-ErrId
c6025a:M7-CfgRDBD-En-RB
c6025a:M7-CfgPOSLAG-En-RB
c6025a:M7-CfgDHLM-En-RB
c6025a:M7-CfgDLLM-En-RB
c6025a:M8-Stat
c6025a:M8-ErrId
c6025a:M8-WrnId
c6025a:M8-EncCnt
c6025a:M8-MR-ErrId
c6025a:M8-CfgRDBD-En-RB
c6025a:M8-CfgPOSLAG-En-RB
c6025a:M8-CfgDHLM-En-RB
c6025a:M8-CfgDLLM-En-RB
c6025a:m0-Stat
c6025a:m0-SlvCntr
c6025a:m0-MemmapCntr
c6025a:m0-EntryCntr
c6025a:m0-Dom-FailCntrTot
c6025a:m0-Dom-Stat
c6025a:m0s001-AI01-UndrLimAlrm
c6025a:m0s001-AI01-OvrLimAlrm
c6025a:m0s001-AI01-ErrAlrm
c6025a:m0s001-AI02-UndrLimAlrm
c6025a:m0s001-AI02-OvrLimAlrm
c6025a:m0s001-AI02-ErrAlrm
c6025a:m0s001-AI03-UndrLimAlrm
c6025a:m0s001-AI03-OvrLimAlrm
c6025a:m0s001-AI03-ErrAlrm
c6025a:m0s001-AI04-UndrLimAlrm
c6025a:m0s001-AI04-OvrLimAlrm
c6025a:m0s001-AI04-ErrAlrm
c6025a:m0s001-Online
c6025a:m0s001-Operational
c6025a:m0s001-Alstate-Init
c6025a:m0s001-Alstate-Preop
c6025a:m0s001-Alstate-Safeop
c6025a:m0s001-Alstate-Op
c6025a:m0s002-Enc01-DataAlrm
c6025a:m0s002-Enc01-FrameAlrm
c6025a:m0s002-Enc01-PowerAlrm
c6025a:m0s002-Online
c6025a:m0s002-Operational
c6025a:m0s002-Alstate-Init
c6025a:m0s002-Alstate-Preop
c6025a:m0s002-Alstate-Safeop
c6025a:m0s002-Alstate-Op
c6025a:m0s003-BI01
c6025a:m0s003-BI02
c6025a:m0s003-BI03
c6025a:m0s003-BI04
c6025a:m0s003-BI05
c6025a:m0s003-BI06
c6025a:m0s003-BI07
c6025a:m0s003-BI08
c6025a:m0s003-Online
c6025a:m0s003-Operational
c6025a:m0s003-Alstate-Init
c6025a:m0s003-Alstate-Preop
c6025a:m0s003-Alstate-Safeop
c6025a:m0s003-Alstate-Op
c6025a:m0s004-Drv01-WrnAlrm
c6025a:m0s004-Drv01-ErrAlrm
c6025a:m0s004-Drv01-StlAlrm
c6025a:m0s004-Drv01-SyncErrAlrm
c6025a:m0s004-Enc01-ExtLtchOK
c6025a:m0s004-Enc01-OpnCrctAlrm
c6025a:m0s004-Enc01-WrnAlrm
c6025a:m0s004-Enc01-SyncErrAlrm
c6025a:m0s004-Online
c6025a:m0s004-Operational
c6025a:m0s004-Alstate-Init
c6025a:m0s004-Alstate-Preop
c6025a:m0s004-Alstate-Safeop
c6025a:m0s004-Alstate-Op
c6025a:M1-EnaCmd-RB
c6025a:M1-EnaAct
c6025a:M1-ExeCmd-RB
c6025a:M1-Busy
c6025a:M1-AtTarget
c6025a:M1-Moving
c6025a:M1-LimFwd
c6025a:M1-LimBwd
c6025a:M1-HomeSwitch
c6025a:M1-Homed
c6025a:M1-InRT
c6025a:M1-TrjSrcTyp-RB
c6025a:M1-EncSrcTyp-RB
c6025a:M1-CmdFrmPLCCmd-RB
c6025a:M1-SftLimFwdEna-RB
c6025a:M1-SftLimBwdEna-RB
c6025a:M1-InStartup
c6025a:M1-SumIlockFwd
c6025a:M1-SumIlockBwd
c6025a:M1-PLC-EnaCmd-RB
c6025a:M1-PLC-FirstScan
c6025a:M1-Err
c6025a:M1-Wrn
c6025a:M2-EnaCmd-RB
c6025a:M2-EnaAct
c6025a:M2-ExeCmd-RB
c6025a:M2-Busy
c6025a:M2-AtTarget
c6025a:M2-Moving
c6025a:M2-LimFwd
c6025a:M2-LimBwd
c6025a:M2-HomeSwitch
c6025a:M2-Homed
c6025a:M2-InRT
c6025a:M2-TrjSrcTyp-RB
c6025a:M2-EncSrcTyp-RB
c6025a:M2-CmdFrmPLCCmd-RB
c6025a:M2-SftLimFwdEna-RB
c6025a:M2-SftLimBwdEna-RB
c6025a:M2-InStartup
c6025a:M2-SumIlockFwd
c6025a:M2-SumIlockBwd
c6025a:M2-PLC-EnaCmd-RB
c6025a:M2-PLC-FirstScan
c6025a:M2-Err
c6025a:M2-Wrn
c6025a:M3-EnaCmd-RB
c6025a:M3-EnaAct
c6025a:M3-ExeCmd-RB
c6025a:M3-Busy
c6025a:M3-AtTarget
c6025a:M3-Moving
c6025a:M3-LimFwd
c6025a:M3-LimBwd
c6025a:M3-HomeSwitch
c6025a:M3-Homed
c6025a:M3-InRT
c6025a:M3-TrjSrcTyp-RB
c6025a:M3-EncSrcTyp-RB
c6025a:M3-CmdFrmPLCCmd-RB
c6025a:M3-SftLimFwdEna-RB
c6025a:M3-SftLimBwdEna-RB
c6025a:M3-InStartup
c6025a:M3-SumIlockFwd
c6025a:M3-SumIlockBwd
c6025a:M3-PLC-EnaCmd-RB
c6025a:M3-PLC-FirstScan
c6025a:M3-Err
c6025a:M3-Wrn
c6025a:M4-EnaCmd-RB
c6025a:M4-EnaAct
c6025a:M4-ExeCmd-RB
c6025a:M4-Busy
c6025a:M4-AtTarget
c6025a:M4-Moving
c6025a:M4-LimFwd
c6025a:M4-LimBwd
c6025a:M4-HomeSwitch
c6025a:M4-Homed
c6025a:M4-InRT
c6025a:M4-TrjSrcTyp-RB
c6025a:M4-EncSrcTyp-RB
c6025a:M4-CmdFrmPLCCmd-RB
c6025a:M4-SftLimFwdEna-RB
c6025a:M4-SftLimBwdEna-RB
c6025a:M4-InStartup
c6025a:M4-SumIlockFwd
c6025a:M4-SumIlockBwd
c6025a:M4-PLC-EnaCmd-RB
c6025a:M4-PLC-FirstScan
c6025a:M4-Err
c6025a:M4-Wrn
c6025a:M5-EnaCmd-RB
c6025a:M5-EnaAct
c6025a:M5-ExeCmd-RB
c6025a:M5-Busy
c6025a:M5-AtTarget
c6025a:M5-Moving
c6025a:M5-LimFwd
c6025a:M5-LimBwd
c6025a:M5-HomeSwitch
c6025a:M5-Homed
c6025a:M5-InRT
c6025a:M5-TrjSrcTyp-RB
c6025a:M5-EncSrcTyp-RB
c6025a:M5-CmdFrmPLCCmd-RB
c6025a:M5-SftLimFwdEna-RB
c6025a:M5-SftLimBwdEna-RB
c6025a:M5-InStartup
c6025a:M5-SumIlockFwd
c6025a:M5-SumIlockBwd
c6025a:M5-PLC-EnaCmd-RB
c6025a:M5-PLC-FirstScan
c6025a:M5-Err
c6025a:M5-Wrn
c6025a:M6-EnaCmd-RB
c6025a:M6-EnaAct
c6025a:M6-ExeCmd-RB
c6025a:M6-Busy
c6025a:M6-AtTarget
c6025a:M6-Moving
c6025a:M6-LimFwd
c6025a:M6-LimBwd
c6025a:M6-HomeSwitch
c6025a:M6-Homed
c6025a:M6-InRT
c6025a:M6-TrjSrcTyp-RB
c6025a:M6-EncSrcTyp-RB
c6025a:M6-CmdFrmPLCCmd-RB
c6025a:M6-SftLimFwdEna-RB
c6025a:M6-SftLimBwdEna-RB
c6025a:M6-InStartup
c6025a:M6-SumIlockFwd
c6025a:M6-SumIlockBwd
c6025a:M6-PLC-EnaCmd-RB
c6025a:M6-PLC-FirstScan
c6025a:M6-Err
c6025a:M6-Wrn
c6025a:M7-EnaCmd-RB
c6025a:M7-EnaAct
c6025a:M7-ExeCmd-RB
c6025a:M7-Busy
c6025a:M7-AtTarget
c6025a:M7-Moving
c6025a:M7-LimFwd
c6025a:M7-LimBwd
c6025a:M7-HomeSwitch
c6025a:M7-Homed
c6025a:M7-InRT
c6025a:M7-TrjSrcTyp-RB
c6025a:M7-EncSrcTyp-RB
c6025a:M7-CmdFrmPLCCmd-RB
c6025a:M7-SftLimFwdEna-RB
c6025a:M7-SftLimBwdEna-RB
c6025a:M7-InStartup
c6025a:M7-SumIlockFwd
c6025a:M7-SumIlockBwd
c6025a:M7-PLC-EnaCmd-RB
c6025a:M7-PLC-FirstScan
c6025a:M7-Err
c6025a:M7-Wrn
c6025a:M8-EnaCmd-RB
c6025a:M8-EnaAct
c6025a:M8-ExeCmd-RB
c6025a:M8-Busy
c6025a:M8-AtTarget
c6025a:M8-Moving
c6025a:M8-LimFwd
c6025a:M8-LimBwd
c6025a:M8-HomeSwitch
c6025a:M8-Homed
c6025a:M8-InRT
c6025a:M8-TrjSrcTyp-RB
c6025a:M8-EncSrcTyp-RB
c6025a:M8-CmdFrmPLCCmd-RB
c6025a:M8-SftLimFwdEna-RB
c6025a:M8-SftLimBwdEna-RB
c6025a:M8-InStartup
c6025a:M8-SumIlockFwd
c6025a:M8-SumIlockBwd
c6025a:M8-PLC-EnaCmd-RB
c6025a:M8-PLC-FirstScan
c6025a:M8-Err
c6025a:M8-Wrn
c6025a:MCU-ThdRTPrioOK
c6025a:MCU-ThdMemLocked
c6025a:m0-LinkUp
c6025a:m0-AlStates-Init
c6025a:m0-AlStates-Preop
c6025a:m0-AlStates-Safeop
c6025a:m0-AlStates-Op
c6025a:m0-Dom-RedunActive
c6025a:m0-Dom-WC-Zero
c6025a:m0-Dom-WC-Incomplete
c6025a:m0-Dom-WC-Complete
c6025a:m0-Stat-OK
c6025a:m0s001-EntryCntr
c6025a:m0s002-EntryCntr
c6025a:m0s003-EntryCntr
c6025a:m0s004-EntryCntr
c6025a:M1-SeqState
c6025a:M1-LastIlock
c6025a:M2-SeqState
c6025a:M2-LastIlock
c6025a:M3-SeqState
c6025a:M3-LastIlock
c6025a:M4-SeqState
c6025a:M4-LastIlock
c6025a:M5-SeqState
c6025a:M5-LastIlock
c6025a:M6-SeqState
c6025a:M6-LastIlock
c6025a:M7-SeqState
c6025a:M7-LastIlock
c6025a:M8-SeqState
c6025a:M8-LastIlock
c6025a:m0-SlvRsp
c6025a:m0-Dom-WC
c6025a:M1-Cmd_
c6025a:M2-Cmd_
c6025a:M3-Cmd_
c6025a:M4-Cmd_
c6025a:M5-Cmd_
c6025a:M6-Cmd_
c6025a:M7-Cmd_
c6025a:M8-Cmd_
c6025a:m0s001-One
c6025a:m0s001-Zero
c6025a:m0s002-One
c6025a:m0s002-Zero
c6025a:m0s003-One
c6025a:m0s003-Zero
c6025a:m0s004-One
c6025a:m0s004-Zero
c6025a:M1-MtnCmdData
c6025a:M1-DIR_
c6025a:M1-ErrRst
c6025a:M2-MtnCmdData
c6025a:M2-DIR_
c6025a:M2-ErrRst
c6025a:M3-MtnCmdData
c6025a:M3-DIR_
c6025a:M3-ErrRst
c6025a:M4-MtnCmdData
c6025a:M4-DIR_
c6025a:M4-ErrRst
c6025a:M5-MtnCmdData
c6025a:M5-DIR_
c6025a:M5-ErrRst
c6025a:M6-MtnCmdData
c6025a:M6-DIR_
c6025a:M6-ErrRst
c6025a:M7-MtnCmdData
c6025a:M7-DIR_
c6025a:M7-ErrRst
c6025a:M8-MtnCmdData
c6025a:M8-DIR_
c6025a:M8-ErrRst
c6025a:require_VERS
c6025a:misc_VERS
c6025a:ecmccfg_VERS
c6025a:ECmasterECMC_VERS
c6025a:calc_VERS
c6025a:asyn_VERS
c6025a:motorECMC_VERS
c6025a:ruckig_VERS
c6025a:ecmc_VERS
c6025a:m0s001-HWType
c6025a:m0s002-HWType
c6025a:m0s003-HWType
c6025a:m0s004-HWType
c6025a:M1-MsgTxt
c6025a:M2-MsgTxt
c6025a:M3-MsgTxt
c6025a:M4-MsgTxt
c6025a:M5-MsgTxt
c6025a:M6-MsgTxt
c6025a:M7-MsgTxt
c6025a:M8-MsgTxt
c6025a:m0s001-AI01
c6025a:m0s001-AI02
c6025a:m0s001-AI03
c6025a:m0s001-AI04
c6025a:m0s002-Enc01-PosAct
c6025a:m0s004-Drv01-Cmd-RB
c6025a:m0s004-Drv01-Spd-RB
c6025a:m0s004-Enc01-PosAct
c6025a:m0s004-Enc01-LtchPosAct
c6025a:m0s004-Enc01-Cmd-RB
c6025a:m0s004-Enc01-PosCmd-RB
c6025a:M1-PosAct
c6025a:M1-VelAct
c6025a:M1-PosSet
c6025a:M1-PosErr
c6025a:M1-PLC-Err
c6025a:M1-Enc01-PosAct
c6025a:M1-Enc01-VelAct
c6025a:M1-Enc01-HmeVelToCam
c6025a:M1-Enc01-HmeVelFrmCam
c6025a:M1-Enc01-HmeAcc
c6025a:M1-Enc01-HmeDec
c6025a:M1-Enc01-HmePos
c6025a:M1-Enc01-HmePstMveEna
c6025a:M1-Enc01-HmePstMvePos
c6025a:M1-Enc01-HmeRefAtStrtToEncId
c6025a:M1-Enc01-HmeRefAtHme
c6025a:M1-Vel-RB
c6025a:M1-Acc-RB
c6025a:M1-EncAct
c6025a:M1-CfgSREV-RB
c6025a:M1-CfgUREV-RB
c6025a:M1-CfgPMIN-RB
c6025a:M1-CfgPMAX-RB
c6025a:M1-CfgSPDB-RB
c6025a:M1-CfgRDBD-RB
c6025a:M1-CfgRDBD-Tim-RB
c6025a:M1-CfgPOSLAG-RB
c6025a:M1-CfgPOSLAG-Tim-RB
c6025a:M1-CfgDHLM-RB
c6025a:M1-CfgDLLM-RB
c6025a:M1-CfgVELO-RB
c6025a:M1-CfgVMAX-RB
c6025a:M1-CfgJVEL-RB
c6025a:M1-CfgACCS-RB
c6025a:M1-HomPos-RB
c6025a:M2-PosAct
c6025a:M2-VelAct
c6025a:M2-PosSet
c6025a:M2-PosErr
c6025a:M2-PLC-Err
c6025a:M2-Enc01-PosAct
c6025a:M2-Enc01-VelAct
c6025a:M2-Enc01-HmeVelToCam
c6025a:M2-Enc01-HmeVelFrmCam
c6025a:M2-Enc01-HmeAcc
c6025a:M2-Enc01-HmeDec
c6025a:M2-Enc01-HmePos
c6025a:M2-Enc01-HmePstMveEna
c6025a:M2-Enc01-HmePstMvePos
c6025a:M2-Enc01-HmeRefAtStrtToEncId
c6025a:M2-Enc01-HmeRefAtHme
c6025a:M2-Vel-RB
c6025a:M2-Acc-RB
c6025a:M2-EncAct
c6025a:M2-CfgSREV-RB
c6025a:M2-CfgUREV-RB
c6025a:M2-CfgPMIN-RB
c6025a:M2-CfgPMAX-RB
c6025a:M2-CfgSPDB-RB
c6025a:M2-CfgRDBD-RB
c6025a:M2-CfgRDBD-Tim-RB
c6025a:M2-CfgPOSLAG-RB
c6025a:M2-CfgPOSLAG-Tim-RB
c6025a:M2-CfgDHLM-RB
c6025a:M2-CfgDLLM-RB
c6025a:M2-CfgVELO-RB
c6025a:M2-CfgVMAX-RB
c6025a:M2-CfgJVEL-RB
c6025a:M2-CfgACCS-RB
c6025a:M2-HomPos-RB
c6025a:M3-PosAct
c6025a:M3-VelAct
c6025a:M3-PosSet
c6025a:M3-PosErr
c6025a:M3-PLC-Err
c6025a:M3-Enc01-PosAct
c6025a:M3-Enc01-VelAct
c6025a:M3-Enc01-HmeVelToCam
c6025a:M3-Enc01-HmeVelFrmCam
c6025a:M3-Enc01-HmeAcc
c6025a:M3-Enc01-HmeDec
c6025a:M3-Enc01-HmePos
c6025a:M3-Enc01-HmePstMveEna
c6025a:M3-Enc01-HmePstMvePos
c6025a:M3-Enc01-HmeRefAtStrtToEncId
c6025a:M3-Enc01-HmeRefAtHme
c6025a:M3-Vel-RB
c6025a:M3-Acc-RB
c6025a:M3-EncAct
c6025a:M3-CfgSREV-RB
c6025a:M3-CfgUREV-RB
c6025a:M3-CfgPMIN-RB
c6025a:M3-CfgPMAX-RB
c6025a:M3-CfgSPDB-RB
c6025a:M3-CfgRDBD-RB
c6025a:M3-CfgRDBD-Tim-RB
c6025a:M3-CfgPOSLAG-RB
c6025a:M3-CfgPOSLAG-Tim-RB
c6025a:M3-CfgDHLM-RB
c6025a:M3-CfgDLLM-RB
c6025a:M3-CfgVELO-RB
c6025a:M3-CfgVMAX-RB
c6025a:M3-CfgJVEL-RB
c6025a:M3-CfgACCS-RB
c6025a:M3-HomPos-RB
c6025a:M4-PosAct
c6025a:M4-VelAct
c6025a:M4-PosSet
c6025a:M4-PosErr
c6025a:M4-PLC-Err
c6025a:M4-Enc01-PosAct
c6025a:M4-Enc01-VelAct
c6025a:M4-Enc01-HmeVelToCam
c6025a:M4-Enc01-HmeVelFrmCam
c6025a:M4-Enc01-HmeAcc
c6025a:M4-Enc01-HmeDec
c6025a:M4-Enc01-HmePos
c6025a:M4-Enc01-HmePstMveEna
c6025a:M4-Enc01-HmePstMvePos
c6025a:M4-Enc01-HmeRefAtStrtToEncId
c6025a:M4-Enc01-HmeRefAtHme
c6025a:M4-Vel-RB
c6025a:M4-Acc-RB
c6025a:M4-EncAct
c6025a:M4-CfgSREV-RB
c6025a:M4-CfgUREV-RB
c6025a:M4-CfgPMIN-RB
c6025a:M4-CfgPMAX-RB
c6025a:M4-CfgSPDB-RB
c6025a:M4-CfgRDBD-RB
c6025a:M4-CfgRDBD-Tim-RB
c6025a:M4-CfgPOSLAG-RB
c6025a:M4-CfgPOSLAG-Tim-RB
c6025a:M4-CfgDHLM-RB
c6025a:M4-CfgDLLM-RB
c6025a:M4-CfgVELO-RB
c6025a:M4-CfgVMAX-RB
c6025a:M4-CfgJVEL-RB
c6025a:M4-CfgACCS-RB
c6025a:M4-HomPos-RB
c6025a:M5-PosAct
c6025a:M5-VelAct
c6025a:M5-PosSet
c6025a:M5-PosErr
c6025a:M5-PLC-Err
c6025a:M5-Enc01-PosAct
c6025a:M5-Enc01-VelAct
c6025a:M5-Enc01-HmeVelToCam
c6025a:M5-Enc01-HmeVelFrmCam
c6025a:M5-Enc01-HmeAcc
c6025a:M5-Enc01-HmeDec
c6025a:M5-Enc01-HmePos
c6025a:M5-Enc01-HmePstMveEna
c6025a:M5-Enc01-HmePstMvePos
c6025a:M5-Enc01-HmeRefAtStrtToEncId
c6025a:M5-Enc01-HmeRefAtHme
c6025a:M5-Vel-RB
c6025a:M5-Acc-RB
c6025a:M5-EncAct
c6025a:M5-CfgSREV-RB
c6025a:M5-CfgUREV-RB
c6025a:M5-CfgPMIN-RB
c6025a:M5-CfgPMAX-RB
c6025a:M5-CfgSPDB-RB
c6025a:M5-CfgRDBD-RB
c6025a:M5-CfgRDBD-Tim-RB
c6025a:M5-CfgPOSLAG-RB
c6025a:M5-CfgPOSLAG-Tim-RB
c6025a:M5-CfgDHLM-RB
c6025a:M5-CfgDLLM-RB
c6025a:M5-CfgVELO-RB
c6025a:M5-CfgVMAX-RB
c6025a:M5-CfgJVEL-RB
c6025a:M5-CfgACCS-RB
c6025a:M5-HomPos-RB
c6025a:M6-PosAct
c6025a:M6-VelAct
c6025a:M6-PosSet
c6025a:M6-PosErr
c6025a:M6-PLC-Err
c6025a:M6-Enc01-PosAct
c6025a:M6-Enc01-VelAct
c6025a:M6-Enc01-HmeVelToCam
c6025a:M6-Enc01-HmeVelFrmCam
c6025a:M6-Enc01-HmeAcc
c6025a:M6-Enc01-HmeDec
c6025a:M6-Enc01-HmePos
c6025a:M6-Enc01-HmePstMveEna
c6025a:M6-Enc01-HmePstMvePos
c6025a:M6-Enc01-HmeRefAtStrtToEncId
c6025a:M6-Enc01-HmeRefAtHme
c6025a:M6-Vel-RB
c6025a:M6-Acc-RB
c6025a:M6-EncAct
c6025a:M6-CfgSREV-RB
c6025a:M6-CfgUREV-RB
c6025a:M6-CfgPMIN-RB
c6025a:M6-CfgPMAX-RB
c6025a:M6-CfgSPDB-RB
c6025a:M6-CfgRDBD-RB
c6025a:M6-CfgRDBD-Tim-RB
c6025a:M6-CfgPOSLAG-RB
c6025a:M6-CfgPOSLAG-Tim-RB
c6025a:M6-CfgDHLM-RB
c6025a:M6-CfgDLLM-RB
c6025a:M6-CfgVELO-RB
c6025a:M6-CfgVMAX-RB
c6025a:M6-CfgJVEL-RB
c6025a:M6-CfgACCS-RB
c6025a:M6-HomPos-RB
c6025a:M7-PosAct
c6025a:M7-VelAct
c6025a:M7-PosSet
c6025a:M7-PosErr
c6025a:M7-PLC-Err
c6025a:M7-Enc01-PosAct
c6025a:M7-Enc01-VelAct
c6025a:M7-Enc01-HmeVelToCam
c6025a:M7-Enc01-HmeVelFrmCam
c6025a:M7-Enc01-HmeAcc
c6025a:M7-Enc01-HmeDec
c6025a:M7-Enc01-HmePos
c6025a:M7-Enc01-HmePstMveEna
c6025a:M7-Enc01-HmePstMvePos
c6025a:M7-Enc01-HmeRefAtStrtToEncId
c6025a:M7-Enc01-HmeRefAtHme
c6025a:M7-Vel-RB
c6025a:M7-Acc-RB
c6025a:M7-EncAct
c6025a:M7-CfgSREV-RB
c6025a:M7-CfgUREV-RB
c6025a:M7-CfgPMIN-RB
c6025a:M7-CfgPMAX-RB
c6025a:M7-CfgSPDB-RB
c6025a:M7-CfgRDBD-RB
c6025a:M7-CfgRDBD-Tim-RB
c6025a:M7-CfgPOSLAG-RB
c6025a:M7-CfgPOSLAG-Tim-RB
c6025a:M7-CfgDHLM-RB
c6025a:M7-CfgDLLM-RB
c6025a:M7-CfgVELO-RB
c6025a:M7-CfgVMAX-RB
c6025a:M7-CfgJVEL-RB
c6025a:M7-CfgACCS-RB
c6025a:M7-HomPos-RB
c6025a:M8-PosAct
c6025a:M8-VelAct
c6025a:M8-PosSet
c6025a:M8-PosErr
c6025a:M8-PLC-Err
c6025a:M8-Enc01-PosAct
c6025a:M8-Enc01-VelAct
c6025a:M8-Enc01-HmeVelToCam
c6025a:M8-Enc01-HmeVelFrmCam
c6025a:M8-Enc01-HmeAcc
c6025a:M8-Enc01-HmeDec
c6025a:M8-Enc01-HmePos
c6025a:M8-Enc01-HmePstMveEna
c6025a:M8-Enc01-HmePstMvePos
c6025a:M8-Enc01-HmeRefAtStrtToEncId
c6025a:M8-Enc01-HmeRefAtHme
c6025a:M8-Vel-RB
c6025a:M8-Acc-RB
c6025a:M8-EncAct
c6025a:M8-CfgSREV-RB
c6025a:M8-CfgUREV-RB
c6025a:M8-CfgPMIN-RB
c6025a:M8-CfgPMAX-RB
c6025a:M8-CfgSPDB-RB
c6025a:M8-CfgRDBD-RB
c6025a:M8-CfgRDBD-Tim-RB
c6025a:M8-CfgPOSLAG-RB
c6025a:M8-CfgPOSLAG-Tim-RB
c6025a:M8-CfgDHLM-RB
c6025a:M8-CfgDLLM-RB
c6025a:M8-CfgVELO-RB
c6025a:M8-CfgVMAX-RB
c6025a:M8-CfgJVEL-RB
c6025a:M8-CfgACCS-RB
c6025a:M8-HomPos-RB
c6025a:MCU-AppMode
c6025a:MCU-ErrId
c6025a:MCU-ThdLatMin
c6025a:MCU-ThdLatMax
c6025a:MCU-ThdPrdMin
c6025a:MCU-ThdPrdMax
c6025a:MCU-ThdExeMin
c6025a:MCU-ThdExeMax
c6025a:MCU-ThdSndMin
c6025a:MCU-ThdSndMax
c6025a:M1-MCU1-asyn
c6025a:M2-MCU1-asyn
c6025a:M3-MCU1-asyn
c6025a:M4-MCU1-asyn
c6025a:M5-MCU1-asyn
c6025a:M6-MCU1-asyn
c6025a:M7-MCU1-asyn
c6025a:M8-MCU1-asyn
c6025a:MCU-Cmd
c6025a:M1
c6025a:M2
c6025a:M3
c6025a:M4
c6025a:M5
c6025a:M6
c6025a:M7
c6025a:M8
c6025a>
```

