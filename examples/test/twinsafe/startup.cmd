##############################################################################
## Example config FSoE test

require ecmccfg twinsafe "ENG_MODE=1"
require ecmccomp

# 22  0:22  PREOP  +  EP1918, 8K. Safety Eingang 24V, TwinSAFE
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,         "SLAVE_ID=22,HW_DESC=EP1918-0002"

# 23  0:23  PREOP  +  EP1957, 8Ch. Safety Input 24V, 4Ch. Safety Output 24V, 0.5A, Tw
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,         "HW_DESC=EP1957-0022"

#- PLC for FSoE communication
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd,      "FILE=cfg/FSoE.plc, PLC_MACROS='FSOE_M_SID=22,FSOE_S_SID=23'"

#- ###########################################################################
#- go active
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
