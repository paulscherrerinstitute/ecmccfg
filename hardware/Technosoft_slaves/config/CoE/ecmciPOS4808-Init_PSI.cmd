#-d /**
#-d   \brief hardware script for iPOS4808-Init
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

require ecmccfg 


##############################################################################
## Config hardware:

# - Note.. use the iPOS4808BX_VOLT jsutr here since it seems it works
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=5,HW_DESC=iPOS4808BX_VOLT"

# Download base config (parsed from Techosoft EasySetup configuration): Only needed first time a drive is used..
< ecmciPOS4808-EEPROM-BaseConfig-StepperOpenLoopCSV.cmd

# Apply hardware configuration
ecmcConfigOrDie "Cfg.EcApplyConfig(1)"

##############################################################################
############# Configure diagnostics:

# go active
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
