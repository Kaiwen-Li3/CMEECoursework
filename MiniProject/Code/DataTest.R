setwd("~/GitHub/CMEECoursework/MiniProject/Code")
#install.packages("panda")
library("tidyverse")

data <- read.csv("../Data/LogisticGrowthData.csv")
sum(is.na(data$PopBio))
data <- na.omit(data)



data$ID <- paste(data$Species, data$Medium, data$Temp, data$Citation, sep = "_")
data$ID_num <- as.numeric(factor(data$ID))

unique(data$PopBio_units)  
table(data$PopBio_units)

data <- data %>%
  group_by(PopBio_units) %>% 
  mutate(Norm_PopBio = scale(PopBio)) %>% 
  ungroup()
summary(data$Norm_PopBio)




data$log_PopBio <- log(data$PopBio + 1)  # Adding 1 avoids log(0) issues




subset_data <- data[data$ID_num == 4, ]

# plot(subset_data$Time, subset_data$PopBio, 
#      xlab = "Time", ylab = "Population Size (PopBio)", 
#      main = "Scatter Plot of Time vs Population Size", 
#      pch = 19, col = "blue")


plot(data$Time, data$Norm_PopBio, 
     xlab = "Time", ylab = "Population Size (PopBio)", 
     main = "Bacterial Growth Over Time", 
     col = data$ID_num, pch = 19)
legend("topleft", legend = unique(data$ID_num), col = unique(data$ID_num), pch = 19)






# K_start <- max(data$PopBio, na.rm = TRUE)
# N0_start <- min(data$PopBio[data$PopBio > 0], na.rm = TRUE)  # Ensure positive values
# r_start <- (log(max(data$PopBio)) - log(N0_start)) / (max(data$Time) - min(data$Time))  # Approximate
# 
# 
# logistic_model <- nls(PopBio ~ K / (1 + ((K - N0) / N0) * exp(-r * Time)), 
#                       data = data,
#                       start = list(K = K_start, N0 = N0_start, r = r_start),
#                       control = nls.control(maxiter = 1000, tol = 1e-6))
# 
# 
# summary(logistic_model)
