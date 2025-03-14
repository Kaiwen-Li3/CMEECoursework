# CMEE 2024 HPC exercises R code main pro forma
# You don't HAVE to use this but it will be very helpful.
# If you opt to write everything yourself from scratch please ensure you use
# EXACTLY the same function and parameter names and beware that you may lose
# marks if it doesn't work properly because of not using the pro-forma.
#setwd("~/Documents/HPC/code")


#######test

name <- "Kaiwen Li"
preferred_name <- "Kaiwen Li"
email <- "kl2621@imperial.ac.uk"
username <- "kl2621"

# Please remember *not* to clear the work space here, or anywhere in this file.
# If you do, it'll wipe out your username information that you entered just
# above, and when you use this file as a 'toolbox' as intended it'll also wipe
# away everything you're doing outside of the toolbox.  For example, it would
# wipe away any automarking code that may be running and that would be annoying!

# Section One: Stochastic demographic population model

#================================================================================
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

projection_matrix = reproduction_matrix + growth_matrix


clutch_distribution <- c(0.06,0.08,0.13,0.15,0.16,0.18,0.15,0.06,0.03)

source("Demographic.R")

#================================================================================



# Question 0

state_initialise_adult <- function(num_stages,initial_size){

population <- c(rep(0, num_stages-1), initial_size)
return(population)
}

state_initialise_spread <- function(num_stages,initial_size){
spreadperstage <- (floor(initial_size / num_stages))
remainder <- initial_size %% num_stages
population <- c(rep(spreadperstage, num_stages))
for (i in 1:num_stages) {
    if (remainder > 0) {
        population[i] <- population[i]+1
        remainder <- remainder - 1
    }#
}
return(population)
}

print(state_initialise_adult(5, 3))
print(state_initialise_spread(5,12))


# Question 1
question_1 <- function(){
  
#source the file first

adultresult <- deterministic_simulation(state_initialise_adult(4,100),projection_matrix,23)
spreadresult<- deterministic_simulation(state_initialise_spread(4,100),projection_matrix,23)

  png(filename="kl2621_HPC_2024_question_1", width = 600, height = 400)
  # plot your graph here


matplot(1:24, cbind(adultresult, spreadresult), type = "l", lty = 1, 
        col = c("red", "blue"), xlab = "X", 
        ylab = "Y", main = "Population size time series for two simulations")
legend("bottomright", legend = c("All adults", "Even spread"), 
       col = c("red", "blue"), 
       lty = 1)


  Sys.sleep(0.1)
  dev.off()
  
  return("An initial population comprised of all adults features a steep spike and decline in population at the beginning of the simulation, and has a faster overall growth rate compared to one evenly comprised of individuals from all four life stages.")
}



question_1()
# Question 2
question_2 <- function(){

stadultresult <- stochastic_simulation(state_initialise_adult(4,100),growth_matrix,reproduction_matrix,clutch_distribution,23)
stspreadresult <- stochastic_simulation(state_initialise_spread(4,100), growth_matrix, reproduction_matrix, clutch_distribution, 23)


  png(filename="kl2621_HPC_2024_question_2", width = 600, height = 400)
  # plot your graph here
matplot(1:24, cbind(stadultresult, stspreadresult), type = "l", lty = 1, 
        col = c("red", "blue"), xlab = "X", 
        ylab = "Y", main = "Population size time series for two simulations")
legend("bottomright", legend = c("All adults", "Even spread"), 
       col = c("red", "blue"), 
       lty = 1)



  Sys.sleep(0.1)
  dev.off()
  
  return("The stochastic models are much less smooth than the deterministic ones. This is because they incorporate randomness and uncertainty, like a recruitment probability. They won't produce a determined outcome, but can produce a range of different outcomes.")
}

question_2()


# Questions 3 and 4 involve writing code elsewhere to run your simulations on the cluster


