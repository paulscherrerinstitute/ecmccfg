##############################################################################
## Example config for EL7041 and EL5042

require ecmccfg "ENG_MODE=1"
require ecmccomp

##############################################################################
# - apply hardware configuration
${SCRIPTEXEC} ${ecmccfg_DIR}loadSubstConfig.cmd,  "FILE=cfg/hw.subst"

##############################################################################
# - motion
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml,               DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=7, ENC_SID=2, ENC_CH=01, BO_SID=${BO_SID}, BO_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml,      DEV=${IOC}, DRV_SID=${ECMC_EC_SLAVE_NUM}"

#- #################################################################
#- go active
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
