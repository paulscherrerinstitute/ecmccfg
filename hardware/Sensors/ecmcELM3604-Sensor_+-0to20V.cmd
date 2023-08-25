#-d /**
#-d   \brief hardware script for ELM3604 for 0..20V range
#-d   \details Parametrization of ELM3604 for 0..20V range (all 4 channels)
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

epicsEnvSet(ECMC_RANGE,"0to20V")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM3604-Sensor_generic.cmd "RANGE=${ECMC_RANGE}"
epicsEnvUnset(ECMC_RANGE)