# Question 5
question_5 <- function(){
  
  #outputfiles are in ../data
  rda_files <- file.path("../data", paste0("output", 1:100, ".rda"))
  extinction_data <- data.frame(InitialCondition = integer(), NumExtinctions = integer(), stringsAsFactors = FALSE)
  total_extinctions <- 0
  
  for (file in rda_files) {
    load(file)  # Loads reslist
    
    extinction_status <- sapply(reslist, function(run) tail(run, 1) == 0)
    
    num_extinctions <- sum(extinction_status)
    
    #extinction counter
    total_extinctions <- total_extinctions + num_extinctions
    #outputx.rda
    file_number <- as.numeric(gsub("output(\\d+)\\.rda", "\\1", basename(file)))
    initial_condition <- ceiling(file_number / 25)  # 1-25 → 1, 26-50 → 2, etc.
    
    # Store results
    extinction_data <- rbind(extinction_data, 
                             data.frame(InitialCondition = initial_condition, 
                                        NumExtinctions = num_extinctions))
  }
  
  
  library(ggplot2)
  
  summary_data <- aggregate(NumExtinctions ~ InitialCondition, data = extinction_data, sum)
  
  #3750 simulations total for each condition, find proportion
  summary_data$NumExtinctions <- summary_data$NumExtinctions/3750
  
  
  
  condition_labels <- c("100 adults", "10 adults", "100 mixed life stages", "10 mixed life stages")
  summary_data$Initialcondition <- factor(summary_data$InitialCondition, 
                                          levels = 1:4, 
                                          labels = condition_labels)
  

  
  
  png(filename="kl2621_HPC_2024_question_5", width = 600, height = 400)
  # plot your graph here
  
  ggplot(summary_data, aes(x = Initialcondition, y = NumExtinctions, fill = Initialcondition)) +
    geom_bar(stat = "identity") +
    labs(title = "Proportion of stochastic simulations ending in extinction",
         x = "Initial Condition",
         y = "Proportion Extinct") +
    theme_minimal() +
    theme(legend.position = "none") 
  
  
  
  
  
  Sys.sleep(0.1)
  dev.off()
  
  return("The populations with a starting size of 10 as opposed to 100 would be more likely to go extinct; smaller population means more vulnerability to stochastic effects such as random extinction. The population with mixed life stages was more likely to go extinct because only adult individuals could reproduce, according to reproduction_matrix. Less reproducing individuals means slower population growth.")
}

# Question 6
question_6 <- function(){
  
  
  
  
  
  
  png(filename="kl2621_HPC_2024_question_6", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  return("type your written answer here")
}


# Section Two: Individual-based ecological neutral theory simulation 

# Question 7
species_richness <- function(community){
  richness <- length(unique(community))
  return(richness)
}

#
x<-10
# Question 8
init_community_max <- function(size){
  return(seq(1, size))  # Each individual gets a unique species ID
}

# Question 9
init_community_min <- function(size){
  return(rep(1, size))  # All individuals are the same species
}

# Question 10
choose_two <- function(max_value){
  max1 <- (sample(max_value, 1))
  max2 <- max1
  while (max1 == max2) {
    max2 <- (sample(max_value, 1))
  }
  return(c(max1, max2))
}

#print(replicate(100, choose_two(10)))

# Question 11
  neutral_step <- function(community){

    stepindices <- choose_two(length(community))

    community[stepindices[1]] <- community[stepindices[2]] 
  return(community)
  }




  # Question 12
  neutral_generation <- function(community){
  communitysize <- length(community)

    if (communitysize %% 2 == 0) {
      timer <- (communitysize / 2)  # If x is even, return x divided by 2
    } else {
      timer <- (sample(c(floor(communitysize / 2), ceiling(communitysize / 2)), 1))  # If x is odd, randomly round
    }

    for (i in 1:timer) {
      community <- neutral_step(community)

    }
    return(community)
  }


 print(neutral_generation(c(1,2)))

# Question 13
neutral_time_series <- function(community,duration)  {
  richnessvector <- c(species_richness(community))  

  for (i in 1:duration) {
    community <- neutral_generation(community)
    richnessvector <- c(richnessvector, species_richness(community))
  }

  return(richnessvector)
}

print(neutral_time_series(init_community_max(7),20))


# Question 14
question_14 <- function() {
  
  simulation <- neutral_time_series(init_community_max(100),200)
  print(simulation)

  
  
  png(filename="kl2621_HPC_2024_question_14", width = 600, height = 400)
  # plot your graph here
  plot(simulation, type = "l", col = "blue", lwd = 2,
       xlab = "Generation", ylab = "Community Size",
       main = "Neutral Time Series")
  
  
  
  Sys.sleep(0.1)
  dev.off()
  
 
}

# Question 15
neutral_step_speciation <- function(community,speciation_rate)  {
  randomgen <- runif(1, min=0, max=1)
  if (randomgen <= speciation_rate) {
    possible_numbers <- 1:100
    unused_numbers <- setdiff(possible_numbers, community)
    if (length(unused_numbers) > 0) {
      # Randomly choose a number from community to replace
      random_index <- sample(seq_along(community), 1)
      # Randomly choose an unused number
      replacement <- sample(unused_numbers, 1)
      # Replace the chosen number in community
      community[random_index] <- replacement}
  } else {
    #####################################################################
    stepindices <- choose_two(length(community))
    community[stepindices[1]] <- community[stepindices[2]] 
  }
  return(community)
}

neutral_step_speciation(c(1,2,3,4,5),1)

# Question 16
neutral_generation_speciation <- function(community,speciation_rate)  {
  communitysize <- length(community)
  
  if (communitysize %% 2 == 0) {
    timer <- (communitysize / 2)  # If x is even, return x divided by 2
  } else {
    timer <- (sample(c(floor(communitysize / 2), ceiling(communitysize / 2)), 1))  # If x is odd, randomly round
  }
  
  for (i in 1:timer) {
    community <- neutral_step_speciation(community, speciation_rate)
    
  }
  return(community)
}

# Question 17
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  richnessvector <- c(species_richness(community))  
  
  for (i in 1:duration) {
    community <- neutral_generation_speciation(community,speciation_rate)
    richnessvector <- c(richnessvector, species_richness(community))
  }
  
  return(richnessvector)
}



