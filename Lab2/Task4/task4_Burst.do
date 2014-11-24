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
vcom -quiet memory_Burst.vhd
vcom -quiet bram_tdp.vhd
vcom -quiet accScanline_Burst.vhd
vcom -quiet test4_Burst.vhd


# The -quiet option disables output from the vcom command
# that is not error or warning messages.

################################################################
# The vsim command starts the testbench design unit and runs
# the simulation

vsim testbench

add wave -label reset /testbench/reset
add wave -label start /testbench/start

add wave -label clk /testbench/clk
add wave -label addr -radix unsigned /testbench/addr
add wave -label state /testbench/Accelerator/state

#add wave -label latencyCount_reg -radix unsigned /testbench/Accelerator/latencyCount_reg
add wave -label firstRow /testbench/Accelerator/firstRow
add wave -label lastRow /testbench/Accelerator/lastRow

add wave -label col_reg -radix unsigned /testbench/Accelerator/col_reg
add wave -label scan0ptr_reg -radix unsigned /testbench/Accelerator/scan0ptr_reg
add wave -label scan1ptr_reg -radix unsigned /testbench/Accelerator/scan1ptr_reg
add wave -label out_addr -radix unsigned /testbench/Accelerator/out_addr

add wave -label scanLineBuffer/mem -radix hexadecimal /testbench/Accelerator/scanLineBuffer/mem
add wave -label OutputBuffer/mem -radix hexadecimal /testbench/Accelerator/OutputBuffer/mem
add wave -label out_din -radix hexadecimal /testbench/Accelerator/out_din

add wave -label pix_reg -radix hexadecimal /testbench/Accelerator/pix_reg

add wave -label a_dout -radix hexadecimal /testbench/Accelerator/a_dout
add wave -label b_dout -radix hexadecimal /testbench/Accelerator/b_dout
add wave -label dataR_reg -radix hexadecimal /testbench/Accelerator/dataR_reg
add wave -label dataR -radix hexadecimal /testbench/Accelerator/dataR

add wave -label out_dout -radix hexadecimal /testbench/Accelerator/out_dout
add wave -label dataW -radix hexadecimal /testbench/Accelerator/dataW

add wave -label memory/dataR -radix hexadecimal /testbench/memory/dataR

run 20000 ns

################################################################