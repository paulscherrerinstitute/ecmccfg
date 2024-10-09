#-d /**
#-d   \brief Script for applying dc config to slave
#-d   \details Apply dc configurations to a slave.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \param SLAVE_ID Slave Id
#-d   \param ASSIGN_ACTIVATE DC setting. Assign Activate Word from TC xml
#-d   \param SYNC_0_CYCLE (optional) Sync 0 sample time [ns]. Defaults to ethercat cycle time in nanoseconds
#-d   \param SYNC_0_SHIFT (optional) Sync 0 shift time [ns]. Defaults to 0ns
#-d   \param SYNC_1_CYCLE (optional) Sync 1 sample time [ns]. Defaults to 0ns
#-d   \pre A slave must have been added/configured (addSlave.cmd or configureSlave.cmd) immediately before the call of this script (or ECMC_EC_SLAVE_NUM set to correct slave number).
#-d */

#- Check ASSIGN_ACTIVATE is set
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "'${ASSIGN_ACTIVATE=}'==''", "ecmcExit : Error: ASSIGN_ACTIVATE not defined","#- ")
${ECMC_EXE_CMD}
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},${ASSIGN_ACTIVATE=${ECMC_EC_ASSIGN_ACTIVATE}},${SYNC_0_CYCLE=${ECMC_TEMP_PERIOD_NANO_SECS}},${SYNC_0_SHIFT=0},${SYNC_1_CYCLE=0},0)"
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
