#==============================================================================
# addSlaveKL.cmd
#- Arguments: HW_DESC, SLAVE_ID, SLAVE_ID_KL

#-d /**
#-d   \brief Script for adding a KL slave to the EtherCAT bus configuration of KL type.
#-d   \details Adds the respective hardware to the bus configuration, adds specific and default PV to the EPICS database. For some/most slaves also a default
#-d   \author Anders Sandstrom
#-d   \file
#-d   \param HW_DESC Hardware descriptor, i.e. KL2032
#-d   \param SLAVE_ID EtherCAT bus position of the BK1250 (or similar terminal)
#-d   \param SLAVE_ID_KL KL-Bus index in two digit hex starting at zero for the first slave _after_ BK1250 (or similar terminal)
#-d                      Must always be a 2 digit hex number (without 0x).. Example: "1A" for KL slave 26(decimal).
#-d   \param SUBST_FILE (optional) substitution file
#-d   \note Example calls:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL1018, SLAVE_ID=1, SLAVE_ID_KL=0A"
#-d   \endcode
#-d   \pre A master has to be claimed by calling \b addMaster.cmd, which is typically done within the startup.script
#-d   \post After all slaves have been added to the bus configuration, \b applyConfig.cmd has to be called.
#-d */

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID=0}")
epicsEnvSet("ECMC_KL_SLAVE_NUM",  "${SLAVE_ID_KL=0}")
epicsEnvSet("HW_DESC",            "${HW_DESC}")
# add ${HW_DESC} to the bus at position ${SLAVE_ID}
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd

ecmcEpicsEnvSetCalcTernary(DEFAULT_SUBS, "${DEFAULT_SUBS=True}", "","#- ")
${DEFAULT_SUBS}${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}applySubstitutions.cmd" "SUBST_FILE=${SUBST_FILE=ecmc${ECMC_EC_HWTYPE}.substitutions},ECMC_P=${ECMC_P}"
epicsEnvUnset(DEFAULT_SUBS)

#- TODO: do you want the default stuff in, or not?
