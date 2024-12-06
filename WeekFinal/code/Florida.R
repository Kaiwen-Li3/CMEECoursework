setwd("~/Documents/CMEECoursework/WeekFinal/code")

rm(list=ls())


corrvec <- c()
for (i in 1:50) {
load("../data/KeyWestAnnualMeanTemperature.RData")
df <- ats

data <- df[sample(nrow(df), size=50, replace=FALSE),]

corrvec <- c(corrvec, cor(data$Year,data$Temp,method="pearson"))

}

print(corrvec)


#observed = 0.5331784
