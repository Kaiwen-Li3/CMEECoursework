require(ggplot2)

#plotting nicer looking graphics with ggplot2
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
dim(MyDF)

qplot(Prey.mass, Predator.mass, data = MyDF)
qplot(log(Prey.mass), log(Predator.mass), data = MyDF)
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = Type.of.feeding.interaction)
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = Type.of.feeding.interaction, asp = 1) #aspect ratios
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape = Type.of.feeding.interaction, asp = 1) # changing shape

#manual setting
qplot(log(Prey.mass), log(Predator.mass), 
    data = MyDF, colour = "red") #manually set colour
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = I("red")) #"real" red using identity

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape= I(3)) #crosses instead of dots


#transparency
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = Type.of.feeding.interaction, alpha = I(.5))

#smoothers
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"))

#linear regression
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth")) + geom_smooth(method = "lm")

#smoother for each type of interaction
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"), 
      colour = Type.of.feeding.interaction) + geom_smooth(method = "lm")
#extending lines to full range
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"),
      colour = Type.of.feeding.interaction) + geom_smooth(method = "lm",fullrange = TRUE)

#how ratio between predator:prey mass changes based on interaction
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF)

#add jitter
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "jitter")

#boxplots
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "boxplot")


#histogram of predator-prey mass ratios
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram")

#colour according to interaction
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram", 
      fill = Type.of.feeding.interaction)
#define bin widths
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram", 
      fill = Type.of.feeding.interaction, binwidth = 1)
#plot smoothed data density
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      fill = Type.of.feeding.interaction)
#visible overlaps
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      fill = Type.of.feeding.interaction, 
      alpha = I(0.5))
#only show outlines
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      colour = Type.of.feeding.interaction)


#multi-faceted plots
qplot(log(Prey.mass/Predator.mass), facets = Type.of.feeding.interaction ~., data = MyDF, geom =  "density")
qplot(log(Prey.mass/Predator.mass), facets =  .~ Type.of.feeding.interaction, data = MyDF, geom =  "density")