SHELL := /bin/bash

SIM_DIR := sim
TEST ?= register_chk
VERIBLE_LINT ?= verible-verilog-lint
VERILATOR ?= verilator

-include env/local.env

ifneq ($(strip $(QUESTA_HOME)),)
export PATH := $(QUESTA_HOME)/bin:$(PATH)
endif
export QUESTA_HOME
export LM_LICENSE_FILE
export SALT_LICENSE_SERVER

RTL_SOURCES := $(shell find rtl -type f \( -name '*.v' -o -name '*.sv' \) | sort)
DV_SOURCES := $(shell find tb testcases -type f \( -name '*.v' -o -name '*.sv' \) | sort)

.PHONY: help doctor fmt-check lint lint-verible lint-verilator compile test regress coverage wave clean

help:
	@echo "APB3 Timer project commands"
	@echo "  make doctor                 Check local tool configuration"
	@echo "  make fmt-check              Check formatting without changing files"
	@echo "  make lint                   Run Verible and Verilator lint"
	@echo "  make compile TEST=name      Compile one directed testcase"
	@echo "  make test TEST=name         Compile and run one testcase"
	@echo "  make regress                Run all directed testcases"
	@echo "  make coverage               Run coverage regression and reports"
	@echo "  make wave TEST=name         Run one testcase and open its waveform"
	@echo "  make clean                  Remove generated simulation outputs"

doctor:
	@bash scripts/check_tools.sh

fmt-check:
	@command -v verible-verilog-format >/dev/null 2>&1 || { echo "ERROR: verible-verilog-format not found"; exit 127; }
	@verible-verilog-format --verify $(RTL_SOURCES) $(DV_SOURCES)

lint: lint-verible lint-verilator

lint-verible:
	@command -v $(VERIBLE_LINT) >/dev/null 2>&1 || { echo "ERROR: $(VERIBLE_LINT) not found"; exit 127; }
	@$(VERIBLE_LINT) $(RTL_SOURCES) $(DV_SOURCES)

lint-verilator:
	@command -v $(VERILATOR) >/dev/null 2>&1 || { echo "ERROR: $(VERILATOR) not found"; exit 127; }
	@$(MAKE) -C $(SIM_DIR) drc

compile:
	@$(MAKE) -C $(SIM_DIR) build TESTNAME=$(TEST)

test:
	@$(MAKE) -C $(SIM_DIR) all TESTNAME=$(TEST)

regress:
	@$(MAKE) -C $(SIM_DIR) all_testcase

coverage:
	@$(MAKE) -C $(SIM_DIR) clean
	@$(MAKE) -C $(SIM_DIR) all_testcase_cov
	@$(MAKE) -C $(SIM_DIR) gen_cov
	@$(MAKE) -C $(SIM_DIR) gen_html

wave:
	@$(MAKE) -C $(SIM_DIR) all_wave TESTNAME=$(TEST)

clean:
	@$(MAKE) -C $(SIM_DIR) clean_git