# Question 18
question_18 <- function()  {
  
  simulationspec <- neutral_time_series_speciation(init_community_max(100),0.1,200)
  simulationspec2 <- neutral_time_series_speciation(init_community_min(100),0.1,200)
  print(simulationspec)

  
  png(filename="kl2621_HPC_2024_question_18", width = 600, height = 400)
  plot(simulationspec, type = "l", col = "blue", lwd = 2,
       xlab = "Generation", ylab = "Community Size",
       main = "Neutral Time Series (0.1 Speciation Rate)")
  lines(simulationspec2, col = "red", lwd = 2)
  # plot your graph here
    Sys.sleep(0.1)
  dev.off()
  
  return("What's interesting is how the population starting at the maximum possible species richness eventually converges to fluctuate at around the same richness as the minimal species richness population, when they have the same speciation rate. This is likely because at high richness, the model causes drift, which reduces it via extinction - and at low richness, the speciation rate introduces new species. This results in both population getting balanced to around the same richness with time.")
}


question_18()

# Question 19
species_abundance <- function(community)  {
  sortedcom <- sort(community, decreasing = TRUE)
  sortedtabcom <- table(sortedcom)
  structured_tab <- rbind(names(sortedtabcom), as.numeric(sortedtabcom))
  
  # Return the second row (frequencies)
  return(as.numeric(structured_tab[2, ]))
  }

#species_abundance(c(1,1,4,5,5,5,6,7,7))

# Question 20
octaves <- function(abundance_vector) {
  filtered_abundance <- abundance_vector[abundance_vector > 0]
  octave_bins <- floor(log2(filtered_abundance)) + 1
  octave_counts <- tabulate(octave_bins)
  return(octave_counts)
}


# Question 21
sum_vect <- function(x, y) {
  if (length(x) > length(y)) {
  difference = length(x) - length(y) 
  y <- c(y, rep(0, difference))  }
  else {
  difference = length(y) - length(x)
  x <- c(x, rep(0, difference))
  }

  total <- x + y
  return(total)
}



# Question 22
question_22 <- function() {
  
  maxcom <- init_community_max(100)
  mincom <- init_community_min(100)
  
  for (i in 1:200) {
    maxcom <- neutral_generation_speciation(maxcom,0.1)
    mincom <- neutral_generation_speciation(mincom,0.1)
  }
    
  
  octavemax <- list()
  octavemin <- list()
  
  for (i in 1:2000) {
    maxcom <- neutral_generation_speciation(maxcom,0.1)
    mincom <- neutral_generation_speciation(mincom,0.1)
    
    if (i %% 20 == 0) {
      octavemax[[length(octavemax) + 1]] <- octaves(tabulate(maxcom))
      octavemin[[length(octavemin) + 1]] <- octaves(tabulate(mincom))
    }
  }
  
  total_bins_max <- max(sapply(octavemax, length))
  total_bins_min <- max(sapply(octavemin, length))
  
  abundance_matrix_max <- matrix(0, nrow = length(octavemax), ncol = total_bins_max)
  abundance_matrix_min <- matrix(0, nrow = length(octavemin), ncol = total_bins_min)
  
  for (i in seq_along(octavemax)) {
    abundance_matrix_max[i, 1:length(octavemax[[i]])] <- octavemax[[i]]
  }
  
  for (i in seq_along(octavemin)) {
    abundance_matrix_min[i, 1:length(octavemin[[i]])] <- octavemin[[i]]
  }
  
  
  mean_octavemax <- colMeans(abundance_matrix_max)
  mean_octavemin <- colMeans(abundance_matrix_min)
  
  
  
  png(filename="kl2621_HPC_2024_question_22", width = 600, height = 400)
  # plot your graph here
  mean_abundances <- rbind(mean_octavemax, mean_octavemin)
  
  octave_labels <- c("[1, 2)", "[2, 4)", "[4, 8)", "[8, 16)", "[16, 32)", "[33,64)")
  
  barplot(mean_abundances,
          beside = TRUE,
          main = "Mean Abundance per Octave Bin",
          xlab = "Octave Bins",
          ylab = "Mean Abundance",
          col = c("skyblue", "pink"),
          legend = c("Max Diversity", "Min Diversity"),
          border = "black",
          names.arg = octave_labels)
  
  Sys.sleep(0.1)
  dev.off()
  
  return("No; initial condition doesn't seem to matter, since maximum diversity and minimum diversity have similar octave distributions")
}

