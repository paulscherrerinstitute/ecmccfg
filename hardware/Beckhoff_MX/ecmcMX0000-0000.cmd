epicsEnvSet("ECMC_EC_HWTYPE",        "MX0000-0000")
epicsEnvSet("ECMC_EC_VENDOR_ID",     "0x00000000")
epicsEnvSet("ECMC_EC_PRODUCT_ID",    "0x00000000")

#- verify slave
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#ecmcConfigOrDie "Cfg.EcAddSlave(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

ecmcEpicsEnvSetCalcTernary(ECMC_MX_INIT_CMD, "${ECMC_SIM=0}=0", "", "#-")
${ECMC_MX_INIT_CMD}system "${ECMC_EC_TOOL_PATH} states -m${ECMC_EC_MASTER_ID} -p${ECMC_EC_SLAVE_NUM} INIT"
epicsEnvUnset(ECMC_MX_INIT_CMD)
