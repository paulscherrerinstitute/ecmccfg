##############################################################################
## Example config for open loop only
require ecmccfg sandst_a "ENG_MODE=1,ECMC_VER=sandst_a"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000,L_COIL_UH=3050,R_COIL_MOHM=2630'"
#${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=1, MACROS='ST_ENC_RES=4096'"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Drive-Generic-Ctrl-Params,    CH_ID=1, MACROS='I_TI=12,I_KP=58,V_TI=150,V_KP=176,P_KP=10'"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=2, MACROS='ST_ENC_RES=4000'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

# CH1 Set touch probe to latch on index pulse
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8001,0x11,5,2)"

# CH2 Set touch probe to latch on index pulse
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8101,0x11,5,2)"

# CH2 Set touch probe source 01 to secondary encoder
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8101,0x15,1,2)"

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml,          DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01" 

# strange but in this case the incremental encoder is connected to ch2
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_inc.yaml, DEV=${IOC}, ENC_SID=${DRV_SID},ENC_CH=02"

#- Limit bwd
#- dbpf c6025a-08:m0s003-One 3

${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd     "FILE=./cfg/target.plc, SAMPLE_RATE_MS=1000"
