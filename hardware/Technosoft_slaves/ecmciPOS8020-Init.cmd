#-d /**
#-d   \brief hardware script for iPOS8020-Init
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d   \todo adapt to \ecmccfg.
#-d */

############################################################
############# Init

< ../general/require_E3
< ../general/init

############################################################
############# General:
# This file is only used to download the basic setup to an technosoft drive.
# Normally this is done from Technosoft EasySetup or EasyMotion Studio.
# The setup information can be downloaded via SDO access (after parsing to ecmc format)
# Parsing tool can be found in ecmctraining/V2/startup/hardware/technosoft
# This procedure should only be needed to perform once (new drive or replacing of drive)
# Please ensure that the online cheksum corresponds to the offline checksum (see logfile printouts)
############################################################
############# ASYN Configuration:

epicsEnvSet("ECMC_MOTOR_PORT",    "$(SM_MOTOR_PORT=MCU1)")
epicsEnvSet("ECMC_ASYN_PORT",     "$(SM_ASYN_PORT=MC_CPU1)")
epicsEnvSet("ECMC_PREFIX",        "$(SM_ECMC_PREFIX=IOC2:)")

ecmcAsynPortDriverConfigure($(ECMC_ASYN_PORT),1000,0,0,100)

asynOctetSetOutputEos("$(ECMC_ASYN_PORT)", -1, ";\n")
asynOctetSetInputEos("$(ECMC_ASYN_PORT)", -1, ";\n")

asynSetTraceMask("$(ECMC_ASYN_PORT)", -1, 0x41)
asynSetTraceIOMask("$(ECMC_ASYN_PORT)", -1, 6)
asynSetTraceInfoMask("$(ECMC_ASYN_PORT)", -1, 1)

EthercatMCCreateController("$(ECMC_MOTOR_PORT)", "$(ECMC_ASYN_PORT)", "32", "200", "1000", "")

############################################################
############# Misc settings:
# Disable function call trace printouts
ecmcConfigOrDie "Cfg.SetEnableFuncCallDiag(0)"

# Disable on change printouts from objects (for easy logging)
ecmcConfigOrDie "Cfg.SetTraceMaskBit(15,1)"

# Disable on command transform diag
ecmcConfigOrDie "Cfg.SetTraceMaskBit(7,0)"

# Choose to generate EPICS-records for EtherCAT-entries
# (For records use ECMC_GEN_EC_RECORDS="-records" otherwise ECMC_GEN_EC_RECORDS="")
epicsEnvSet("ECMC_GEN_EC_RECORDS",          "-records")

# Choose to generate EPICS-records for ax-entries (PosAct, SetPos,..)
# (For records use ECMC_GEN_AX_RECORDS="-records" otherwise ECMC_GEN_AX_RECORDS="")
epicsEnvSet("ECMC_GEN_AX_RECORDS",          "-records")

# Update records in 10ms (100Hz)
epicsEnvSet("ECMC_SAMPLE_RATE_MS",       "10")

############################################################
############# Configure hardware:

epicsEnvSet("ECMC_EC_MASTER_ID"          "0")

#Choose master
ecmcConfigOrDie "Cfg.EcSetMaster($(ECMC_EC_MASTER_ID))"

# Configure IPOS 8020 Drive terminal
epicsEnvSet("ECMC_EC_SLAVE_NUM",              "22")

< ../hardware/ecmciPOS8020-driveCSV${ECMC_GEN_EC_RECORDS}

# Configure Motor
< ../hardware/ecmciPOS8020-Motor-McLennan-34HT18C340-Parallel

# Download base config (parsed from Techosoft EasySetup configuration): Only needed first time a drive is used..
< ../hardware/ecmciPOS8020-EEPROM-BaseConfig-StepperOpenLoopCSV

# Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"

##############################################################################
############# Diagnostics:

ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(10)"
ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
ecmcConfigOrDie "Cfg.SetDiagAxisEnable(0)"

##############################################################################
############# Load general controller level records:

< ../general/general

##############################################################################
############# Go to runtime:

ecmcConfig "Cfg.SetAppMode(1)"
