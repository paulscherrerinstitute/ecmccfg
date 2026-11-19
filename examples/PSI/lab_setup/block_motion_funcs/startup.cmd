on error break

require ecmccfg v11.2.0_RC2 "ENG_MODE=1,ECMC_VER=v11.2.0_RC2"
require ecb


epicsEnvSet(AID, 1)

#- hardware -------------------------------------------------------------------
iocshLoad ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=14, HW_DESC=EL7041"


iocshLoad ${ecmccfg_DIR}applyComponent.cmd "COMP_S_ID=14,EC_COMP_TYPE=EL7041,COMP=Motor-Generic-2Phase-Stepper,MACROS='I_MAX_MA=1500,I_STDBY_MA=500,U_NOM_MV=48000,INV_DIR=0,R_COIL_MOHM=1700'"

#- axis -----------------------------------------------------------------------
iocshLoad ${ecmccfg_DIR}loadYamlAxis.cmd, "FILE=./cfg/pax.yaml,ANAME=X,AID=${AID},DRV_SID=14,BI_SID=3,BI_CH=01"

# Permanently enable admission filtering. It only rejects a command when its
# motion function is disabled and never masks STOP or drive disable.
ecmcConfigOrDie "Cfg.SetAxisIgnoreDisabledMotionCommands(${AID},1)"
ecmcConfigOrDie "Cfg.SetAxisEnableMotionFunctions(${AID},1,1,1)"

# PLC debug is the test interlock: high blocks normal moves and starts homing.
iocshLoad ${ecmccfg_DIR}loadPLCFile.cmd, "FILE=cfg/block_motion_funcs.plc,PLC_ID=0"

