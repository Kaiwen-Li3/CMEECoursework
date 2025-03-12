#setwd("~/GitHub/CMEECoursework/MiniProject/Code")
library(ggplot2)

#import dataset
data <- read.csv("../Data/LogisticGrowthData.csv")



#remove na rows
data <- na.omit(data)

summary(data$PopBio) 

#remove negative and small popbio (problematic values)
data <- data[which(data$PopBio >= 0), ]
data <- data[data$PopBio > 1e-5, ]


#remove negative and far too large time values
data <- data[which(data$Time >= 0), ]
data <- data[which(data$Time <= 1000), ]

#create logs
data$log_PopBio <- log(data$PopBio)

#create ids
data$ID <- paste(data$Species, data$Medium, data$Temp, data$Citation, sep = "_")



#number of data points per ID
ID_counts <- table(data$ID)
#purge small data counts
valid_IDs <- names(ID_counts[ID_counts >= 8])

data <- subset(data, ID %in% valid_IDs)



#turn ids numeric
data$ID_num <- as.numeric(factor(data$ID))




write.csv(data, "../Data/LogisticGrowthDataMod.csv", row.names=FALSE)










###############========================================================
#VISUALISATION
