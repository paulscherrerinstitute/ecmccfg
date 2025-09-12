#- Configuration scripts
#- ############################################################################
#- add slaves
#- list of slaves (4 axis test motion box)
# Master0
#   0  0:0   PREOP  +  EK1100 EtherCAT-Koppler (2A E-Bus)
#   1  0:1   PREOP  +  EL9227-5500 �berstromschutz 24V DC, 2K., max. 10A (Summe), eins
#   2  0:2   PREOP  +  EL5042 2Ch. BiSS-C Encoder
#   3  0:3   PREOP  +  EL5042 2Ch. BiSS-C Encoder
#   4  0:4   PREOP  +  EL3204 4K. Ana. Eingang PT100 (RTD)
#   5  0:5   PREOP  +  EL2008 8K. Dig. Ausgang 24V, 0.5A
#   6  0:6   PREOP  +  EL1008 8K. Dig. Eingang 24V, 3ms
#   7  0:7   PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
#   8  0:8   PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
#   9  0:9   PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
#  10  0:10  PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
#

# 0:0  - EK1100    EtherCAT coupler
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EK1100"

# 0:1  - EL9227-5500
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL9227-5500"

# 0:2  - EL5042    2Ch BiSS-C Encoder
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL5042"

# 0:3  - EL5042    2Ch BiSS-C Encoder
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL5042"

# 0:4  - EL3204    
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL3204"

# 0:5  - EL2008 
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL2008"

# 0:6  - EL1008    8K. Dig. Eingang 24V, 3ms
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL1008"

# 0:7 - EL7041    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd     "COMP=Motor-Generic-2Phase-Stepper,MACROS='I_MAX_MA=1000,I_STDBY_MA=500,U_NOM_MV=48000,R_COIL_MOHM=1230'"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,      "FILE=../common/axis_ax5_LO.yaml, DRV_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_CHANNEL=01"

# 0:8 - EL7041    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd     "COMP=Motor-Generic-2Phase-Stepper,MACROS='I_MAX_MA=1000,I_STDBY_MA=500,U_NOM_MV=48000,R_COIL_MOHM=1230'"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,      "FILE=../common/axis_ax6_HI.yaml, DRV_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_CHANNEL=01"

# 0:9 - EL7041    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL7041-0052"

# 0:10 - EL7041    1Ch Stepper
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,          "HW_DESC=EL7041-0052"

#- Virtual axes
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,      "FILE=../common/axis_vax5_YCEN.yaml, AX_ID=${AX_NUM=12}"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,      "FILE=../common/axis_vax6_YGAP.yaml, AX_ID=${AX_NUM=13}"
