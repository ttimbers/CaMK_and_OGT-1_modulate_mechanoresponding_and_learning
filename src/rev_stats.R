# R code for how statistics for tap reversal distance (mag_data) was analyzed
# Tiffany Timbers

# the input .csv file must have the following columns: 
# 1. plate
# 2. group
# 3. id
# 4. time
# 5. rev_dist
# 6. tap

# example usage: Rscript rev_stats.R exp2/parsed.csv exp2/stats N2 PY1589

# load libraries
library(tidyverse)
library(nlme)
library(multcomp)
library(broom)

# Get arguements from command line
# Make args a list of the items in the command line after the script was called.
args <- commandArgs(trailingOnly = TRUE)
# assign variable names to arguements
data_in_path <- args[1]
data_out_path <- args[2]
base_strain <- args[3]
base_strain_2 <- args[4]

main <- function() {
  # load data
  data <- read_csv(data_in_path)
  
  # make group, id and plate factors
  data$group <- as.factor(data$group)
  data$plate <- as.factor(data$plate)
  data$id <- as.factor(data$id)
  
  # do stats for base strain for tap 1
  tap_1_stats <- ancova_dist_stats(data, base_strain, 1)
  
  # do stats for base strain for tap 30
  tap_30_stats <- ancova_dist_stats(data, base_strain, 30)
  
  # combine data frames
  tap_stats <- bind_rows(tap_1_stats, tap_30_stats)
  
  if (exists("base_strain_2")) {
    # do stats for second base strain for tap 1 (if exists)
    base2_tap_1_stats <- ancova_dist_stats(data, base_strain_2, 1)
    
    # do stats for second base strain for tap 30 (if exists)
    base2_tap_30_stats <- ancova_dist_stats(data, base_strain_2, 30)
    
    # combine with base_strain stats
    tap_stats <- bind_rows(list(tap_stats, base2_tap_1_stats, base2_tap_30_stats))
  }
  
  # write stats to csv
  write_csv(tap_stats, paste0(data_out_path, "_stats.csv"))
  
  # plot data
  data <- within(data, group <- relevel(group, ref = base_strain))
  summary_data <- data %>% 
    group_by(group, tap) %>% 
    summarise(mean = mean(rev_dist),
              n = n(),
              sd = sd(rev_dist),
              error = qt(0.975, df = n, lower.tail = TRUE) * sd / sqrt(n),
              ci_lower = mean - error,
              ci_upper = mean + error)
  
  rev_dist_plot <- ggplot(summary_data, aes(x = tap, y = mean, color = group)) +
    geom_line() +
    geom_point() +
    geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper)) +
    labs(x = "Time(s)", y = "Reversal Distance (mm)") + 
    theme(legend.title = element_blank(),
          legend.key=element_rect(fill = 'white'),
          panel.background = element_rect(fill = 'white'),
          axis.text.x = element_text(colour = "black"),
          axis.text.y = element_text(colour = "black"),
          axis.line.x = element_line(),
          axis.line.y = element_line()) +
    scale_color_manual(values = c("black", "red", "blue", "green", "lightskyblue", "purple2")) +
    scale_x_continuous(breaks = seq(0, 30, by = 5))
  
  ggsave(paste0(data_out_path, "_fig.pdf"), rev_dist_plot, height = 4, width = 5)        
}

# runs ANCOVA on x (data frame) using ref_strain as reference strain to compare to
# and does it for provided tap number
ancova_dist_stats <- function(x, ref_strain, tap_n) {
  # set base factor
  relevelled_x <- within(x, group <- relevel(group, ref = ref_strain))
  
  # do stats for specified tap 
  tap_data <- relevelled_x %>% filter(tap == tap_n)
  tap_model <- lme(rev_dist ~ group, random = ~ 1 | plate, 
                    data = tap_data, 
                    method = "ML", 
                    na.action = "na.omit")
  
  # get p-values from Tukey's from each group comparison
  tap_stats <- tidy(summary(glht(tap_model, linfct=mcp(group = "Tukey"))))
  tap_stats$tap <- tap_n
  return(tap_stats)
}

main()