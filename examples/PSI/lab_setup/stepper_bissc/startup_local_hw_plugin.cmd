##############################################################################
## Example config for EL7041 and EL5042

require ecmccfg  "ENG_MODE=1"

# 0:7 - EL7041    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=23,HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1500, I_STDBY_MA=100, U_NOM_MV=48000, R_COIL_MOHM=1230'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

# 0:2  - EL5042    2Ch BiSS-C Encoder, RLS-LA11
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=19,HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=1"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=2"
epicsEnvSet(ENC_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_lookup.yaml,     DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${ENC_SID}, ENC_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml,   DEV=${IOC}, ENC_SID=${DRV_SID}"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_RLS_lookup.yaml,  DEV=${IOC}, ENC_SID=${ENC_SID}"
#
epicsEnvSet(ECMC_PLUGIN_CONFIG,"PLUGIN_ID=1,AX=1,BUFF_SIZE=2000,DBG=0,ENA=1")
require ecmc_plugin_motion "${ECMC_PLUGIN_CONFIG}"

require ecmc_plugin_daq

#-#############################################################################
#-# Load safety plugin
#-
require ecmc_plugin_safety

epicsEnvSet(EC_RAMP_DOWN_CMD,"ec${ECMC_EC_MASTER_ID}.s${ENC_SID}.ONE.0")
epicsEnvSet(EC_AXES_AT_REST_STAT,"ec${ECMC_EC_MASTER_ID}.s${ENC_SID}.ZERO.0")
epicsEnvSet(EC_AXES_LIM_VELO_CMD,"ec${ECMC_EC_MASTER_ID}.s${ENC_SID}.ONE.1")
epicsEnvSet(SAFETY_TIMEOUT,500)
${SCRIPTEXEC} ${ecmc_plugin_safety_DIR}addSS1Group.cmd "NAME=first,EC_RAMP_DOWN_CMD=${EC_RAMP_DOWN_CMD},EC_AXES_AT_REST_STAT=${EC_AXES_AT_REST_STAT},EC_AXES_LIM_VELO_CMD=${EC_AXES_LIM_VELO_CMD=empty},DELAY_MS=${SAFETY_TIMEOUT}"

#- Add axis
#-   AX_ID              :   Axis ID
#-   VELO_REST_LIM      :   Velocity at rest limit [unit same as EGU of axis]
#-   VELO_MAX_LIM       :   Velocity maximum limit, -1 to disable [unit same as EGU of axis]
${SCRIPTEXEC} ${ecmc_plugin_safety_DIR}addAxisToSafetyGroup.cmd "NAME=first,AX_ID=1,VELO_REST_LIM=1,VELO_MAX_LIM=100"
