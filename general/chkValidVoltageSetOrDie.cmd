#==============================================================================
# chkValidVoltageSetOrDie.cmd
#-d /**
#-d   \brief Ensure requested nominal voltage is less than max voltage and larger than 0
#-d   need to use ecmcExit since iocsh command "exit" just stops reading current file.
#-d
#-d    Arguments:
#-d      V_MAX_MV   :  Max voltage in mV
#-d      V_NOM_MV   :  Nominal voltage in mV
#-d
#-d   \file
#-d*/

ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${V_NOM_MV=-1}<0 or ${V_NOM_MV=-1}>${I_MAX_MA=0}", "ecmcExit Error: Voltage setpoint too high, negative or zero...","# Voltage setting OK (${V_NOM_MV=-1})...")
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)
