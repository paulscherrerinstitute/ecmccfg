# EL2262 at master 0, slave 23, with 1000 output samples per EtherCAT cycle.
require ecmccfg v11.2.0_RC2 "ECMC_VER=v11.2.0_RC2,EC_RATE=1000"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=23, HW_DESC=EL2262, NELM=125"
ecmcConfigOrDie "Cfg.EcSelectReferenceDC(0,23)"

# Run from this directory. PLC 0 drives channel 1 at a 1 MHz sample rate.
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0,SAMPLE_RATE_MS=1,FILE=./pulseTrain.plc,PLC_MACROS='PULSE_BYTES=125'"
dbLoadRecords("./pulseTrain.db", "IOC=$(IOC),PORT=$(ECMC_ASYN_PORT),MAX_FREQ=500000")
