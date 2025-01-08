##############################################################################
## Example config for EL7041 and EL5042

require ecmccfg v10.0.0_RC1 "ECMC_VER=v10.0.0_RC1,ENG_MODE=1,MASTER_ID=1"

# 0:7 - EL7041    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=14,HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1500, I_STDBY_MA=100, U_NOM_MV=48000, R_COIL_MOHM=1230'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

# 0:2  - EL5042    2Ch BiSS-C Encoder, RLS-LA11
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=9,HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=1"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=2"
epicsEnvSet(ENC_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_lookup.yaml,     DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${ENC_SID}, ENC_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml,   DEV=${IOC}, ENC_SID=${DRV_SID}"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_RLS_lookup.yaml,  DEV=${IOC}, ENC_SID=${ENC_SID}"
#
epicsEnvSet(ECMC_PLUGIN_CONFIG,"PLUGIN_ID=1,AX=1,BUFF_SIZE=2000,DBG=0,ENA=1")
require ecmc_plugin_motion sandst_a "${ECMC_PLUGIN_CONFIG}"

#-#############################################################################
#-# Load safety plugin
#-
require ecmc_plugin_safety sandst_a
## Create SS1 group
##-   EC_RAMP_DOWN_CMD   :   EtherCAT entry for ramp down command, input to ecmc (command from safety PLC/system)
##-   EC_REST_STAT  :   EtherCAT entry for signaling that all axes in group are at rest, output from ecmc (feedback to safety PLC/system)
##-   EC_RED_VEL_CMD     :   EtherCAT entry for reducing velocity, input to ecmc (command from safety PLC/system)
##-   DELAY_MS           :   Time between ramp-down command and STO
epicsEnvSet(RAMP_DOWN_CMD,"ec${ECMC_EC_MASTER_ID}.s${ENC_SID}.ONE.0")
epicsEnvSet(REST_STAT,"ec${ECMC_EC_MASTER_ID}.s${ENC_SID}.ONE.1")
epicsEnvSet(RED_VEL_CMD,"ec${ECMC_EC_MASTER_ID}.s${ENC_SID}.ONE.2")
epicsEnvSet(SAFETY_TIMEOUT,500)
${SCRIPTEXEC} ${ecmc_plugin_safety_DIR}addSS1Group.cmd "NAME=first,EC_RAMP_DOWN_CMD=${RAMP_DOWN_CMD},EC_REST_STAT=${REST_STAT},EC_RED_VEL_CMD=${RED_VEL_CMD=empty},DELAY_MS=${SAFETY_TIMEOUT}"

#- Add axis
#-   AX_ID              :   Axis ID
#-   VELO_REST_LIM      :   Velocity at rest limit [unit same as EGU of axis]
#-   VELO_MAX_LIM       :   Velocity maximum limit, -1 to disable [unit same as EGU of axis]
${SCRIPTEXEC} ${ecmc_plugin_safety_DIR}addAxisToSafetyGroup.cmd "NAME=first,AX_ID=1,VELO_REST_LIM=1,VELO_MAX_LIM=100"
