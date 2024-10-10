#!/bin/bash -e
# Author: Kaiwen Li kl2621@imperial.ac.uk
# Script: CountLines.sh
# Desc: counts the number of lines in a file
# Arguments: none
# Date: Oct 2024

NumLines=`wc -l < $1`
# < redirects contents of the file to the standard input of the command wc -l
echo "The file $1 has $NumLines line(s)"
exit