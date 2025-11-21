#==============================================================================
# pvtControllerConfig.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Script for configuring Motor Record profile move (PVT) for asynMotorController
#-d   \author Anders Sandström
#-d   \file
#-d   \param NPOINTS       (optional) Number points in trajectory (defaults to max NPOINTS defined in axes cfg if this command is executed after axes are configured)
#-d   \param NREADBACK     (optional) Number points in trajectory (defaults to max NREADBACK defined in axes cfg if this command is executed after axes are configured)
#-d   \param NPULSES       (optional) Number of pulses to output (defaults to NPOINTS)
#-d   \param NAXES         (optional) Number of axes using pvt mode (defaults to the number of axes configuered for pvt if this command is executed after axes are configured)
#-d   \param MAX_POINTS_PULSES (optional) Number points in time array (defaults to max of NREADBACK and NPOINTS defined in axes cfg if this command is executed after axes are configured)
#-d   \param TRG_EC_ENTRY  (optional) EtherCAT entry for trigger output, default to nothing (triggering disabled). Example: TRG_EC_ENTRY='ec0.23.binaryOutput02.0'
#-d   \param TRG_DUR_S     (optional) Duration of trigger pulse defaults to 0.1 s. Example: TRG_DUR_S=0.2, 
#-d   \param SOFT_TRG_FLNK (optional) Forward-link for soft trigger (PV name = <P>PVT-SftTrg)
#-d */

#- Handle default values
epicsEnvSet(NREADBACK,${NREADBACK=${ECMC_MR_PVT_MAX_RB_POINTS_IN_USE=0}})
epicsEnvSet(NPOINTS,${NPOINTS=${ECMC_MR_PVT_MAX_POINTS_IN_USE=0}})
epicsEnvSet(NPULSES,${NPULSES=${NPOINTS=0}})
epicsEnvSet(NAXES,${NAXES=${ECMC_MR_PVT_AXES_COUNT_IN_USE=0}})

#- Find max count of NPOINTS, NREADBACK, and NPULSES for allocation of time and readback array's 
ecmcEpicsEnvSetCalcTernary(ECMC_MAX_SIZE,"${NREADBACK}>${NPOINTS}",${NREADBACK},${NPOINTS})
ecmcEpicsEnvSetCalcTernary(ECMC_MAX_SIZE,"${NPULSES}>${ECMC_MAX_SIZE}",${NPULSES},${ECMC_MAX_SIZE})
epicsEnvSet(MAX_SIZE,${MAX_SIZE=${ECMC_MAX_SIZE=0}})

#- Call initailize() in model 3 driver (max size of point, pulses,...)
ecmcCreateProfile(${ECMC_MOTOR_PORT},${MAX_SIZE})

#- Load pvt controller records if PVT is in use
ecmcFileExist("ecmcProfileMoveController.template",1,1)
dbLoadRecords(ecmcProfileMoveController.template,"P=${ECMC_PREFIX},R=PVT-,PORT=${ECMC_MOTOR_PORT},NAXES=${NAXES},NPOINTS=${NPOINTS},NREADBACK=${NREADBACK},NPULSES=${NPULSES},ADDR=0,MAX_SIZE=${MAX_SIZE}")

#- And the softtrigger (needs to be fast so in communication through ECMC_ASYN_PORT instead of ECMC_MOTOR_PORT)
#- Hardcoded to be updated at EC_RATE  (ECMC_EC_SAMPLE_RATE_MS)
ecmcFileExist("ecmcPVTTrigger.template",1,1)
dbLoadRecords(ecmcPVTTrigger.template,"P=${ECMC_PREFIX},R=PVT-,PORT=${ECMC_ASYN_PORT},T_SMP_MS=${ECMC_EC_SAMPLE_RATE_MS},FLNK=${SOFT_TRG_FLNK=''}")

ecmcIf("'${TRG_EC_ENTRY=NAN}'!='NAN'")
${IF_TRUE}ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${TRG_EC_ENTRY=NAN},pvtctrl.trigger.output)"
${IF_TRUE}ecmcEpicsEnvSetCalc(ECMC_PVT_CNTRL_TRG_DUR_MS,"$(TRG_DUR_S=0.1)*1000")
${IF_TRUE}ecmcConfigOrDie "Cfg.SetPVTControllerTrgDurMs($(ECMC_PVT_CNTRL_TRG_DUR_MS=100))"
ecmcEndIf()

#-Cleanup
epicsEnvUnset(ECMC_MAX_SIZE)
epicsEnvUnset(MAX_SIZE)
epicsEnvUnset(NREADBACK)
epicsEnvUnset(NPOINTS)
epicsEnvUnset(NPULSES)
epicsEnvUnset(NAXES)
epicsEnvUnset(TRG_EC_ENTRY)
epicsEnvUnset(TRG_DUR_S)
epicsEnvUnset(ECMC_PVT_CNTRL_TRG_DUR_MS)
epicsEnvSet(ECMC_MR_PVT_CONTROLLER_CONFIGURED,1)
