#==============================================================================
# ecmc_axis.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for configuring a physical axis.
#-d   \details Configures a physical axis in ECMC, based on previously set environment variables.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note This script is typically called by \b addAxis.cmd, often via \b ecmc_axis-records.cmd
#-d   \pre An axis definition for a physical axis has to be added/configured immediately before the call of this script.
#-d */

#- Ensure valid current settings
ecmcFileExist("${ECMC_CONFIG_ROOT}verifyOrDie.cmd",1)
#- ECMC_ENC_SCALE_NUM
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}verifyOrDie.cmd "EXPR_STR='abs(${ECMC_ENC_SCALE_NUM})<>0',SUCCESS_STR='ECMC_ENC_SCALE_NUM value OK == ${ECMC_ENC_SCALE_NUM}...',ERROR_STR='ECMC_ENC_SCALE_NUM == 0...'"
#- ECMC_ENC_SCALE_DENOM
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}verifyOrDie.cmd "EXPR_STR='abs(${ECMC_ENC_SCALE_DENOM})<>0',SUCCESS_STR='ECMC_ENC_SCALE_DENOM value OK == ${ECMC_ENC_SCALE_DENOM}...',ERROR_STR='ECMC_ENC_SCALE_DENOM == 0...'"
#- ECMC_DRV_SCALE_NUM
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}verifyOrDie.cmd "EXPR_STR='abs(${ECMC_DRV_SCALE_NUM})<>0',SUCCESS_STR='ECMC_DRV_SCALE_NUM value OK == ${ECMC_DRV_SCALE_NUM}...',ERROR_STR='ECMC_DRV_SCALE_NUM == 0...'"
#- ECMC_DRV_SCALE_DENOM
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}verifyOrDie.cmd "EXPR_STR='abs(${ECMC_DRV_SCALE_DENOM})<>0',SUCCESS_STR='ECMC_DRV_SCALE_DENOM value OK == ${ECMC_DRV_SCALE_DENOM}...',ERROR_STR='ECMC_DRV_SCALE_DENOM == 0...'"

#- Issue Warning if ECMC_MRES is set. MRES calculated bu SREV and UREV instead
ecmcFileExist("${ECMC_CONFIG_ROOT}issueWarning.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}issueWarning.cmd "EXPR_STR='${ECMC_MRES=-1}>0',WARNING_STR='WARNING: ECMC_MRES setting is deprecated and will not be used. (MRES will be calulated instead: ECMC_ENC_SCALE_NUM/ECMC_ENC_SCALE_DENOM).. '"

#- General
ecmcConfigOrDie "Cfg.CreateAxis(${ECMC_AXIS_NO},1,${ECMC_DRV_TYPE=0},${ECMC_TRAJ_TYPE=0})"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_AXIS_HEALTH},"ax${ECMC_AXIS_NO}.health")"
ecmcConfigOrDie "Cfg.SetAxisModRange(${ECMC_AXIS_NO}, ${ECMC_MOD_RANGE=0})"
ecmcConfigOrDie "Cfg.SetAxisModType(${ECMC_AXIS_NO}, ${ECMC_MOD_TYPE=0})"

