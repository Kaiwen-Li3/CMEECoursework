library(ggplot2)
library(minpack.lm)
library(qpcR)



setwd("~/GitHub/CMEECoursework/MiniProject/Code")
dataMod <- read.csv("../Data/LogisticGrowthDataMod.csv")

############################################################################################################

lm_model <- lm(log_PopBio ~ Time, data = dataMod)

summary(lm_model)


############################################################################################################


N_0_start <- min(dataMod$log_PopBio)
K_start <- max(dataMod$log_PopBio)
r_max_start <- 0.0013
t_lag_start <- dataMod$Time[which.max(diff(diff(dataMod$log_PopBio)))]


gompertz_model <- function(t, r_max, K, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}   


fit_gompertz <- nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), 
                      data = dataMod,
                      start = list(t_lag = t_lag_start, r_max = r_max_start, N_0 = N_0_start, K = K_start),
                      control = nls.lm.control(maxiter = 100)) 

summary(fit_gompertz)

#######################################################################################################
#AIC


AIC_lm <- AIC(lm_model)
AIC_gompy <- AIC(fit_gompertz)


AIC_vec <- c(AIC_lm, AIC_gompy)
akaike.weights(AIC_vec)



########################################################################
#BIC


BIC_lm <- BIC(lm_model)
BIC_gompy <- BIC(fit_gompertz)




#########################################################################
#Data visualisation

time_seq <- seq(min(dataMod$Time), max(dataMod$Time), length.out = 100)
gompertz_pred <- predict(fit_gompertz, newdata = data.frame(Time = time_seq))

gompertz_df <- data.frame(Time = time_seq, log_PopBio = gompertz_pred)


ggplot(dataMod, aes(x = Time, y = log_PopBio)) +
  geom_point(color = "gray", alpha = 0.6) +  # Scatter plot for raw data
  geom_smooth(method = "lm", color = "blue", linetype = "dashed", se = FALSE) +  # Linear model fit
  geom_line(data = gompertz_df, aes(x = Time, y = log_PopBio), color = "red", size = 1) +  # Gompertz fit
  labs(title = "Gompertz vs Linear Fit", x = "Time", y = "log(PopBio)") +
  theme_minimal() +
  theme(legend.position = "top")





unique_ids <- unique(dataMod$ID_num)
plot_directory <- "../Results"

for(id in unique_ids) {
  
  subset_data <- subset(dataMod, ID_num == id)
  time_seq <- seq(min(subset_data$Time), max(subset_data$Time), length.out = 100)
  new_data <- data.frame(Time = time_seq, ID_num = id)
  new_data$log_PopBio <- predict(fit_gompertz, newdata = new_data)
  
  
  plot <- ggplot(subset_data, aes(x=Time, y=log_PopBio)) +
    geom_point(color = "gray", alpha = 0.75) +
    geom_smooth(method = "lm", color = "purple", linetype = "dashed", se = FALSE) +
    geom_line(data = new_data, aes(x = Time, y = log_PopBio), color="limegreen", size = 1) +
    theme_minimal() +
    labs(title = paste("Bacterial growth for numeric ID: ", id), x = "Time (hours)", y = "Log population")
  
  
  filename <- paste0(plot_directory, "/Bacterial_Growth_Plot_", id, ".pdf")
  ggsave(filename, plot = plot, width = 8, height = 6, dpi = 300)
}













######################################################
library(ggplot2)
library(minpack.lm)
library(qpcR)

gompertz_model <- function(t, r_max, K, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}   


unique_ids <- unique(dataMod$ID_num)
plot_directory <- "../Results"

model_select_df <- data.frame(
  ID_num = numeric(),
  Model = character(),
  AIC = numeric(),
  BIC = numeric(),
  stringsAsFactors = FALSE
  
)


for(id in unique_ids) {
  
  subset_data <- subset(dataMod, ID_num == id)

  lm_fit <- lm(log_PopBio ~ Time, data = subset_data)
  
  lm_AIC <- AIC(lm_fit)
  lm_BIC <- BIC(lm_fit)
  
  model_select_df <- rbind(model_select_df, data.frame(
    ID_num = id,
    Model = "Linear",
    AIC = lm_AIC,
    BIC = lm_BIC
  ))
  
  
  N_0_start <- min(subset_data$log_PopBio)
  K_start <- max(subset_data$log_PopBio)
  r_max_start <- coef(lm_fit)["Time"]
  t_lag_start <- min(subset_data$Time)
  
  fit_gomping_time <- nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), 
                            data = subset_data,
                            start = list(t_lag = t_lag_start, r_max = r_max_start, N_0 = N_0_start, K = K_start),
                            control = nls.lm.control(maxiter = 100)) 
  
  gompy_AIC <- AIC(fit_gomping_time)
  gompy_BIC <- BIC(fit_gomping_time)
  
  
  model_select_df <- rbind(model_select_df, data.frame(
    ID_num = id,
    Model = "Gompertz",
    AIC = gompy_AIC,
    BIC = gompy_BIC))
  
  time_seq <- seq(min(subset_data$Time), max(subset_data$Time), length.out = 100)
  gompy_predation <- predict(fit_gompertz, newdata = data.frame(Time = time_seq))
  
  gompertz_df <- data.frame(Time = time_seq, log_PopBio = gompy_predation)
  
  
  
  
  plot <- ggplot(subset_data, aes(x = Time, y = log_PopBio)) +
    geom_point(color = "gray", alpha = 0.75) +  
    geom_smooth(method = "lm", color = "darkred", linetype = "dashed", se = FALSE) + 
    geom_line(data = gompertz_df, aes(x = Time, y = log_PopBio), color = "darkblue", size = 1) +  # Gompertz model line
    theme_minimal() +
    labs(title = paste("Bacterial Growth for ID: ", id), x = "Time (hours)", y = "Log Population")
  
  filename <- paste0(plot_directory, "/Bacterial_Growth_Plot_ID_", id, ".pdf")
  ggsave(filename, plot = plot, width = 8, height = 6, dpi = 300)
}
                     