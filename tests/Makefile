# ------------------------------------------------------------------
# Makefile for Cocotb Simulation with optional waveform generation
# ------------------------------------------------------------------

# Simulator
SIM ?= icarus

# Top-level language
TOPLEVEL_LANG ?= verilog

# Verilog sources
VERILOG_SOURCES += $(PWD)/hdl/dut_sum.v

# Top-level DUT module
TOPLEVEL = dut_sum

# Cocotb test module (without .py)
# Since the testbench is in tests/, import as a Python package
MODULE = tests.tests_dut_sum

# Optional waveform generation (0 = off, 1 = on)
WAVEFORM ?= 0
ifeq ($(WAVEFORM),1)
	export COCOTB_WAVES = 1
endif

# Target: run DUT simulation
dut:
	rm -rf sim_build
	$(MAKE) sim MODULE=$(MODULE) TOPLEVEL=$(TOPLEVEL)

# Optional clean target
clean:
	rm -rf sim_build results.xml *.vcd

# Include Cocotb makefiles
include $(shell cocotb-config --makefiles)/Makefile.sim

