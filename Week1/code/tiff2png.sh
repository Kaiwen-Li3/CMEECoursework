#!/bin/bash -e
# Author: Kaiwen Li kl2621@imperial.ac.uk
# Script: tiff2png.sh
# Desc: converts  .tifs to .pngs
# Arguments: none
# Date: Oct 2024

if ls *.tif 1> /dev/null 2>&1; then
    for f in *.tif; 
        do  
            echo "Converting $f"; 
            convert "$f"  "$(basename "$f" .tif).png"; 
        done
else
    echo "No .tif files found."
fi