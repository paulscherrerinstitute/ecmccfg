##############################################################################
## Simple example config for plcs with save and restore

require ecmccfg "ENG_MODE=1"

#- #############################################################################
# ASR / auto-save-restore
require "autoSRarray"
set_requestfile_path("./db")
set_pass0_restoreFile("$(IOC)_ecmc_test.sav")
set_pass1_restoreFile("$(IOC)_ecmc_test.sav")
afterInit create_monitor_set,"ecmc_test.req",10,"IOC=$(IOC)","$(IOC)_ecmc_test.sav")

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
dbLoadRecords("ecmcPlcBinary.db","P=$(IOC):,PORT=MC_CPU1,ASYN_NAME=plcs.plc0.static.restoreVariableBin,REC_NAME=-Bin")
dbLoadRecords("ecmcPlcAnalog.db","P=$(IOC):,PORT=MC_CPU1,ASYN_NAME=plcs.plc0.static.restoreVariableAnalog,REC_NAME=-Ana")


#- ############################################################################
#- Go active
${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd

#dbpf c6015a-01:Set-restoreVariable-RB 1
#dbpf c6015a-01:Set-restoreVariable-RB 0
