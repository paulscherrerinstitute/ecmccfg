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
#-d   \param MST_SLV_ID (optional) Default the next free number.
#-d
#-d */

epicsEnvSet("ECMC_MST_SLV_ID",              "${MST_SLV_ID=0}")

ecmcEpicsEnvSetCalc("ECMC_MST_SLV_ID_2_CHAR", "${ECMC_MST_SLV_ID}","%02d")

ecmcConfigOrDie "Cfg.CreateMasterSlaveSM(${ECMC_MST_SLV_ID},${NAME=empty},${MST_GRP_NAME},${SLV_GRP_NAME})"
ecmcFileExist("ecmcMasterSlaveSM.db",1,1)
dbLoadRecords("ecmcMasterSlaveSM.db", "P=$(ECMC_PREFIX),ID_2CH=${ECMC_MST_SLV_ID_2_CHAR},ID=${ECMC_MST_SLV_ID},PORT=${ECMC_ASYN_PORT},T_SMP_MS=${ECMC_EC_SAMPLE_RATE_MS},NAME=${NAME=empty},SLV_NAME=${SLV_GRP_NAME},MST_NAME=${MST_GRP_NAME}")

#- increment ID
ecmcEpicsEnvSetCalc("MST_SLV_ID", "${ECMC_MST_SLV_ID}+1","%d")
