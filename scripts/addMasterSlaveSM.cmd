#==============================================================================
# addMasterSlaveSM.cmd
#- Arguments: NAME, MST_GRP_NAME, SLV_GRP_NAME [MST_SLV_ID]
#-d /**
#-d   \brief Script for craeting and adding a lookup table (LUT) from file.
#-d   \author Anders Sandström
#-d   \file
#-d   \param NAME : name of object
#-d   \param MST_GRP_NAME : name of master group (normally virtual axes) 
#-d   \param SLV_GRP_NAME : name of slave group (normally physcal axes)
#-d   \param MST_DISABLE (optional) Disable all master axes when they are not busy (will override auto-disable in yaml), default 0 (axis will not disable)
#-d          when running scans it can be good to allow the master axes to be enabled.   
#-d   \param SLV_DISABLE (optional) Disable all slave axes when they are not busy (will override auto-disable in yaml), default 1 (axes will disable)
#-d          Slaves are default diabled when not busy in order to give control to master axes as soon as possible. 
#-d    To have full control, both SLV_DISABLE and MST_DISABLE, can be set to 0 and then therequired timeouts can be configured in the axis.autoEnable parameters.
#-d */

epicsEnvSet("ECMC_SM_ID",              "${SM_ID=0}")

ecmcEpicsEnvSetCalc("ECMC_SM_ID_2_CHAR", "${ECMC_SM_ID}","%02d")

ecmcConfigOrDie "Cfg.CreateMasterSlaveSM(${ECMC_SM_ID},${NAME=empty},${MST_GRP_NAME},${SLV_GRP_NAME},${MST_DISABLE=0},${SLV_DISABLE=1})"
ecmcFileExist("ecmcSM.db",1,1)
dbLoadRecords("ecmcSM.db", "P=$(ECMC_PREFIX),ID_2CH=${ECMC_SM_ID_2_CHAR},Index=${ECMC_SM_ID},PORT=${ECMC_ASYN_PORT},T_SMP_MS=${ECMC_EC_SAMPLE_RATE_MS},NAME=${NAME=empty},SLV_NAME=${SLV_GRP_NAME},MST_NAME=${MST_GRP_NAME},PREV_OBJ_ID=${ECMC_PREV_SM_OBJ_ID=-1}")


#- Below for facilitate auto gui generation
# Do not set NxtObj "pointer" if this is the first SM (ECMC_PREV_SM_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_SM,"${ECMC_PREV_SM_OBJ_ID=-1}>=0", "","#- ")
${ECMC_EXE_NEXT_SM}ecmcFileExist(ecmcSMPrevSM.db,1,1)
${ECMC_EXE_NEXT_SM}dbLoadRecords(ecmcSMPrevSM.db,"NEXT_OBJ_ID=${ECMC_SM_ID=-1},PREV_ECMC_P=${ECMC_PREV_SM_P=""}")
epicsEnvUnset(ECMC_EXE_NEXT_SM)

#- If this is the first added SM then store value in P:MCU-Cfg-SM-FrstObjId
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_SM,"${ECMC_PREV_SM_OBJ_ID=-1}<0", "","#- ")
${ECMC_EXE_FIRST_SM}ecmcFileExist(ecmcSMFirstSM.db,1,1)
${ECMC_EXE_FIRST_SM}dbLoadRecords(ecmcSMFirstSM.db,"P=${ECMC_PREFIX},FIRST_OBJ_ID=${ECMC_SM_ID}")
epicsEnvUnset(ECMC_EXE_FIRST_SM)

epicsEnvSet(ECMC_PREV_SM_P,"$(ECMC_PREFIX)MCU-Cfg-SM${ECMC_SM_ID}-")
epicsEnvSet(ECMC_PREV_SM_OBJ_ID,${ECMC_SM_ID})

ecmcEpicsEnvSetCalc("ECMC_SM_COUNT", "${ECMC_SM_COUNT=0}+1","%d")

#- increment SM ID
ecmcEpicsEnvSetCalc("SM_ID", "${ECMC_SM_ID}+1","%d")
