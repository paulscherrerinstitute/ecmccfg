#==============================================================================
# loadSubstConfig.cmd
#-d /**
#-d   \brief Script for loading complete ecmc cfg based on subst files and templates
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE Subsitution file , i.e. ./cfg.subs
#-d   \param MACROS (optional ) macros to msi , "I=7021"
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadSubstConfig.cmd, "FILE=./cfg.subs"
#-d   \endcode
#-d */

#- Parse subst and template with msi. Parse output to separetae axis files 
system "${ecmccfg_DIR}loadCompleteCfgSubst.sh ${FILE} ${ECMC_TMP_DIR} tempExe.cmd tempFile.ax ${ecmccfg_DIR} ${MACROS=''}"
system "ls ${ECMC_TMP_DIR}"

#- Execute the generated file (calling loadYamlAxis.cmd)
$(SCRIPTEXEC) ${ECMC_TMP_DIR}tempExe.cmd

#- Cleanup
system "rm ${ECMC_TMP_DIR}tempExe.cmd"

