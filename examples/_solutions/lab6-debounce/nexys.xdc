# =================================================
# Nexys A7-50T - General Constraints File
# Based on https://github.com/Digilent/digilent-xdc
# =================================================

# -----------------------------------------------
# Clock
# -----------------------------------------------
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports {clk}];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];

# -----------------------------------------------
# Push buttons
# -----------------------------------------------
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports {btnu}];
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports {btnd}];

# -----------------------------------------------
# LEDs
# -----------------------------------------------
set_property PACKAGE_PIN H17 [get_ports {led[0]}];
set_property PACKAGE_PIN K15 [get_ports {led[1]}];
set_property PACKAGE_PIN J13 [get_ports {led[2]}];
set_property PACKAGE_PIN N14 [get_ports {led[3]}];
set_property PACKAGE_PIN R18 [get_ports {led[4]}];
set_property PACKAGE_PIN V17 [get_ports {led[5]}];
set_property PACKAGE_PIN U17 [get_ports {led[6]}];
set_property PACKAGE_PIN U16 [get_ports {led[7]}];
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# -----------------------------------------------
# RGB LEDs
# -----------------------------------------------
set_property -dict { PACKAGE_PIN R12 IOSTANDARD LVCMOS33 } [get_ports {led16_b}];
