## Dashboard version
dashboard_version <- system(r"(git log -1 --format="%cd")", intern=TRUE)
if (is_empty(dashboard_version)) {
  dashboard_version <- "N/A"
}

#### LOAD DATA ####
outcome_dat <- read_excel(lang[["loc_outome_table.xlsx"]], sheet = "outcome")
area_dat <- read_excel(lang[["loc_outome_table.xlsx"]], sheet = "area")


for (i in c("bins20", "bins10", "bins5", "mean", "parents_edu")) {
  
  assign(i, read_rds(file.path(lang[["loc_data_rds"]] , paste0(i, "_tab.rds"))))
  
}
rm(i)

# combines gradient data
gradient_dat <- bind_rows(bins20, bins10) 
gradient_dat <- bind_rows(gradient_dat, bins5)
gradient_dat <- bind_rows(gradient_dat, mean)
gradient_dat <- bind_rows(gradient_dat, parents_edu) 
rm(bins20, bins10, bins5, mean, parents_edu)


# txt file for README in download button for data and fig
# temp_txt <- paste(readLines("./data/README.txt"))
temp_txt <- paste0(
  lang[["download_readme_title"]], "\n",
  "================================================================================\n"
  )


