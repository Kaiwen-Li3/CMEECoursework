#Create a 10x10 matrix filled with 100 random numbers
#Calculate the mean / variance of each row, and mean of each column


M <- matrix(rnorm(100), 10, 10)

RowMeans <- apply(M, 1, mean)
# apply(X, margin, function)
#for a matrix margin 1 indicates rows, 2 columns, c(1,2) rows and columns
print (RowMeans)

RowVars <- apply(M, 1, var)
print(RowVars)


ColMeans <- apply(M, 2, mean)