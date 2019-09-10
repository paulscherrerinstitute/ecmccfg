############################################################
############# MCU1026:

#Configure EL1018 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=0, HW_DESC=EL1018"

#Configure EL2808 digital output terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=1, HW_DESC=EL2808"

# Save the slave number for later
epicsEnvSet("ECMC_EC_SLAVE_NUM_DIG_OUT", "${ECMC_EC_SLAVE_NUM}")

#Configure EL5101 Incremental Encoder Interface
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=2, HW_DESC=EL5101"

#Configure EL5101 Incremental Encoder Interface
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=3, HW_DESC=EL5101"

# Configure EL9505 Power supply terminal 5V
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=4, HW_DESC=EL9505"

# Configure EL1252 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=5, HW_DESC=EL1252"

#Configure EL7037 stepper drive terminal, motor 1
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=6, HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B"

############# Configure hardware interlock on drive for axis 1:
# Set function of input 1 to "Enable hardware"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x32,1,1)"

#Configure EL7037 stepper drive terminal, motor 2
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=7, HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B"

############# Configure hardware interlock on drive for axis 1:
# Set function of input 1 to "Enable hardware"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x32,1,1)"

#Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
