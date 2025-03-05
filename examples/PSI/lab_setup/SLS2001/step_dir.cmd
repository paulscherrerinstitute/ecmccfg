##############################################################################
## Example config for EL2522 step direction drive

##############################################################################
## Initiation:
require ecmccfg "ENG_MODE=1,EC_RATE=500"

##############################################################################
## Config hardware:
# Master0
#   0  0:0  PREOP  +  EK1100 EtherCAT-Koppler (2A E-Bus)
#   1  0:1  PREOP  +  EL4102 2K. Ana. Ausgang 0-10V, 16bit
#   2  0:2  PREOP  +  EL4102 2K. Ana. Ausgang 0-10V, 16bit
#   3  0:3  PREOP  +  EL3164 4K. Ana. Eingang 0-10V
#   4  0:4  PREOP  +  EL2522 2K. Pulse Train Ausgang
#   5  0:5  PREOP  +  EL9505 Netzteilklemme 5V
#
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=4,HW_DESC=EL2522"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-Step-Dir,  MACROS='MAX_FREQ=3000,FREQ_RES=0.1',CH_ID=1"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-Step-Dir,  MACROS='',CH_ID=2"
epicsEnvSet("DRV_ID","$(ECMC_EC_SLAVE_NUM)")
$(SCRIPTEXEC) ($(ecmccfg_DIR)loadYamlAxis.cmd, FILE=./cfg/axis.yaml)

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=12,HW_DESC=EL2521"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-Step-Dir,  MACROS='MAX_FREQ=3000,FREQ_RES=0.1',CH_ID=1"

