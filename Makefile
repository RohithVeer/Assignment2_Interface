# ------------------------------------------------------------------
# Makefile for Cocotb Simulation with waveform generation
# ------------------------------------------------------------------

# Simulator
SIM ?= icarus

# Top-level language
TOPLEVEL_LANG ?= verilog

# Verilog sources
VERILOG_SOURCES += $(PWD)/hdl/dut_sum.v

# Top-level DUT module
TOPLEVEL = dut_sum

# Cocotb test module
MODULE = tests.tests_dut_sum

# Enable waveform
export COCOTB_WAVES = 1

# ------------------------------------------------------------------
# Default target: run simulation
# ------------------------------------------------------------------
dut:
	@echo "Removing previous build..."
	rm -rf sim_build
	@echo "Running Cocotb simulation..."
	$(MAKE) sim MODULE=$(MODULE) TOPLEVEL=$(TOPLEVEL)
	@echo ""
	@echo "Simulation complete."
	@echo "Open GTKWave manually with:"
	@echo "  gtkwave sim_build/wave.vcd"

# Optional clean
distclean:
	rm -rf sim_build results.xml *.vcd

# Include Cocotb makefiles
include $(shell cocotb-config --makefiles)/Makefile.sim

