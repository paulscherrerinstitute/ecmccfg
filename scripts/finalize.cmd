#==============================================================================
# finalize.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Script for finalizing. Executed just before iocInit (atInit)
#-d   \details Script for finalizing. Executed just before iocInit (atInit).
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

# Load axes group info
ecmcConfig "GetAxisGroupCount()"
ecmcEpicsEnvSetCalcTernary(ECMC_BLOCK_EXE, "'Error' in '${ECMC_CONFIG_RETURN_VAL}'", "#-", "")
${ECMC_BLOCK_EXE=}epicsEnvSet(ECMC_AXES_GRP_COUNT,${ECMC_CONFIG_RETURN_VAL=0})
${ECMC_BLOCK_EXE=}dbLoadRecords(ecmcAxisGroups.db,"P=${IOC}:,COUNT=${ECMC_AXES_GRP_COUNT=0}")
${ECMC_BLOCK_EXE=}ecmcEpicsEnvSetCalc(ECMC_AXES_GRP_LOOP_END,"${ECMC_AXES_GRP_COUNT=0}-1")
${ECMC_BLOCK_EXE=}ecmcEpicsEnvSetCalcTernary(ECMC_BLOCK_EXE, "${ECMC_AXES_GRP_COUNT=0}>0", "", "#-")
${ECMC_BLOCK_EXE=}ecmcForLoop(${ecmccfg_DIR}finalizeAxGrp_loopStep.cmd,"P=${IOC}:",ECMC_LOOP_IDX,0,${ECMC_AXES_GRP_LOOP_END=0},1)
epicsEnvUnset(ECMC_BLOCK_EXE)

#- Set app mode if not done
ecmcIf("${ECMC_SET_APP_MODE_DONE=0}!=1")
${IF_TRUE}$(SCRIPTEXEC) ($(ecmccfg_DIR)setAppMode.cmd)
ecmcEndIf()
epicsEnvUnset(ECMC_SET_APP_MODE_DONE)
