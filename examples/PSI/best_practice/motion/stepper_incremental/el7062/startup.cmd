require ecmccfg "ENG_MODE=1"


${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000,L_COIL_UH=3050,R_COIL_MOHM=2630'"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Drive-Generic-Ctrl-Params,    CH_ID=1, MACROS='I_TI=12,I_KP=58,V_TI=150,V_KP=176,P_KP=10'"
# configure touch probe to latch on index pulse of secondary encoder (incremental)
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=1, MACROS='ST_ENC_RES=4000,TP1_POS_SRC=SEC,TP1_TRG=INDEX'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml,             DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01" 

# strange but in this case the incremental encoder is connected to ch2
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_inc.yaml,          DEV=${IOC}, ENC_SID=${DRV_SID},ENC_CH=01"

