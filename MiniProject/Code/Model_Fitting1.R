library(ggplot2)
library(minpack.lm)


rm(list = ls())
setwd("~/GitHub/CMEECoursework/MiniProject/Code")
dataMod <- read.csv("../Data/LogisticGrowthDataMod.csv")


####Define gompertz
gompertz_model <- function(t, r_max, K, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}   

#List of ID_num
unique_ids <- unique(dataMod$ID_num)
plot_directory <- "../Results"

gompertz_AIC_wins <- 0
lm_AIC_wins <- 0
gompertz_BIC_wins <- 0
lm_BIC_wins <- 0


#LOOP START
for(id in unique_ids) {
  
  
  #Make subset
  subset_data <- subset(dataMod, ID_num == id)
  
  
  #Fit LM
  lm_fit <- lm(log_PopBio ~ Time, data = subset_data)
  
  
  
  #AIC / BIC for LM
  lm_AIC <- AIC(lm_fit)
  lm_BIC <- BIC(lm_fit)
  
  
  
  #Define starting parameters for gompertz
  N_0_start <- min(subset_data$log_PopBio)
  K_start <- max(subset_data$log_PopBio)
  r_max_start <- coef(lm_fit)["Time"]
  t_lag_start <- min(subset_data$Time)
  
  
  
  #Gompertz fit
  fit_gomping_time <- nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), 
                            data = subset_data,
                            start = list(t_lag = t_lag_start, r_max = r_max_start, N_0 = N_0_start, K = K_start),
                            control = nls.lm.control(maxiter = 100)) 
  
  
  
  
  #AIC / BIC for LM
  gompy_AIC <- AIC(fit_gomping_time)
  gompy_BIC <- BIC(fit_gomping_time)
  
  #####Model selection?? Which one fits more IDs?
  if(lm_AIC < gompy_AIC) {
    lm_AIC_wins <- lm_AIC_wins + 1
  } else {
    gompertz_AIC_wins <- gompertz_AIC_wins + 1
  }
  
  if(lm_BIC < gompy_BIC) {
    lm_BIC_wins <- lm_BIC_wins + 1
  } else {
    gompertz_BIC_wins <- gompertz_BIC_wins + 1
  }

  
  
  #Dataframe of gompertz line for this ID
  time_seq <- seq(min(subset_data$Time), max(subset_data$Time), length.out = 100)
  gompy_predation <- predict(fit_gomping_time, newdata = data.frame(Time = time_seq))
  gompertz_df <- data.frame(Time = time_seq, log_PopBio = gompy_predation)
  
  
  
  #Plot, with lm and gompertz lines
  plot <- ggplot(subset_data, aes(x = Time, y = log_PopBio)) +
    geom_point(color = "gray", alpha = 0.75) +  
    geom_smooth(method = "lm", color = "darkred", linetype = "dashed", se = FALSE) + 
    geom_line(data = gompertz_df, aes(x = Time, y = log_PopBio), color = "darkblue", size = 1) +  # Gompertz model line
    theme_minimal() +
    labs(title = paste("Bacterial Growth for ID: ", id), x = "Time (hours)", y = "Log Population")
  
  
  #Save the file
  filename <- paste0(plot_directory, "/Bacterial_Growth_Plot_ID_", id, ".pdf")
  ggsave(filename, plot = plot, width = 8, height = 6, dpi = 300)
}
#LOOP END