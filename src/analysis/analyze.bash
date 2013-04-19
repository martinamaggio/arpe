#!/bin/bash

################################################################################
# Written by Martina Maggio
# This run script is part of the APRE development
################################################################################

PATH_TO_RESULTS=$1

if [ -d $PATH_TO_RESULTS ]; 
then
  # save all the time results in times.txt
  cat $PATH_TO_RESULTS/*/*/APRE_timed.txt > timed.txt
  python exectime.py # expect the file timed.txt to be there
else
  echo "[ERROR] The provided result directory does not exist"
  echo "        usage: ./analyze.bash <results_dir>"
fi

