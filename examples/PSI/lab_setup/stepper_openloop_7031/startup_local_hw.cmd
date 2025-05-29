##############################################################################
## Example config for open loop only

require ecmccfg "ENG_MODE=1,MASTER_ID=1,EC_RATE=500"
require ecmccomp

# 0:11 - EL7031    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=11,HW_DESC=EL7031"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=24000, R_COIL_MOHM=8000,SPEED_RANGE=5'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_open_loop.yaml,    DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01" 

#- Disable boosts.. Nicer current control
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x7,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x8,0,2)"

# 8010:05 EMF
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x5,100,2)"
##- Kp
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1,40,2)"
#
##- Ki
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2,4,2)"

#- ###########################################################################
#- Go Active
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
