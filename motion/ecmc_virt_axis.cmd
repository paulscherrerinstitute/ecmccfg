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

${ECMC_MR_MODULE="ecmcMotorRecord"}CreateAxis(${ECMC_MOTOR_PORT}, "${ECMC_AXIS_NO}", "6", "stepSize=${ECMC_MRES}")

dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord"}".template", "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO}, DESC=${ECMC_DESC}, EGU=${ECMC_EGU}, PREC=${ECMC_PREC}, VELO=${ECMC_VELO}, JVEL=${ECMC_JOG_VEL}, JAR=${ECMC_JAR}, ACCL=${ECMC_ACCL}, MRES=${ECMC_MRES}, RDBD=${ECMC_MON_AT_TARGET_TOL}, DLLM=${ECMC_SOFT_LOW_LIM}, DHLM=${ECMC_SOFT_HIGH_LIM}, HOMEPROC=${ECMC_HOME_PROC} ${ECMCAXISFIELDINIT}")
epicsEnvSet("ECMCAXISFIELDINIT",  "")

dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord"}"home.template", "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO},HOMEPROC=${ECMC_HOME_PROC}, HOMEPOS=${ECMC_HOME_POS}, HVELTO=${ECMC_HOME_VEL_TO}, HVELFRM=${ECMC_HOME_VEL_FRM}, HOMEACC=${ECMC_HOME_ACC}, HOMEDEC=${ECMC_HOME_DEC}")

dbLoadRecords("ecmcExpression.db", "PORT=${ECMC_ASYN_PORT},A=0,Index=${ECMC_AXIS_NO},Name=${ECMC_PREFIX}${ECMC_MOTOR_NAME}")


