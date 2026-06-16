require ecmccfg sandst_a "ENG_MODE=1, ECMC_VER=sandst_a"
require ecmccomp sandst_a

#- Choose channel to use and not to use
epicsEnvSet(CH_USED,02)
epicsEnvSet(CH_NOT_USED,01)
#epicsEnvSet(CH_USED,01)
#epicsEnvSet(CH_NOT_USED,02)

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=22,HW_DESC=ED7062"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper, CH_ID=${CH_USED=01}, MACROS='I_MAX_MA=500, I_STDBY_MA=100, U_NOM_MV=48000,L_COIL_UH=3100,R_COIL_MOHM=2620'"

#- Use autotune to get the controller parameters, resistance, and inductance (trigger in hw expert panel) 
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Drive-Generic-Ctrl-Params,    CH_ID=${CH_USED=01}, MACROS='L_COIL_UH=3100,R_COIL_MOHM=2620,I_TI=12,I_KP=59,V_TI=150,V_KP=176,P_KP=10'"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-Generic-INC,          CH_ID=${CH_USED=01}, MACROS='ST_ENC_RES=2000,TP1_POS_SRC=SEC,TP1_TRG=INDEX'"

#- Must tell ecmc that channel is not in use
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Generic-Ch-Not-Used,          CH_ID=${CH_NOT_USED=02}'"

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_chx.yaml,          DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${ECMC_EC_SLAVE_NUM},DRV_CH=${CH_USED=01}, ENC_SID=${ECMC_EC_SLAVE_NUM}, ENC_CH=${CH_USED=01}"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_openloop.yaml,      DEV=${IOC}, ENC_SID=${ECMC_EC_SLAVE_NUM}, ENC_CH=${CH_USED=01}"
