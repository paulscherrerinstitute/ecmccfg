#==============================================================================
# ecmc_axis-records.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for adding axis related EPICS PVs.
#-d   \details Adds motorRecord to the IOC.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note This script is typically called by \b addAxis.cmd
#-d   \pre An axis definition for a physical axis has to be added/configured immediately before the call of this script.
#-d */

ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc_axis.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc_axis.cmd
ecmcFileExist("ecmcAxis.db",1,1)
dbLoadRecords("ecmcAxis.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_NO=${ECMC_AXIS_NO},HOMEPROC=${HOMEPROC=0},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
#- This is an REAL axis == type 1
ecmcFileExist("ecmcAxisType.db",1,1)
dbLoadRecords("ecmcAxisType.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_TYPE=1,DRV_TYPE=$(ECMC_DRV_TYPE=0),TRAJ_TYPE=$(ECMC_TRAJ_TYPE=0)")

#- special PVs for commissioning only add if the COMMISSIONG is set to 1 in startup.cmd
${ECMC_ENG_MODE_CMD="#-"}ecmcFileExist("ecmcAxisCommission.db",1,1)
${ECMC_ENG_MODE_CMD="#-"}dbLoadRecords("ecmcAxisCommission.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},KP=${ECMC_CNTRL_KP},KI=${ECMC_CNTRL_KI},KD=${ECMC_CNTRL_KD},KFF=${ECMC_CNTRL_KFF}")
