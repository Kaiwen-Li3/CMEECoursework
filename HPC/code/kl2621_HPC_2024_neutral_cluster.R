# Debugging messages added
rm(list=ls())
graphics.off()
source("kl2621_HPC_2024_main.R")

# Debugging: Check if script is running
print("Script started")

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
#iter <- 1
set.seed(iter)

if (iter <= 25) {
  size = 500
} else if (iter > 25 && iter <= 50) {
  size = 1000
} else if (iter > 50 && iter <= 75) {
  size = 2500
} else {
  size = 5000
}

output <- paste("neutral_output_", iter, ".rda", sep="")
print(paste("Output file:", output))

# Run the function and check if it completes
neutral_cluster_run(0.004285, size, 5, 1, size/10, 8*size, output)

# Check if file was created
if (file.exists(output)) {
  print(paste("File created successfully:", output))
} else {
  print("ERROR: File was not created!")
}

ls()
