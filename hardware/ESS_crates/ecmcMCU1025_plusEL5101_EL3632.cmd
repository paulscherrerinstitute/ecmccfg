############################################################
############# MCU1025 extended with a EL5101 and EL3632

ecmcFileExist(${ecmccfg_DIR}ecmcMCU1025_plusEL5101.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcMCU1025_plusEL5101.cmd

#Configure EL3632 Condition Monitoring
# High freq.
epicsEnvSet("ECMC_SAMPLE_RATE_MS_BACK", $(ECMC_SAMPLE_RATE_MS))
epicsEnvSet("ECMC_SAMPLE_RATE_MS",       "1")
ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_NUM", "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL3632_s${ECMC_EC_OVERSAMPLING_FACTOR}"

epicsEnvSet("ECMC_SAMPLE_RATE_MS", $(ECMC_SAMPLE_RATE_MS_BACK))

# Sensors ch 0
epicsEnvSet("ECMC_EC_CHANNEL_ID",  "0")

${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd "HW_DESC=EL3632, CONFIG=-Sensor-chX-MTS-PCB-608A11"

# test sensor amplifier (gain = 20)
epicsEnvSet("ECMC_EC_SDO_INDEX",  "0x80$(ECMC_EC_CHANNEL_ID)8")
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1") # Enabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

# Sensors ch 1
epicsEnvSet("ECMC_EC_CHANNEL_ID",  "1")
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd "HW_DESC=EL3632, CONFIG=-Sensor-chX-MTS-PCB-608A11"

# test sensor amplifier (gain = 20)
epicsEnvSet("ECMC_EC_SDO_INDEX",  "0x80$(ECMC_EC_CHANNEL_ID)8")
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1") # Enabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"
