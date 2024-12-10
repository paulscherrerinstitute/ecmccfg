##############################################################################
## Example config for EL7041 and EL5042

require ecmccfg sandst_a "ECMC_VER=sandst_a,ENG_MODE=1,MASTER_ID=1"

# 0:7 - EL7041    1Ch Stepper
# ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=14,HW_DESC=EL7041-0052"
# ${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1500, I_STDBY_MA=1000, U_NOM_MV=48000, R_COIL_MOHM=1230'"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=29, HW_DESC=iPOS4808BX_2"
#- Apply component: Oriental motor PKE244A
#- For IPOS4808 some macros are mandatory:
#-  * I_CTRL_GAIN   : Current loop gain
#-  * I_CTRL_INT    : Current loop integrator gain 
#-  * I_MAX_MA      : Mandatory if Motor-Generic-2Phase-Stepper is used
#-  * I_STDBY_MA    : Mandatory if Motor-Generic-2Phase-Stepper is used
#- The values can be taken from EasyMotionStudio or by trial and error (BTW, coil resistance and inductance are not used in the iPOS cfgs)
#- After running a tuning test in EasyMotionStudio, a reset is needed (from easymotion studio or over SDO (see motor cfg scripts).)
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1000,I_STDBY_MA=200,CURR_KP=0.8,CURR_TI=0.26'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

# 0:2  - EL5042    2Ch BiSS-C Encoder, RLS-LA11
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=9,HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=1"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=2"
epicsEnvSet(ENC_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_ipos.yaml,               DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${ENC_SID}, ENC_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop_ipos.yaml,      DEV=${IOC}, DRV_SID=${DRV_SID}"

