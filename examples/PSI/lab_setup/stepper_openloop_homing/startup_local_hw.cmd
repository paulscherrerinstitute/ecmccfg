##############################################################################
## Example config for open loop only


require ecmccfg "ENG_MODE=1,MASTER_ID=1"
require ecmccomp

# 0:11 - EL7031    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=11,HW_DESC=EL7031"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1500, I_STDBY_MA=200, U_NOM_MV=24000, R_COIL_MOHM=1230,SPEED_RANGE=2'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_open_loop.yaml,    DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01" 

# 0:13 - EL7041    1Ch Stepper
#${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=13,HW_DESC=EL7041-0052"
#${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1000, I_STDBY_MA=200, U_NOM_MV=48000, R_COIL_MOHM=1230,SPEED_RANGE=2'"
#epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})
#
#${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_open_loop.yaml,    DEV=${IOC}, AX_NAME=M2, AXIS_ID=2, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01"
#$(SCRIPTEXEC) $(ecmccfg_DIR)loadPLCFile.cmd,    "PLC_ID=1, SAMPLE_RATE_MS=1000,FILE=./cfg/test.plc"
