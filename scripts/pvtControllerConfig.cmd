#==============================================================================
# pvtControllerConfig.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Script for configuring Motor Record profile move (PVT) for asynMotorController
#-d   \author Anders Sandström
#-d   \file
#-d   \param NPOINTS   (optional) Number points in trajectory (defaults to max NPOINTS defined in axes cfg if this command is executed after axes are configured)
#-d   \param NREADBACK (optional) Number points in trajectory (defaults to max NREADBACK defined in axes cfg if this command is executed after axes are configured)
#-d   \param NPULSES   (optional) Number of pulses to output (defaults to NPOINTS)
#-d   \param NAXES     (optional) Number of axes using pvt mode (defaults to the number of axes configuered for pvt if this command is executed after axes are configured)
#-d   \param N_TIME_POINTS  (optional) Number points in time array (defaults to max of NREADBACK and NPOINTS defined in axes cfg if this command is executed after axes are configured)
#-d */

#- Handle default values
epicsEnvSet(NREADBACK,${NREADBACK=${ECMC_MR_PVT_MAX_RB_POINTS_IN_USE=0}})
epicsEnvSet(NPOINTS,${NPOINTS=${ECMC_MR_PVT_MAX_POINTS_IN_USE=0}})
epicsEnvSet(NPULSES,${NPULSES=${NPOINTS=0}})
epicsEnvSet(NAXES,${NAXES=${ECMC_MR_PVT_AXES_COUNT_IN_USE=0}})

#- Find max count of NPOINTS,NREADBACK, and NPULSES for allocation of time array 
ecmcEpicsEnvSetCalcTernary(ECMC_N_TIME_POINTS,"${NREADBACK}>${NPOINTS}",${NREADBACK},${NPOINTS})
ecmcEpicsEnvSetCalcTernary(ECMC_N_TIME_POINTS,"${NPULSES}>${NREADBACK}",${NPULSES},${NREADBACK})
epicsEnvSet(N_TIME_POINTS,${N_TIME_POINTS=${ECMC_N_TIME_POINTS=0}})

#- Call initailize() in model 3 driver
ecmcCreateProfile(${ECMC_MOTOR_PORT},${ECMC_N_TIME_POINTS})

#- Load pvt controller records if PVT is in use
dbLoadRecords(ecmcProfileMoveController.template,"P=${ECMC_PREFIX},R=PVT-,PORT=${ECMC_MOTOR_PORT},NAXES=${NAXES},NPOINTS=${NPOINTS},NREADBACK=${NREADBACK},NPULSES=${NPULSES},ADDR=0")

#-Cleanup
epicsEnvUnset(ECMC_N_TIME_POINTS)
epicsEnvUnset(N_TIME_POINTS)
epicsEnvUnset(NREADBACK)
epicsEnvUnset(NPOINTS)
epicsEnvUnset(NPULSES)
epicsEnvUnset(NAXES)
epicsEnvSet(ECMC_MR_PVT_CONTROLLER_CONFIGURED,1)
