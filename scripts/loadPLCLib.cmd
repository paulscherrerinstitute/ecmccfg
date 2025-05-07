#==============================================================================
# loadPLCLib.cmd
#- Arguments: FILE, [PLC_ID], [SAMPLE_RATE_MS], [PLC_MACROS]

#-d /**
#-d   \brief Script for loading a PLC from lib from file.
#-d   \details Adds a PLC defined in FILE. Also adds PLC specific EPICS PVs, i.e. for enable/disable.
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE PLC definition file, i.e. ./plc/homeSlit.plc
#-d   \param PLC_ID (optional) PLC number, default last loaded PLC
#-d   \param PLC_MACROS (optional) Substitution macros for PLC code. The macros "SELF_ID","SELF",M_ID, and M are reserved:
#-d          * "SELF_ID" = PLC Id of this plc
#-d          * "SELF"    = "plc${SELF_ID}"
#-d          * "M_ID"    = EtherCAT master ID
#-d          * "M"       = "ec${M_ID}"
#-d   \param INC (optional) List of directories for include files to pass to MSI (if several paths thendivide with ':').
#-d   \param TMP_PATH (optional) directory to dump the temporary plc file after macro substitution
#-d   \param PRINT_PLC_FILE (optional) 1/0, printout msi parsed plc file (default enable(1)).
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCLib.cmd, "PLC_ID=0, FILE=./plc/homeSlit.plc, SAMPLE_RATE_MS=100"
#-d   \endcode
#-d */

#- Default to last loaded PLC
epicsEnvSet("ECMC_PLC_ID",              "${PLC_ID=${ECMC_PLC_ID}}")

#- PLC rate, if not explicitly declared, deduce rate from bus frequence (ECMC_EC_SAMPLE_RATE)
ecmcEpicsEnvSetCalc(ECMC_PLC_RATE_, "1000/${ECMC_EC_SAMPLE_RATE}", "%f")
epicsEnvSet("ECMC_PLC_SAMPLE_RATE_MS",  "${SAMPLE_RATE_MS=0}")
ecmcEpicsEnvSetCalcTernary(ECMC_PLC_SAMPLE_RATE_MS, "${ECMC_PLC_SAMPLE_RATE_MS}>0", "${ECMC_PLC_SAMPLE_RATE_MS}","${ECMC_PLC_RATE_}")
epicsEnvUnset(ECMC_PLC_RATE_) # clean up, temp variable

epicsEnvSet("ECMC_TMP_FILE",            "${TMP_PATH=/tmp}/PLC${ECMC_PLC_ID}.plc")
#- Add SELF and SELF_ID, M_ID and M
epicsEnvSet("PLC_MACROS",              "SELF_ID=${ECMC_PLC_ID}, SELF='plc${ECMC_PLC_ID}', M_ID=${ECMC_EC_MASTER_ID=0}, M='ec${ECMC_EC_MASTER_ID=0}', ${PLC_MACROS=}")

#- Convert file with optional macros (msi)
ecmcFileExist("${FILE}",1)
system "msi -I ${INC=.} -V -M '${PLC_MACROS=EMPTY}' -o ${ECMC_TMP_FILE} ${FILE}"
epicsEnvUnset(PLC_MACROS)

#- Printout parsed file?
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, ${PRINT_PLC_FILE=1}=1,"", "#-"  )
${ECMC_EXE_CMD=""}########### Parsed PLC-lib file:
${ECMC_EXE_CMD=""}system "cat ${ECMC_TMP_FILE}"
${ECMC_EXE_CMD=""}############ PLC-lib file end
${ECMC_EXE_CMD=""}#
epicsEnvUnset(ECMC_EXE_CMD)

#- Now load the file to ecmc
ecmcFileExist("${ECMC_TMP_FILE}",1)
ecmcConfigOrDie "Cfg.LoadPLCLibFile(${ECMC_PLC_ID},${ECMC_TMP_FILE})"

#- Remove parsed file after load
system "rm -f ${ECMC_TMP_FILE}"
