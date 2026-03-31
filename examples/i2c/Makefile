# ===============================================
# Simple Makefile for GHDL + GTKWave
# ===============================================

# Simulator and tools
GHDL    = /opt/homebrew/bin/ghdl
GTKWAVE = gtkwave

# Top-level testbench entity
TOP     = simple_i2c_master_tb

# Waveform file
VCD     = simple_i2c_master.vcd

# VHDL source files
SRCS    = simple_i2c_master.vhd simple_i2c_master_tb.vhd

# Default target
all: sim

# Analyze, elaborate, and run simulation
sim: $(SRCS)
	$(GHDL) -a $(SRCS)
	$(GHDL) -e $(TOP)
	$(GHDL) -r $(TOP) --vcd=$(VCD)

# Open waveform in GTKWave
wave: sim
	$(GTKWAVE) $(VCD)

# Clean generated files
clean:
	rm -f *.o *.cf $(TOP) $(VCD)

# Help
help:
	@echo "make        - analyze, elaborate, and run simulation"
	@echo "make sim    - compile and run"
	@echo "make wave   - compile, run, and view waves"
	@echo "make clean  - remove generated files"
