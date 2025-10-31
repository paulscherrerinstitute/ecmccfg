##############################################################################
## IMPORTANT: this example configure the motor on channel 1 and the incremnetal encoder on channel 2


# The default callback queue in EPICS base is only 2000 bytes. 
# "callbackRequest: cbLow ring buffer full" 
# right after the epicsThreadSleep at the end of this script
#callbackSetQueueSize(4000)

require ecmccfg sandst_a "ENG_MODE=1,ECMC_VER=sandst_a"

#- Digital output for switches
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=2,HW_DESC=EL2819"
epicsEnvSet(BO_SID,${ECMC_EC_SLAVE_NUM})

#- Drive an encoders (openloop and incremental)
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000,L_COIL_UH=3050,R_COIL_MOHM=2630'"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Drive-Generic-Ctrl-Params,    CH_ID=1, MACROS='I_TI=12,I_KP=58,V_TI=150,V_KP=176,P_KP=10'"
#-    configure touch probe to latch on index pulse of secondary encoder (incremental) and single turn resolution
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=2, MACROS='ST_ENC_RES=4000,TP1_POS_SRC=SEC,TP1_TRG=INDEX'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})


ecmcConfig "Cfg.EcAddSimEntry(${ECMC_EC_SLAVE_NUM},TESTING,U8,255)"

ecmcConfig "Cfg.EcAddSimEntry(-1,TESTING,U8,255)"
ecmcConfig "Cfg.EcAddSimEntry(-1,TESTING1,U8,255)"
ecmcConfig "Cfg.EcAddSimEntry(-1,TESTING2,U8,255)"
ecmcConfig "Cfg.EcAddSimEntry(-1,TESTING3,U8,255)"
ecmcConfig "Cfg.EcAddSimEntry(-1,TESTING4,U8,255)"
ecmcConfig "Cfg.EcAddSimEntry(-1,TESTING5,U8,255)"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml,             DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01, BO_SID=${BO_SID}" 

# strange but in this case the incremental encoder is connected to ch2
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_inc.yaml,          DEV=${IOC}, ENC_SID=${DRV_SID},ENC_CH=02"

#- Just for test..
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd     "FILE=./cfg/test_sim_entries.plc, SAMPLE_RATE_MS=100"



