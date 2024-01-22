#==============================================================================
# loadAxisPLCFile.cmd
#- Arguments: FILE, [AX_ID],[PLC_MACROS]

#-d /**
#-d   \brief Script for adding a PLC from file.
#-d   \details Adds a PLC defined in FILE. Also adds PLC specific EPICS PVs, i.e. for enable/disable.
#-d   \author Niko Kivel
#-d   \file
#-d   \param FILE PLC definition file, i.e. ./plc/homeSlit.plc
#-d   \param AX_ID (optional) Ax number, default 0
#-d   \param PLC_MACROS (optional) Substitution macros for PLC code
#-d   \param TMP_PATH (optional) directory to dump the temporary plc file after macro substitution
#-d   \param PRINT_PLC_FILE (optional) 1/0, printout msi parsed plc file (default enable(1)).
#-d   \param SUBST_FILE (optional) custom substitution file otherwise ecmccfg default will be loaded
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadAxisPLCFile.cmd, "AX_ID=1, FILE=./plc/homeSlit.plc"
#-d   \endcode
#-d */

#- Create a new PLC 0 (Motion: Direct access through variables, I/O, global var, plc enable)

epicsEnvSet("ECMC_AX_ID_TEMP",          "${AX_ID=0}")

epicsEnvSet("ECMC_TMP_FILE",            "${TMP_PATH=/tmp}/PLC${ECMC_AX_ID_TEMP}.plc")

#- Convert file with optional macros (msi)
ecmcFileExist("${FILE}",1)
system "msi -V -M '${PLC_MACROS=EMPTY}' -o ${ECMC_TMP_FILE} ${FILE}"

#- Printout parsed file?
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, ${PRINT_PLC_FILE=1}=1,"", "#-"  )
${ECMC_EXE_CMD=""}########### Parsed PLC file:
${ECMC_EXE_CMD=""}system "cat ${ECMC_TMP_FILE}"
${ECMC_EXE_CMD=""}############ PLC file end
${ECMC_EXE_CMD=""}#
epicsEnvUnset(ECMC_EXE_CMD)

ecmcFileExist("${ECMC_TMP_FILE}",1)
ecmcConfigOrDie "Cfg.LoadAxisPLCFile(${ECMC_AX_ID_TEMP},${ECMC_TMP_FILE})"

#- Remove parsed file after load
system "rm -f ${ECMC_TMP_FILE}"
