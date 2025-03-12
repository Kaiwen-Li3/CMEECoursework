#for plots
library(ggplot2)

#for nlslm
library(minpack.lm)

#PURGE THE WORKSPACE!!!!!!!!!!!
rm(list = ls())
#setwd("~/GitHub/CMEECoursework/MiniProject/Code")
dataMod <- read.csv("../Data/LogisticGrowthDataMod.csv")

#### It's gompertz time
gompertz_model <- function(t, r_max, K, N_0, t_lag){ 
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}   

#Looking at "real" vs artificial / symnthetic
artificial_media <- c("TSB", "ESAW", "TGE agar", "MRS broth", "APT Broth", "MRS")
dataMod$Environment <- ifelse(dataMod$Medium %in% artificial_media, "Artificial", "Real-world")

#id
unique_ids <- unique(dataMod$ID_num)
plot_directory <- "../Results"

#Init counter
results <- data.frame(Environment = character(), Model = character(), AIC_wins = integer(), BIC_wins = integer())

####===========================================
#====================================================================================================================================
# LOOP START
for(id in unique_ids) {
  
  #...for each ID
  subset_data <- subset(dataMod, ID_num == id)
  env_type <- unique(subset_data$Environment)  # Get environment type
  
  # fit Linear Model
  lm_fit <- lm(log_PopBio ~ Time, data = subset_data)
  
#fit LM to the ID
  lm_AIC <- AIC(lm_fit)
  lm_BIC <- BIC(lm_fit)
  # define starting gompertz
  N_0_start <- min(subset_data$log_PopBio)
  K_start <- max(subset_data$log_PopBio)
  r_max_start <- coef(lm_fit)["Time"]
  t_lag_start <- min(subset_data$Time)
  
  # try to fit gompertz
  fit_gomping_time <- tryCatch({
    nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), 
          data = subset_data,
          start = list(t_lag = t_lag_start, r_max = r_max_start, N_0 = N_0_start, K = K_start),
          control = nls.lm.control(maxiter = 100))
  }, error = function(e) {
    message(paste("Error fitting Gompertz for ID:", id, ":", e$message))
    return(NULL)
  })
  ###########################################
  ####IF START
  # If Gompertz fit is successful, compare AIC/BIC
  if (!is.null(fit_gomping_time)) {
    gompy_AIC <- AIC(fit_gomping_time)
    gompy_BIC <- BIC(fit_gomping_time)
    
     #who wins?
    AIC_winner <- ifelse(lm_AIC < gompy_AIC, "Linear", "Gompertz")
    
    BIC_winner <- ifelse(lm_BIC < gompy_BIC, "Linear", "Gompertz")
    
    # storing results
    results <- rbind(results, data.frame(Environment = env_type, Model = AIC_winner, AIC_wins = 1, BIC_wins = 0))
    
     results <- rbind(results, data.frame(Environment = env_type, Model = BIC_winner, AIC_wins = 0, BIC_wins = 1))
    
    # dataframe for the plot for gompertz
    time_seq <- seq(min(subset_data$Time), max(subset_data$Time), length.out = 100)
    gompy_predation <- predict(fit_gomping_time, newdata = data.frame(Time = time_seq))
    gompertz_df <- data.frame(Time = time_seq, log_PopBio = gompy_predation)
    
    # create the plot, lm in red, gomp in blue
    plot <- ggplot(subset_data, aes(x = Time, y = log_PopBio)) +
      geom_point(color = "gray", alpha = 0.75) +  
      geom_smooth(method = "lm", color = "darkred", linetype = "dashed", se = FALSE) + 
      geom_line(data = gompertz_df, aes(x = Time, y = log_PopBio), color = "darkblue", size = 1) +  # Gompertz model line
      theme_minimal() +
      labs(title = paste("Bacterial Growth for ID: ", id), x = "Time (hours)", y = "Log Population")
    
    # Save plot
    filename <- paste0(plot_directory, "/Bacterial_Growth_Plot_ID_", id, ".pdf")
    ggsave(filename, plot = plot, width = 8, height = 6, dpi = 300)
    
    
    #if invalid gompertz fit, skip
  } else {
    message(paste("Skipping ID:", id, "due to Gompertz fitting failure"))
  }
  
  ###IF END
  ###########################################
}
#====================================================================================================================================
#LOOP END



# Summarize and print results
summary_results <- aggregate(cbind(AIC_wins, BIC_wins) ~ Environment + Model, 
                              data = results, sum, drop = FALSE)
write.csv(summary_results, file = "../Results/lm_vs_gompertz_summary.csv", row.names = FALSE)

