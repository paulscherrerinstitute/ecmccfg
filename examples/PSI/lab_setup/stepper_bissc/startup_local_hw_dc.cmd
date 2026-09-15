##############################################################################
## Example config for EL7041 and EL5042

require ecmccfg dc_timing "ENG_MODE=1,MASTER_ID=0,ECMC_VER=dc_timing"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=14,HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1500, I_STDBY_MA=1000, U_NOM_MV=48000, R_COIL_MOHM=1230'"
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)

${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveDCconfig.cmd,  "ASSIGN_ACTIVATE=0x300,SYNC_0_CYCLE=${ECMC_TEMP_PERIOD_NANO_SECS},SYNC_0_SHIFT=500000,SYNC_1_CYCLE=${ECMC_TEMP_PERIOD_NANO_SECS}"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}setRecordUpdateRate.cmd "RATE_MS=1"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=9,HW_DESC=EL5042_DC"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=1"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=2"
epicsEnvSet(ENC_SID,${ECMC_EC_SLAVE_NUM})
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveDCconfig.cmd, "ASSIGN_ACTIVATE=0x300,SYNC_0_CYCLE=${ECMC_TEMP_PERIOD_NANO_SECS},SYNC_0_SHIFT=-250000,SYNC_1_CYCLE=${ECMC_TEMP_PERIOD_NANO_SECS}"
${SCRIPTEXEC} ${ecmccfg_DIR}setRecordUpdateRate.cmd "RATE_MS=10"


${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=22,HW_DESC=ED7062"

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_dc.yaml,          DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${ENC_SID}, ENC_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml, DEV=${IOC}, ENC_SID=${DRV_SID}"
ecmcConfigOrDie "Cfg.EcSelectReferenceDC(0,9)"
afterInit "epicsThreadSleep 2"
afterInit "ecmcConfig 'EcPrintSlaveConfig(9)'"
afterInit "ecmcConfig 'EcPrintSlaveConfig(14)'"


#${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=10,DS_SIZE=200,SAMPLE_RATE_MS=-1,DS_TYPE=2,DESC='Cycle'"
#${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=11,DS_SIZE=200,SAMPLE_RATE_MS=-1,DS_TYPE=2,DESC='EL7041VelocitySetpoint'"
#${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=12,DS_SIZE=200,SAMPLE_RATE_MS=-1,DS_TYPE=2,DESC='EL7041OpenLoopPosition'"
#${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=13,DS_SIZE=200,SAMPLE_RATE_MS=-1,DS_TYPE=2,DESC='EL7041OpenLoopDelta'"
#${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=14,DS_SIZE=200,SAMPLE_RATE_MS=-1,DS_TYPE=2,DESC='EL7041EncoderToggle'"
#${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=15,DS_SIZE=200,SAMPLE_RATE_MS=-1,DS_TYPE=2,DESC='EL7041DriveStatus'"
#${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=16,DS_SIZE=200,SAMPLE_RATE_MS=-1,DS_TYPE=2,DESC='EL5042Position'"
#${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=17,DS_SIZE=200,SAMPLE_RATE_MS=-1,DS_TYPE=2,DESC='EL5042Toggle'"
#
#${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd     "FILE=./cfg/dc.plc"


# ecmcConfig "EcTimingCaptureArm(9,14,256)"
# ecmcConfig "EcPrintTimingCapture()"


# caqtdm -macro "IOC=c6025a-08,MasterID=0,SlaveID=014" ecmcEcTiming.u
