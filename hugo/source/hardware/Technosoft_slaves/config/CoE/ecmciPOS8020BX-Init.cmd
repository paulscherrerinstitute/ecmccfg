#-d /**
#-d   \brief hardware script for iPOS8020-Init
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d */

############################################################
############# General:
# This file is only used to download the basic setup to an technosoft drive.
# Normally this is done from Technosoft EasySetup or EasyMotion Studio.
# The setup information can be downloaded via SDO access (after parsing to ecmc format)
# Parsing tool can be found in ecmctraining/V2/startup/hardware/technosoft
# This procedure should only be needed to perform once (new drive or replacing of drive)
# Please ensure that the online cheksum corresponds to the offline checksum (see logfile printouts)
############################################################

epicsEnvSet("IOC" ,"${IOC="IOC_TEST"}")

require ecmccfg anders_ipos8020BX

# run module startup.cmd
iocshLoad ${ecmccfg_DIR}startup.cmd, "IOC=${IOC},ECMC_VER=master,stream_VER=2.8.10"

##############################################################################
## Config hardware:

${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=0, HW_DESC=iPOS8020BX, CONFIG=-Motor-McLennan-34HT18C340-Parallel"

# Download base config (parsed from Techosoft EasySetup configuration): Only needed first time a drive is used..
${SCRIPTEXEC} ./ecmciPOS8020BX-EEPROM-BaseConfig-72Volt-StepperOpenLoopCSV.cmd

# Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"

##############################################################################
############# Configure diagnostics:

ecmcConfigOrDie "Cfg.EcSetDiagnostics(1)"
ecmcConfigOrDie "Cfg.EcEnablePrintouts(0)"
ecmcConfigOrDie "Cfg.EcSetDomainFailedCyclesLimit(100)"

# go active
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
