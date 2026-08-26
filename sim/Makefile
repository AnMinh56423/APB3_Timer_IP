##################################################################################################
# Makefile for APB3 Timer RTL and directed verification
##################################################################################################

TESTNAME        ?= register_chk
TB_NAME         ?= test_bench
RADIX           ?= decimal
REGRESS_LIST    ?= pat.list
COV_REGRESS_LIST ?= $(shell sed '/^[[:space:]]*#/d; /^[[:space:]]*$$/d' $(REGRESS_LIST))

LOG_DIR         ?= log
WAVEFORM        ?= vsim.wlf
COVERAGE        ?= bcesft
COV_DIR         ?= coverage
COV_DB          ?= APB3_TIMER_IP.ucdb
COV_REPORT      ?= $(COV_DIR)/summary_report.txt
COV_DETAIL      ?= $(COV_DIR)/detail_report.txt
UCDB_INPUTS     ?= $(filter-out $(COV_DB),$(wildcard *.ucdb))

.PHONY: all all_wave all_cov build build_cov run run_cov wave all_testcase all_testcase_cov gen_cov gen_html view_cov drc clean clean_cov help

all: clean build run

all_wave: clean build run wave

all_cov: build_cov run_cov

drc:
	verilator --lint-only -Wall -f rtl.f

build:
	mkdir -p $(LOG_DIR)
	rm -rf work
	cp -f ../testcases/$(TESTNAME).v run_test.v
	vlib work
	vmap work work
	vlog -f compile.f | tee compile.log

build_cov:
	mkdir -p $(LOG_DIR)
	rm -rf work
	cp -f ../testcases/$(TESTNAME).v run_test.v
	vlib work
	vmap work work
	vlog +cover=$(COVERAGE) -f compile.f | tee compile_cov.log

run:
	mkdir -p $(LOG_DIR)
	vsim -debugDB -wlf $(WAVEFORM) -l $(LOG_DIR)/$(TESTNAME).log -voptargs=+acc -assertdebug -c $(TB_NAME) -do "log -r /*; run -all; quit -f"
	cp -f $(LOG_DIR)/$(TESTNAME).log sim.log

run_cov:
	mkdir -p $(LOG_DIR)
	vsim -coverage -debugDB -wlf $(WAVEFORM) -l $(LOG_DIR)/$(TESTNAME)_cov.log -voptargs="+acc +cover=$(COVERAGE)" -assertdebug -c $(TB_NAME) -do "coverage exclude -du $(TB_NAME); coverage save -onexit $(TESTNAME).ucdb; log -r /*; run -all; quit -f"
	cp -f $(LOG_DIR)/$(TESTNAME)_cov.log sim_cov.log

wave:
	@test -f $(WAVEFORM) || (echo "Missing $(WAVEFORM). Run 'make all_wave TESTNAME=$(TESTNAME)' first."; exit 1)
	vsim -gui -view $(WAVEFORM) -do "add wave -r /$(TB_NAME)/*; radix -$(RADIX)" &

all_testcase:
	@for test in `sed '/^[[:space:]]*#/d; /^[[:space:]]*$$/d' $(REGRESS_LIST)`; do \
		$(MAKE) all TESTNAME=$$test || exit $$?; \
	done

all_testcase_cov: clean_cov
	@for test in $(COV_REGRESS_LIST); do \
		$(MAKE) all_cov TESTNAME=$$test || exit $$?; \
	done

gen_cov:
	@test -n "$(UCDB_INPUTS)" || (echo "No testcase UCDB files found. Run 'make all_testcase_cov' first."; exit 1)
	mkdir -p $(COV_DIR)
	rm -f $(COV_DB)
	vcover merge -ignoredusig $(COV_DB) $(UCDB_INPUTS)
	vcover report $(COV_DB) -output $(COV_REPORT)
	vcover report -zeros -details -code $(COVERAGE) -annotate -All -codeAll $(COV_DB) -output $(COV_DETAIL)

gen_html:
	@test -f $(COV_DB) || (echo "Missing $(COV_DB). Run 'make gen_cov' first."; exit 1)
	mkdir -p $(COV_DIR)
	vcover report -zeros -details -code $(COVERAGE) -annotate -testhitdataAll -html $(COV_DB)

view_cov:
	@test -f $(COV_DB) || (echo "Missing $(COV_DB). Run 'make gen_cov' first."; exit 1)
	vsim -gui -viewcov $(COV_DB) &

clean_cov:
	rm -rf $(COV_DIR)
	rm -f *.ucdb

# ============================================================
# Clean generated files before pushing project to GitHub
# ============================================================
clean_git:
	@echo "=========================================="
	@echo " Cleaning generated files for GitHub..."
	@echo "=========================================="

	rm -rf work
	rm -rf log
	rm -rf coverage
	rm -rf covhtmlreport
	rm -rf vsim.dbg
	rm -rf transcript
	rm -rf top.json
	rm -rf run_test.v

	rm -f *.wlf
	rm -f *.ucdb
	rm -f *.log

	# Remove Windows Zone.Identifier files
	find . -name '*:Zone.Identifier' -delete

	@echo "=========================================="
	@echo " Project is clean for GitHub!"
	@echo "=========================================="


clean:
	rm -rf work
	rm -rf vsim.dbg
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript
	rm -rf top.json
	rm -rf run_test.v
	$(MAKE) clean_cov

help:
	@echo ""
	@echo "****************************************"
	@echo "** make clean              : clean simulation and coverage data"
	@echo "** make build              : compile one testcase"
	@echo "** make build_cov          : compile with code coverage"
	@echo "** make run TESTNAME=name  : run one testcase"
	@echo "** make run_cov TESTNAME=name : run one testcase with coverage"
	@echo "** make all TESTNAME=name  : clean, build, and run"
	@echo "** make all_wave TESTNAME=name : run and open waveform"
	@echo "** make all_cov TESTNAME=name : build and run with coverage"
	@echo "** make all_testcase       : run every directed testcase"
	@echo "** make all_testcase_cov   : collect UCDB for all testcases"
	@echo "** make gen_cov            : merge UCDB and generate text reports"
	@echo "** make gen_html           : generate HTML coverage report"
	@echo "** make view_cov           : open merged coverage database"
	@echo "** make wave               : open latest waveform"
	@echo "****************************************"
	@echo ""
