##############################################################################
## Example config for EL7041 and EL5042 using loadSubstConfig.cmd

require ecmccfg sandst_a "ENG_MODE=1,ECMC_VER=test_softlim"

##############################################################################
# - apply hardware configuration
${SCRIPTEXEC} ${ecmccfg_DIR}loadSubstConfig.cmd,  "FILE=cfg/hw_light.subs"

##############################################################################
# - motion
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml,               DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=14, ENC_SID=9, ENC_CH=01,BO_SID=2"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml,      DEV=${IOC}, DRV_SID=14"
