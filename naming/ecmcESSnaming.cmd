
#==============================================================================
# ecmcmXsXXX.cmd
#- Arguments: none

#-d /**
#-d   \brief Script for defining ${ECMC_P}
#-d   \details Gathers relevant information about MasterID, SlaveID, ... to create naming convention compliant PREFIX
#-d   \author Niko Kivel
#-d   \file
#-d   \pre A ecmc${HW_DESC}.cmd script has to be called before, to popultate MASTER_ID, SLAVE_POS and HWTYPE
#-d */

ecmcEpicsEnvSetCalc("sid", "${SLAVE_POS}","%03d")
ecmcEpicsEnvSetCalc("mid", "${MASTER_ID}","%01d")

#-Master prefix
epicsEnvSet("ECMC_EC_MP",        "#m")
#- pva Group
epicsEnvSet("ECMC_G",            "${ECMC_PREFIX}${ECMC_EC_MP}${mid}s${sid}")
#- PV Prefix
epicsEnvSet("ECMC_P",            "${ECMC_PREFIX}${ECMC_EC_MP}${mid}s${sid}-")

epicsEnvUnset(sid)
epicsEnvUnset(mid)
