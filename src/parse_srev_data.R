# Rscript to take data.srev created by call_chore.sh and give back a csv file
# which has the following columns:
# 1. plate
# 2. group
# 3. id
# 4. time
# 5. rev_dist
#
# example usage: Rscript src/parse_srev_data.R exp2/data.srev exp2/parsed.srev

# load libraries
library(tidyverse)
library(stringr)

# Get arguements from command line
# Make args a list of the items in the command line after the script was called.
args <- commandArgs(trailingOnly = TRUE)
# assign variable names to arguements
data_in_path <- args[1]
data_out_path <- args[2]

## load data into R (data.srev)
data <- read_table(data_in_path, col_names = FALSE)

# extract plate information from first column (X1). Plate is the date (8 numeric characters) and an underdash (-) and the time (6 numeric characters: HH:MM:SS)
plate <- str_extract(data$X1, "[0-9]{8}_[0-9]{6}")

# extract strain information from first column (X1). We are trying to be flexible to grab the correct info whether someone enters the strain name, the gene name, or the allele name. It might be better to be more limited and consistent about what one enters into the filename in the MWT Tracker program for filename.
strain <- str_extract(data$X1,"[0-9]{6}/[A-Za-z]+[-]?[0-9]*[A-Za-z]*")
strain <- sub("[0-9]+/", "", strain)
# convert all to uppercase (incase there's a mix)
strain <- toupper(strain)

# extract wormID from first column (X1). Time gets included into the path string when we use grep to combine all the files. It's format is: rev:#####
id <- str_extract(data$X1, "rev:[0-9]{5}")
id <- sub("rev:", "", id)

# split column X2 into components (time of reversal, reversal distance and reversal duration)
data <- separate(data, X2, into = c("time", "garbage", "distance", "duration"), sep = " ")

# combine to make the dataframe we want
parsed_data <- data.frame(plate,
                   group = strain,
                   id,
                   time = as.numeric(data$time),
                   rev_dist = as.numeric(data$distance))

# write data to file
write_csv(parsed_data, data_out_path)