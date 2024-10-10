#!/bin/bash -e
# Author: Kaiwen Li kl2621@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: merges two files into a third one
# Arguments: none
# Date: Oct 2024

#============================================================================================================================================

[ $# -ne 3 ] && echo "Invalid number of arguments provided. 3 arguments should be provided: <file1> <file2> <outputfile.txt>". && exit 1 #check for 3 arguments
[ ! -f $1 ] && echo "Error: $1 is not a valid file" && exit 1 #check for 1 existing
[ ! -f $2 ] && echo "Error: $2 is not a valid file" && exit 1 #check for 2 existing

[ ! -d "$(dirname "$3")" ] && echo "Error: $3 is not a valid directory" && exit 1 #check if 3 is a valid directory (will not check if the created file name exists)

[[ "$3" != *.txt ]] && echo "Error: $3 does not end in .txt" && exit 1 #check 3 ends in .txt


#============================================================================================================================================

echo "Merging $1 and $2 into $3..."
cat $1 > $3 #merge 1 and 2
cat $2 >> $3
echo "Merged File is:"
cat $3
exit

#============================================================================================================================================
