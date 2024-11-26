#===============================================================================
# applyComponent.cmd (ecmccfg, warpper to ecmccomp/applyComponent.cmd)
#- Arguments: n/a
#-d /**
#-d   \brief Warpper for ecmccomp/applyComponent.cmd. 
#-d   \details Checks if ecmccomp is loaded, if not loads, then calls ecmccomp/applyComponent.cmd. 
#-d            Using this wrapper will ensure that ecmccomp is loaded and therefore minimizes the risks of missing hw config.
#-d            NOTE: Only for use if the ecmccomp modeule is accessible (at PSI)
#-d   \author Anders Sandström
#-d   \file
#-d   \param COMP Component name
#-d   \param EC_COMP_TYPE   (optional) Hardware descriptor, i.e. EL7037, defaults to ECMC_EC_COMP_TYPE or ECMC_EC_HWTYPE set in ecmccfg/addSlave.cmd
#-d   \param COMP_S_ID      (optional) Slave bus position, defaults to ECMC_EC_SLAVE_NUM set in ecmccfg/addSlave.cmd
#-d   \param CH_ID          (optional) Channel of slave default to 1
#-d   \param MACROS         (optional) Special macros, depending on component/slave type:
#-d */

#- Check if ecmccomp is loaded otherwise require it
ecmcEpicsEnvSetCalcTernary(EXE,"'${ecmccomp_DIR=NAN}'=='NAN'","", "#-")
${EXE}require ecmccomp ${ECMCCOMP_VER=''}
#- Check again, now it should be there
${EXE}ecmcEpicsEnvSetCalcTernary(EXE,"'${ecmccomp_DIR=NAN}'=='NAN'","", "#-")
${EXE}ecmcExit Error: ecmccomp module not loaded and not found
epicsEnvUnset(EXE)

ecmcFileExist(${ecmccomp_DIR}applyComponent.cmd,1,1)
${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd  "COMP=${COMP}, EC_COMP_TYPE=${EC_COMP_TYPE=${ECMC_EC_COMP_TYPE=${ECMC_EC_HWTYPE=NAN}}}, COMP_S_ID=${COMP_S_ID=${ECMC_EC_SLAVE_NUM=0}}, CH_ID=${CH_ID=1}, MACROS='${MACROS=}'"
