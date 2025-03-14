

growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
0.5, 0.4, 0.0, 0.0,
0.0, 0.4, 0.7, 0.0,
0.0, 0.0, 0.25, 0.4),
nrow=4, ncol=4, byrow=T)

reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
0.0, 0.0, 0.0, 0.0,
0.0, 0.0, 0.0, 0.0,
0.0, 0.0, 0.0, 0.0),
nrow=4, ncol=4, byrow=T)

clutch_distribution <- c(0.06,0.08,0.13,0.15,0.16,0.18,0.15,0.06,0.03)

#=========================================================================================
rm(list=ls())
graphics.off()
source("Demographic.R")
source("kl2621_HPC_2024_main.R")


###4 initial conditions

############################################################



#VVVVVVVVVVVV-------------COMMENT ME OUT WHEN RUNNING THE THING
#iter <- 5
#VVVVVVVVVVV--------------UNCOMMENT ME OUT
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
set.seed(iter)


if (iter <= 25) {
initial_state <- state_initialise_adult(4,100) #100 adults
} else if (iter >25 && iter <= 50) {
initial_state <- state_initialise_adult(4,10) #10 adults
} else if (iter >50 && iter <= 75) {
initial_state <- state_initialise_spread(4,100) #100 spread
} else {
initial_state <- state_initialise_spread(4,10) #10 spread
}

reslist <- list()

####100 cluster runs
###################################################
####150 runs of stochastic_simulation per cluster run
for (i in 1:150) {
    #################################
    ###120 steps of stochastic_simulation per simulation
    stochasticresult <- stochastic_simulation(initial_state,growth_matrix,reproduction_matrix,clutch_distribution,120)
    reslist[[i]] <- stochasticresult
    #################################
}
###################################################

print(reslist)
save(reslist, file=paste("output",iter,".rda",sep=""))


###############################################################


# Clear the workspace and turn off graphics.
# • Load all the functions you need by sourcing the provided demographic.R file
# • Read in the job number from the cluster. To do this, your code should include a new
# variable iter and should start with the line:
# iter <- as.numeric(Sys.getenv(“PBS_ARRAY_INDEX”))
# • Control the random number seeds so that each parallel simulation takes place with a
# different seed. Your function should therefore set the random number seed as iter so that
# each parallel simulation has a unique random seed.
# • In each parallel run, select the initial condition to be used. Ensure that 25 of the parallel
# simulations are allocated to each of the initial conditions.
# • Create a variable which is the filename to store your results. The end of the filename
# should be the number iter to ensure that simulation files do not overwrite one another on
# the cluster.
# • Initialise a list which will contain the results of your 150 simulations.
# • Call the stochastic_simulation function to do the appropriate simulation 150 times,
# appending the output to the results list, and then save the results list.

#four initial conditions (25 cluster runs per)
#each cluster run runs simulation 150 times
#1) large population of 100 adults
#2) small population of 10 adults
#3) 100 individuals spread
#4) small population of 10 individuals
