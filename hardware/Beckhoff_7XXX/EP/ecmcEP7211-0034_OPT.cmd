#-d /**
#-d   \brief Option-driven hardware script for EP7211-0034
#-d   \details Selects a motion mode and optional functions together with their records.
#-d   \param MODE CSV (default), CSP or CST
#-d   \param TP Enable touch-probe PDO and records: 0 (default) or 1
#-d   \param INFO2 INPUTS (default) or TEMP. INPUTS exposes digital inputs 1
#-d          and 2 plus the STO status (HWE level in the ESI). TEMP exposes
#-d          the PCB temperature through Info data 2.
#-d   \param SYNC_0_CYCLE Sync 0 cycle [ns], default EtherCAT cycle
#-d   \param SYNC_0_SHIFT Sync 0 shift [ns], default half an EtherCAT cycle
#-d   \param SYNC_1_CYCLE Sync 1 cycle [ns], default 0
#-d   \param SYNC_1_SHIFT Sync 1 shift [ns], default 0
#-d   \param WATCHDOG_DIVIDER EtherCAT watchdog divider, default gives 1 ms
#-d   \param WATCHDOG_INTERVALS EtherCAT watchdog intervals, default gives 10 ms
#-d   \note Pass feature selection through addSlave.cmd OPT, for example
#-d         OPT='MODE=CSP,TP=1,INFO2=INPUTS,SYNC_0_SHIFT=0'.
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP7211-0034_OPT")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1c2b4052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7211_OCT")

#- Resolve and validate the selected profile without ecmcIf. Hardware snippets
#- can be called from an outer ecmcIf block, whose global state must be preserved.
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_CSV,"'${MODE=CSV}'='CSV'","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_NOT_CSV,"'${MODE=CSV}'!='CSV'","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_CSP,"'${MODE=CSV}'='CSP'","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_NOT_CSP,"'${MODE=CSV}'!='CSP'","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_CST,"'${MODE=CSV}'='CST'","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_NOT_CST,"'${MODE=CSV}'!='CST'","","#-")
${ECMC_EP7211_OPT_NOT_CSV}${ECMC_EP7211_OPT_NOT_CSP}${ECMC_EP7211_OPT_NOT_CST}ecmcExit Error: EP7211-0034_OPT MODE must be CSV, CSP or CST

ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_TP,"${TP=0}==1","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_INFO2_INPUTS,"'${INFO2=INPUTS}'='INPUTS'","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_INFO2_TEMP,"'${INFO2=INPUTS}'='TEMP'","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_INFO2_NOT_INPUTS,"'${INFO2=INPUTS}'!='INPUTS'","","#-")
ecmcEpicsEnvSetCalcTernary(ECMC_EP7211_OPT_INFO2_NOT_TEMP,"'${INFO2=INPUTS}'!='TEMP'","","#-")
${ECMC_EP7211_OPT_INFO2_NOT_INPUTS}${ECMC_EP7211_OPT_INFO2_NOT_TEMP}ecmcExit Error: EP7211-0034_OPT INFO2 must be INPUTS or TEMP

#- Verify slave, including reset.
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- Configure one complete, validated base PDO profile.
${ECMC_EP7211_OPT_CSV}${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_CSV.cmd
${ECMC_EP7211_OPT_CSP}${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_CSP.cmd
${ECMC_EP7211_OPT_CST}${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_CST_OPT.cmd
ecmcConfigOrDie "Cfg.EcSetSlavePortWiringCheckEnable(${ECMC_EC_SLAVE_NUM},1)"

#- Info data 2 is already mapped by the CST base profile; add the same PDO for
#- CSV/CSP. Selection 10 is defined by the EP7211-0034 ESI as: bit 0 input 1,
#- bit 1 input 2, bit 8 HWE/STO level. Selection 4 is PCB temperature.
${ECMC_EP7211_OPT_NOT_CST}ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,U16,infoData02)"
${ECMC_EP7211_OPT_INFO2_INPUTS}ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3A,10,1)"
${ECMC_EP7211_OPT_INFO2_TEMP}ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3A,4,1)"

#- Optional touch-probe input PDO.
${ECMC_EP7211_OPT_TP}ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a07,0x6001,0x01,16,touchProbeStatus01)"
${ECMC_EP7211_OPT_CST}ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0C,0x6000,0x01,U16,encoderStatus01)"

