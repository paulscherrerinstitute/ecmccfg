include /ioc/tools/driver.makefile

MODULE=ecmccfg

LIBVERSION = 6.2.0

BUILDCLASSES = Linux
EXCLUDE_VERSIONS=3
ARCH_FILTER=RHEL%

SCRIPTS+=startup.cmd

SCRIPTS+=$(wildcard ./scripts/*)
SCRIPTS+=$(wildcard ./general/*)
SCRIPTS+=$(wildcard ./hardware/*/*.cmd)
SCRIPTS+=$(wildcard ./motion/*)
SCRIPTS+=$(wildcard ./protocol/*)

TEMPLATES+=$(wildcard ./db/*.db)
TEMPLATES+=$(wildcard ./db/*.template)
TEMPLATES+=$(wildcard ./db/*.substitutions)
TEMPLATES+=$(wildcard ./db/*.subs)
TEMPLATES+=$(wildcard ./db/*/*.db)
TEMPLATES+=$(wildcard ./db/*/*.template)
TEMPLATES+=$(wildcard ./db/*/*.substitutions)
TEMPLATES+=$(wildcard ./db/*/*.subs)
