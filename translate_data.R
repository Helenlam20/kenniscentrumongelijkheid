translate_en <- function(i) {
  i['geografie'][i['geografie'] == 'Nederland'] = 'The Netherlands'
  i['geografie'][i['geografie'] == 'Metropool Amsterdam'] = 'Amsterdam Metropolitan Area'
  
  i['geslacht'][i['geslacht'] == 'Totaal'] = 'Total'
  i['geslacht'][i['geslacht'] == 'Mannen'] = 'Men'
  i['geslacht'][i['geslacht'] == 'Vrouwen'] = 'Women'
  
  i[['migratieachtergrond']] <- revalue(i[['migratieachtergrond']], c(
    "Totaal"="Total", 
    "Zonder migratieachtergrond" = "No Migration Background",
    "Marokko" = "Morocco",
    "Turkije" = "Turkey",
    "Suriname" = "Suriname",
    "Nederlandse Antillen" = "Dutch Caribbean"
  ))
  
  i['huishouden'][i['huishouden'] == 'Totaal'] = 'Total'
  i['huishouden'][i['huishouden'] == 'Eenoudergezin'] = 'Single Parent'
  i['huishouden'][i['huishouden'] == 'Tweeoudergezin'] = 'Two Parents'
  
  i['opleiding_ouders'][i['opleiding_ouders'] == 'Totaal'] = 'Total'
  i['bins'][i['bins'] == 'Totaal'] = 'Total'
  return(i)
}

for (i in c("bins20", "bins10", "bins5", "mean", "parents_edu")) {
  assign(i, read_rds(file.path("./data/nl/", paste0(i, "_tab.rds"))))

}

bins20 <- translate_en(bins20)
bins10 <- translate_en(bins10)
bins5 <- translate_en(bins5)
mean <- translate_en(mean)
parents_edu <- translate_en(parents_edu)

for (i in c("bins20", "bins10", "bins5", "mean", "parents_edu")) {
  write_rds(get(i), file.path("./data/en/", paste0(i, "_tab.rds")))
}


