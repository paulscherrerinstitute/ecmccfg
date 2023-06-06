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
ecmcEpicsEnvSetCalcTernary("ECMC_PLUGIN_REPORT", "${REPORT=-1}>0","","#")
${ECMC_PLUGIN_REPORT}ecmcConfigOrDie "Cfg.ReportPlugin(${PLUGIN_ID})"
epicsEnvUnset(ECMC_PLUGIN_REPORT);

#- Below for facilitate auto gui generation
dbLoadRecords(ecmcPlg.template, "P=${ECMC_PREFIX},Index=${PLUGIN_ID}")

# Do not set NxtObj "pointer" if this is the first axis (ECMC_PREV_PLG_OBJ_ID==-1)
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_NEXT_PLG,"${ECMC_PREV_PLG_OBJ_ID=-1}>=0", "","#- ")
${ECMC_EXE_NEXT_PLG}dbLoadRecords(ecmcPlgPrevPlg.db,"NEXT_OBJ_ID=${PLUGIN_ID=-1},PREV_ECMC_P=${ECMC_PREV_PLG_P=""}")
epicsEnvUnset(ECMC_EXE_NEXT_PLG)

#- If this is the first added slave then store value in P:MCU-Cfg-AX-FrstObj
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_FIRST_PLG,"${ECMC_PREV_PLG_OBJ_ID=-1}<0", "","#- ")
${ECMC_EXE_FIRST_PLG}dbLoadRecords(ecmcPlgFirstplg.db,"P=${ECMC_PREFIX},FIRST_OBJ_ID=${PLUGIN_ID}")
epicsEnvUnset(ECMC_EXE_FIRST_PLG)

#- Store info to populate the ECMC_P-NxtObj "pointer" of next added axis
epicsEnvSet(ECMC_PREV_PLG_P,"$(ECMC_PREFIX)MCU-Cfg-DS${PLUGIN_ID}-")
epicsEnvSet(ECMC_PREV_PLG_OBJ_ID,${PLUGIN_ID})
