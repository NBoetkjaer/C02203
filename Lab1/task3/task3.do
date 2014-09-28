################################################################
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

vcom -quiet clock.vhd
vcom -quiet debounce_entity.vhd
vcom -quiet debounce_sim.vhd
vcom -quiet gcd_optim.vhd
vcom -quiet gcd_entity.vhd
vcom -quiet gcd_sys.vhd
vcom -quiet env.vhd
vcom -quiet test.vhd

# The -quiet option disables output from the vcom command
# that is not error or warning messages.

################################################################
# The vsim command starts the testbench design unit and runs
# the sim.do to set up the simulation

vsim -do sim.do testbench

################################################################