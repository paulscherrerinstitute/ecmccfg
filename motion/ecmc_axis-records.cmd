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
dbLoadRecords("ecmcAxis.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_NO=${ECMC_AXIS_NO},HOMEPROC=${ECMC_HOME_PROC=0},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},EGU=${ECMC_EGU},PREC=${ECMC_PREC}")
#- This is an REAL axis == type 1
ecmcFileExist("ecmcAxisType.db",1,1)
dbLoadRecords("ecmcAxisType.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_TYPE=1,DRV_TYPE=$(ECMC_DRV_TYPE=0),TRAJ_TYPE=$(ECMC_TRAJ_TYPE=0)")
#-Add info in MCU namespace for auto gui generation
ecmcFileExist("ecmcMcuAxisInfo.db",1,1)
dbLoadRecords("ecmcMcuAxisInfo.db","P=${SM_PREFIX},DEV=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_NO=${ECMC_AXIS_NO}")

#- special PVs for commissioning only add if the COMMISSIONG is set to 1 in startup.cmd
${ECMC_ENG_MODE_CMD="#-"}ecmcFileExist("ecmcAxisCommission.db",1,1)
${ECMC_ENG_MODE_CMD="#-"}dbLoadRecords("ecmcAxisCommission.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},KP=${ECMC_CNTRL_KP},KI=${ECMC_CNTRL_KI},KD=${ECMC_CNTRL_KD},KFF=${ECMC_CNTRL_KFF}")

#- Below for facilitate auto gui generation
# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_AXIS_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_AX,"${ECMC_PREV_AXIS_OBJ_ID=-1}>=0", "","#- ")
${ECMC_EXE_NEXT_AX}ecmcFileExist(ecmcAxPrevAxis.db,1,1)
${ECMC_EXE_NEXT_AX}dbLoadRecords(ecmcAxPrevAxis.db,"NEXT_OBJ_ID=${ECMC_AXIS_NO=-1},PREV_ECMC_P=${ECMC_PREV_AXIS_P=""}")
epicsEnvUnset(ECMC_EXE_NEXT_AX)

#- If this is the first added slave then store value in P:MCU-Cfg-AX-FrstObj
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_AX,"${ECMC_PREV_AXIS_OBJ_ID=-1}<0", "","#- ")
${ECMC_EXE_FIRST_AX}ecmcFileExist(ecmcAxFirstAxis.db,1,1)
${ECMC_EXE_FIRST_AX}dbLoadRecords(ecmcAxFirstAxis.db,"P=${ECMC_PREFIX},FIRST_OBJ_ID=${ECMC_AXIS_NO}")
epicsEnvUnset(ECMC_EXE_FIRST_AX)

#- Store info to populate the ECMC_P-NxtObj "pointer" of next added axis
epicsEnvSet(ECMC_PREV_AXIS_P,"$(ECMC_PREFIX)MCU-Cfg-AX${ECMC_AXIS_NO}-")
epicsEnvSet(ECMC_PREV_AXIS_OBJ_ID,${ECMC_AXIS_NO})
