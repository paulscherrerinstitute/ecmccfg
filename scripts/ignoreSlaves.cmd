#==============================================================================
# ignoreSlaves.cmd
#- Arguments:
#-d /**
#-d   \brief Ignores a slave
#-d   \details Ignores a slave by increase SLAVE_ID with 1
#-d   \author Anders Sandström
#-d   \file
#-d   \param COUNT (optional) Skip this number of slaves, defaults to 1
#-d */
# increment SLAVE_ID
ecmcEpicsEnvSetCalc("SLAVE_ID", "${SLAVE_ID=0}+${COUNT=1}","%d")