#- Trajectory
#- Issue Warning if ECMC_ACCL is set. ECMC_ACCS_EGU_PER_S2 with unit EGU/s² should be used instead
ecmcFileExist("${ECMC_CONFIG_ROOT}issueWarning.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}issueWarning.cmd "EXPR_STR='${ECMC_ACCL=-1}>0',WARNING_STR='WARNING: ECMC_ACCL setting is deprecated. Please use ECMC_ACCS_EGU_PER_S2 instead..'"

#- Use ECMC_ACCL if defined otherwise ECMC_ACCS_EGU_PER_S2
ecmcEpicsEnvSetCalcTernary(ECMC_BLOCK_ACCL,"'${ECMC_ACCL=EMPTY}'!='EMPTY'","", "#-")
ecmcEpicsEnvSetCalcTernary(ECMC_BLOCK_ACCS,"'${ECMC_ACCL=EMPTY}'=='EMPTY'","", "#-")
${ECMC_BLOCK_ACCL} ecmcConfigOrDie "Cfg.SetAxisVelAccDecTime(${ECMC_AXIS_NO},${ECMC_VELO},${ECMC_ACCL=0})"
${ECMC_BLOCK_ACCS} ecmcConfigOrDie "Cfg.SetAxisAcc(${ECMC_AXIS_NO},${ECMC_ACCS_EGU_PER_S2=0})"
${ECMC_BLOCK_ACCS} ecmcConfigOrDie "Cfg.SetAxisDec(${ECMC_AXIS_NO},${ECMC_DECS_EGU_PER_S2=${ECMC_ACCS_EGU_PER_S2=0}})"
ecmcConfigOrDie "Cfg.SetAxisJerk(${ECMC_AXIS_NO},${ECMC_JERK=0})"
ecmcConfigOrDie "Cfg.SetAxisVel(${ECMC_AXIS_NO},${ECMC_VELO})"
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(${ECMC_AXIS_NO},${ECMC_EMERG_DECEL})"
ecmcConfigOrDie "Cfg.SetAxisHomeVelTowardsCam(${ECMC_AXIS_NO},${ECMC_HOME_VEL_TO})"
ecmcConfigOrDie "Cfg.SetAxisHomeVelOffCam(${ECMC_AXIS_NO},${ECMC_HOME_VEL_FRM})"

#- Controller
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(${ECMC_AXIS_NO},${ECMC_CNTRL_KP})"
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(${ECMC_AXIS_NO},${ECMC_CNTRL_KI})"
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(${ECMC_AXIS_NO},${ECMC_CNTRL_KD})"
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(${ECMC_AXIS_NO},${ECMC_CNTRL_KFF})"

#- Encoder
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_ACTPOS},"ax${ECMC_AXIS_NO}.enc.actpos")"
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(${ECMC_AXIS_NO},${ECMC_ENC_SCALE_DENOM})"
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(${ECMC_AXIS_NO},${ECMC_ENC_SCALE_NUM})"
ecmcConfigOrDie "Cfg.SetAxisEncType(${ECMC_AXIS_NO},${ECMC_ENC_TYPE})"
ecmcConfigOrDie "Cfg.SetAxisEncBits(${ECMC_AXIS_NO},${ECMC_ENC_BITS})"
ecmcConfigOrDie "Cfg.SetAxisEncAbsBits($(ECMC_AXIS_NO),${ECMC_ENC_ABS_BITS})"
ecmcConfigOrDie "Cfg.SetAxisEncOffset($(ECMC_AXIS_NO),${ECMC_ENC_ABS_OFFSET})"
ecmcConfigOrDie "Cfg.SetAxisEncVelFilterSize($(ECMC_AXIS_NO),${ECMC_ENC_VEL_FILTER_SIZE=100})"
ecmcConfigOrDie "Cfg.SetAxisEncPosFilterSize($(ECMC_AXIS_NO),${ECMC_ENC_POS_FILTER_SIZE=1})"
ecmcConfigOrDie "Cfg.SetAxisEncPosFilterEnable($(ECMC_AXIS_NO),${ECMC_ENC_POS_FILTER_ENABLE=0})"

ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_RESET=""},"ax${ECMC_AXIS_NO}.enc.reset")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_ALARM_0=""},"ax${ECMC_AXIS_NO}.enc.alarm0")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_ALARM_1=""},"ax${ECMC_AXIS_NO}.enc.alarm1")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_ALARM_2=""},"ax${ECMC_AXIS_NO}.enc.alarm2")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_WARNING=""},"ax${ECMC_AXIS_NO}.enc.warning")"

#- Encoder latching
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCHPOS=""},"ax${ECMC_AXIS_NO}.enc.latchpos")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCH_CONTROL=""},"ax${ECMC_AXIS_NO}.enc.latchcontrol")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCH_STATUS=""},"ax${ECMC_AXIS_NO}.enc.latchstatus")"

#- Multi encoder support
ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup($(ECMC_AXIS_NO),${ECMC_ENC_REF_TO_ENC_AT_STARTUP=-1})"
ecmcConfigOrDie "Cfg.SelectAxisEncPrimary($(ECMC_AXIS_NO),${ECMC_ENC_PRIMARY_ID=-1})"
ecmcConfigOrDie "Cfg.SelectAxisEncHome($(ECMC_AXIS_NO),${ECMC_ENC_HOME_ID=-1})"
ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome($(ECMC_AXIS_NO),${ECMC_ENC_REF_AT_HOME=-1})"


