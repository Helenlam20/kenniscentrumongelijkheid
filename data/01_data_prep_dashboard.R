# Gradients Metropool Amsterdam
#
# Edit data for the dashboard


# create workspace
rm(list=ls())
options(scipen=999)


#### PACKAGES ####
library(tidyverse)
library(readxl)

# add NL name
outcome_tab <- read_excel("~/Documents/GitHub/kenniscentrumongelijkheid/data/nl/outcome_table.xlsx") 
outcome_tab <- outcome_tab %>%
  select(analyse_outcome, outcome_name)

# directories
for (i in c("mean", "parents_edu", "median", "bins5", "bins10", "bins20")) {
  file_path <- paste0("~/Documents/GitHub/kenniscentrumongelijkheid/data/nl/", i, "_tab.rds")
  data <- readRDS(file_path)
  
  if (i == "bins20") {
    bin <- "20"
  } else if (i == "bins10") {
    bin <- "10"
  } else if (i == "bins5") {
    bin <- "5"
  } else if (i == "mean") {
    bin <- "1"
  } else if (i == "parents_edu") {
    bin <- "parents_edu"
  } else if (i == "median") {
    bin <- "median"
  }
  
  # add type of data
  data = select(data, -uitkomst_NL)
  data <- data %>%
    mutate(type = bin, 
           opleiding_ouders = coalesce(opleiding_ouders, "Totaal"),
           migratieachtergrond = case_when(
             migratieachtergrond == "Nederland" ~ "Zonder migratieachtergrond",
             TRUE ~ as.character(migratieachtergrond)
            )    
           ) %>%
    left_join(outcome_tab, c("uitkomst" = "analyse_outcome")) %>%
    rename(uitkomst_NL = outcome_name)
  
  write_rds(data, file_path)
}
  
