############################################################
############# MCU1026_wirescanner:

epicsEnvSet("ECMC_EC_MASTER_ID"          "0")

#Choose master
ecmcConfigOrDie "Cfg.EcSetMaster($(ECMC_EC_MASTER_ID))"

# Configure EL1018 digital input terminal
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "0")
< ../hardware/ecmcEL1018$(ECMC_GEN_EC_RECORDS)

# Configure EL2808 digital output terminal
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "1")
< ../hardware/ecmcEL2808$(ECMC_GEN_EC_RECORDS)

# Save the slave number for later
epicsEnvSet("ECMC_EC_SLAVE_NUM_DIG_OUT",    "${ECMC_EC_SLAVE_NUM}")

# Configure EL5101 incremental encoder terminal, motor 1
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "2")
< ../hardware/ecmcEL5101$(ECMC_GEN_EC_RECORDS)

# Configure EL5101 incremental encoder terminal, motor 2
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "3")
< ../hardware/ecmcEL5101$(ECMC_GEN_EC_RECORDS)

# Configure EL9505 Power supply terminal 5V
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "4")
< ../hardware/ecmcEL9505$(ECMC_GEN_EC_RECORDS)

# Configure EL1252 digital input terminal
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "5")
< ../hardware/ecmcEL1252$(ECMC_GEN_EC_RECORDS)

# Configure EL7037 stepper drive terminal, motor 1
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "6")
< ../hardware/ecmcEL7037$(ECMC_GEN_EC_RECORDS)

#Configure motor for EL7037
< ../hardware/ecmcEL7037-Motor-Nanotec-ST4118L1804-B

############# Configure hardware interlock on drive for axis 1:
# Set function of input 1 to "Enable hardware"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x32,1,1)"

# Configure EL7037 stepper drive terminal, motor 2
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "7")
< ../hardware/ecmcEL7037$(ECMC_GEN_EC_RECORDS)

#Configure motor for EL7037
< ../hardware/ecmcEL7037-Motor-Nanotec-ST4118L1804-B

############# Configure hardware interlock on drive for axis 1:
# Set function of input 1 to "Enable hardware"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x32,1,1)"

# Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"

