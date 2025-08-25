##############################################################################
## Example config for EL7041 and EL5042 using loadSubstConfig.cmd

require ecmccfg "ENG_MODE=1"

##############################################################################
# - apply hardware configuration
${SCRIPTEXEC} ${ecmccfg_DIR}loadSubstConfig.cmd,  "FILE=cfg/hw.subs"

##############################################################################
# - motion
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml,               DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=7, ENC_SID=2, ENC_CH=01, BO_SID=5, BO_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml,      DEV=${IOC}, DRV_SID=7"
