#
# Windows:
#   1. Download and install GtkWave:
#        https://sourceforge.net/projects/gtkwave/
#   2. Download and install ghdl-0.29.1
#        http://ghdl.free.fr/ghdl-installer-0.29.1.exe
#        http://ghdl.free.fr/site/pmwiki.php?n=Main.Download
#   3. In this file:
#        -- set the TOP_ENTITY according to your testbench
#        -- set path to gtkwave (Windows GTK parameter) 
#        -- comment Linux GTK
#   4. Open Git Bash terminal and run this script:
#        sh RUN.sh
#
# Linux:
#   1. Download and install everything:
#        sudo apt-get install ghdl gtkwave
#   2. In this file:
#        -- set the TOP_ENTITY according to your testbench
#        -- comment Windows GTK parameter
#        -- uncomment Linux GTK parameter
#   3. Open any terminal and run this script:
#        sh RUN.sh
#


##############################################################
## Change top entity you want to simulate and GtkWave path
##############################################################

TOP_ENTITY=demorgan_tb

# For Windows
# GTK=C:/APPZ/VHDL/gtkwave/bin

# For Linux and macOS
GTK=/usr/bin


##############################################################
## You should not change anything below here
##############################################################
##
## Script inspired by EDA Playground
##   - VHDL-2002 standard selected
##   - Supply an IEEE library containing only packages defined 
##     by IEEE standard
##

ghdl -i --std=02 --ieee=standard *.vhd &&
	ghdl -m $TOP_ENTITY && 
	ghdl -r $TOP_ENTITY --stop-time=800ns --vcd=dump.vcd &&
        # Modify input file dump.vcd, search (s) and replace 
	# all occurences (g) of characters '^U'-->'X', '^-'-->'X', etc.
#	sed -i 's/^U/X/g; s/^-/X/g; s/^H/1/g; s/^L/0/g' dump.vcd && 
	$GTK/gtkwave dump.vcd

# To clean
rm -f dump.vcd *.cf *.o $TOP_ENTITY
