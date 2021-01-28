#-d /**
#-d   \brief hardware script for ELM360X for +-640mV range
#-d   \details Parmetrization of ELM360X for +-640mV range used for voltage measurement (not IEPE)
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre CH_ID Channel id 1..4
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

ecmcEpicsEnvSetCalc("ECMC_SDO_ID_LOCAL",${CH_ID}-1)

#- Check ECMC_SDO_ID_LOCAL>=0
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${ECMC_SDO_ID_LOCAL=-1}<0", "ecmcExit Error: Channel ID out of range (${HW_TYPE} at bus position ${SLAVE_ID})","#- Channel ID valid")
# Result:
${ECMC_EXE_CMD}

#- +-640mV Setting (101)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_SDO_ID_LOCAL}0,0x1,101,2)"
#- IEPE AC coupling (off)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_SDO_ID_LOCAL}0,0x3,0,2)"
#- IEPE Bias current (0mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_SDO_ID_LOCAL}0,0x7,0,1)"

#- Cleanup
epicsEnvUnset(ECMC_SDO_ID_LOCAL)
epicsEnvUnset(ECMC_EXE_CMD)
