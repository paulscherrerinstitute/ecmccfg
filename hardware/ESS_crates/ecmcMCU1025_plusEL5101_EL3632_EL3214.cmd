############################################################
############# MCU1025:

epicsEnvSet("ECMC_EC_MASTER_ID"          "0")

#Choose master
ecmcConfigOrDie "Cfg.EcSetMaster($(ECMC_EC_MASTER_ID))"

#Configure EK1100 coupler terminal
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "0")
< ../hardware/ecmcEK1100$(ECMC_GEN_EC_RECORDS)

#Configure EL1018 digital input terminal
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "1")
< ../hardware/ecmcEL1018$(ECMC_GEN_EC_RECORDS)

#Configure EL2808 digital output terminal
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "2")
< ../hardware/ecmcEL2808$(ECMC_GEN_EC_RECORDS)

# Save the slave number for later
epicsEnvSet("ECMC_EC_SLAVE_NUM_DIG_OUT", "${ECMC_EC_SLAVE_NUM}")

#Configure EL5002 2-channel SSI encoder terminal, motor 1
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "3")
< ../hardware/ecmcEL5002$(ECMC_GEN_EC_RECORDS)

#Configure Baumer encoder for EL5002 2-channel SSI encoder terminal (Channel 1)
< ../hardware/ecmcEL5002-Encoder-ch1-Baumer-BMMH30D1G24C1213P55     

#Configure Baumer encoder for EL5002 2-channel SSI encoder terminal (Channel 2)
< ../hardware/ecmcEL5002-Encoder-ch2-Baumer-BMMH30D1G24C1213P55     

# Configure EL9505 Power supply terminal 5V
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "4")
< ../hardware/ecmcEL9505$(ECMC_GEN_EC_RECORDS)

# Configure EL1252 digital input terminal
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "5")
< ../hardware/ecmcEL1252$(ECMC_GEN_EC_RECORDS)

# Configure EL9410 Power supply with refresh of E-Bus.
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "6")
< ../hardware/ecmcEL9410$(ECMC_GEN_EC_RECORDS)

#Configure EL7037 stepper drive terminal, motor 1
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "7")
< ../hardware/ecmcEL7037$(ECMC_GEN_EC_RECORDS)

#Configure motor for EL7037
< ../hardware/ecmcEL7037-Motor-Nanotec-ST4118L1804-B

#Configure EL7037 stepper drive terminal, motor 2
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "8")
< ../hardware/ecmcEL7037$(ECMC_GEN_EC_RECORDS)

#Configure motor for EL7037
< ../hardware/ecmcEL7037-Motor-Nanotec-ST4118L1804-B

#Configure EL5101 counter
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "9")
< ../hardware/ecmcEL5101$(ECMC_GEN_EC_RECORDS)

# Configure as counter card
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,1,1)"

#Configure EL3632 Condition Monitoring
# High freq.
epicsEnvSet("ECMC_SAMPLE_RATE_MS_BACK", $(ECMC_SAMPLE_RATE_MS))
epicsEnvSet("ECMC_SAMPLE_RATE_MS",       "1")
epicsEnvSet("ECMC_EC_SLAVE_NUM",         "10")
< ../hardware/ecmcEL3632_s$(ECMC_EC_OVERSAMPLING_FACTOR)$(ECMC_GEN_EC_RECORDS)
epicsEnvSet("ECMC_SAMPLE_RATE_MS", $(ECMC_SAMPLE_RATE_MS_BACK))

# Sensors ch 0
epicsEnvSet("ECMC_EC_CHANNEL_ID",  "0")
< ../hardware/ecmcEL3632-Sensor-chX-MTS-PCB-608A11

# test sensor amplifier (gain = 20)
epicsEnvSet("ECMC_EC_SDO_INDEX",  "0x80$(ECMC_EC_CHANNEL_ID)8")
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1") # Enabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

# Sensors ch 1
epicsEnvSet("ECMC_EC_CHANNEL_ID",  "1")
< ../hardware/ecmcEL3632-Sensor-chX-MTS-PCB-608A11

# test sensor amplifier (gain = 20)
epicsEnvSet("ECMC_EC_SDO_INDEX",  "0x80$(ECMC_EC_CHANNEL_ID)8")
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1") # Enabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

# Configure EL3214 analog input hardware
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "11")
< ../hardware/ecmcEL3214$(ECMC_GEN_EC_RECORDS)

############# Configure sensors:
# Common for all channels
< ../hardware/ecmcEL32XX-Sensor-PT100-common

# Configure channel 1 with S+S Regeltechnik HFT50 PT100
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8000")
< ../hardware/ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT100

# Configure channel 2 with S+S Regeltechnik HFT50 PT100
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8010")
< ../hardware/ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT100

# Configure channel 3 with S+S Regeltechnik HFT50 PT1000 NOTE!!! PT1000
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8020")
< ../hardware/ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT1000

# Configure channel 4 with S+S Regeltechnik HFT50 PT1000 NOTE!!! PT1000
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x8030")
< ../hardware/ecmcEL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT1000

#Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
