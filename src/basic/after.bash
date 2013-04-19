#!/bin/bash

################################################################################
# Written by Martina Maggio
# This run script is part of the APRE development
################################################################################
## REMARKS and ASSUMPTIONS:
# 1. In this file the command that was executed is assumed to be present
#    in the environment as the variable $CMD_EXECUTED, which is coherent
#    with the tool generation script.
# 2. The parameter string is assumed to be present as $PAR_SPACED
# 3. The script assumes that there is a file called 'timed' in the current
#    directory, containing the information retreived by the time command
## OUTCOMES:
# 1. File APRE_cpu.txt
# 2. File APRE_oprofile.txt
# 3. File APRE_timed.txt
################################################################################

#####
# Getting the PID of the process that is under execution
#####
PID_EXECUTED=`ps aux | grep "$CMD_EXECUTED" | grep -v "grep" | awk '{print $2}'`

#####
# Calling pidstat to get cpu consumption statistics
#####
SECONDS=1
pidstat $SECONDS -p $PID_EXECUTED >> APRE_cpu.txt

#####
# Wait for termination of the process if necessary - means writing timed
# This could be done with a huge amount of different techniques, one may be
# wait for $PID_EXECUTED. However, waiting for the file to be written allows
# to handle situations in which a process spawns some other processes and than
# does not wait or similar. The writing of timed is controlled directly by the
# framework invocation so it should be safer.
#####
while [ ! -f ./timed ] || [ ! -s ./timed ]
do
  sleep 1
done

#####
# Oprofile part
#####
COMMAND_BASE=`echo ${CMD_EXECUTED} | awk '{print $1}'`
opcontrol --stop
opreport -l `which "${COMMAND_BASE}"` > APRE_oprofile.txt

#####
# Time parsing part
#####
REAL=`head -n1 timed`
USER=`head -n2 timed | tail -n1`
SYSTEM=`tail -n1 timed`
rm -f timed
echo $REAL $USER $SYSTEM $PAR_SPACED > APRE_timed.txt
