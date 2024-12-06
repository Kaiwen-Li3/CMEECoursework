setwd("~/Documents/CMEECoursework/WeekFinal/code")

library(dplyr)
library(ggplot2)

MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
dim(MyDF) #check the size of the data frame you loaded
unique(MyDF$Prey.mass.unit)

MyDF <- MyDF %>%
  mutate(
    Prey.mass.g = ifelse(Prey.mass.unit == "mg", Prey.mass / 1000, Prey.mass)
  )


# Plotting
ppplot <- ggplot(MyDF, aes(x = Prey.mass.g, y = Predator.mass, color = Predator.lifestage)) +
  geom_point(shape=4,size=1.0) +
  geom_smooth(method = "lm", se = FALSE, aes(group = Predator.lifestage)) +
  facet_grid(rows = vars(Type.of.feeding.interaction), switch = "y") +
  scale_x_log10() +  # Optional: Log scale if masses span wide ranges
  scale_y_log10() +  # Optional: Log scale for predator mass
  theme_minimal() +
  theme(
    strip.placement = "outside",   # Places facet labels outside the plot
    strip.text.y = element_text(angle = 0)  # Rotates the text for better readability
  ) +
  labs(
    x = "Prey Mass (g)",
    y = "Predator Mass (g)",
    title = "Predator-Prey Mass Relationships",
    color = "Predator Lifestage"
  )


pdf("../results/pp_regress_plot.pdf", width = 10, height = 10) 
print(ppplot)
dev.off()


library(dplyr)

# Group data and fit linear models with error handling
model_results <- MyDF %>%
  group_by(Predator.lifestage, Type.of.feeding.interaction) %>%
  summarize(
    intercept = tryCatch(
      coef(lm(log10(Predator.mass) ~ log10(Prey.mass.g), data = cur_data()))[1],
      error = function(e) NA
    ),
    slope = tryCatch(
      coef(lm(log10(Predator.mass) ~ log10(Prey.mass.g), data = cur_data()))[2],
      error = function(e) NA
    ),
    r_squared = tryCatch(
      summary(lm(log10(Predator.mass) ~ log10(Prey.mass.g), data = cur_data()))$r.squared,
      error = function(e) NA
    ),
    p_value = tryCatch(
      summary(lm(log10(Predator.mass) ~ log10(Prey.mass.g), data = cur_data()))$coefficients[2, 4],
      error = function(e) NA
    )
  )

# View the results
print(model_results)


# Define the file path
output_file <- "../results/PP_Regress_Results.csv"

# Save the results to a CSV file
write.csv(model_results, file = output_file, row.names = FALSE)

# Confirm the save
print("Linear regression results saved to:", output_file, "\n")



#  $ Record.number              : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ In.refID                   : chr  "ATSH063" "ATSH080" "ATSH089" "ATSH143" ...
#  $ IndividualID               : chr  "1" "2" "3" "4" ...
#  $ Predator                   : chr  "Rhizoprionodon terraenovae" "Rhizoprionodon terraenovae" "Rhizoprionodon terraenovae" "Rhizoprionodon terraenovae" ...
#  $ Predator.common.name       : chr  "Atlantic sharpnose shark" "Atlantic sharpnose shark" "Atlantic sharpnose shark" "Atlantic sharpnose shark" ...
#  $ Predator.taxon             : chr  "ectotherm vertebrate" "ectotherm vertebrate" "ectotherm vertebrate" "ectotherm vertebrate" ...
#  $ Predator.lifestage         : chr  "adult" "adult" "adult" "adult" ...
#  $ Type.of.feeding.interaction: chr  "predacious/piscivorous" "predacious/piscivorous" "predacious/piscivorous" "predacious/piscivorous" ...
#  $ Predator.mass              : num  1540 1600 1840 87.6 63.9 79.2 71.2 92.1 79.2 79.2 ...
#  $ Prey.common.name           : chr  "teleosts/molluscs/crustaceans" "teleosts/molluscs/crustaceans" "teleosts/molluscs/crustaceans" "teleosts/molluscs/crustaceans" ...
#  $ Prey.taxon                 : chr  "mixed" "mixed" "mixed" "mixed" ...

#  $ Location                   : chr  "Apalachicola Bay,



#  $ Predator.lifestage         : chr  "adult" "adult" "adult" "adult" ...
#  $ Predator.mass              : num  1540 1600 1840 87.6 63.9 79.2 71.2 92.1 79.2 79.2 ...
#  $ Prey.mass                  : num  14.3 6.02 11.9 8.12 6.56 5.41 4.45 5.98 6.95 5.6 ...
#  $ Prey.mass.unit             : chr  "g" "g" "g" "g" ...
#  $ Type.of.feeding.interaction: chr  "predacious/piscivorous" "predacious/piscivorous" "predacious/piscivorous" "predacious/piscivorous" ...
