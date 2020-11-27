#==============================================================================
# general.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for adding general and master diagnostics EPICS PVs
#-d   \author Niko Kivel, Anders Sandstroem
#-d   \file
#-d */

#- Add ecmc general records
ecmcFileExist("ecmcGeneral.db",1,1)
dbLoadRecords("ecmcGeneral.db","P=${ECMC_PREFIX},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},ECMC_PROC_HOOK=${ECMC_PROC_HOOK}")
# Nice commands for info ecmcReport <level> or asynReport <level>
# ecmcReport 3
#-------------------------------------------------------------------------------
