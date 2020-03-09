#==============================================================================
# loadPLCFile.cmd
#- Arguments: FILE, [PLC_ID], [SAMPLE_RATE_MS], [PLC_MACROS]

#-d /**
#-d   \brief Script for adding a PLC from file.
#-d   \details Adds a PLC defined in FILE. Also adds PLC specific EPICS PVs, i.e. for enable/disable.
#-d   \author Niko Kivel
#-d   \file
#-d   \param FILE PLC definition file, i.e. ./plc/homeSlit.plc
#-d   \param PLC_ID (optional) PLC number, default 0
#-d   \param SAMPLE_RATE_MS (optional) excecution rate, default 1 ms (realtime)
#-d   \param PLC_MACROS (optional) Substitution macros for PLC code
#-d   \param TMP_PATH (optional) directory to dump the temporary plc file after macro substitution
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0, FILE=./plc/homeSlit.plc, SAMPLE_RATE_MS=100"
#-d   \endcode
#-d */

#- Create a new PLC 0 (Motion: Direct access through variables, I/O, global var, plc enable)

epicsEnvSet("ECMC_PLC_ID",              "${PLC_ID=0}")
epicsEnvSet("ECMC_PLC_SAMPLE_RATE_MS",  "${SAMPLE_RATE_MS=1}") # execute at 1000Hz
epicsEnvSet("ECMC_TMP_FILE",            "${TMP_PATH=/tmp}/PLC${ECMC_PLC_ID}.plc")

#- Convert file with optional macros (msi)
ecmcFileExist("${FILE}",1)
system "msi -V -M '${PLC_MACROS=EMPTY}' ${FILE} > ${ECMC_TMP_FILE}"
ecmcFileExist("${ECMC_TMP_FILE}",1)
ecmcConfigOrDie "Cfg.CreatePLC(${ECMC_PLC_ID},${ECMC_PLC_SAMPLE_RATE_MS})"
ecmcConfigOrDie "Cfg.LoadPLCFile(${ECMC_PLC_ID},${ECMC_TMP_FILE})"

#- Remove parsed file after load
system "rm -f ${ECMC_TMP_FILE}"
ecmcFileExist("ecmcPlc.db",1,1)
dbLoadRecords("ecmcPlc.db", "PORT=${ECMC_ASYN_PORT},A=0,Index=${ECMC_PLC_ID},Name=${ECMC_PREFIX}")
