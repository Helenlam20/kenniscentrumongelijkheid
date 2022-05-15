#### LOAD DATA ####
outcome_dat <- read_excel("./data/outcome_table.xlsx", sheet = "outcome")
area_dat <- read_excel("./data/outcome_table.xlsx", sheet = "area")


for (i in c("bins_20", "bins_10", "bins_5", "total", "parents_edu")) {
  
  assign(i, read_rds(file.path("./data/", paste0(i, "_tab.rds"))))
  
}
rm(i)

# combines gradient data
gradient_dat <- bind_rows(bins_20, bins_10) 
gradient_dat <- bind_rows(gradient_dat, bins_5)
gradient_dat <- bind_rows(gradient_dat, total)
gradient_dat <- bind_rows(gradient_dat, parents_edu) 
rm(bins_20, bins_10, bins_5, total, parents_edu)


# txt file for README in download button for data and fig
temp_txt <- paste(readLines("./data/README.txt"))


