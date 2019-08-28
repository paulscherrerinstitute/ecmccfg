############################################################
############# MCU1026:

epicsEnvSet("ECMC_EC_MASTER_ID"          "0")

#Choose master
ecmcConfigOrDie "Cfg.EcSetMaster($(ECMC_EC_MASTER_ID))"

#Configure EK1100 EtherCAT Coupler
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


#Configure EL5101 incremental encoder terminal, motor 1
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "3")
< ../hardware/ecmcEL5101$(ECMC_GEN_EC_RECORDS)


#Configure EL7047 stepper drive terminal, motor 1
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "4")
< ../hardware/ecmcEL7047$(ECMC_GEN_EC_RECORDS)

#Configure motor for EL7047
< ../hardware/ecmcEL7047-Motor-Nanotec-ST4118M1804-B


# Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"

