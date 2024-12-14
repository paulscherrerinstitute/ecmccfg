#===============================================================================
# configureArchiver.cmd
#- Arguments: [POLICY], [CLUSTER]

#-d /**
#-d   \brief Sets variables consumed by info tags related to integration with the EPICS Archiver Appliance.
#-d   \details Currently only availble at ESS.
#-d   \file
#-d   \param POLICY (optional) default value depends on ECMC_P_SCRIPT
#-d   \param CLUSTER (optional) default value depends on ECMC_P_SCRIPT
#-d   \note Examples:
#-d   \code
#-d     $(SCRIPTEXEC) ${ecmccfg_DIR}configureArchiver.cmd
#-d     $(SCRIPTEXEC) ${ecmccfg_DIR}configureArchiver.cmd, "POLICY=1Hz"
#-d     $(SCRIPTEXEC) ${ecmccfg_DIR}configureArchiver.cmd, "CLUSTER=lab"
#-d     $(SCRIPTEXEC) ${ecmccfg_DIR}configureArchiver.cmd, "POLICY=1Hz, CLUSTER=lab"
#-d   \endcode
#-d   \pre Must be called after startup.cmd
#-d   \post Must be called before addAxis.cmd
#-d */

#- The default value for ECMC_BLOCK_ARCHIVER is # (check ecmc_axis_mr.cmd).
#- This prevents the info tags from being loaded.
#- The next line removes this restriction.
epicsEnvSet("ECMC_BLOCK_ARCHIVER" , "")

#- Set ESS-specific default values if NAMING==ESSnaming
#- These values are overridden if either POLICY or CLUSTER are non empty.
ecmcEpicsEnvSetCalcTernary("BLOCK_ESS_DEFAULTS", "'${ECMC_P_SCRIPT}' == 'ESSnaming')", "", "#-")
$(BLOCK_ESS_DEFAULTS) epicsEnvSet("ECMC_ARCHIVER_POLICY" , "default")
$(BLOCK_ESS_DEFAULTS) epicsEnvSet("ECMC_ARCHIVER_CLUSTER", "tn")

#- Only set ECMC_ARCHIVER_POLICY and ECMC_ARCHIVER_CLUSTER if
#- POLICY and CLUSTER arguments are, respectively, non-empty.
#- This allows us to honor the default values in ecmc_axis_mr.cmd
ecmcEpicsEnvSetCalcTernary("BLOCK_POLICY" , "'$(POLICY=)' != ''", "", "#-")
ecmcEpicsEnvSetCalcTernary("BLOCK_CLUSTER", "'$(CLUSTER=)' != ''", "", "#-")
$(BLOCK_POLICY) epicsEnvSet("ECMC_ARCHIVER_POLICY" , "$(POLICY)" )
$(BLOCK_CLUSTER) epicsEnvSet("ECMC_ARCHIVER_CLUSTER", "$(CLUSTER)")

#- Cleanup
epicsEnvUnset(BLOCK_ESS_DEFAULTS)
epicsEnvUnset(BLOCK_POLICY)
epicsEnvUnset(BLOCK_CLUSTER)
