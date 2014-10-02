
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
add wave -label ack /testbench/ack
add wave -label C -radix unsigned /testbench/C
add wave -label state /testbench/GCD_module/u1/fsm_comp/state
add wave -label fn -radix unsigned /testbench/GCD_module/u1/datapath_comp/fn 
add wave -label ABorALU /testbench/GCD_module/u1/datapath_comp/ABorALU 
add wave -label LDA /testbench/GCD_module/u1/datapath_comp/LDA
add wave -label LDB /testbench/GCD_module/u1/datapath_comp/LDB
add wave -label Z /testbench/GCD_module/u1/datapath_comp/Z
add wave -label N /testbench/GCD_module/u1/datapath_comp/N
add wave -label C_ready /testbench/GCD_module/u1/datapath_comp/C_ready
run 1100ns

# WaveRestoreZoom changes the wave view to show the simulated time
WaveRestoreZoom {0 ns} {1100 ns}

