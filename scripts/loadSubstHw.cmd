#==============================================================================
# loadSubstHw.cmd
#- Arguments: FILE

#-d /**
#-d   \brief Script for adding multiple hw based on subst and template file
#-d   \details Loads hw cfg based on subst files and templates
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE Subsitution file , i.e. ./hw.subs
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadSubstHw.cmd, "FILE=./hw.subs"
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
ecmcFileExist(${ecmccfg_DIR}multiHw.sh,1,1)
system "${ecmccfg_DIR}multiHw.sh ${FILE} ${ECMC_TMP_DIR} tempHw.cmd"
system "ls ${ECMC_TMP_DIR}"

#- Execute the generated file (calling loadYamlAxis.cmd)
ecmcFileExist(${ECMC_TMP_DIR}tempHw.cmd,1,1)
$(SCRIPTEXEC) ${ECMC_TMP_DIR}tempHw.cmd

#- Cleanup
system "rm ${ECMC_TMP_DIR}tempHw.cmd"
