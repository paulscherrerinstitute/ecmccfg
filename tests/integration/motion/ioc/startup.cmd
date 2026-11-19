# Standalone motion and PLC acceptance IOC.
epicsEnvSet("IOC", "${TEST_IOC=SIMMOTION}")
require ecmccfg ${ECMCCFG_TEST_VER=sandst_a} "MASTER_ID=0,ENG_MODE=1,EC_RATE=1000,ECMC_VER=${ECMC_TEST_VER=sandst_a},SIM=1"
on error halt
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd "SLAVE_ID=0,HW_DESC=EK1100"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd "SLAVE_ID=1,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd "SLAVE_ID=2,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd "FILE=./axis.yaml,AX_ID=1,SID=1,AX_NAME=CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd "FILE=./axis.yaml,AX_ID=2,SID=2,AX_NAME=PLC"
ecmcConfigOrDie "Cfg.SimSetValue(ec0.s1.driveStatus01,64)"
ecmcConfigOrDie "Cfg.SimSetValue(ec0.s2.driveStatus01,64)"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd "SLAVE_ID=3,HW_DESC=EL1008"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd "SLAVE_ID=4,HW_DESC=EL2008"
${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=0,DS_SIZE=4,DS_TYPE=0,SAMPLE_RATE_MS=-1"
${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=1,DS_SIZE=4,DS_TYPE=0,SAMPLE_RATE_MS=-1"
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd "FILE=./motion.plc,PLC_ID=0,SAMPLE_RATE_MS=10,START_AFTER_EPICS=1"
dbLoadTemplate("./plc.substitutions","P=${ECMC_PREFIX},PORT=${ECMC_ASYN_PORT}")
