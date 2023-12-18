#==============================================================================
# loadSubstHw.cmd
#- Arguments: FILE

#-d /**
#-d   \brief Script for adding multiple hw based on subst and template file
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE Subsitution file , i.e. ./hw.subs
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadSubstHw.cmd, "FILE=./hw.subs"
#-d   \endcode
#-d */

#- Parse subst and template with msi. Parse output to separetae axis files 
system "${ecmccfg_DIR}multiHw.sh ${FILE} ${ECMC_TMP_DIR} tempHw.cmd"
system "ls ${ECMC_TMP_DIR}"

#- Execute the generated file (calling loadYamlAxis.cmd)
$(SCRIPTEXEC) ${ECMC_TMP_DIR}tempHw.cmd

#- Cleanup
system "rm ${ECMC_TMP_DIR}tempHw.cmd"

