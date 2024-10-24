#tapply allows you to apply a function to subsets of a vector in a dataframe

x <- 1:20
x

y <- factor(rep(letters[1:5], each = 4))
y

tapply(x, y, sum)
#adds up the values in x within each subgroup defined by y
#e.g. 1 + 2 + 3 + 4 + 5, 6 + 7 + 8 + 9, etc.

#You can also do something similar to tapply with the by function

attach(iris)
iris

by(iris[,1:2], iris$Species, colMeans)
#Finds the mean sepal.length and sepal.width based on species
by(iris[,1:2], iris$Petal.Width, colMeans)
#Finds the mean sepal.length and sepal.width based on petal.width


#Replicate can avoid a loop for function that typically involves random number generation
replicate(10, runif(5))
#generates 10 sets (columns) of 5 uniformly distributed random numbers

