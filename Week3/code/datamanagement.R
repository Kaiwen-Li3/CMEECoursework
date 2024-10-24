require(tidyverse)
require(httpgd)


MyData <- as.matrix(read.csv("../data/PoundHillData.csv",header = FALSE))
class(MyData)

MyMetaData <- read.csv("../data/PoundHillMetaData.csv",header = TRUE,  sep=";")
class(MyMetaData)

MyMetaData
head(MyMetaData)

MyData[MyData == ""] = 0

#convert to long format (each subject will have data in multiple rows)

MyData <- t(MyData)
head(MyData)

#turn column names into actual column names
TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F)
head(TempData)
colnames(TempData) <- MyData[1,]
head(TempData)


library(reshape2)

MyWrangledData <- melt(TempData, id=c("Cultivation", "Block", "Plot", "Quadrat"), variable.name = "Species", value.name = "Count")


MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"]) # nolint
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])
str(MyWrangledData)

install.packages("ragg")
install.packages("tidyverse", dependencies=TRUE)

#sudo apt install r-cran-tidyverse

tidyverse_packages(include_self = TRUE)

MyWrangledData <- dplyr::as_tibble(MyWrangledData)
MyWrangledData

glimpse(MyWrangledData)
slice(MyWrangledData, 10:15)

MyWrangledData %>% #pipe operator creates compact sequence of manipulations
    group_by(Species) %>%
        summarise(avg = mean(Count))

plot(x,y)
plot(y~x)
hist(mydata)
barplot(mydata)
points(y1$\sim$x1)
boxplot(y$\sim$x)

MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
dim(MyDF) #check the size of the data frame you loaded
glimpse(MyDF)

#change columns to factor because we want to use them as grouping variables:
MyDF$Type.of.feeding.interaction <- as.factor(MyDF$Type.of.feeding.interaction)
MyDF$Location <- as.factor(MyDF$Location)
str(MyDF)



plot(MyDF$Predator.mass,MyDF$Prey.mass)