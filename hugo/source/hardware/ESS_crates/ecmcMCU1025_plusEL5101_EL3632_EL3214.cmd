############# MCU1025 extended with a EL5101, EL3632 and EL3214

ecmcFileExist(${ecmccfg_DIR}ecmcMCU1025_plusEL5101_EL3632.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcMCU1025_plusEL5101_EL3632.cmd

# Configure EL3214 analog input hardware
ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_NUM", "${ECMC_EC_SLAVE_NUM}+1")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM}, HW_DESC=EL3214"

############# Configure sensors:
# Common for all channels
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-PT100-common.cmd

# Configure channel 1 with S+S Regeltechnik HFT50 PT100
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8000")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT100.cmd

# Configure channel 2 with S+S Regeltechnik HFT50 PT100
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8010")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT100.cmd

# Configure channel 3 with S+S Regeltechnik HFT50 PT1000 NOTE!!! PT1000
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8020")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT1000.cmd

# Configure channel 4 with S+S Regeltechnik HFT50 PT1000 NOTE!!! PT1000
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8030")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT1000.cmd
