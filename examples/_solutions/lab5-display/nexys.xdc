# =================================================
# Nexys A7-50T – General Constraints File
# Based on https://github.com/Digilent/digilent-xdc
# =================================================

# -----------------------------------------------
# Switches
# -----------------------------------------------
# set_property PACKAGE_PIN J15 [get_ports {sw[0]}]
# set_property PACKAGE_PIN L16 [get_ports {sw[1]}]
# set_property PACKAGE_PIN M13 [get_ports {sw[2]}]
# set_property PACKAGE_PIN R15 [get_ports {sw[3]}]
# set_property PACKAGE_PIN R17 [get_ports {sw[4]}]
# set_property PACKAGE_PIN T18 [get_ports {sw[5]}]
# set_property PACKAGE_PIN U18 [get_ports {sw[6]}]
# set_property PACKAGE_PIN R13 [get_ports {sw[7]}]
# set_property PACKAGE_PIN T8  [get_ports {sw[8]}]
# set_property PACKAGE_PIN U8  [get_ports {sw[9]}]
# set_property PACKAGE_PIN R16 [get_ports {sw[10]}]
# set_property PACKAGE_PIN T13 [get_ports {sw[11]}]
# set_property PACKAGE_PIN H6  [get_ports {sw[12]}]
# set_property PACKAGE_PIN U12 [get_ports {sw[13]}]
# set_property PACKAGE_PIN U11 [get_ports {sw[14]}]
# set_property PACKAGE_PIN V10 [get_ports {sw[15]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {sw[8] sw[9]}]

# -----------------------------------------------
# LEDs
# -----------------------------------------------
# set_property PACKAGE_PIN H17 [get_ports {led[0]}]
# set_property PACKAGE_PIN K15 [get_ports {led[1]}]
# set_property PACKAGE_PIN J13 [get_ports {led[2]}]
# set_property PACKAGE_PIN N14 [get_ports {led[3]}]
# set_property PACKAGE_PIN R18 [get_ports {led[4]}]
# set_property PACKAGE_PIN V17 [get_ports {led[5]}]
# set_property PACKAGE_PIN U17 [get_ports {led[6]}]
# set_property PACKAGE_PIN U16 [get_ports {led[7]}]
# set_property PACKAGE_PIN V16 [get_ports {led[8]}]
# set_property PACKAGE_PIN T15 [get_ports {led[9]}]
# set_property PACKAGE_PIN U14 [get_ports {led[10]}]
# set_property PACKAGE_PIN T16 [get_ports {led[11]}]
# set_property PACKAGE_PIN V15 [get_ports {led[12]}]
# set_property PACKAGE_PIN V14 [get_ports {led[13]}]
# set_property PACKAGE_PIN V12 [get_ports {led[14]}]
# set_property PACKAGE_PIN V11 [get_ports {led[15]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# -----------------------------------------------
# Seven-segment cathodes CA..CG + DP (active-low)
# -----------------------------------------------
# set_property PACKAGE_PIN T10 [get_ports {seg[6]}]
# set_property PACKAGE_PIN R10 [get_ports {seg[6]}]
# set_property PACKAGE_PIN K16 [get_ports {seg[6]}]
# set_property PACKAGE_PIN K13 [get_ports {seg[6]}]
# set_property PACKAGE_PIN P15 [get_ports {seg[6]}]
# set_property PACKAGE_PIN T11 [get_ports {seg[6]}]
# set_property PACKAGE_PIN L18 [get_ports {seg[6]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {seg[*] dp}]

# -----------------------------------------------
# Seven-segment anodes AN7..AN0 (active-low)
# -----------------------------------------------
# set_property PACKAGE_PIN J17 [get_ports {an[0]}]
# set_property PACKAGE_PIN J18 [get_ports {an[1]}]
# set_property PACKAGE_PIN T9  [get_ports {an[2]}]
# set_property PACKAGE_PIN J14 [get_ports {an[3]}]
# set_property PACKAGE_PIN P14 [get_ports {an[4]}]
# set_property PACKAGE_PIN T14 [get_ports {an[5]}]
# set_property PACKAGE_PIN K2  [get_ports {an[6]}]
# set_property PACKAGE_PIN U13 [get_ports {an[7]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

# -----------------------------------------------
# Push buttons
# -----------------------------------------------
# set_property PACKAGE_PIN N17 [get_ports {btnc}]
# set_property PACKAGE_PIN M18 [get_ports {btnu}]
# set_property PACKAGE_PIN P17 [get_ports {btnl}]
# set_property PACKAGE_PIN M17 [get_ports {btnr}]
# set_property PACKAGE_PIN P18 [get_ports {btnd}]
# set_property IOSTANDARD LVCMOS33 [get_ports {btnc btnu btnl btnr btnd}]

# -----------------------------------------------
# RGB LEDs
# -----------------------------------------------
# set_property PACKAGE_PIN N15 [get_ports {led16_r}]
# set_property PACKAGE_PIN M16 [get_ports {led16_g}]
# set_property PACKAGE_PIN R12 [get_ports {led16_b}]
# set_property PACKAGE_PIN N16 [get_ports {led17_r}]
# set_property PACKAGE_PIN R11 [get_ports {led17_g}]
# set_property PACKAGE_PIN G14 [get_ports {led17_b}]
# set_property IOSTANDARD LVCMOS33 [get_ports {led16_r led16_g led16_b led17_r led17_g led17_b}]

# -----------------------------------------------
# Clock
# -----------------------------------------------
# set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk100mhz }];
# create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk100mhz}];

# -----------------------------------------------
# USB-RS232 Interface
# -----------------------------------------------
# set_property -dict { PACKAGE_PIN C4 IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }];
# set_property -dict { PACKAGE_PIN D4 IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }];
# set_property -dict { PACKAGE_PIN D3 IOSTANDARD LVCMOS33 } [get_ports { uart_cts }];
# set_property -dict { PACKAGE_PIN E5 IOSTANDARD LVCMOS33 } [get_ports { uart_rts }];

# -----------------------------------------------
# Pmod Header JA
# -----------------------------------------------
# set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports { ja[1] }];
# set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { ja[2] }];
# set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports { ja[3] }];
# set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { ja[4] }];
# set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports { ja[7] }];
# set_property -dict { PACKAGE_PIN E17 IOSTANDARD LVCMOS33 } [get_ports { ja[8] }];
# set_property -dict { PACKAGE_PIN F18 IOSTANDARD LVCMOS33 } [get_ports { ja[9] }];
# set_property -dict { PACKAGE_PIN G18 IOSTANDARD LVCMOS33 } [get_ports { ja[10] }];

# -----------------------------------------------
# (Remaining peripherals preserved but omitted here for brevity)
# JB, JC, JD, XADC, VGA, SD, Ethernet, Audio, etc.
# Same conversion style applies:
#
# # set_property PACKAGE_PIN <PIN> [get_ports {<signal>}]
# # set_property IOSTANDARD LVCMOS33 [get_ports {...}]
#
# -----------------------------------------------
