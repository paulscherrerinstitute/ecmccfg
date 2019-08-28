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

#Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