#- Common timing, watchdog and initial peak current.
ecmcEpicsEnvSetCalc("ECMC_EP7211_OPT_PERIOD_NS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcEpicsEnvSetCalc("ECMC_EP7211_OPT_HALF_PERIOD_NS",${ECMC_EP7211_OPT_PERIOD_NS}/2)
ecmcEpicsEnvSetCalc("ECMC_EP7211_OPT_WD_DIVIDER",1000/${ECMC_EC_SAMPLE_RATE=1000}*1000)
ecmcEpicsEnvSetCalc("ECMC_EP7211_OPT_WD_INTERVALS",${ECMC_EP7211_OPT_WD_DIVIDER}*10)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_DC.cmd "ASSIGN_ACTIVATE=0x700,SYNC_0_CYCLE=${SYNC_0_CYCLE=${ECMC_EP7211_OPT_PERIOD_NS}},SYNC_0_SHIFT=${SYNC_0_SHIFT=${ECMC_EP7211_OPT_HALF_PERIOD_NS}},SYNC_1_CYCLE=${SYNC_1_CYCLE=0},SYNC_1_SHIFT=${SYNC_1_SHIFT=0}"
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd "WATCHDOG_DIVIDER=${WATCHDOG_DIVIDER=${ECMC_EP7211_OPT_WD_DIVIDER}},WATCHDOG_INTERVALS=${WATCHDOG_INTERVALS=${ECMC_EP7211_OPT_WD_INTERVALS}}"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,1000,4)"
epicsEnvUnset(ECMC_EP7211_OPT_PERIOD_NS)
epicsEnvUnset(ECMC_EP7211_OPT_HALF_PERIOD_NS)
epicsEnvUnset(ECMC_EP7211_OPT_WD_DIVIDER)
epicsEnvUnset(ECMC_EP7211_OPT_WD_INTERVALS)

#- Load only records corresponding to configured PDOs. ECMC_P is prepared by
#- addSlave.cmd before this hardware script is executed.
${ECMC_EP7211_OPT_CSV}${SCRIPTEXEC} ${ecmccfg_DIR}applySubstitutions.cmd "SUBST_FILE=ecmcEP7211-0034_OPT_csv.substitutions,ECMC_P=${ECMC_P}"
${ECMC_EP7211_OPT_CSP}${SCRIPTEXEC} ${ecmccfg_DIR}applySubstitutions.cmd "SUBST_FILE=ecmcEP7211-0034_OPT_csp.substitutions,ECMC_P=${ECMC_P}"
${ECMC_EP7211_OPT_CST}${SCRIPTEXEC} ${ecmccfg_DIR}applySubstitutions.cmd "SUBST_FILE=ecmcEP7211-0034_OPT_cst.substitutions,ECMC_P=${ECMC_P}"
${ECMC_EP7211_OPT_INFO2_TEMP}${SCRIPTEXEC} ${ecmccfg_DIR}applySubstitutions.cmd "SUBST_FILE=ecmcEP7211-0034_OPT_info2Temp.substitutions,ECMC_P=${ECMC_P}"
${ECMC_EP7211_OPT_INFO2_INPUTS}${SCRIPTEXEC} ${ecmccfg_DIR}applySubstitutions.cmd "SUBST_FILE=ecmcEP7211-0034_OPT_info2Inputs.substitutions,ECMC_P=${ECMC_P}"
${SCRIPTEXEC} ${ecmccfg_DIR}applySubstitutions.cmd "SUBST_FILE=ecmcEP7211-0034_OPT_encoder.substitutions,ECMC_P=${ECMC_P}"
${ECMC_EP7211_OPT_TP}${SCRIPTEXEC} ${ecmccfg_DIR}applySubstitutions.cmd "SUBST_FILE=ecmcEP7211-0034_OPT_touchProbe.substitutions,ECMC_P=${ECMC_P}"

#- Suppress the legacy monolithic substitution lookup in addSlave.cmd.
epicsEnvSet("DEFAULT_SUBS"                "false")
${ECMC_EP7211_OPT_NOT_CST}epicsEnvSet("ECMC_HW_PANEL", "Ex72x1")
${ECMC_EP7211_OPT_CST}epicsEnvSet("ECMC_HW_PANEL", "Ex72x1_CST_STD")

epicsEnvUnset(ECMC_EP7211_OPT_CSV)
epicsEnvUnset(ECMC_EP7211_OPT_NOT_CSV)
epicsEnvUnset(ECMC_EP7211_OPT_CSP)
epicsEnvUnset(ECMC_EP7211_OPT_NOT_CSP)
epicsEnvUnset(ECMC_EP7211_OPT_CST)
epicsEnvUnset(ECMC_EP7211_OPT_NOT_CST)
epicsEnvUnset(ECMC_EP7211_OPT_TP)
epicsEnvUnset(ECMC_EP7211_OPT_INFO2_INPUTS)
epicsEnvUnset(ECMC_EP7211_OPT_INFO2_TEMP)
epicsEnvUnset(ECMC_EP7211_OPT_INFO2_NOT_INPUTS)
epicsEnvUnset(ECMC_EP7211_OPT_INFO2_NOT_TEMP)
