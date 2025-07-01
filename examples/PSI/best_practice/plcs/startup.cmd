##############################################################################
## Simple example config for plcs

#require ecmccfg sandst_a "ENG_MODE=1,ECMC_VER=sandst_a"
require ecmccfg "ENG_MODE=1"

#- ############################################################################
#- Configure hardware
#- ethercat slaves
#- Master0
#- ...
#-  10  0:10  PREOP  +  EL2819 16K. Dig. Ausgang 24V, 0,5A, Diagnose
#- ...
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=2, HW_DESC=EL2819"

#- ############################################################################
#- Load PLC (note the include dir (INC) and the use of ECMC_EC_SLAVE_NUM)
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd,    "FILE=./cfg/main.plc, INC=.:./cfg/, DESC='Toggle bits', SAMPLE_RATE_MS=1000, PLC_MACROS='BO_S_ID=${ECMC_EC_SLAVE_NUM}'"

