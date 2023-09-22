#-d /**
#-d   \brief hardware script for ELM360X for +-2.5V range
#-d   \details Parametrization of ELM360X for +-2.5V range used for voltage measurement (not IEPE)
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre CH_ID Channel id 1..4
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

ecmcEpicsEnvSetCalc("ECMC_SDO_ID_LOCAL",${CH_ID}-1)

# Check ECMC_SDO_ID_LOCAL>=0
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${ECMC_SDO_ID_LOCAL=-1}<0", "ecmcExit Error: Channel ID out of range (${ECMC_EC_HWTYPE} at bus position ${ECMC_EC_SLAVE_NUM})","# Channel ID valid")
# Result:
${ECMC_EXE_CMD}

#- +-2.5V Setting (99)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_SDO_ID_LOCAL}0,0x1,99,2)"
#- IEPE AC coupling (off)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_SDO_ID_LOCAL}0,0x3,0,2)"
#- IEPE Bias current (0mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_SDO_ID_LOCAL}0,0x7,0,1)"

#- Cleanup
epicsEnvUnset(ECMC_SDO_ID_LOCAL)
epicsEnvUnset(ECMC_EXE_CMD)
