#==============================================================================
# ecmc_enc-records.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for adding encoder related EPICS PVs.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note This script is typically called by \b addAxis.cmd
#-d   \pre An axis definition for a encoder has to be added/configured immediately before the call of this script.
#-d */

ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc_enc.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc_enc.cmd
ecmcFileExist("ecmcEnc.db",1,1)
dbLoadRecords("ecmcEnc.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_NO=${ECMC_AXIS_NO},ENC_NO=${ECMC_ENC_CFG_ID=1},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},EGU=${ECMC_ENC_EGU=${ECMC_EGU=}},DESC=${ECMC_ENC_DESC=${ECMC_DESC=}},HOME_PROC=${ECMC_HOME_PROC=0},VEL_TO_CAM=${ECMC_HOME_VEL_TO=0},VEL_FRM_CAM=${ECMC_HOME_VEL_FRM=0},ACC=${ECMC_HOME_ACC=-1},DEC=${ECMC_HOME_DEC=-1},REF_HME=${ECMC_ENC_REF_AT_HOME=-1},REF_STRT=${ECMC_ENC_REF_TO_ENC_AT_STARTUP_ID=-1},POST_ENA=${ECMC_HOME_POS_MOVE_ENA=-1},POST_POS=${ECMC_HOME_POS_MOVE_TARG_POS=0},POS=${ECMC_HOME_POS=0}")
