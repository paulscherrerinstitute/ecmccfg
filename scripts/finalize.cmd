#==============================================================================
# finalize.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Script for finalizing. Executed just before iocInit (atInit)
#-d   \author Anders Sandström
#-d   \file
#-d */

#- set ECMC_OVERRIDE_FINALIZE to 1 in order to not execute this script
ecmcIf("${ECMC_OVERRIDE_FINALIZE=0}==1")
${IF_TRUE}exit
ecmcEndIf()
epicsEnvUnset(ECMC_OVERRIDE_FINALIZE)

#- Apply ec cfg if not done
ecmcIf("${ECMC_EC_APPLY_CFG_DONE=0}!=1")
${IF_TRUE}$(SCRIPTEXEC) ($(ecmccfg_DIR)applyConfig.cmd)
ecmcEndIf()
epicsEnvUnset(ECMC_EC_APPLY_CFG_DONE)

#- Set app mode if not done
ecmcIf("${ECMC_SET_APP_MODE_DONE=0}!=1")
${IF_TRUE}$(SCRIPTEXEC) ($(ecmccfg_DIR)setAppMode.cmd)
ecmcEndIf()
epicsEnvUnset(ECMC_SET_APP_MODE_DONE)
