

# 0:7 - EL7031    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=12,HW_DESC=EL7031"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=24000, R_COIL_MOHM=1230'"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=../common/axis_ax6_HI_mr_disable.yaml, DRV_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_CHANNEL=01,M_ID=${ECMC_EC_MASTER_ID}"


# 0:7 - EL7041    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=14,HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=48000, R_COIL_MOHM=1230'"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=../common/axis_ax5_LO_mr_disable.yaml, DRV_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_CHANNEL=01,M_ID=${ECMC_EC_MASTER_ID}"

#- #################################################################
#- Virtual axes
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,      "FILE=../common/axis_vax5_YCEN_mr_disable.yaml, AX_ID=${AX_NUM=12},M_ID=${ECMC_EC_MASTER_ID},DRV_SLAVE=${ECMC_EC_SLAVE_NUM}"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,      "FILE=../common/axis_vax6_YGAP_mr_disable.yaml, AX_ID=${AX_NUM=13},M_ID=${ECMC_EC_MASTER_ID},DRV_SLAVE=${ECMC_EC_SLAVE_NUM}"