# Question 23
neutral_cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name) {
  community <- init_community_min(size)
  gennumber <- 0
  time_series <- c()
  abundance_list <- list()
  
  start_time <- Sys.time() 
  target_time <- start_time + as.difftime(wall_time, units = "mins")
  
  while (Sys.time() < target_time) {
    gennumber <- gennumber + 1
    generationresults <- neutral_generation_speciation(community, speciation_rate)
    
    
    #burn_in check
    if (gennumber <= burn_in_generations) {
      if (gennumber %% interval_rich == 0) {
        time_series <- c(time_series, species_richness(community))
      }
    }
    
    #every octave
    if (gennumber %% interval_oct == 0) {
      abundance_list[[length(abundance_list) + 1]] <- octaves(species_abundance(generationresults))
    }
    
    community <- generationresults
  }
  
  end_time <- Sys.time()
  total_time <- difftime(end_time, start_time, units = "secs")
  
  # List creation
  results <- list(
    speciation_rate = speciation_rate,
    size = size,
    wall_time = wall_time,
    interval_rich = interval_rich,
    interval_oct = interval_oct,
    burn_in_generations = burn_in_generations,
    time_series = time_series,
    community = community,
    abundance_list = abundance_list,
    total_time = total_time
  )
  
  save(results, file = output_file_name)
}


#neutral_cluster_run(speciation_rate=0.1, size=100,
 #                   wall_time=2, interval_rich=1, interval_oct=10,
  #                  burn_in_generations=200,
   #                 output_file_name="my_test_file_1.rda")



# Questions 24 and 25 involve writing code elsewhere to run your simulations on
# the cluster

# Question 26 

#Couldn't answer this question for groups 3 and 4



process_neutral_cluster_results <- function() {
  

#group means = blank list
  group_means <- list()
  

  for (group in 1:4) {
    print(paste("group:", group))
    
    #for the group of 25
    group_column_means <- NULL
    
    # Load each of the 25 files in the current group
    for (i in ((group-1)*25 + 1):(group*25)) {
      print(paste("file:", i))
      # Load the RDA file
      file_path <- paste0("../data/neutral_output_", i, ".rda")
      load(file_path)
      
        # Extract abundance
        abundance_list <- results[[9]]  # Get the 9th element from the list
      
      # ignore 80 entries
      abundance_list_trimmed <- as.matrix(abundance_list[-(1:80)])
      
      
      column_sums <- colSums(do.call(rbind, abundance_list_trimmed))
      
      
      # Calculate column means (sum per column / number of rows)
      column_means <- column_sums / nrow(abundance_list_trimmed)
      
      # Accumulate the means for this group
      if (is.null(group_column_means)) {
        group_column_means <- column_means
      } else {
        group_column_means <- group_column_means + column_means
      }
    }
    
    #Divide by 25 for each group sum
    mean_group_column_sums <- group_column_means / 25
    

    group_means[[group]] <- mean_group_column_sums
  }
  
  

     
plot_neutral_cluster_results <- function(){

    # load combined_results from your rda file

  combined_results <- do.call(rbind, lapply(1:length(group_means), function(group_idx) {
    data.frame(
      Group = rep(group_idx, length(group_means[[group_idx]])),
      Value = group_means[[group_idx]],
      Category = factor(paste(1:length(group_means[[group_idx]])), 
                        levels = paste(1:length(group_means[[group_idx]])))  # Order categories correctly
    )
  }))
  
  
  head(combined_results)
  
    png(filename="plot_neutral_cluster_results", width = 600, height = 400)
    
    
    
    
    # plot your graph here
    
    library(ggplot2)
    
      ggplot(combined_results, aes(x = Category, y = Value, fill = factor(Group))) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Population Octave", y = "Mean Value", title = "Group Means by Population Octave") +
      facet_wrap(~ Group, scales = "free_y") +  
      theme_minimal() +
      theme(legend.position = "none")
  
    
    
  
    Sys.sleep(0.1)
    dev.off()
    
    
   
    
    
    
    return(combined_results)
}


# Challenge questions - these are substantially harder and worth fewer marks.
# I suggest you only attempt these if you've done all the main questions. 

# Challenge question A
Challenge_A <- function(){
  
  png(filename="Challenge_A", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
}

# Challenge question B
Challenge_B <- function() {
  
  png(filename="Challenge_B", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
}

# Challenge question C
Challenge_B <- function() {
  
  png(filename="Challenge_C", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()

}

# Challenge question D
Challenge_D <- function() {
  
  png(filename="Challenge_D", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
}

# Challenge question E
Challenge_E <- function() {
  
  png(filename="Challenge_E", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  return("type your written answer here")
}

