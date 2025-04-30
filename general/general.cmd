#==============================================================================
# general.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Add general PVs
#-d   \details Script for adding general and master diagnostics EPICS PVs
#-d   \author Niko Kivel, Anders Sandstroem
#-d   \file
#-d   Macros (optional):
#-d     T_SMP_HOOK_MS  : Update rate of MCU-Updated PV [ms]
#-d     ECMC_PROC_HOOK : Same as PROC_HOOK
#-d     T_SMP_MS       : Maximum sample time of other records loaded by this script [ms]
#-d */

#- Add ecmc general records
ecmcFileExist("ecmcGeneral.db",1,1)
dbLoadRecords("ecmcGeneral.db","P=${ECMC_PREFIX},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,T_SMP_MS=${T_SMP_MS=${ECMC_SAMPLE_RATE_MS}},TSE=${ECMC_TSE},ECMC_PROC_HOOK=${ECMC_PROC_HOOK=''},T_SMP_HOOK_MS=${ECMC_T_SMP_HOOK_MS=${T_SMP_MS=${ECMC_SAMPLE_RATE_MS}}}")

#- Add MCU sumamry records
ecmcFileExist("ecmcMcuInfoLast.db",1,1)
dbLoadRecords("ecmcMcuInfoLast.db","P=${ECMC_PREFIX},AXIS_COUNT=${ECMC_AXIS_COUNT=0},PLC_COUNT=${ECMC_PLC_COUNT=0},PLUGIN_COUNT=${ECMC_PLUGIN_COUNT=0},DS_COUNT=${ECMC_DS_COUNT=0},ECDOMAIN_COUNT=${ECMC_ECDOMAIN_COUNT=1},ECSLAVE_COUNT=${ECMC_ECSLAVE_COUNT=0}")
