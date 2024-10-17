#take sample of size n from popn and return its mean
myexperiment <- function(popn,n) {
    pop_sample <- sample(popn, n, replace = FALSE)
    return(mean(pop_sample))
}

#calculate means using a FOR loop on a vector without preallocation
loopy_sample1 <- function(popn, n, num) {
    result1 <- vector()
    for(i in 1:num) {
        result1 <- c(result1, myexperiment(popn, n))
    }
    return(result1)
}

#run num iterations of the experiment using a for loop on a vector with preallocation
loopy_sample2 <- function(popn, n, num) {
    result2 <- vector(,num) #Preallocate expected size
    for(i in 1:num) {
        result2[i] <- myexperiment(popn, n)
    }
    return(result2)
}




#run num iterations of the experiment using a for loop on a list with preallocation
loopy_sample3 <- function(popn, n, num) {
    result3 <- vector("list", num)
    for(i in 1:num) {
        result3[[i]] <- myexperiment(popn, n)
    }
    return(result3)
}


#run num iterations of the experiment using vectorisation with lapply
lapply_sample <- function(popn, n, num) {
    result4 <- lapply(1:num, function(i) myexperiment(popn, n))
    return(result4)
}

#run num iterations of the experiment using vectorisation with sapply
sapply_sample <- function(popn, n, num) {
    result5 <- sapply(1:num, function(i) myexperiment(popn, n))
    return(result5)
}

set.seed(12345)
popn <- rnorm(10000)
hist(popn)

n <- 100
num <- 10000
print("Using loops without preallocation on a vector took:" )
print(system.time(loopy_sample1(popn, n, num)))

print("Using loops with preallocation on a vector took:" )
print(system.time(loopy_sample2(popn, n, num)))

print("Using loops with preallocation on a list took:" )
print(system.time(loopy_sample3(popn, n, num)))

print("Using the vectorized sapply function (on a list) took:" )
print(system.time(sapply_sample(popn, n, num)))

print("Using the vectorized lapply function (on a list) took:" )
print(system.time(lapply_sample(popn, n, num)))




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

