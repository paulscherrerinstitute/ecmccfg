############################################################
############# MCU1012:

# EtherCAT Bus Coupler
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=0, HW_DESC=EK1100"

# EL1014 | 4-channel digital input terminal 24 V DC, 10 µs
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=1, HW_DESC=EL1014"
# EL2004 | 4-channel digital output terminal 24 V DC, 0.5 A
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=2, HW_DESC=EL2004"

# Save the slave number for later
#epicsEnvSet("ECMC_EC_SLAVE_NUM_DIG_OUT", "${ECMC_EC_SLAVE_NUM}")

# EL2124 | 4-channel digital output terminal 5 V DC
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=3, HW_DESC=EL2124"
# 2 channel pulse width output terminal, 24 VDC
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=4, HW_DESC=EL2502"

# EtherCAT Bus Coupler
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=5, HW_DESC=EK1100"
# EL3202 | 2-channel input terminal PT100 (RTD) for 2- or 3-wire connection
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=6, HW_DESC=EL3202-0010"
# EL3164 | 4-channel analog input terminal 0…10 V, single-ended, 16 bit
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=7, HW_DESC=EL3164"
# EL3602 | 2-channel analog input terminal ±10 V, ±5 V, ±2.5 V, ±1.25 V, differential input, 24 bit
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=8, HW_DESC=EL3602"

# EtherCAT Bus Coupler
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=9, HW_DESC=EK1100"
# EL4104 | 4-channel analog output terminal 0…10 V, 16 bit
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=10, HW_DESC=EL4104"


#${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=7, HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B"

#Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"

