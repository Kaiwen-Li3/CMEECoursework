    doit <- function(x) {
    #If the sample is more than 30, take the mean, otherwise return an error
        temp_x <- sample(x, replace = TRUE)
        if(length(unique(temp_x)) > 30) {#only take mean if sample was sufficient
            print(paste("Mean of this sample was:", as.character(mean(temp_x))))
            } 
        else {
            stop("Couldn't calculate mean: too few unique values!")
            }
        }


    set.seed(1345) # again, to get the same result for illustration

    popn <- rnorm(50)

    hist(popn)


#apply doit to 15 samples
    lapply(1:15, function(i) doit(popn))
    result <- lapply(1:15, function(i) try(doit(popn), FALSE))
    class(result)

    result

#preallocation 
    result <- vector("list", 15) #Preallocate/Initialize
    for(i in 1:15) {
        result[[i]] <- try(doit(popn), FALSE)
        }