############################################################
############# MCU1025:

#Configure EK1100 coupler terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=0, HW_DESC=EK1100"

#Configure EL1018 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=1, HW_DESC=EL1018"

#Configure EL2808 digital output terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=2, HW_DESC=EL2808"

# Save the slave number for later
epicsEnvSet("ECMC_EC_SLAVE_NUM_DIG_OUT", "${ECMC_EC_SLAVE_NUM}")

#Configure EL5002 2-channel SSI encoder terminal, motor 1
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=3, HW_DESC=EL5002"

#Configure Baumer encoder for EL5002 2-channel SSI encoder terminal (Channel 1)
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd "CONFIG=-Encoder-ch1-Baumer-BMMH30D1G24C1213P55"

#Configure Baumer encoder for EL5002 2-channel SSI encoder terminal (Channel 2)
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd "CONFIG=-Encoder-ch2-Baumer-BMMH30D1G24C1213P55"

# Configure EL9505 Power supply terminal 5V
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=4, HW_DESC=EL9505"

# Configure EL1252 digital input terminal
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=5, HW_DESC=EL1252"

# Configure EL9410 Power supply with refresh of E-Bus.
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=6, HW_DESC=EL9410"

#Configure EL7037 stepper drive terminal, motor 1
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=7, HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B"

#Configure EL7037 stepper drive terminal, motor 2
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=8, HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B"

#Configure EL5101 counter
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=9, HW_DESC=EL5101"

# Configure as counter card
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,1,1)"

#Configure EL3632 Condition Monitoring
# High freq.
epicsEnvSet("ECMC_SAMPLE_RATE_MS_BACK", $(ECMC_SAMPLE_RATE_MS))
epicsEnvSet("ECMC_SAMPLE_RATE_MS",       "1")
epicsEnvSet("ECMC_EC_SLAVE_NUM",         "10")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=10, HW_DESC=EL3632_s${ECMC_EC_OVERSAMPLING_FACTOR}"

epicsEnvSet("ECMC_SAMPLE_RATE_MS", $(ECMC_SAMPLE_RATE_MS_BACK))

# Sensors ch 0
epicsEnvSet("ECMC_EC_CHANNEL_ID",  "0")

${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd "CONFIG=-Sensor-chX-MTS-PCB-608A11"

# test sensor amplifier (gain = 20)
epicsEnvSet("ECMC_EC_SDO_INDEX",  "0x80$(ECMC_EC_CHANNEL_ID)8")
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1") # Enabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

# Sensors ch 1
epicsEnvSet("ECMC_EC_CHANNEL_ID",  "1")
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd "CONFIG=-Sensor-chX-MTS-PCB-608A11"

# test sensor amplifier (gain = 20)
epicsEnvSet("ECMC_EC_SDO_INDEX",  "0x80$(ECMC_EC_CHANNEL_ID)8")
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1") # Enabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

# Configure EL3214 analog input hardware
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=11, HW_DESC=EL3214"

############# Configure sensors:
# Common for all channels
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-PT100-common.cmd

# Configure channel 1 with S+S Regeltechnik HFT50 PT100
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8000")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT100

# Configure channel 2 with S+S Regeltechnik HFT50 PT100
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8010")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT100

# Configure channel 3 with S+S Regeltechnik HFT50 PT1000 NOTE!!! PT1000
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8020")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT1000

# Configure channel 4 with S+S Regeltechnik HFT50 PT1000 NOTE!!! PT1000
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8030")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT1000

#Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
