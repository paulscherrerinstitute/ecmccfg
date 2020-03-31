############################################################
############# MCU1015:

#0  0:0  PREOP  E  0x00000000:0x00000000
#1  0:1  PREOP  +  EL1018 8K. Dig. Eingang 24V, 10�s
#2  0:2  PREOP  +  EL2808 8K. Dig. Ausgang 24V, 0.5A
#3  0:3  PREOP  +  EL3004 4K.Ana. Eingang  +/-10V
#4  0:4  PREOP  +  EL4004 4K. Ana. Ausgang 0-10V, 12bit
#5  0:5  PREOP  +  EL9505 Netzteilklemme 5V
#6  0:6  PREOP  +  EL2124 4K. Dig. Ausgang 5V, 20mA

#Configure EK1100 coupler terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=0, HW_DESC=EK1100"

#Configure EL1018 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=1, HW_DESC=EL1018"

#Configure EL2808 digital output terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=2, HW_DESC=EL2808"

#Configure EL3004 analog input  +/-10V
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=3, HW_DESC=EL3004"

# Configure EL4004 analog output terminal 0-10V, 12 bit
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=4, HW_DESC=EL4004"

# Configure EL9505 power supply 5V
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=5, HW_DESC=EL9505"

# Configure EL2124 digital output terminal 5V.
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=6, HW_DESC=EL2124"

#Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
