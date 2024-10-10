#!/bin/sh -e
# Author: Kaiwen Li kl2621@imperial.ac.uk
# Script: csvtospace.sh
# Desc: creates a space separated values file from a csv file
# Arguments: 1
# Date: Oct 2024

[ ! -f $1 ] && echo "Error: $1 is not a valid file or directory" && exit 1 #check for 1 existing
[[ "$1" != *.csv ]] && echo "Error: $1 does not end in .csv" && exit 1 #check 1 ends in .csv

#====================================================================================================================

BASEFILE_EXT="$(basename "$1")" #gets the file name e.g. 1800.csv
FILENAME="${BASEFILE_EXT%.*}" #removes the extension

#====================================================================================================================

echo "Creating a space separated values version of $BASEFILE_EXT..."
cat $1 | tr -s "," " " > ../results/$FILENAME.ssv #creates the ssv file, with spaces instead of commas
echo "Done!"
exit

#====================================================================================================================