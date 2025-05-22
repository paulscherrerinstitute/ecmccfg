##############################################################################
# Test homing on legacy axis cfg
#
require ecmccfg v9.6.2_RC1 "ENG_MODE=1,ECMC_VER=v9.6.2_RC1"
require ecmccomp

##############################################################################
## Configure hardware

epicsEnvSet("DRV_ID",              "13")
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=$(DRV_ID),HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1000, I_STDBY_MA=200, U_NOM_MV=48000, R_COIL_MOHM=1230,SPEED_RANGE=1'"

##############################################################################
## AXIS 1
epicsEnvSet("DEV",      "$(IOC)")
$(SCRIPTEXEC) $(ecmccfg_DIR)configureAxis.cmd, CONFIG=./cfg/el704X_1.ax

#- ###########################################################################
#- go active
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
