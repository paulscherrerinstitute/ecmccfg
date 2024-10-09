#==============================================================================
# ecmc_enc_unset.cmd
#- Arguments: n/a
#-d /**
#-d   \brief Clears all encoder related variables
#-d   \details Unsets all varaiables set by ecmc_enc.cmd configuration snippet
#-d   \author Anders Sandstroem
#-d */

#- epicsEnvUnset(ECMC_AXIS_NO)
epicsEnvUnset(ECMC_ENC_DESC)
epicsEnvUnset(ECMC_ENC_EGU)
epicsEnvUnset(ECMC_EC_ENC_ACTPOS)
epicsEnvUnset(ECMC_EC_ENC_LATCHPOS)
epicsEnvUnset(ECMC_EC_ENC_LATCH_CONTROL)
epicsEnvUnset(ECMC_EC_ENC_LATCH_STATUS)
epicsEnvUnset(ECMC_HOME_LATCH_COUNT_OFFSET)
epicsEnvUnset(ECMC_ENC_SCALE_DENOM)
epicsEnvUnset(ECMC_ENC_SCALE_NUM)
epicsEnvUnset(ECMC_ENC_TYPE)
epicsEnvUnset(ECMC_ENC_BITS)
epicsEnvUnset(ECMC_ENC_ABS_BITS)
epicsEnvUnset(ECMC_ENC_ABS_OFFSET)
epicsEnvUnset(ECMC_ENC_VEL_FILTER_SIZE)
epicsEnvUnset(ECMC_ENC_POS_FILTER_SIZE)
epicsEnvUnset(ECMC_ENC_POS_FILTER_ENABLE)
epicsEnvUnset(ECMC_EC_ENC_RESET)
epicsEnvUnset(ECMC_EC_ENC_ALARM_0)
epicsEnvUnset(ECMC_EC_ENC_ALARM_1)
epicsEnvUnset(ECMC_EC_ENC_ALARM_2)
epicsEnvUnset(ECMC_EC_ENC_WARNING)
epicsEnvUnset(ECMC_ENC_REF_TO_ENC_AT_STARTUP_ID)
epicsEnvUnset(ECMC_ENC_HOME_ID)
epicsEnvUnset(ECMC_ENC_PRIMARY_ID)
epicsEnvUnset(ECMC_ENC_CFG_ID)
epicsEnvUnset(ECMC_ENC_REF_AT_HOME)
epicsEnvUnset(ECMC_ENC_MAX_DIFF_TO_PRIM_ENC)
