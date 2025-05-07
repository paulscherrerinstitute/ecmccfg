#==============================================================================
# initAxis.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for setting up the basic AXIS environment.
#-d   \author Niko Kivel, Anders Sandstroem
#-d   \file
#-d */

ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc_axis_unset.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc_axis_unset.cmd"

ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc_axis_sync_unset.cmd",1)
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc_axis_sync_unset.cmd"

#- NOTE: ecmc_virt_axis_unset.cmd is not needed here since ecmc_axis_unset.cmd contains all varaibles.