#- Drive
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_CONTROL},"ax${ECMC_AXIS_NO}.drv.control")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_STATUS},"ax${ECMC_AXIS_NO}.drv.status")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_VELOCITY=""},"ax${ECMC_AXIS_NO}.drv.velocity")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_POSITION=""},"ax${ECMC_AXIS_NO}.drv.position")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_BRAKE},"ax${ECMC_AXIS_NO}.drv.brake")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_REDUCE_TORQUE},"ax${ECMC_AXIS_NO}.drv.reducetorque")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_RESET=""},"ax${ECMC_AXIS_NO}.drv.reset")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_ALARM_0=""},"ax${ECMC_AXIS_NO}.drv.alarm0")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_ALARM_1=""},"ax${ECMC_AXIS_NO}.drv.alarm1")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_ALARM_2=""},"ax${ECMC_AXIS_NO}.drv.alarm2")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_WARNING=""},"ax${ECMC_AXIS_NO}.drv.warning")"

ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(${ECMC_AXIS_NO},${ECMC_DRV_SCALE_DENOM})"
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(${ECMC_AXIS_NO},${ECMC_DRV_SCALE_NUM})"
ecmcConfigOrDie "Cfg.SetAxisDrvBrakeOpenDelayTime(${ECMC_AXIS_NO},${ECMC_DRV_BRAKE_OPEN_DLY_TIME})"
ecmcConfigOrDie "Cfg.SetAxisDrvBrakeCloseAheadTime(${ECMC_AXIS_NO},${ECMC_DRV_BRAKE_CLOSE_AHEAD_TIME})"

#- Soft limits
ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(${ECMC_AXIS_NO},${ECMC_SOFT_LOW_LIM})"
ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(${ECMC_AXIS_NO},${ECMC_DXLM_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(${ECMC_AXIS_NO},${ECMC_SOFT_HIGH_LIM})"
ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(${ECMC_AXIS_NO},${ECMC_DXLM_ENABLE})"

#- Monitor
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_MON_LOWLIM},"ax${ECMC_AXIS_NO}.mon.lowlim")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_MON_HIGHLIM},"ax${ECMC_AXIS_NO}.mon.highlim")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_MON_HOME_SWITCH},"ax${ECMC_AXIS_NO}.mon.homesensor")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_MON_EXT_INTERLOCK},"ax${ECMC_AXIS_NO}.mon.extinterlock")"
ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(${ECMC_AXIS_NO},${ECMC_MON_AT_TARGET_TOL})"
ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(${ECMC_AXIS_NO},${ECMC_MON_AT_TARGET_TIME})"
ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(${ECMC_AXIS_NO},${ECMC_MON_AT_TARGET_ENA})"
ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(${ECMC_AXIS_NO},${ECMC_MON_LAG_MON_TOL})"
ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(${ECMC_AXIS_NO},${ECMC_MON_LAG_MON_TIME})"
ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(${ECMC_AXIS_NO},${ECMC_MON_LAG_MON_ENA})"
ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(${ECMC_AXIS_NO},${ECMC_MON_VELO_MAX})"
ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(${ECMC_AXIS_NO},${ECMC_MON_VELO_MAX_ENA})"
ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(${ECMC_AXIS_NO},${ECMC_MON_VELO_MAX_DRV_TIME})"
ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(${ECMC_AXIS_NO},${ECMC_MON_VELO_MAX_TRAJ_TIME})"

#- Homing
ecmcConfigOrDie "Cfg.SetAxisMonHomeSwitchPolarity(${ECMC_AXIS_NO},${ECMC_HOME_SWITCH_POL=0})"
ecmcConfigOrDie "Cfg.SetAxisHomeLatchCountOffset(${ECMC_AXIS_NO},${ECMC_HOME_LATCH_COUNT_OFFSET=0.0})"
ecmcConfigOrDie "Cfg.SetAxisHomePosition(${ECMC_AXIS_NO},${ECMC_HOME_POS=0.0})"
ecmcConfigOrDie "Cfg.SetAxisHomePostMoveEnable(${ECMC_AXIS_NO}, ${ECMC_HOME_POS_MOVE_ENA=0})"
ecmcConfigOrDie "Cfg.SetAxisHomePostMoveTargetPosition(${ECMC_AXIS_NO}, ${ECMC_HOME_POS_MOVE_TARG_POS=0})"

#- Call motor record dedicated script  (Must be called here so ECMC_BLOCK_ACCL and ECMC_BLOCK_ACCS are correct)
${ECMC_USE_MOTOR_RECORD} ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc_axis_mr.cmd",1)
${ECMC_USE_MOTOR_RECORD} ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc_axis_mr.cmd

#- Cleanup

epicsEnvUnset(ECMC_BLOCK_ACCL)
epicsEnvUnset(ECMC_BLOCK_ACCS)
