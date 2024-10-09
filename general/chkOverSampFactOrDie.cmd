#==============================================================================
# chkOverSampFactOrDie.cmd
#-d /**
#-d   \brief Validates requested oversampling factor
#-d   need to use ecmcExit
#-d   \details Checks if requested oversampling factor is valid otherwise exits EPICS/ECMC
#-d   \author Anders Sandstroem
#-d
#-d    Arguments:
#-d      OVER_SAMP_MAX :  Max oversampling factor for this terminal
#-d      OVER_SAMP_REQ :  Requested Oversampling factor for this terminal
#-d      EC_SAMP       :  EtherCAT bus sampling rate in [Hz]
#-d      HW_TYPE       :  Hardware type
#-d      SLAVE_ID      :  Slave bus position
#-d
#-d   \file
#-d */
#
# Check EtherCAT sample rate is set and valid
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${EC_SAMP=-1}=-1", "ecmcExit Error: EtherCAT sampling rate undefined (${HW_TYPE} at bus position ${SLAVE_ID})","# EtherCAT sampling rate is defined: ${EC_SAMP}")
# Result:
${ECMC_EXE_CMD}
#
# Check requested oversampling factor is in range (1..OVER_SAMP_MAX)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${OVER_SAMP_REQ}>${OVER_SAMP_MAX} or ${OVER_SAMP_REQ}<1", "ecmcExit Error: Oversampling factor out of range (${HW_TYPE} at bus position ${SLAVE_ID}).","# Oversampling factor in range: 1<=${OVER_SAMP_REQ}<=${OVER_SAMP_MAX}")
# Result:
${ECMC_EXE_CMD}
#
# Check that sampling period [ns] (for each sample in the terminal) is an integer
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "floor(1/${EC_SAMP}*1E9/${OVER_SAMP_REQ})<>(1/${EC_SAMP}*1E9/${OVER_SAMP_REQ})", "ecmcExit Error: Oversampling factor not valid (${HW_TYPE} at bus position ${SLAVE_ID}).","# Oversampling factor valid: ${OVER_SAMP_REQ}")
# Result:
${ECMC_EXE_CMD}
#-Cleanup
epicsEnvUnset(ECMC_EXE_CMD)
#
