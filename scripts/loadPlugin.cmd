#==============================================================================
# loadPlugin.cmd
#- Arguments: FILE, PLUGIN_ID, [CONFIG], [REPORT]

#-d /**
#-d   \brief Script for loading a ecmc pluginfrom file.
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE      Filename of plugin shared lib (./ecmcPlugin_Advanced.so)
#-d   \param PLUGIN_ID Id of plugin to load
#-d   \param CONFIG (optional) Configuration string sent to plugin at construct
#-d   \param REPORT (optional) Printout information of loaded plugin if set to "1"
#-d   \note Example call:
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}loadPlugin.cmd, "PLUGIN_ID=0,FILE=./ecmcPlugin_Advanced.so,CONFIG='PLUGIN CONFIGS GO HERE '
#-d   \endcode
#-d */

ecmcConfigOrDie "Cfg.LoadPlugin(${PLUGIN_ID},${FILE},${CONFIG=""})"
#- Report if REPORT>0
ecmcEpicsEnvSetCalcTenary("ECMC_PLUGIN_REPORT", "${REPORT=-1}>0","","#")
${ECMC_PLUGIN_REPORT}ecmcConfigOrDie "Cfg.ReportPlugin(${PLUGIN_ID})"
epicsEnvUnset(ECMC_PLUGIN_REPORT);
