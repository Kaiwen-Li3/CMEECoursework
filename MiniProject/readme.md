# Kaiwen Li Miniproject: Fitting models to empirical data

## Overview
This miniproject is about fitting a linear model, and a nonlinear model (gompertz in this case) to empirical data; a collection of bacterial growth data from experiments across the globe
The goal is to see which approach fits the dataset better.
In addition, whether being in an artifical or natural medium impacts the extent to which one model fits better is also examined.

## Workflow
The miniproject uses a shell script; "run_miniproject.sh" to execute the workflow in sequence

1. **DataPreparation.R**
- This R script cleans the data ("../Data/LogisticGrowthData.csv"), removing missing or problematic values, before then assigning a numeric ID to experiments based on their unique species/medium/temperature/citation combination
- Then, the resultant data is saved as ("../Data/LogisticGrowthDataMod.csv").

2. **Model_Fitting_Analysis.R**
- This R script fits a lm and gompertz model to the modified data
- It goes through each ID and compares the model performance using AIC and BIC, in each case seeing which model "wins" (has lower AIC and / or BIC)
- In addition, the growth media are categorised, and artifical vs natural medium is taken into account
- The results of the comparison are saved as ("../Results/lm_vs_gompertz_summary.csv")



## Prerequisites
This miniproject makes use of the following R packages:
- **ggplot2** for plotting data
- **minpack.lm** for its nlslm() function