#==============================================================================
# setRecordUpdateRate.cmd
#- Arguments: [RATE_MS = ECMC_EC_SAMPLE_RATE_MS]

#-d /**
#-d   \brief Script for changing record update rate
#-d   \author Anders Sandström
#-d   \file
#-d   \param RATE_MS (optional) update rate in milli-seconds of any record loaded after this call, defaults to ethercat bus rate.
#-d */

epicsEnvSet(ECMC_SAMPLE_RATE_MS,${RATE_MS=${ECMC_EC_SAMPLE_RATE_MS}})
