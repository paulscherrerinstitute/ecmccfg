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
dbLoadRecords("ecmcAxis.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_NO=${ECMC_AXIS_NO},ECMC_SOFT_LOW_LIM=${ECMC_SOFT_LOW_LIM},ECMC_SOFT_HIGH_LIM=${ECMC_SOFT_HIGH_LIM},ECMC_MON_VELO_MAX=${ECMC_MON_VELO_MAX},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
