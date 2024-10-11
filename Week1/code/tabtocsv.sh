#!/bin/sh -e
# Author: Kaiwen Li kl2621@imperial.ac.uk
# Script: tabtocsv.sh
# Desc: creates csv from a tab delimited file
# Arguments: 1
# Date: Oct 2024

[ ! -f $1 ] && echo "Error: $1 is not a valid file" && exit 1 #check for 1 existing

#====================================================================================================================

BASEFILE_EXT="$(basename "$1")" #gets the file name e.g. test.txt
FILENAME="${BASEFILE_EXT%.*}" #removes the extension

#====================================================================================================================


echo "Creating a comma delimited version of $BASEFILE_EXT..."
cat $1 | tr -s "\t" "," > ../results/$FILENAME.csv #creates the csv version of the file
echo "Done!"
exit

#====================================================================================================================


