#==============================================================================
# loadSubstAxes.cmd
#- Arguments: FILE

#-d /**
#-d   \brief Script for adding multiple axes based on subst and template file
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE Subsitution file , i.e. ./plc/ax.subs
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadSubstAxes.cmd, "FILE=./ax.subs"
#-d   \endcode
#-d */

#- Parse subst and template with msi. Parse output to separetae axis files
ecmcFileExist(${ecmccfg_DIR}multiAxis.sh,1,1)
system "${ecmccfg_DIR}multiAxis.sh ${FILE} ${ECMC_TMP_DIR} tempFile.ax ${ecmccfg_DIR}"
system "ls ${ECMC_TMP_DIR}"

#- Execute the generated file (calling loadYamlAxis.cmd)
ecmcFileExist(${ECMC_TMP_DIR}tempFile.ax.exe.cmd,1,1)
$(SCRIPTEXEC) ${ECMC_TMP_DIR}tempFile.ax.exe.cmd

#- Cleanup
system "rm ${ECMC_TMP_DIR}tempFile.ax.exe.cmd"

