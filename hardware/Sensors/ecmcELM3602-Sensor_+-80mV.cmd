#-d /**
#-d   \brief hardware script for ELM3602 for +-80mV range
#-d   \details Parmetrization of ELM3602 for +-80mV range (all 2 channels)
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

epicsEnvSet(ECMC_RANGE,"+-80mV")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM3602-Sensor_generic.cmd "RANGE=${ECMC_RANGE}"
epicsEnvUnset(ECMC_RANGE)
