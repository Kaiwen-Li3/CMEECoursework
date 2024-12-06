# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

TreeHeight <- function(degrees, distance) {
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    print(paste("Tree height is:", height))
  
    return (height)
}

TreeHeight(37, 40)


#source("TreeHeight.R")

treedf <- read.csv("../data/TreeHeight.csv")
calculated_heights <- apply(treedf, 1, function(row) {
    TreeHeight(as.numeric(row["Angle.degrees"]), as.numeric(row["Distance.m"]))
})

print(calculated_heights)


treedf$calculatedheight <- calculated_heights 

output_file <- "../results/TreeHts.csv"
write.csv(treedf, file = output_file, row.names = FALSE)

