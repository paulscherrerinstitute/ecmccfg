include /ioc/tools/sls_ioc.makefile

IOC_STARTUP_FILE := $(notdir $(firstword $(wildcard *_startup.script)))
IOC_PARAMS_FILE := $(notdir $(firstword $(wildcard *_parameters.yaml)))
IOC_NAME ?= $(patsubst %_startup.script,%,$(IOC_STARTUP_FILE))
ifeq ($(IOC_NAME),)
IOC_NAME := $(patsubst %_parameters.yaml,%,$(IOC_PARAMS_FILE))
endif

CPP_LOGIC_ROOT ?= $(abspath ../..)
PYTHON ?= python3
GENERATE_QT ?= 1
IOC_QT_PANEL := qt/$(IOC_NAME)_cpp_logic.ui
IOC_QTGEN := $(CPP_LOGIC_ROOT)/utils/cpp_logic_ioc_qtgen.py
IOC_SUBS_FILE := cfg/libmain.so_cpp_logic.subs

.PHONY: pvs ui

pvs:
	$(MAKE) -C src stage

ui: pvs
	if [ "$(GENERATE_QT)" = "1" ]; then $(PYTHON) $(IOC_QTGEN) --input $(IOC_SUBS_FILE) --output $(IOC_QT_PANEL) --pv-prefix "$(IOC_NAME):" --title "$(IOC_NAME) cpp_logic PVs"; fi
