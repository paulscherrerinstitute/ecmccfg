############################################################
############# Init

< ../general/require_E3
< ../general/init

##############################################################################
############# ASYN Configuration:

epicsEnvSet("ECMC_MOTOR_PORT",    "$(SM_MOTOR_PORT=MCU1)")
epicsEnvSet("ECMC_ASYN_PORT",     "$(SM_ASYN_PORT=MC_CPU1)")
epicsEnvSet("ECMC_PREFIX",        "$(SM_PREFIX=IOC_SLIT:)")

ecmcAsynPortDriverConfigure($(ECMC_ASYN_PORT),1000,0,0,100)

asynOctetSetOutputEos("${ECMC_ASYN_PORT}", -1, ";\n")
asynOctetSetInputEos("${ECMC_ASYN_PORT}", -1, ";\n")

asynSetTraceMask("${ECMC_ASYN_PORT}", -1, 0x41)
asynSetTraceIOMask("${ECMC_ASYN_PORT}", -1, 2)
asynSetTraceIOMask("${ECMC_ASYN_PORT}", -1, 6)

asynSetTraceInfoMask("${ECMC_ASYN_PORT}", -1, 1)

EthercatMCCreateController("${ECMC_MOTOR_PORT}", "${ECMC_ASYN_PORT}", "32", "200", "1000", "")

##############################################################################
############# Misc settings:

# Disable function call trace printouts
ecmcConfigOrDie "Cfg.SetEnableFuncCallDiag(0)"

# Disable on change printouts from objects (enable for easy logging)
ecmcConfigOrDie "Cfg.SetTraceMaskBit(15,0)"

# Choose to generate EPICS-records for EtherCAT-entries 
# (For records use ECMC_GEN_EC_RECORDS="-records" otherwise ECMC_GEN_EC_RECORDS="") 
epicsEnvSet("ECMC_GEN_EC_RECORDS",          "-records")

# Choose to generate EPICS-records for ax-entries (PosAct, SetPos,..)
# (For records use ECMC_GEN_AX_RECORDS="-records" otherwise ECMC_GEN_AX_RECORDS="") 
epicsEnvSet("ECMC_GEN_AX_RECORDS",          "-records")

# Update records in 10ms (100Hz) 
epicsEnvSet("ECMC_SAMPLE_RATE_MS",       "10")

##############################################################################
############# Configure hardware:
epicsEnvSet("ECMC_EC_OVERSAMPLING_FACTOR",    "5")
< ../hardware/ecmcMCU1025_plusEL5101_EL3632_EL3214

##############################################################################
############# Write outputs in order to power switches (see elec. drawings):

ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},OUPIN_1,1)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},OUPIN_2,1)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},OUPIN_3,1)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},OUPIN_4,1)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},OUPIN_5,1)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},OUPIN_6,1)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},OUPIN_7,1)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},OUPIN_8,1)"

##############################################################################
############# Configuration of motor 3

# Custom settings for Axis 3
< axis_3

# Apply configurations to ECMC
< ../motion/ecmc_axis$(ECMC_GEN_AX_RECORDS)

# Sync. settings
< axis_$(ECMC_AXIS_NO)_sync

# Apply configurations to ECMC
< ../motion/ecmc_axis_sync

##############################################################################
############# Configuration of motor 4

# Custom settings for Axis 4
< axis_4

# Apply configurations to ECMC
< ../motion/ecmc_axis$(ECMC_GEN_AX_RECORDS)

# Sync. settings
< axis_$(ECMC_AXIS_NO)_sync

# Apply configurations to ECMC
< ../motion/ecmc_axis_sync

##############################################################################
############# Configuration of motor 1 (center position):

# Custom settings for Axis 1
< axis_1_virt

< ../motion/ecmc_virt_axis$(ECMC_GEN_AX_RECORDS)

# Sync. settings
< axis_$(ECMC_AXIS_NO)_sync

# Apply configurations to ECMC
< ../motion/ecmc_axis_sync

##############################################################################
############# Configuration of motor 2 (gap):

# Custom settings for Axis 2
< axis_2_virt

< ../motion/ecmc_virt_axis$(ECMC_GEN_AX_RECORDS)

# Sync. settings
< axis_$(ECMC_AXIS_NO)_sync

# Apply configurations to ECMC
< ../motion/ecmc_axis_sync

##############################################################################
############# Configuration of motor 5 (master, timing):

# Custom settings for Axis 5
< axis_5_virt

< ../motion/ecmc_virt_axis$(ECMC_GEN_AX_RECORDS)

# Sync. settings
< axis_$(ECMC_AXIS_NO)_sync

# Apply configurations to ECMC
< ../motion/ecmc_axis_sync

##############################################################################
############# Configuration of motor 6 (Amplitude):

# Custom settings for Axis 6
< axis_6_virt

< ../motion/ecmc_virt_axis$(ECMC_GEN_AX_RECORDS)

# Sync. settings
< axis_$(ECMC_AXIS_NO)_sync

# Apply configurations to ECMC
< ../motion/ecmc_axis_sync

##############################################################################
############# Configure diagnostics:

ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(100)"
ecmcConfigOrDie "Cfg.SetDiagAxisIndex(2)"
ecmcConfigOrDie "Cfg.SetDiagAxisFreq(2)"
ecmcConfigOrDie "Cfg.SetDiagAxisEnable(0)"

##############################################################################
############# Load general controller level records:

< ../general/general

require iocStats,ae5d083
dbLoadRecords("iocAdminSoft.db", "IOC=$(ECMC_PREFIX)IocStats")

##############################################################################
############# Go to runtime:

ecmcConfigOrDie "Cfg.SetAppMode(1)"

iocInit

dbl > "$(ECMC_PREFIX)_PVs.list"

