include /ioc/tools/driver.makefile
MODULE = main
BUILDCLASSES = Linux
ARCH_FILTER = deb10% deb12%
EXCLUDE_VERSIONS+=3 7.0.5 7.0.6 7.0.7 7.0.8 7.0.9
USR_CXXFLAGS += -std=c++17
ecmc_VERSION = sandst_a
DIRS+=.
SOURCES += $(foreach d,${DIRS}, $(wildcard $d/*.c) $(wildcard $d/*.cpp))
HEADERS += $(foreach d,${DIRS}, $(wildcard $d/*.h))
HEADERS += $(foreach d,${DIRS}, $(wildcard $d/*.hpp))

CPP_LOGIC_ROOT ?= $(abspath ../../..)
PYTHON ?= python3
SUBSGEN := $(CPP_LOGIC_ROOT)/utils/ecmcCppLogicSourceSubstGen.py
STAGE_SUBS ?= ../cfg/lib$(MODULE).so_cpp_logic.subs
STAGE_DIR := $(dir $(STAGE_SUBS))
LOCAL_MODULE := $(notdir $(abspath ..))

.PHONY: stage

stage:
	mkdir -p $(STAGE_DIR); \
	$(PYTHON) $(SUBSGEN) --source main.cpp --logic-name "$(LOCAL_MODULE)" --output $(STAGE_SUBS)
