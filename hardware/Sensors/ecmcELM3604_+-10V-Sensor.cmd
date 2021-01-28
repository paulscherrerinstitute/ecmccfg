#-d /**
#-d   \brief hardware script for ELM3604 for +-10V range
#-d   \details Parmetrization of ELM3604 for +-10V range (all 4 channels)
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

epicsEnvSet(ECMC_RANGE,"+-10V")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM360X_${ECMC_RANGE}-Sensor-chX.cmd CH_ID=1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM360X_${ECMC_RANGE}-Sensor-chX.cmd CH_ID=2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM360X_${ECMC_RANGE}-Sensor-chX.cmd CH_ID=3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM360X_${ECMC_RANGE}-Sensor-chX.cmd CH_ID=4
epicsEnvUnset(ECMC_RANGE)
