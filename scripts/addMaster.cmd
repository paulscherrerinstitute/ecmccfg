#===============================================================================
# addMaster.cfg
#- Arguments: [MASTER_ID = 0]

#-d /**
#-d   \brief Script for claiming a particular master.
#-d   \author Niko Kivel
#-d   \file
#-d   \param MASTER_ID (optional) master ID as shown by `ethercat master`.
#-d   \note Example calls:
#-d   \note - call w/o MASTER_ID
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addMaster.cmd
#-d   \endcode
#-d   \note - call w/ MASTER_ID, which claims the 4th master.
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addMaster.cmd,      "MASTER_ID=3"
#-d   \endcode
#-d */

epicsEnvSet("ECMC_EC_MASTER_ID"          "${MASTER_ID=0}")

# Claim master
ecmcConfigOrDie "Cfg.EcSetMaster(${ECMC_EC_MASTER_ID})"
