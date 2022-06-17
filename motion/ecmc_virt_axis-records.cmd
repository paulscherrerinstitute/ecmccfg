#==============================================================================
# ecmc_virt_axis-records.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for adding axis related EPICS PVs.
#-d   \details Adds motorRecord to the IOC.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note This script is typically called by \b addVirtualAxis.cmd
#-d   \pre An axis definition for a virtual axis has to be added/configured immediately before the call of this script.
#-d */

ecmcFileExist("${ecmccfg_DIR}ecmc_virt_axis.cmd",1)
${SCRIPTEXEC}( ${ecmccfg_DIR}ecmc_virt_axis.cmd )
ecmcFileExist("ecmcAxis.db",1,1)
dbLoadRecords("ecmcAxis.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_NO=${ECMC_AXIS_NO},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
#- This is an VIRT axis == type 2
ecmcFileExist("ecmcAxisType.db",1,1)
dbLoadRecords("ecmcAxisType.db","P=${ECMC_PREFIX},AXIS_NAME=${ECMC_MOTOR_NAME},AXIS_TYPE=1,DRV_TYPE=2,TRAJ_TYPE=$(ECMC_TRAJ_TYPE=0)")
