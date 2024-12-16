#==============================================================================
# ecmc_axis_mr.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for loading motor record related databases
#-d   \details Script for loading motor record related databases and creating motor record axis object
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note This script is typically called by \b ecmc_axis.cmd, often via \b ecmc_axis-records.cmd
#-d */

#- Motor record init
${ECMC_MR_MODULE="ecmcMotorRecord"}CreateAxis(${ECMC_MOTOR_PORT}, "${ECMC_AXIS_NO}", "6", ${ECMC_AXISCONFIG})

#- Calc motor record SREV and UREV fields if not defined then return 1 for both SREV and UREV
ecmcEpicsEnvSetCalc("ECMC_TEMP_SREV","if(abs(${ECMC_ENC_SCALE_DENOM=1})>0){RESULT:=abs(${ECMC_ENC_SCALE_DENOM=0});} else {RESULT:=1.0};","%d")
ecmcEpicsEnvSetCalc("ECMC_TEMP_UREV","if(abs(${ECMC_ENC_SCALE_NUM=0})>0){RESULT:=abs(${ECMC_ENC_SCALE_NUM=0});} else {RESULT:=1.0};","%lf")

#- Use correct field depending on use of ACCL or ACCS
ecmcFileExist(${ECMC_MR_MODULE="ecmcMotorRecord${ECMC_PVA}"}.template,1,1)
${ECMC_BLOCK_ACCL} dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord${ECMC_PVA}"}.template, "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO}, DESC=${ECMC_DESC}, EGU=${ECMC_EGU}, PREC=${ECMC_PREC}, VELO=${ECMC_VELO}, JVEL=${ECMC_JOG_VEL}, JAR=${ECMC_JAR}, ACCL=${ECMC_ACCL=0}, RDBD=${ECMC_MON_AT_TARGET_TOL}, DLLM=${ECMC_SOFT_LOW_LIM}, DHLM=${ECMC_SOFT_HIGH_LIM}, HOMEPROC=${ECMC_HOME_PROC},SREV=${ECMC_TEMP_SREV},UREV=${ECMC_TEMP_UREV}, ${ECMC_AXISFIELDINIT=""}")
${ECMC_BLOCK_ACCS} dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord${ECMC_PVA}"}.template, "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO}, DESC=${ECMC_DESC}, EGU=${ECMC_EGU}, PREC=${ECMC_PREC}, VELO=${ECMC_VELO}, JVEL=${ECMC_JOG_VEL}, JAR=${ECMC_JAR}, ACCS=${ECMC_ACCS_EGU_PER_S2=0}, RDBD=${ECMC_MON_AT_TARGET_TOL}, DLLM=${ECMC_SOFT_LOW_LIM}, DHLM=${ECMC_SOFT_HIGH_LIM}, HOMEPROC=${ECMC_HOME_PROC},SREV=${ECMC_TEMP_SREV},UREV=${ECMC_TEMP_UREV}, ${ECMC_AXISFIELDINIT=""}")

epicsEnvSet("ECMC_AXISFIELDINIT",  "")

ecmcFileExist(${ECMC_MR_MODULE="ecmcMotorRecord"}home.template,1,1)
dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord"}home.template, "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO},HOMEPROC=${ECMC_HOME_PROC}, HOMEPOS=${ECMC_HOME_POS}, HVELTO=${ECMC_HOME_VEL_TO}, HVELFRM=${ECMC_HOME_VEL_FRM}, HOMEACC=${ECMC_HOME_ACC}")

#- Cleanup
epicsEnvUnset(ECMC_TEMP_SREV)
epicsEnvUnset(ECMC_TEMP_UREV)
