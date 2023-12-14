#==============================================================================
# addSlave.cmd
#- Arguments: HW_DESC, [SLAVE_ID = 0, SUBST_FILE, P_SCRIPT, NELM, DEFAULT_SUBS, DEFAULT_SLAVE_PVS]

#-d /**
#-d   \brief Script for adding a slave to the EtherCAT bus configuration.
#-d   \details Adds the respective hardware to the bus configuration, adds specific and default PV to the EPICS database. For some/most slaves also a default
#-d   \author Niko Kivel
#-d   \file
#-d   \param HW_DESC Hardware descriptor, i.e. EL1008
#-d   \param SLAVE_ID (optional) bus position
#-d   \param SUBST_FILE (optional) substitution file
#-d   \param P_SCRIPT (optional) naming convention prefix script
#-d   \param NELM (optional) Used for oversampling cards. Defaults to 1
#-d   \param DEFAULT_SUBS (optional) option to disble default PVs for mapped PDOs
#-d   \param DEFAULT_SLAVE_PVS (optional, caution!) basic slave PVs, i.e. ${ECMC_P}-Operational will be suppressed
#-d   \note Example calls:
#-d   \note - call w/o SLAVE_ID
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "HW_DESC=EL7037"
#-d   \endcode
#-d   \note - call w/ SLAVE_ID
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "HW_DESC=EL1018, SLAVE_ID=1"
#-d   \endcode
#-d   \note - call w/ SLAVE_ID and P_SCRIPT
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "HW_DESC=EL1018, SLAVE_ID=1, P_SCRIPT=mXsXXX"
#-d   \endcode
#-d   \note - call w/ default PDO PVs disabled
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "HW_DESC=EL3204, DEFAULT_SUBS=false, DEFAULT_SLAVE_PVS=true"
#-d   \endcode
#-d   \pre A master has to be claimed by calling \b addMaster.cmd, which is typically done within the startup.script
#-d   \post After all slaves have been added to the bus configuration, \b applyConfig.cmd has to be called.
#-d */

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID=0}")
epicsEnvSet("HW_DESC",            "${HW_DESC}")
epicsEnvSet("P_SCRIPT",           "${P_SCRIPT=${ECMC_P_SCRIPT}}")

#- Ensure same slave is not added twice in a row
ecmcEpicsEnvSetCalcTernary(BLOCK,"${SLAVE_ID}==${ECMC_HW_OLD_SLAVE_ID=-100}","#-", "")
epicsEnvSet(ECMC_HW_OLD_SLAVE_ID,${SLAVE_ID})

# add ${HW_DESC} to the bus at position ${SLAVE_ID}
${BLOCK}ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd",1)
${BLOCK}${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd" "NELM=${NELM=1}"

# deduce what the prefix should be
${BLOCK}ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd",1)
${BLOCK}${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}ecmc${P_SCRIPT}.cmd" "MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE}"

${BLOCK}ecmcEpicsEnvSetCalcTernary(DEFAULT_SUBS, "${DEFAULT_SUBS=True}", "","#- ")
${BLOCK}${DEFAULT_SUBS}${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}applySubstitutions.cmd" "SUBST_FILE=${SUBST_FILE=ecmc${ECMC_EC_HWTYPE}.substitutions},ECMC_P=${ECMC_P}"
${BLOCK}epicsEnvUnset(DEFAULT_SUBS)

${BLOCK}ecmcEpicsEnvSetCalcTernary(DEFAULT_SLAVE_PVS, "${DEFAULT_SLAVE_PVS=True}", "","#- ")
${BLOCK}${DEFAULT_SLAVE_PVS}${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=${ECMC_P},ECMC_G=${ECMC_G=}"
${BLOCK}epicsEnvUnset(DEFAULT_SLAVE_PVS)

#- Do not set NxtSlv "pointer" if this is the first slave (ECMC_EC_PREVIOUS_SLAVE==-1)
${BLOCK}ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_SLV,"${ECMC_EC_PREV_SLAVE_NUM=-1}>=0", "","#- ")
#- Next slave of the previous slave is this slave
${BLOCK}${ECMC_EXE_NEXT_SLV}dbLoadRecords(ecmcEcPrevSlave.db,"NEXT_SLAVE_ID=${ECMC_EC_SLAVE_NUM=-1},PREV_ECMC_P=${ECMC_PREV_ECMC_P=""}")
${BLOCK}epicsEnvUnset(ECMC_EXE_NEXT_SLV)

#- If this is the first added slave then store value in P:MCU-Cfg-EC-FrstObjId
${BLOCK}ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_SLAVE,"${ECMC_EC_PREV_SLAVE_NUM=-1}<0", "","#- ")
#- Next slave of the previous slave is this slave
${BLOCK}${ECMC_EXE_FIRST_SLAVE}dbLoadRecords(ecmcEcFirstSlave.db,"P=${ECMC_PREFIX},FIRST_SLAVE_ID=${ECMC_EC_SLAVE_NUM}")
${BLOCK}epicsEnvUnset(ECMC_EXE_FIRST_SLAVE)

#- Store info to populate the ECMC_P-NxtSlv "pointer" of next added slave
${BLOCK}epicsEnvSet(ECMC_PREV_ECMC_P,${ECMC_P})
${BLOCK}epicsEnvSet(ECMC_EC_PREV_SLAVE_NUM,${ECMC_EC_SLAVE_NUM})

# increment SLAVE_ID
${BLOCK}ecmcEpicsEnvSetCalc("SLAVE_ID", "${ECMC_EC_SLAVE_NUM}+1","%d")

