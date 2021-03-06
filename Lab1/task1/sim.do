## ##############################################################
##
##	Title		: Setting up the waves in simulation
##
##	Developers	: Jens Spars� and Rasmus Bo S�rensen
##
##	Revision	: 02203 fall 2012 v.2
##
## This script is meant for setting up the simulation
## of the project
#################################################################

# add wave will add the waves to the wave view
# To change the name of the waves in the wave view use the -label option
# Example:
# add wave -label clk /testbench/clk
add wave /testbench/clk
add wave /testbench/reset
add wave /testbench/AB
add wave /testbench/req
add wave /testbench/C
add wave /testbench/ack

run 1100ns

# WaveRestoreZoom changes the wave view to show the simulated time
WaveRestoreZoom {0 ns} {1100 ns}

