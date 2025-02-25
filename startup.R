

#### LOAD DATA ####
outcome_dat <- read_excel(lang[["loc_outome_table.xlsx"]], sheet = "outcome")
area_dat <- read_excel(lang[["loc_outome_table.xlsx"]], sheet = "area")

# Define sample names
samples <- c("child_mortality", "classroom", "elementary_school", 
             "high_school", "main", "perinatal", "students")

# Load all RDS files into a named list
data_list <- lapply(samples, function(sample) {
  read_rds(file.path(lang[["loc_data_rds"]], paste0(sample, ".rds")))
})
names(data_list) <- samples  # Assign names to the list

# Combine all datasets into one (if needed)
gradient_dat <- bind_rows(data_list)

# txt file for README in download button for data and fig
# temp_txt <- paste(readLines("./data/README.txt"))
temp_txt <- paste0(
  lang[["download_readme_title"]], "\n",
  "================================================================================\n"
  )


