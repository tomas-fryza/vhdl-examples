GHDL_FLAGS = --std=08 --work=work

make:
	ghdl -a $(GHDL_FLAGS) i2c.vhd tb/i2c_tb.vhd
	ghdl -e $(GHDL_FLAGS) i2c_tb

output.vcd: make
	ghdl -r $(GHDL_FLAGS) i2c_tb --vcd=$@

sim: output.vcd

gtkwave: output.vcd
	gtkwave $<
