#a simple way to debug is browser()
#it allows insertion of a breakpoint in your script and then step through your code


Exponential <- function(N0 = 1, r = 1, generations = 10) {
  # Runs a simulation of exponential growth
  # Returns a vector of length generations
  
  N <- rep(NA, generations)    # Creates a vector of NA
  
  N[1] <- N0
  for (t in 2:generations) {
    N[t] <- N[t-1] * exp(r)
    browser()
  }
  return (N)
}

plot(Exponential(), type="l", main="Exponential growth")
#the script will be run until the first iteration of the for loop and the console will enter browser mode
#now you can examine the variables present at that point
