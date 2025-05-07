##############################################################################
## Example config for EL7041 and EL5042

require ecmccfg v10.0.0_RC1 "ECMC_VER=debian12,ENG_MODE=1,MASTER_ID=0,EC_RATE=5000"
require ecmccomp debian12

# 0:7 - EL7041    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=14,HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1500, I_STDBY_MA=1000, U_NOM_MV=48000, R_COIL_MOHM=1230'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

# 0:2  - EL5042    2Ch BiSS-C Encoder, RLS-LA11
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=9,HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=1"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=2"
epicsEnvSet(ENC_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml,          DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${ENC_SID}, ENC_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml, DEV=${IOC}, ENC_SID=${DRV_SID}"

#epicsEnvSet(ECMC_PLUGIN_CONFIG,"PLUGIN_ID=1,AX=1,BUFF_SIZE=200,DBG=0,ENA=1")
#require ecmc_plugin_motion sandst_a "${ECMC_PLUGIN_CONFIG}"

 