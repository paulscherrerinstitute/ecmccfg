#==============================================================================
# ecmc_axis_sync_unset.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Unsets all varaiables set by ecmc_axis_sync.cmd configuration snippet
#-d   \author Anders Sandstroem
#-d */

epicsEnvUnset(ECMC_CMD_FRM_OTHER_PLC_ENABLE)
epicsEnvUnset(ECMC_CMD_AXIS_PLC_ENABLE)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_1)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_2)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_3)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_4)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_5)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_6)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_7)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_8)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_9)
epicsEnvUnset(ECMC_AXIS_EXPR_LINE_10)
epicsEnvUnset(ECMC_ENC_VELO_FILT_SIZE)
epicsEnvUnset(ECMC_ENC_VELO_FILT_ENABLE)
epicsEnvUnset(ECMC_ENC_SOURCE)
epicsEnvUnset(ECMC_TRAJ_VELO_FILT_SIZE)
epicsEnvUnset(ECMC_TRAJ_VELO_FILT_ENABLE)
epicsEnvUnset(ECMC_TRAJ_SOURCE)
