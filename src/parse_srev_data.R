# Rscript to take data.srev created by call_chore.sh and give back a csv file
# which has the following columns:
# 1. plate
# 2. group
# 3. id
# 4. time
# 5. rev_dist
#
# requires arguments:
# 1. path to data file (data.srev)
# 2. path to save parsed data to
# 3. stimulus onset (optional)
# 4. isi (optional)
#
# example usage: Rscript src/parse_srev_data.R exp2/data.srev exp2/parsed.srev 100 60

# load libraries
library(tidyverse)
library(stringr)

# Get arguements from command line
# Make args a list of the items in the command line after the script was called.
args <- commandArgs(trailingOnly = TRUE)
# assign variable names to arguements
data_in_path <- args[1]
data_out_path <- args[2]
stimulus_onset <- as.numeric(args[3])
isi <- as.numeric(args[4])

## load data into R (data.srev)
data <- read_delim(data_in_path, col_names = FALSE, delim = " ")

# extract plate information from first column (X1). Plate is the date (8 numeric characters) and an underdash (-) and the time (6 numeric characters: HH:MM:SS)
plate <- str_extract(data$X1, "[0-9]{8}_[0-9]{6}")

# extract strain information from first column (X1). We are trying to be flexible to grab the correct info whether someone enters the strain name, the gene name, or the allele name. It might be better to be more limited and consistent about what one enters into the filename in the MWT Tracker program for filename.
strain <- str_extract(data$X1,"[0-9]{6}/[A-Za-z]+[-]?[0-9]*[A-Za-z]*")
strain <- sub("[0-9]+/", "", strain)
# convert all to uppercase (incase there's a mix)
strain <- toupper(strain)

# extract wormID from first column (X1). Time gets included into the path string when we use grep to combine all the files. It's format is: rev:#####
id <- str_extract(data$X1, ":[0-9]{5}")
id <- sub(":", "", id)

# combine to make the dataframe we want
parsed_data <- data.frame(plate,
                   group = strain,
                   id,
                   time = as.numeric(data$X2),
                   rev_dist = as.numeric(data$X4))

if (exists("stimulus_onset") & exists("isi")) {
  # convert times to tap numbers
  parsed_data$tap <- round(((parsed_data$time - stimulus_onset) / isi) + 1) %>% 
    as.integer()
}

# write data to file
write_csv(parsed_data, data_out_path)