#==============================================================================
#-d /** chkValidCurrentSetOrDie.cmd
#-d
#-d   \brief Checks if requested run current and stanby current is less than max current and larget than 0
#-d   need to use ecmcExit since iocsh command "exit" just stops reading current file.
#-d
#-d   \author Anders Sandstroem
#-d
#-d    Arguments: 
#-d      I_MAX_MA   :  Max current in mA
#-d      I_RUN_MA   :  Run current in mA
#-d      I_STDBY_MA :  Standby current in mA
#-d
#-d   \file
#-d */

# Ensure running current is below max current otherwise exit
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${I_RUN_MA=-1}>${I_MAX_MA=0} or ${I_RUN_MA=-1}<=0", "ecmcExit Error: Run current setpoint to high or negative...","# Run current setting OK (${I_RUN_MA_LOCAL=-1})...")
# Result: 
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)

# Ensure standby current is below max current otherwise exit
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${I_STDBY_MA=-1}>${I_MAX_MA=0} or ${I_STDBY_MA=-1}<0", "ecmcExit Error: Standby current setpoint to high or negative...","# Standby current setting OK (${I_STDBY_MA=-1})...")
# Result: 
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)

# Ensure standby current is below run current otherwise exit
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${I_STDBY_MA=0}>${I_RUN_MA=-1}", "ecmcExit Error: Standby current higher than run current...","# Standby current and run current setting OK (${I_STDBY_MA=-1}<${I_RUN_MA=-1})...")
# Result: 
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)
