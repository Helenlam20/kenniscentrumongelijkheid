translate_en <- function(i) {
  levels(i$geografie)[match("Nederland",levels(i$geografie))] <- "The Netherlands"
  levels(i$geografie)[match("Metropool Amsterdam",levels(i$geografie))] <- "Amsterdam Metropolitan Area"
  
  levels(i$geslacht)[match("Totaal",levels(i$geslacht))] <- "Total"
  levels(i$geslacht)[match("Mannen",levels(i$geslacht))] <- "Men"
  levels(i$geslacht)[match("Vrouwen",levels(i$geslacht))] <- "Women"
  
  levels(i$migratieachtergrond)[match("Totaal",levels(i$migratieachtergrond))] = "Total"
  levels(i$migratieachtergrond)[match("Zonder migratieachtergrond",levels(i$migratieachtergrond))] = "No Migration Background"
  levels(i$migratieachtergrond)[match("Marokko",levels(i$migratieachtergrond))] = "Morocco"
  levels(i$migratieachtergrond)[match("Turkije",levels(i$migratieachtergrond))] = "Turkey"
  levels(i$migratieachtergrond)[match("Suriname",levels(i$migratieachtergrond))] = "Suriname"
  levels(i$migratieachtergrond)[match("Nederlandse Antillen",levels(i$migratieachtergrond))] = "Dutch Caribbean"
  levels(i$migratieachtergrond)[match("Wel migratieachtergrond",levels(i$migratieachtergrond))] = "With Migration Background"
  
  
  levels(i$huishouden)[match("Totaal",levels(i$huishouden))] <- "Total"
  levels(i$huishouden)[match("Eenoudergezin",levels(i$huishouden))] <- "Single Parent"
  levels(i$huishouden)[match("Tweeoudergezin",levels(i$huishouden))] <- "Two Parents"
  
  
  if ("opleiding_ouders" %in% names(i)) {
    levels(i$opleiding_ouders)[match("Totaal",levels(i$opleiding_ouders))] <- "Total"
  }
  
  
  levels(i$bins)[match("Totaal",levels(i$bins))] <- "Total"
  
  return(i)
}

for (i in c("bins20", "bins10", "bins5", "mean", "parents_edu")) {
  assign(i, read_rds(file.path("./data/nl/", paste0(i, "_tab.rds"))))
  
}



# this is only necessary if new data has manually been added. The variable types need to be converted
# to factors for the translation to work!!

# library(magrittr)
cols <- c("geografie", "geslacht", "migratieachtergrond", "huishouden", "bins", "uitkomst", "type", "uitkomst_NL", "opleiding_ouders")
bins5 %<>% mutate_at(cols, factor)
bins10 %<>% mutate_at(cols, factor)
bins20 %<>% mutate_at(cols, factor)
mean %<>% mutate_at(cols, factor)
parents_edu %<>% mutate_at(cols, factor)



bins20 <- translate_en(bins20)
bins10 <- translate_en(bins10)
bins5 <- translate_en(bins5)
mean <- translate_en(mean)
parents_edu <- translate_en(parents_edu)

for (i in c("bins20", "bins10", "bins5", "mean", "parents_edu")) {
  write_rds(get(i), file.path("./data/en/", paste0(i, "_tab.rds")))
}
