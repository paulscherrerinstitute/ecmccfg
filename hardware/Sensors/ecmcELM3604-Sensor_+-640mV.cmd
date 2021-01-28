#-d /**
#-d   \brief hardware script for ELM3604 for +-640mV range
#-d   \details Parmetrization of ELM3604 for +-650mV range (all 4 channels)
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

epicsEnvSet(ECMC_RANGE,"+-640mV")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM3604-Sensor_generic.cmd "RANGE=${ECMC_RANGE}"
epicsEnvUnset(ECMC_RANGE)
