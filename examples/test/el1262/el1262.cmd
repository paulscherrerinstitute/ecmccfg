##############################################################################
## Example config for el1262
## Oversampling factor can be set by the changing the "NELM" arg to addSlave
## Note 1: The el1262 does not support any value of NELM. The EtherCAT bus period in nanoseconds diveded by
##       oversampling factor must be an integer.  "(1/EC_RATE*1E9) / NELM"
## Note 2: The number of bits acquired is 8*NELM (NELM is bytes). NELM=1 results in 8 bits collected during the cycle

require ecmccfg sandst_a "ECMC_VER=v11.0.9_RC1"

# Ensure PV-update in 1Khz
epicsEnvSet("ECMC_SAMPLE_RATE_MS",            "1")
# Note NELM equals oversampling factor in this case
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=31, HW_DESC=EL1262, NELM=1"

ecmcConfigOrDie "Cfg.EcSelectReferenceDC(0,$(ECMC_EC_SLAVE_NUM))"

# Restore PV-update in 100Hz for less time critical records
epicsEnvSet("ECMC_SAMPLE_RATE_MS",            "10")
