
## ##############################################################
##
##	Title		: Compilation and simulation
##
##	Developers	: Jens Sparsø and Rasmus Bo Sørensen
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

add wave -label clk /testbench/clk
add wave -label reset /testbench/reset
add wave -label AB -radix unsigned /testbench/AB
add wave -label req /testbench/req
add wave -label C -radix unsigned /testbench/C
add wave -label ack /testbench/ack

run 1100ns

# WaveRestoreZoom changes the wave view to show the simulated time
WaveRestoreZoom {0 ns} {1100 ns}

