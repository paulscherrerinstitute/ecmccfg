##############################################################################
## Example config for open loop only
require ecmccfg sandst_a "ENG_MODE=1,ECMC_VER=v10.1.0_RC1"
require ecmccomp sandst_a

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000, R_COIL_MOHM=2372,L_COIL_UH=3000'"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Drive-Generic-Ctrl-Params,    CH_ID=1, MACROS='P_KP=20'"
#${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=1, MACROS='ST_ENC_RES=1024'"
#${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=2, MACROS='ST_ENC_RES=1024,INV_DIR=1'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_open_loop.yaml,    DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01" 

require ecmc_plugin_motion

