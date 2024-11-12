# Gradients Dashboard Amsterdam
#
# Edit data for the dashboard


# create workspace
rm(list=ls())
options(scipen=999)


#### PACKAGES ####
library(tidyverse)
library(readxl)

# Load gemeente tab
gemeente_tab <- read_excel("~/Documents/GitHub/kenniscentrumongelijkheid/data/nl/outcome_table.xlsx", sheet = "area") 
gemeente_tab <- gemeente_tab %>% 
  filter(type == "Gemeente") %>%
  select(geografie)

# Define bins and outcomes
bins <- c("bins5", "bins10", "bins20", "mean", "parents_edu")
outcomes <- c("child_mortality", "classroom", "elementary_school", "high_school", "perinatal", "students", "main")


for (bin in bins) {
  
  # Set outcomes based on special cases
  if (bin == "parents_edu") {
    outcomes <- c("elementary_school", "perinatal")
  } else {
    outcomes <- c("child_mortality", "classroom", "elementary_school", "high_school", "perinatal", "students", "main")
  }
  
  # Load the Amsterdam data
  amsterdam_path <- paste0("/Users/lilsonea/Documents/GitHub/kenniscentrumongelijkheid/data/nl/", bin, "_tab.rds")
  amsterdam_data <- readRDS(amsterdam_path)
  amsterdam_data <- amsterdam_data %>% 
    mutate(
      N = as.integer(N),
      type = as.character(type),
      uitkomst_NL = as.character(uitkomst_NL)
    )
  
  for (outcome in outcomes) {
    # Load NL data based on conditions
    if (bin %in% c("bins10", "bins20") && outcome == "main") {
      # Combine the two files for "bins10"/"bins20" and "main" outcome
      nl_data <- lapply(1:2, function(i) {
        nl_path <- paste0("/Users/lilsonea/Documents/GitHub/Kansenkloof_Nederland/data/nl/", bin, "_tab_", outcome, "_", i, ".csv")
        read.csv(nl_path)
      }) %>% 
        bind_rows()
    } else {
      # Single file for other cases
      nl_path <- paste0("/Users/lilsonea/Documents/GitHub/Kansenkloof_Nederland/data/nl/", bin, "_tab_", outcome, ".csv")
      nl_data <- read.csv(nl_path)
    }
    
    # Ensure types match
    nl_data <- nl_data %>%
      mutate(type = as.character(type))
    
    # Filter for Amsterdam-specific data from NL dataset
    gemeente_data <- nl_data %>% 
      semi_join(gemeente_tab, by = "geografie")
    
    # Merge gemeente_data into amsterdam_data
    amsterdam_data <- merge(
      amsterdam_data,
      gemeente_data,
      by = c("geografie", "migratieachtergrond", "geslacht", "huishouden", "bins", "uitkomst", "type", "opleiding_ouders"),
      all.x = TRUE,  # Left join
      suffixes = c("", "_updated")
    )
    
    amsterdam_data <- amsterdam_data %>%
      mutate(
        N = case_when(!is.na(N_updated) ~ N_updated, TRUE ~ N),
        mean = case_when(!is.na(mean_updated) ~ mean_updated, TRUE ~ mean),
        parents_income = case_when(!is.na(parents_income_updated) ~ parents_income_updated, TRUE ~ parents_income)
      ) %>%
      select(-ends_with("_updated"))  # Remove the _updated columns after updating
  }
  # Save the updated Amsterdam data
  write_rds(amsterdam_data, amsterdam_path)
}



#Checking differences bins 20 high school

nl <- read.csv("~/Documents/GitHub/Kansenkloof_Nederland/data/nl/bins20_tab_high_school.csv")
ams <- readRDS("/Users/lilsonea/Documents/GitHub/kenniscentrumongelijkheid/data/nl/bins20_tab.rds")

# Define the columns to check
matching_columns <- c("geografie", "migratieachtergrond", "geslacht", "huishouden", "bins", "uitkomst", "type", "opleiding_ouders")

# Loop through each column and compare unique values between `ams` and `nl`
for (column in matching_columns) {
  # Extract unique values for the current column in both datasets
  unique_ams <- unique(ams[[column]])
  unique_nl <- unique(nl[[column]])
  
  # Find values that are only in one of the datasets
  ams_only <- setdiff(unique_ams, unique_nl)
  nl_only <- setdiff(unique_nl, unique_ams)
  
  # Print the differences, if any
  if (length(ams_only) > 0) {
    cat("Values in `ams` but not in `nl` for column", column, ":\n")
    print(ams_only)
  }
  
  if (length(nl_only) > 0) {
    cat("Values in `nl` but not in `ams` for column", column, ":\n")
    print(nl_only)
  }
}

