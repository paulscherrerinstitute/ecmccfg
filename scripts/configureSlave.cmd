#==============================================================================
# configureSlave.cmd
#- Arguments: HW_DESC, CONFIG, [SLAVE_ID = 0], [CFG_MACROS]

#-d /**
#-d   \brief Script for adding a slave with dedicated slave configuration to the EtherCAT bus configuration.
#-d   \details Adds the respective hardware to the bus configuration, adds specific and default PV to the EPICS database. Applies a specific slave configuration.
#-d   \author Niko Kivel
#-d   \file
#-d   \param HW_DESC Hardware descriptor, i.e. EL7037
#-d   \param CONFIG configuration file, i.e. -Motor-Nanotec-ST4118L1804-B
#-d   \note The CONFIG together with the HW_DESC form the full filename which by definition is ecmc${HW_DESC}${CONFIG}.cmd, i.e.: _ecmcEL7037-Motor-Nanotec-ST4118L1804-B.cmd_
#-d   \param SLAVE_ID (optional) bus position
#-d   \param CFG_MACROS (optional) Substitution macros for config file
#-d   \param NELM (optional) Used for oversampling cards. Defaults to 1
#-d   \note Example calls:
#-d   \note - call w/o SLAVE_ID
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B"
#-d   \endcode
#-d   \note - call w/ SLAVE_ID
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B, SLAVE_ID=8"
#-d   \endcode
#-d   \pre A master has to be claimed by calling \b addMaster.cmd, which is typically done within the startup.script
#-d   \post After all slaves have been added to the bus configuration, \b applyConfig.cmd has to be called.
#-d */

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID=0}")
epicsEnvSet("HW_DESC",            "${HW_DESC}")
ecmcFileExist("${ECMC_CONFIG_ROOT}addSlave.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=${HW_DESC}, NELM=${NELM=1}"
# apply config ${CONFIG} for ${HW_DESC}
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${HW_DESC}${CONFIG}.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}${CONFIG}.cmd "${CFG_MACROS=""}"
