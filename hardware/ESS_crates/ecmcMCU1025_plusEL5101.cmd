############################################################
############# MCU1025 extended with a EL5101:

ecmcFileExist(${ecmccfg_DIR}ecmcMCU1025.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcMCU1025.cmd

#Configure EL5101 counter
ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_NUM", "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL5101"

# Configure as counter card
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,1,1)"
