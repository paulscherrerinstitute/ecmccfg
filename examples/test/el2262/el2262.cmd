# Test IOC for the EL2262 at EtherCAT master 0, slave position 23.
require ecmccfg v11.2.0_RC2 "ECMC_VER=v11.2.0_RC2,EC_RATE=1000"

# One packed byte per channel gives eight output samples per EtherCAT cycle.
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=23, HW_DESC=EL2262, NELM=1"

ecmcConfigOrDie "Cfg.EcSelectReferenceDC(0,23)"

# Run from this directory. PLC 0 drives channel 1.
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0,SAMPLE_RATE_MS=1,FILE=./pulseTrain.plc"
dbLoadRecords("./pulseTrain.db", "IOC=$(IOC),PORT=$(ECMC_ASYN_PORT)")
