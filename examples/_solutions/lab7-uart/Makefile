# ===============================================
# Simple Makefile for GHDL + GTKWave
# ===============================================

# Simulator and tools
GHDL    = ghdl
GTKWAVE = gtkwave

# Top-level testbench entity
TOP     = uart_tx_tb

# Waveform file
VCD     = uart_tx.vcd

# VHDL source files
SRCS    = uart_tx.vhd uart_tx_tb.vhd

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
