#!/bin/sh
# Author: Kaiwen Li kl2621@imperial.ac.uk
# Script: run_miniproject.sh
# Desc: Runs a workflow that first prepares the csv file ../Data/LogisticGrowthData.csv, saves a modified version ../Data/LogisticGrowthDataMod.csv, 
#then tries to fit a linear vs gompertz model to the modified data
#and creates a plot for every experiment in the dataset
# Arguments: none
# Date: Mar 2025


#Exit on error
set -e

#Defining r files
#Files should be in the same folder as this .sh
data_prep="DataPreparation.R"
model_fitter_analysis="Model_Fitting_Analysis.R"


install_r_packages() {
    Rscript -e 'packages <- c("ggplot2", "minpack.lm");
                missing <- packages[!(packages %in% installed.packages()[,"Package"])];
                if(length(missing)) install.packages(missing, repos="https://cloud.r-project.org/")'
}

# Install required R packages if not installed
echo "Checking and installing required R packages..."
install_r_packages



# Data preparation
echo "Preparing data:"
Rscript "$data_prep"

# Run Model Fitting and Analysis script
echo "Fitting lm vs gompertz, comparing and plotting:"
Rscript "$model_fitter_analysis"


#woohoo
echo "Complete!"
