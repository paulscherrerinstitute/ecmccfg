#==============================================================================
# addVirtualAxis.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for adding axis EPICS PVs.
#-d   \author Niko Kivel
#-d   \file
#-d */

#- Check ECMC_MODE, only allow if in "FULL" mode
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "'${ECMC_MODE=FULL}'='DAQ'","ecmcExit Error: ECMC started in DAQ mode. Motion not supported..","#-")${ECMC_EXE_CMD}
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)

ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc_virt_axis${ECMC_GEN_EC_RECORDS}.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc_virt_axis${ECMC_GEN_EC_RECORDS}.cmd
