#==============================================================================
# ecmc_virt_axis.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for configuring a virtual axis.
#-d   \details Configures a virtual axis in ECMC, based on previously set environment variables.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note This script is typically called by \b addVirtualAxis.cmd, often via \b ecmc_virt_axis-records.cmd
#-d   \pre An axis definition for a virtual axis has to be added/configured immediately before the call of this script.
#-d */

#- Ensure valid current settings
ecmcFileExist("${ECMC_CONFIG_ROOT}verifyOrDie.cmd",1)
#- ECMC_ENC_SCALE_NUM
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}verifyOrDie.cmd "EXPR_STR='abs(${ECMC_ENC_SCALE_NUM})<>0',SUCCESS_STR='ECMC_ENC_SCALE_NUM value OK == ${ECMC_ENC_SCALE_NUM}...',ERROR_STR='ECMC_ENC_SCALE_NUM == 0...'"
#- ECMC_ENC_SCALE_DENOM
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}verifyOrDie.cmd "EXPR_STR='abs(${ECMC_ENC_SCALE_DENOM})<>0',SUCCESS_STR='ECMC_ENC_SCALE_DENOM value OK == ${ECMC_ENC_SCALE_DENOM}...',ERROR_STR='ECMC_ENC_SCALE_DENOM == 0...'"

#- Issue Warning if ECMC_MRES is set. MRES calculated bu SREV and UREV instead
ecmcFileExist("${ECMC_CONFIG_ROOT}issueWarning.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}issueWarning.cmd "EXPR_STR='${ECMC_MRES=-1}>0',WARNING_STR='WARNING: ECMC_MRES setting is deprecated and will not be used. (MRES will be calulated instead: ECMC_ENC_SCALE_NUM/ECMC_ENC_SCALE_DENOM).. '"

#- General
ecmcConfigOrDie "Cfg.CreateAxis(${ECMC_AXIS_NO},2)"
ecmcConfigOrDie "Cfg.SetAxisTrajStartPos(${ECMC_AXIS_NO},0)"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_AXIS_HEALTH},"ax${ECMC_AXIS_NO}.health")"
ecmcConfigOrDie "Cfg.SetAxisModRange(${ECMC_AXIS_NO}, ${ECMC_MOD_RANGE})"
ecmcConfigOrDie "Cfg.SetAxisModType(${ECMC_AXIS_NO}, ${ECMC_MOD_TYPE})"

#- Trajectory
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(${ECMC_AXIS_NO},${ECMC_EMERG_DECEL})"
ecmcConfigOrDie "Cfg.SetAxisVelAccDecTime(${ECMC_AXIS_NO},${ECMC_VELO},${ECMC_ACCL})"
ecmcConfigOrDie "Cfg.SetAxisHomeVelTwordsCam(${ECMC_AXIS_NO},${ECMC_HOME_VEL_TO})"
ecmcConfigOrDie "Cfg.SetAxisHomeVelOffCam(${ECMC_AXIS_NO},${ECMC_HOME_VEL_FRM})"

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

#- Soft limits
ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(${ECMC_AXIS_NO},${ECMC_SOFT_LOW_LIM})"
ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(${ECMC_AXIS_NO},${ECMC_DXLM_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(${ECMC_AXIS_NO},${ECMC_SOFT_HIGH_LIM})"
ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(${ECMC_AXIS_NO},${ECMC_DXLM_ENABLE})"

#- Homing
ecmcConfigOrDie "Cfg.SetAxisMonHomeSwitchPolarity(${ECMC_AXIS_NO},${ECMC_HOME_SWITCH_POL=0})"
ecmcConfigOrDie "Cfg.SetAxisHomeLatchCountOffset(${ECMC_AXIS_NO},${ECMC_HOME_LATCH_COUNT_OFFSET=0.0})"
ecmcConfigOrDie "Main.M${ECMC_AXIS_NO}.fHomePosition=${ECMC_HOME_POS=0.0}"
ecmcConfigOrDie "Cfg.SetAxisHomePostMoveEnable(${ECMC_AXIS_NO}, ${ECMC_HOME_POS_MOVE_ENA=0})"
ecmcConfigOrDie "Cfg.SetAxisHomePostMoveTargetPosition(${ECMC_AXIS_NO}, ${ECMC_HOME_POS_MOVE_TARG_POS=0})"

${ECMC_MR_MODULE="ecmcMotorRecord"}CreateAxis(${ECMC_MOTOR_PORT}, "${ECMC_AXIS_NO}", "6", "${ECMC_AXISCONFIG}")

#- Calc motor record SREV and UREV fields if not defined then return 1 for both SREV and UREV
ecmcEpicsEnvSetCalc("ECMC_TEMP_SREV","if(abs(${ECMC_ENC_SCALE_DENOM=0})>0){RESULT:=abs(${ECMC_ENC_SCALE_DENOM=0});} else {RESULT:=1.0};","%d")
ecmcEpicsEnvSetCalc("ECMC_TEMP_UREV","if(abs(${ECMC_ENC_SCALE_NUM=0})>0){RESULT:=abs(${ECMC_ENC_SCALE_NUM=0});} else {RESULT:=1.0};","%lf")

ecmcFileExist(${ECMC_MR_MODULE="ecmcMotorRecord"}.template,1,1)
dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord"}.template, "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO}, DESC=${ECMC_DESC}, EGU=${ECMC_EGU}, PREC=${ECMC_PREC}, VELO=${ECMC_VELO}, JVEL=${ECMC_JOG_VEL}, JAR=${ECMC_JAR}, ACCL=${ECMC_ACCL}, RDBD=${ECMC_MON_AT_TARGET_TOL}, DLLM=${ECMC_SOFT_LOW_LIM}, DHLM=${ECMC_SOFT_HIGH_LIM}, HOMEPROC=${ECMC_HOME_PROC},SREV=${ECMC_TEMP_SREV},UREV=${ECMC_TEMP_UREV}, ${ECMC_AXISFIELDINIT=""}")
epicsEnvSet("ECMC_AXISFIELDINIT",  "")

ecmcFileExist(${ECMC_MR_MODULE="ecmcMotorRecord"}"home.template",1,1)
dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord"}"home.template", "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO},HOMEPROC=${ECMC_HOME_PROC}, HOMEPOS=${ECMC_HOME_POS}, HVELTO=${ECMC_HOME_VEL_TO}, HVELFRM=${ECMC_HOME_VEL_FRM}, HOMEACC=${ECMC_HOME_ACC}, HOMEDEC=${ECMC_HOME_DEC}")

#- Cleanup
epicsEnvUnset(ECMC_TEMP_SREV)
epicsEnvUnset(ECMC_TEMP_UREV)
