# R code for how statistics for tap reversal distance (mag_data) was analyzed
# Tiffany Timbers

# note - data must be loaded and saved as a data frame called mag_data and data frame only contains the tap # you are analyzing 
# the data frame must have the following columns: 
# 1. rev_dist
# 2. group
# 3. plate

# load libraries
library(nlme)

# fit model
mag_data_model <- lme(rev_dist ~ group, random = ~ 1 | plate, data = mag_data, method = "ML")

# get summary statistics (f-stat & df from ANOVA)
summary(mag_data_model)

# get Tukey's from each group comparison
 summary(glht(mag_data_model, linfct=mcp(group = "Tukey")))
