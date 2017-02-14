# R code for how statistics for tap reversal distance (mag_data) was analyzed
# Tiffany Timbers

# note - data must be loaded and saved as a data frame called mag_data and data frame only contains the tap # you are analyzing 
# the data frame must have the following columns: 
# 1. plate
# 2. group
# 3. id
# 4. time
# 5. rev_dist

# load libraries
library(tidyverse)
library(nlme)

# Get arguements from command line
# Make args a list of the items in the command line after the script was called.
args <- commandArgs(trailingOnly = TRUE)
# assign variable names to arguements
data_in_path <- args[1]
data_out_path <- args[2]
base_strain <- args[3]
base_strain_2 <- args[4]

# load data
data <- read_csv(data_in_path)

# make group, id and plate factors
data$group <- as.factor(data$group)
data$plate <- as.factor(data$plate)
data$id <- as.factor(data$id)

# do stats for initial tap (assumes 100s preplate)
tap1 <- data %>% filter(time > 99 & time < 101)
tap1_model <- lme(rev_dist ~ group, random = ~ 1 | plate, data = tap1, method = "ML", na.action = "na.omit")

# get summary statistics (f-stat & df from ANOVA)
summary(tap1_model)

# get Tukey's from each group comparison
 summary(glht(tap1_model, linfct=mcp(group = "Tukey")))
