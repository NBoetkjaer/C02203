## ##############################################################
##
##	Title		: Compilation and simulation
##
##	Developers	: Jens Sparsø and Rasmus Bo Sørensen
##
##	Revision	: 02203 fall 2012 v.2
##
## This script is meant for compiling the files in the project
## and starting the simulation
#################################################################

# The vlib command creates the work library
#rm -rf work
vlib work

# When the work library is already created the vlib command
# gives a warning, that is OK.

################################################################
# The order of the vcom statements is important, the hierachy
# should be compiled bottom-up.
# The top most entity should be compiled last.
# And the components that do not instantiate other components
# should be compiled first.
################################################################

vcom -quiet types.vhd
vcom -quiet clock.vhd
vcom -quiet memory2.vhd
vcom -quiet acc2.vhd
vcom -quiet test2.vhd


# The -quiet option disables output from the vcom command
# that is not error or warning messages.

################################################################
# The vsim command starts the testbench design unit and runs
# the simulation

vsim testbench

add wave -label reset /testbench/reset
add wave -label clk /testbench/clk
add wave -label start /testbench/start
add wave -label addr -radix unsigned /testbench/addr
add wave -label state /testbench/Accelerator/state

add wave -label firstRow /testbench/Accelerator/firstRow
add wave -label lastRow /testbench/Accelerator/lastRow
add wave -label firstColumnR /testbench/Accelerator/firstColumnR
add wave -label firstColumnW /testbench/Accelerator/firstColumnW
add wave -label lastColumnW /testbench/Accelerator/lastColumnW

add wave -label pix_reg /testbench/Accelerator/pix_reg
add wave -label dataR /testbench/Accelerator/dataR
add wave -label dataW /testbench/Accelerator/dataW

run 2000 ns

################################################################