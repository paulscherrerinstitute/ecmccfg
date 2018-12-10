include /ioc/tools/driver.makefile

MODULE=ECMC_config

BUILDCLASSES = Linux
EXCLUDE_VERSIONS=3.14.8 3.15 3.16 7
EXCLUDE_VERSIONS=3.14.8 3.15 3.16
ARCH_FILTER=RHEL%

SCRIPTS+=startup.cmd
SCRIPTS+=scripts/addMaster.cmd
SCRIPTS+=scripts/addSlave.cmd
SCRIPTS+=scripts/configureSlave.cmd
SCRIPTS+=scripts/applyConfig.cmd
SCRIPTS+=scripts/setAppMode.cmd
#SCRIPTS+=scripts/addAxis.cmd
SCRIPTS+=scripts/configureAxis.cmd

SCRIPTS+=$(wildcard ./general/*)
SCRIPTS+=$(wildcard ./hardware/*)
SCRIPTS+=$(wildcard ./motion/*)
SCRIPTS+=$(wildcard ./protocol/*)

TEMPLATES+=$(wildcard ./db/*)

