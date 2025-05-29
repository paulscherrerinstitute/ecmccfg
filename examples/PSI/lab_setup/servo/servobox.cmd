require ecmccfg "ENG_MODE=1,MASTER_ID=1"

# Master 1
#   0  0:0   PREOP  +  EK1100 EtherCAT-Koppler (2A E-Bus)
#   1  0:1   PREOP  +  EL9227-5500 Overcurrent protection 24V DC, 2Ch., max. 10A (sum)
#   2  0:2   PREOP  +  EL5042 2Ch. BiSS-C Encoder
#   3  0:3   PREOP  +  EL5042 2Ch. BiSS-C Encoder
#   4  0:4   PREOP  +  EL3204 4K. Ana. Eingang PT100 (RTD)
#   5  0:5   PREOP  +  EL2008 8K. Dig. Ausgang 24V, 0.5A
#   6  0:6   PREOP  +  EL1008 8K. Dig. Eingang 24V, 3ms
#   7  0:7   PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#   8  0:8   PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#   9  0:9   PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#  10  0:10  PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#  11  0:11  PREOP  +  EL9576 Bremschopper Klemme
#  12  0:12  PREOP  +  EP7211-0034 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#  13  0:13  PREOP  +  EP7047-1032 1K. Schrittmotor-Endstufe (50V, 5A)

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EK1100"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL9227-5500"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL3204"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL2008"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL1008"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL7211-9014_ALL_INPUTS"
#- Limit torque to 50% of motor rated torque.  Rated current = 2710mA, set to half I_MAX_MA=1355
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Beckhoff-AM8111-XFX0, MACROS='I_MAX_MA=1355'"
$(SCRIPTEXEC) $(ecmccfg_DIR)loadYamlAxis.cmd   "FILE=./cfg/axis.yaml, DRV_ID=$(ECMC_EC_SLAVE_NUM), AX_NAME='Axis1', AX_ID=1"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL7211-9014_ALL_INPUTS"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL7211-9014_ALL_INPUTS"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL7211-9014_ALL_INPUTS"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "HW_DESC=EL9576"
