############################################################
############# MCU1021:

#Configure EK1100 coupler terminal
epicsEnvSet(ECMC_EC_SLAVE_NUM,${ECMC_EC_SLAVE_NUM=0})
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EK1100"

#Configure EL1018 digital input terminal
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL1018"

#Configure EL2808 digital output terminal
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL2808"

# Save the slave number for later
epicsEnvSet("ECMC_EC_SLAVE_NUM_DIG_OUT", "${ECMC_EC_SLAVE_NUM}")

#Configure EL5101 Incremental Encoder Interface
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL5101"

#Configure EL5101 Incremental Encoder Interface
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL5101"

# Configure EL9505 Power supply terminal 5V
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL9505"

# Configure EL1252 digital input terminal
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL1252"

# Configure EL9410 Power supply with refresh of E-Bus.
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
#${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL9410"

#Configure EL7037 stepper drive terminal, motor 1
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B"

#Configure EL7037 stepper drive terminal, motor 2
ecmcEpicsEnvSetCalc(ECMC_EC_SLAVE_NUM, "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B"

#Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
