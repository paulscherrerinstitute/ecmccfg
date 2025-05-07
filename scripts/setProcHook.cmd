#==============================================================================
# setProcHook.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Set processing hook and update rate
#-d   \details The PV <P>: MCU-Updated can be used to forward link other processing in ecmc by forward link.
#-d   \author Anders Sandström
#-d
#-d   Macros (optional):
#-d     T_SMP_HOOK_MS  : Update rate of <P>:MCU-Updated PV [ms] (defaults to ethercat rate)
#-d     PROC_HOOK      : Forward link of <P>:MCU-Updated PV (defaults to empty)
#-d   \example
#-d     ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}setProcHook.cmd "PROC_HOOK=TEST:TRIGG.PROC,T_SMP_HOOK_MS=1"
#-d     ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}setProcHook.cmd "PROC_HOOK=TEST:TRIGG.PROC"
#-d     ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}setProcHook.cmd "T_SMP_HOOK_MS=1"
#-d */

epicsEnvSet(ECMC_PROC_HOOK,${PROC_HOOK=''})
epicsEnvSet(ECMC_T_SMP_HOOK_MS,${T_SMP_HOOK_MS=${ECMC_EC_SAMPLE_RATE_MS}})
