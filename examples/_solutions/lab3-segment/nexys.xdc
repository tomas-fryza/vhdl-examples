# =================================================
# Nexys A7-50T - Minimal constrains for hex display
# Based on Digilent Nexys-A7-50T-Master.xdc
# =================================================

# -----------------------------------------------
# Slide switches (Right side)
# SW_R[3:0]
# -----------------------------------------------
set_property PACKAGE_PIN J15 [get_ports {sw_r[0]}] ; # SW_0
set_property PACKAGE_PIN L16 [get_ports {sw_r[1]}] ; # SW_1
set_property PACKAGE_PIN M13 [get_ports {sw_r[2]}] ; # SW_2
set_property PACKAGE_PIN R15 [get_ports {sw_r[3]}] ; # SW_3
set_property IOSTANDARD LVCMOS33 [get_ports {sw_r[*]}]

# -----------------------------------------------
# Slide switches (Left side)
# SW_L[3:0]
# -----------------------------------------------
set_property PACKAGE_PIN H6  [get_ports {sw_l[0]}] ; # SW_12
set_property PACKAGE_PIN U12 [get_ports {sw_l[1]}] ; # SW_13
set_property PACKAGE_PIN U11 [get_ports {sw_l[2]}] ; # SW_14
set_property PACKAGE_PIN V10 [get_ports {sw_l[3]}] ; # SW_15
set_property IOSTANDARD LVCMOS33 [get_ports {sw_l[*]}]

# -----------------------------------------------
# LEDs (Right side)
# LED_R[3:0]
# -----------------------------------------------
set_property PACKAGE_PIN H17 [get_ports {led_r[0]}] ; # LED_0
set_property PACKAGE_PIN K15 [get_ports {led_r[1]}] ; # LED_1
set_property PACKAGE_PIN J13 [get_ports {led_r[2]}] ; # LED_2
set_property PACKAGE_PIN N14 [get_ports {led_r[3]}] ; # LED_3
set_property IOSTANDARD LVCMOS33 [get_ports {led_r[*]}]

# -----------------------------------------------
# LEDs (Left side)
# LED_L[3:0]
# -----------------------------------------------
set_property PACKAGE_PIN V15 [get_ports {led_l[0]}] ; # LED_12
set_property PACKAGE_PIN V14 [get_ports {led_l[1]}] ; # LED_13
set_property PACKAGE_PIN V12 [get_ports {led_l[2]}] ; # LED_14
set_property PACKAGE_PIN V11 [get_ports {led_l[3]}] ; # LED_15
set_property IOSTANDARD LVCMOS33 [get_ports {led_l[*]}]

# -----------------------------------------------
# Seven-segment cathodes CA..CG + DP (active-low)
# seg[6]=A ... seg[0]=G
# -----------------------------------------------
set_property PACKAGE_PIN T10 [get_ports {seg[6]}] ; # CA
set_property PACKAGE_PIN R10 [get_ports {seg[5]}] ; # CB
set_property PACKAGE_PIN K16 [get_ports {seg[4]}] ; # CC
set_property PACKAGE_PIN K13 [get_ports {seg[3]}] ; # CD
set_property PACKAGE_PIN P15 [get_ports {seg[2]}] ; # CE
set_property PACKAGE_PIN T11 [get_ports {seg[1]}] ; # CF
set_property PACKAGE_PIN L18 [get_ports {seg[0]}] ; # CG
set_property PACKAGE_PIN H15 [get_ports {dp}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*] dp}]

# -----------------------------------------------
# Seven-segment anodes AN7..AN0 (active-low)
# -----------------------------------------------
set_property PACKAGE_PIN J17 [get_ports {an[0]}]
set_property PACKAGE_PIN J18 [get_ports {an[1]}]
set_property PACKAGE_PIN T9  [get_ports {an[2]}]
set_property PACKAGE_PIN J14 [get_ports {an[3]}]
set_property PACKAGE_PIN P14 [get_ports {an[4]}]
set_property PACKAGE_PIN T14 [get_ports {an[5]}]
set_property PACKAGE_PIN K2  [get_ports {an[6]}]
set_property PACKAGE_PIN U13 [get_ports {an[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

# -----------------------------------------------
# Push button
# -----------------------------------------------
set_property PACKAGE_PIN P18 [get_ports {btnd}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnd}]
