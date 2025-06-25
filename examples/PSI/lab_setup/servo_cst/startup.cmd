require ecmccfg sandst_a "ENG_MODE=1,MASTER_ID=1,ECMC_VER=v10.1.0_RC1"

# Master 1
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EP7211-0034_CST_STD"
#- Limit torque to 50% of motor rated torque.  Rated current = 2710mA, set to half I_MAX_MA=1355
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Beckhoff-AM8111-XFX0, MACROS='I_MAX_MA=1355'"
