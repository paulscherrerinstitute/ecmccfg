##############################################################################
## Simple example config for plcs

require ecmccfg v9.5.5_RC1, "ECMC_VER=v9.5.5_RC1,ENG_MODE=1"

#- ############################################################################
#- Configure hardware
#- ethercat slaves
#- Master0
#- ...
#-  10  0:10  PREOP  +  EL2819 16K. Dig. Ausgang 24V, 0,5A, Diagnose
#- ...
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=10, HW_DESC=EL2819"

#- ############################################################################
#- Load PLC (note the include dir (INC) and the use of ECMC_EC_SLAVE_NUM)
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd,    "FILE=./cfg/main.plc, INC=.:./cfg/, SAMPLE_RATE_MS=1000, PLC_MACROS='BO_S_ID=${ECMC_EC_SLAVE_NUM}'"

#- ############################################################################
#- Go active
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd

