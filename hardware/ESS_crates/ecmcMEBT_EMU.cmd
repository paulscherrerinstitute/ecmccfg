############################################################
############# Bi lab EMU SLIT and GRID HW

#Configure EK1100 coupler terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=0, HW_DESC=EK1100"

#Configure EL1018 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=1, HW_DESC=EL1018"

#Configure EL1018 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=2, HW_DESC=EL1018"

#Configure EL2808 digital output terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=3, HW_DESC=EL2808"

#Configure EL2808 digital output terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=4, HW_DESC=EL2808"

#Configure EL5101 incremental encoder terminal, motor 1
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=5, HW_DESC=EL5101"

#Configure EL5101 incremental encoder terminal, motor 1
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=6, HW_DESC=EL5101"

#Configure EL7047 stepper drive terminal, motor 1 GRID
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=7, HW_DESC=EL7047, CONFIG=-Motor-AS4118L1804-E"

#Configure EL7047 stepper drive terminal, motor 1 GRID
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=8, HW_DESC=EL7047, CONFIG=-Motor-AS4118L1804-E"

# Configure EL3004 +/- 10V Analog Input
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=9, HW_DESC=EL3004"

# Configure EL4004 0-10V Analog Output
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=10, HW_DESC=EL4004"

# Configure EL9505 Power supply terminal 5V
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=11, HW_DESC=EL9505"

# Configure EL2124 digital 5V output terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=12, HW_DESC=EL2124"

#Configure EK1100 coupler terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=13, HW_DESC=EK1100"

#Configure EL1018 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=14, HW_DESC=EL1018"

#Configure EL1018 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=15, HW_DESC=EL1018"

#Configure EL2808 digital output terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL2808"

#Configure EL2808 digital output terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=17, HW_DESC=EL2808"

#Configure EL5101 incremental encoder terminal, motor 1
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=18, HW_DESC=EL5101"

#Configure EL5101 incremental encoder terminal, motor 1
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=19, HW_DESC=EL5101"

#Configure EL7047 stepper drive terminal, motor 1 GRID
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=20, HW_DESC=EL7047, CONFIG=-Motor-Leadshine-57HS09"

#Configure EL7047 stepper drive terminal, motor 1 GRID
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=21, HW_DESC=EL7047, CONFIG=-Motor-Leadshine-57HS09"


#Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
