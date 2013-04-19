#!/bin/bash

################################################################################
# Written by Martina Maggio
# This run script is part of the APRE development
################################################################################

# Copying old sources
rm -rf bin
mkdir bin
cp src/*.py bin
cp src/basic/*.bash bin
cp src/analysis/*.bash bin
cp src/analysis/*.py bin
chmod a+x bin/before.bash
chmod a+x bin/after.bash
chmod a+x bin/analyze.bash

# Run the configurator
cd bin
python generate.py
chmod a+x ./execute.bash
cd ..

# Output something for the user
echo "**********************************************************************"
echo "[DONE] now move to the bin directory and run ./execute.bash"
echo "       when your results are ready you can analyze the model with"
echo "       ./analyze.bash <path_to_results>"
echo "**********************************************************************"