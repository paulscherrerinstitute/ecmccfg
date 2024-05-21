#==============================================================================
# pvtControllerConfig.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Script for configuring Motor Record profile move (PVT) for asynMotorController
#-d   \author Anders Sandström
#-d   \file
#-d   \param NPOINTS   (optional) Number point in trajectory (defaults to max NPOINTS defined in axes cfg if this command is executed after axes are configured)
#-d   \param NREADBACK (optional) Number point in trajectory (defaults to max NREADBACK defined in axes cfg if this command is executed after axes are configured)
#-d   \param NPULSES   (optional) Number of pulses to output (defaults to NPOINTS)
#-d   \param NAXES     (optional) Number of axes using pvt mode (defaults to the number of axes configuered for pvt if this command is executed after axes are configured)
#-d */

#- Handle default values
epicsEnvSet(NREADBACK,${NREADBACK=${ECMC_MR_PVT_MAX_RB_POINTS_IN_USE=0}})
epicsEnvSet(NPOINTS,${NPOINTS=${ECMC_MR_PVT_MAX_POINTS_IN_USE=0}})
epicsEnvSet(NPULSES,${NPULSES=${NPOINTS=0}})
epicsEnvSet(NAXES,${NAXES=${ECMC_MR_PVT_AXES_COUNT_IN_USE=0}})

#- Load pvt controller records if PVT is in use
dbLoadRecords(ecmcProfileMoveController.template,"P=${ECMC_PREFIX},R=PVT-,PORT=${ECMC_MOTOR_PORT},NAXES=${NAXES},NPOINTS=${NPOINTS},NREADBACK=${NREADBACK},NPULSES=${NPULSES},ADDR=0")
epicsEnvUnset(NREADBACK)
epicsEnvUnset(NPOINTS)
epicsEnvUnset(NPULSES)
epicsEnvUnset(NAXES)
epicsEnvSet(ECMC_MR_PVT_CONTROLLER_CONFIGURED,1)
