#==============================================================================
# restoreRecordUpdateRate.cmd
#- Arguments: None

#-d /**
#-d   \brief Restores record update rate to what was defined in startup.cmd
#-d   \author Anders Sandström
#-d   \file
#-d */

epicsEnvSet(ECMC_SAMPLE_RATE_MS,${ECMC_SAMPLE_RATE_MS_ORIGINAL})
