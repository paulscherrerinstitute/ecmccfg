#==============================================================================
# loadSubstConfig.cmd
#-d /**
#-d   \brief Script for loading complete ecmc cfg based on subst files and templates
#-d   \details Loads complete ecmc cfg based on subst files and templates
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE Subsitution file , i.e. ./cfg.subs
#-d   \param MACROS (optional ) macros to msi , "I=7021"
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadSubstConfig.cmd, "FILE=./cfg.subs"
#-d   \endcode
#-d */

#- Check if ecmccomp is loaded otherwise require it
ecmcEpicsEnvSetCalcTernary(EXE,"'${ecmccomp_DIR=NAN}'=='NAN'","", "#-")
${EXE}require ecmccomp ${ECMCCOMP_VER=''}
#- Check again, now it should be there
${EXE}ecmcEpicsEnvSetCalcTernary(EXE,"'${ecmccomp_DIR=NAN}'=='NAN'","", "#-")
${EXE}ecmcExit Error: ecmccomp module not loaded and not found
epicsEnvUnset(EXE)

#- Parse subst and template with msi. Parse output to separetae axis files
ecmcFileExist(${ecmccfg_DIR}loadCompleteCfgSubst.sh,1,1)
system "${ecmccfg_DIR}loadCompleteCfgSubst.sh ${FILE} ${ECMC_TMP_DIR} tempExe.cmd tempFile.ax ${ecmccfg_DIR} ${MACROS=''}"
system "ls ${ECMC_TMP_DIR}"

#- Execute the generated file (calling loadYamlAxis.cmd)
ecmcFileExist(${ECMC_TMP_DIR}tempExe.cmd,1,1)
$(SCRIPTEXEC) ${ECMC_TMP_DIR}tempExe.cmd

#- Cleanup
system "rm ${ECMC_TMP_DIR}tempExe.cmd"
