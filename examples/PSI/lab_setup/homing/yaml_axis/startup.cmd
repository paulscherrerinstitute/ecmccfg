##############################################################################
## Example config for open loop only

require ecmccfg v9.6.2_RC1 "ENG_MODE=1,ECMC_VER=v9.6.2_RC1"
require ecmccomp

# 0:13 - EL7041    1Ch Stepper
epicsEnvSet("DRV_SID",              "13")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=$(DRV_SID),HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1000, I_STDBY_MA=200, U_NOM_MV=48000, R_COIL_MOHM=1230,SPEED_RANGE=1'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_open_loop.yaml,    DEV=${IOC}, AX_NAME=Axis1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01"

#- ###########################################################################
#- go active
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
