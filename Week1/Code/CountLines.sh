#!/bin/bash

NumLines=`wc -l < $1`
# < redirects contents of the file to the standard input of the command wc -l
echo "The file $1 has $NumLines lines"
echo