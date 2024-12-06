setwd("~/Documents/CMEECoursework/WeekFinal/code")

rm(list=ls())


load("../data/KeyWestAnnualMeanTemperature.RData")

df <- ats

corr <- as.numeric(cor(df$Year,df$Temp,method="pearson"))

corrvec <- c()
for (i in 1:50) {
  df <- ats
  
  data <- df[sample(nrow(df), size=50, replace=FALSE),]
  
  corrvec <- c(corrvec, cor(data$Year,data$Temp,method="pearson"))
  
}



greaterthancor <- 0
for (i in 1:length(corrvec)) {
  if (corrvec[i] > corr) {
    greaterthancor <- greaterthancor + 1
  }
}

greaterthancorfrac <- greaterthancor / length(corrvec)
