#==============================================================================
# addVirtualAxis.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for adding axis EPICS PVs.
#-d   \author Niko Kivel
#-d   \file
#-d */
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc_virt_axis${ECMC_GEN_EC_RECORDS}.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc_virt_axis${ECMC_GEN_EC_RECORDS}.cmd
