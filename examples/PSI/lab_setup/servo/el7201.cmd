require ecmccfg sandst_a "ENG_MODE=1,MASTER_ID=1,ECMC_VER=v10.1.0_RC1"


epicsEnvSet(SYNC_0_SHIFT,500000)
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,        "SLAVE_ID=13, HW_DESC=EL7201_STD"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd   "COMP=Motor-Beckhoff-AM8111-XFX0_RES, MACROS='I_MAX_MA=1355'"
$(SCRIPTEXEC) $(ecmccfg_DIR)loadYamlAxis.cmd     "FILE=./cfg/axis.yaml, DRV_ID=$(ECMC_EC_SLAVE_NUM), AX_NAME='Axis1', AX_ID=1"
