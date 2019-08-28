include /ioc/tools/driver.makefile

MODULE=ECMC_config

BUILDCLASSES = Linux
EXCLUDE_VERSIONS=3
ARCH_FILTER=RHEL%

SCRIPTS+=startup.cmd
SCRIPTS+=scripts/addMaster.cmd
SCRIPTS+=scripts/addSlave.cmd
SCRIPTS+=scripts/configureSlave.cmd
SCRIPTS+=scripts/applyConfig.cmd
SCRIPTS+=scripts/setAppMode.cmd
SCRIPTS+=scripts/addAxis.cmd
SCRIPTS+=scripts/addVirtualAxis.cmd
SCRIPTS+=scripts/configureAxis.cmd
SCRIPTS+=scripts/configureVirtualAxis.cmd
SCRIPTS+=scripts/applyAxisSynchronization.cmd
SCRIPTS+=scripts/loadPLCFile.cmd

SCRIPTS+=$(wildcard ./general/*)
SCRIPTS+=$(wildcard ./hardware/*.cmd)
SCRIPTS+=$(wildcard ./hardware/technosoft/*.cmd)
SCRIPTS+=$(wildcard ./motion/*)
SCRIPTS+=$(wildcard ./protocol/*)

TEMPLATES+=$(wildcard ./db/*)
