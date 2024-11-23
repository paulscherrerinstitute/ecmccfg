#==============================================================================
# loadPLCFile.cmd
#- Arguments: FILE, [PLC_ID], [SAMPLE_RATE_MS], [PLC_MACROS]

#-d /**
#-d   \brief Script for adding a PLC from file.
#-d   \details Adds a PLC defined in FILE. Also adds PLC specific EPICS PVs, i.e. for enable/disable.
#-d   \author Niko Kivel, Anders Sandström
#-d   \file
#-d   \param FILE PLC definition file, i.e. ./plc/homeSlit.plc
#-d   \param PLC_ID (optional) PLC number, default 0, or to next free PLC, the actual PLC Id is stored in ECMC_PLC_ID and can be used after this command
#-d   \param SAMPLE_RATE_MS (optional) excecution rate, default 1000/EC_RATE
#-d   \param PLC_MACROS (optional) Substitution macros for PLC code. The macros "SELF_ID","SELF",M_ID, and M are reserved:
#-d          * "SELF_ID" = PLC Id of this plc
#-d          * "SELF"    = "plc${SELF_ID}"
#-d          * "M_ID"    = EtherCAT master ID
#-d          * "M"       = "ec${M_ID}"
#-d   \param TMP_PATH (optional) directory to dump the temporary plc file after macro substitution
#-d   \param PRINT_PLC_FILE (optional) 1/0, printout msi parsed plc file (default enable(1)).
#-d   \param SUBST_FILE (optional) custom substitution file otherwise ecmccfg default will be loaded
#-d   \param INC (optional) List of directories for include files to pass to MSI (if several paths thendivide with ':').
#-d   \param DESC (optional) Description of PLC
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0, FILE=./plc/homeSlit.plc, SAMPLE_RATE_MS=100"
#-d   \endcode
#-d */

#- Create a new PLC 0 (Motion: Direct access through variables, I/O, global var, plc enable)

epicsEnvSet("ECMC_PLC_ID",              "${PLC_ID=0}")

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
${ECMC_EXE_CMD=""}########### Parsed PLC file:
${ECMC_EXE_CMD=""}system "cat ${ECMC_TMP_FILE}"
${ECMC_EXE_CMD=""}############ PLC file end
${ECMC_EXE_CMD=""}#
epicsEnvUnset(ECMC_EXE_CMD)

#- Now load the file to ecmc
ecmcFileExist("${ECMC_TMP_FILE}",1)
ecmcConfigOrDie "Cfg.CreatePLC(${ECMC_PLC_ID},${ECMC_PLC_SAMPLE_RATE_MS})"
ecmcConfigOrDie "Cfg.LoadPLCFile(${ECMC_PLC_ID},${ECMC_TMP_FILE})"

#- Remove parsed file after load
system "rm -f ${ECMC_TMP_FILE}"
ecmcFileExist(${SUBST_FILE="ecmcPlc.substitutions"},1,1)
ecmcEpicsEnvSetCalc(ECMC_PLC_ID_2_CHARS, "${ECMC_PLC_ID}", "%02d")
dbLoadTemplate(${SUBST_FILE="ecmcPlc.substitutions"}, "PORT=${ECMC_ASYN_PORT},A=0,P=${ECMC_PREFIX},Index=${ECMC_PLC_ID},Name=${ECMC_PREFIX},Index2Char=${ECMC_PLC_ID_2_CHARS},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},PREV_OBJ_ID=${ECMC_PREV_PLC_OBJ_ID=-1}, DESC='${DESC=PLC_${ECMC_PLC_ID}}'")
epicsEnvUnset(ECMC_PLC_ID_2_CHARS)

#- Below for facilitate auto gui generation
# Do not set NxtObj "pointer" if this is the first PLC (ECMC_PREV_PLC_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_PLC,"${ECMC_PREV_PLC_OBJ_ID=-1}>=0", "","#- ")
${ECMC_EXE_NEXT_PLC}ecmcFileExist(ecmcPlcPrevPlc.db,1,1)
${ECMC_EXE_NEXT_PLC}dbLoadRecords(ecmcPlcPrevPlc.db,"NEXT_OBJ_ID=${ECMC_PLC_ID=-1},PREV_ECMC_P=${ECMC_PREV_PLC_P=""}")
epicsEnvUnset(ECMC_EXE_NEXT_PLC)

#- If this is the first added PLC then store value in P:MCU-Cfg-PLC-FrstObjId
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_PLC,"${ECMC_PREV_PLC_OBJ_ID=-1}<0", "","#- ")
${ECMC_EXE_FIRST_PLC}ecmcFileExist(ecmcPlcFirstPlc.db,1,1)
${ECMC_EXE_FIRST_PLC}dbLoadRecords(ecmcPlcFirstPlc.db,"P=${ECMC_PREFIX},FIRST_OBJ_ID=${ECMC_PLC_ID}")
epicsEnvUnset(ECMC_EXE_FIRST_PLC)

#- Store info to populate the ECMC_P-NxtObj "pointer" of next added PLC
epicsEnvSet(ECMC_PREV_PLC_P,"$(ECMC_PREFIX)MCU-Cfg-PLC${ECMC_PLC_ID}-")
epicsEnvSet(ECMC_PREV_PLC_OBJ_ID,${ECMC_PLC_ID})

ecmcEpicsEnvSetCalc(ECMC_PLC_COUNT, "$(ECMC_PLC_COUNT=0)+1")

#- increment PLC_ID
ecmcEpicsEnvSetCalc("PLC_ID", "${ECMC_PLC_ID}+1","%d")
