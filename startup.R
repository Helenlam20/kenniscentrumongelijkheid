

#### LOAD DATA ####
outcome_dat <- read_excel(lang[["loc_outome_table.xlsx"]], sheet = "outcome")
area_dat <- read_excel(lang[["loc_outome_table.xlsx"]], sheet = "area_2")


csv_files <- list.files(path = lang[["loc_data_rds"]], pattern = "\\.csv$", full.names = TRUE)


read_and_cast_csv <- function(file) {
  dt <- fread(file)
  
  dt[, N := as.numeric(N)]
  dt[, parents_income := as.numeric(parents_income)]
  dt[, mean := as.numeric(mean)]
  
  # Ensure all other columns are of type character
  dt <- dt %>% mutate(across(-c(N, mean, parents_income), as.character))
  
  
  return(dt)
}

cols_fact <- c("geografie", "geslacht", "migratieachtergrond", "huishouden", "bins", "opleiding_ouders", "uitkomst",
               "type")

gradient_dat <- csv_files %>% map_dfr(~read_and_cast_csv(.x)) %>%
  mutate_at(cols_fact, factor) 


# txt file for README in download button for data and fig
# temp_txt <- paste(readLines("./data/README.txt"))
temp_txt <- paste0(
  lang[["download_readme_title"]], "\n",
  "================================================================================\n"
  )


