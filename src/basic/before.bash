#!/bin/bash

################################################################################
# Written by Martina Maggio
# This run script is part of the APRE development
################################################################################
## REMARKS and ASSUMPTIONS:
# This code is executed before the actual command and contains everything that
# is necessary to execute correctly.
################################################################################

#####
# Removing previous results if present
#####
rm -f APRE_cpu.txt
rm -f APRE_oprofile.txt
rm -f APRE_timed.txt

#####
# Oprofile part
#####
opcontrol --deinit
opcontrol --separate=kernel
opcontrol --init
opcontrol --reset
opcontrol --event=CPU_CLK_UNHALTED:100000 --event=INST_RETIRED:10000 --event=BR_INST_RETIRED:10000 --event=LLC_MISSES:100000 --event=LLC_REFS:100000
opcontrol --start --no-vmlinux
