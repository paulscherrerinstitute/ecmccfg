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
dbLoadRecords("ecmcEnc.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_NO=${ECMC_AXIS_NO},ENC_NO=${ECMC_ENC_CFG_ID},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
