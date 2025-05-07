include /ioc/tools/driver.makefile

MODULE=ecmccfg

BUILDCLASSES = Linux
EXCLUDE_VERSIONS = 3 7.0.5 7.0.6 7.0.7

ARCH_FILTER=deb10% deb12%

SCRIPTS+=startup.cmd

HW_DIR = hardware/

DIRS += ${HW_DIR}Beckhoff_1XXX
DIRS += ${HW_DIR}Beckhoff_2XXX
DIRS += ${HW_DIR}Beckhoff_3XXX
DIRS += ${HW_DIR}Beckhoff_4XXX
DIRS += ${HW_DIR}Beckhoff_5XXX
DIRS += ${HW_DIR}Beckhoff_6XXX
DIRS += ${HW_DIR}Beckhoff_7XXX
DIRS += ${HW_DIR}Beckhoff_9XXX

# all scripts in Beckhoff_*XXX/* ending with 'cmd'
SCRIPTS += $(foreach d,${DIRS}, $(wildcard $d/*/*.cmd))

SCRIPTS+=$(wildcard ./scripts/*)
SCRIPTS+=$(wildcard ./scripts/jinja2/*)
SCRIPTS+=$(wildcard ./scripts/jinja2/templates/*.jinja2)
SCRIPTS+=$(wildcard ./naming/*)
SCRIPTS+=$(wildcard ./general/*)
SCRIPTS+=$(wildcard ./hardware/*/*.cmd)
SCRIPTS+=$(wildcard ./motion/*)
SCRIPTS+=$(wildcard ./protocol/*)
SCRIPTS+=$(wildcard ./plc_lib/*.plc)
SCRIPTS+=$(wildcard ./plc_lib/*.plc_inc)
SCRIPTS+=$(wildcard ./plc_lib/master_slave/*.plc)
SCRIPTS+=$(wildcard ./plc_lib/master_slave/*.plc_inc)
SCRIPTS+=$(wildcard ./plc_lib/twinsafe/*.plc)
SCRIPTS+=$(wildcard ./plc_lib/twinsafe/*.plc_inc)

TEMPLATES+=$(wildcard ./db/*.db)
TEMPLATES+=$(wildcard ./db/*.template)
TEMPLATES+=$(wildcard ./db/*.substitutions)
TEMPLATES+=$(wildcard ./db/*.subs)
TEMPLATES+=$(wildcard ./db/*/*.db)
TEMPLATES+=$(wildcard ./db/*/*.template)
TEMPLATES+=$(wildcard ./db/*/*.substitutions)
TEMPLATES+=$(wildcard ./db/*/*.subs)

SOURCES += $(wildcard ./src/*.cpp)
DBDS    += $(wildcard ./dbd/*.dbd)
