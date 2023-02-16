# Adjextive_map
# For "lang[["adjective_map"]]" only change the lines with starting with "insert". In those lines change what is after "lang[["adjective_map"]],"
lang[["adjective_map"]] = hashmap()
insert(lang[["adjective_map"]], "Totaal", "")
insert(lang[["adjective_map"]], "Mannen", "mannelijke")
insert(lang[["adjective_map"]], "Vrouwen", "vrouwelijke")
insert(lang[["adjective_map"]], "Nederland", "Nederlandse")
insert(lang[["adjective_map"]], "Turkije", "Turkse")
insert(lang[["adjective_map"]], "Marokko", "Marokkaanse")
insert(lang[["adjective_map"]], "Suriname", "Surinaamse")
insert(lang[["adjective_map"]], "Nederlandse Antillen", "Antilliaanse")

# Algemeen tekst
lang[["general_text_plot_order"]] <- " gerangschikt van laag naar hoog ouderlijk inkomen "

lang[["general_text_axis_parent_income"]] <- "Elke stip in het figuur is gebaseerd op <<plot_bar_bin_percentage>>% van de <<input_population>> op de horizontale as <<general_text_plot_order_if_available>> binnen de betreffende groep. De verticale as toont het <<statistic_type>> <<input_outcome_name_lowercase>>."

lang[["general_text_axis_parent_education"]] <- "Elke staaf in het figuur toont het <<statistic_type>> met een <<input_outcome_name_lowercase>> van <<input_population>>, uitgesplitst naar het hoogst behaalde opleidingsniveau van de ouders."

lang[["general_text_axis_parent_education_lollipop"]] <- "Elke lollipop (lijn met stip) in het figuur toont het <<statistic_type>> met een <<input_outcome_name_lowercase>> van <<input_population>>, uitgesplitst naar het hoogst behaalde opleidingsniveau van de ouders. De bolgrootte is afhankelijk van het aantal mensen dat in de lollipop zit binnen een groep.  Hierdoor kan de gebruiker in één oogopslag zien hoeveel mensen er in een lollipop zitten."

lang[["general_text_groupX"]] <- "De <<var_group_id_colored>> bestaat uit <<var_group_size>> <<var_input_gender_adjective>> <<var_input_population>> <<general_text_migration_if_available>> die zijn opgegroeid <<general_text_household_if_available>> in <<var_input_geography>>."

lang[["general_text_group_text_with_migration"]] <- "met een <<var_input_migration_adjective>> migratieachtergrond"
lang[["general_text_group_text_without_migration"]] <- "zonder een migratieachtergrond"

lang[["general_text_group_text_household"]] <- "in een <<var_input_household>>"

lang[["no_group_data"]] <- "Geen data gevonden voor de <<var_group_id_colored>>."

lang[["general_text"]] <- "<p><b> <<input_outcome_name>> </b> <<input_outcome_name_definition>> </p><p> <<general_text_group1>>   <<general_text_group2>> </p><p> <<general_text_axis>> </p>"

lang[["general_text_explanation_parent_education"]] <- "<p><b>Opleiding ouders</b> wordt gedefinieerd als de hoogst behaalde opleiding van één van de ouders. Voor opleiding ouders hebben we drie categorieën: geen wo en hbo, hbo en wo.</p> <p>We kunnen alleen de opleidingen van de ouders bepalen voor de jongere geboortecohorten (groep 8 en pasgeborenen), omdat de gegevens over de opleidingen van ouders pas beschikbaar zijn vanaf 1983 voor wo, 1986 voor hbo en 2004 voor mbo.  Het opleidingsniveau <i>geen hbo of wo</i> kan hierdoor niet verder gedifferentieerd worden.</p>"

lang[["general_text_explanation_parent_income"]] <- "<p><b>Inkomen ouders</b> wordt gedefinieerd als het gemiddelde gezamelijk bruto-inkomen van ouders.</p> <p>We berekenen eerst het gemiddeld bruto-inkomen van elk ouder gemeten in 2018 euro's. Voor de kinderen waarvan twee ouders bekend zijn, tellen we het gemiddelde inkomen van de ouders bij elkaar op. Als slechts een ouder bekend is, dan gebruiken we alleen dat inkomen van de ouder.</p>"

# Wat zie ik 
lang[["dot"]] <- "stip"
lang[["bar"]] <- "staaf"

lang[["what_do_i_see_text_parent_income_multiple_datapoints"]] <- "<p>De meest linker <<var_group_datapoint_id>> laat zien dat, voor de <<data_percentage_per_bin>> <<input_population>> met ouders met de laagste inkomens in de <<var_group_id>> (gemiddeld € <<var_data_parent_lowest_income>> per jaar), het <<statistic_type>> met een <<input_outcome_name_lowercase>> <<var_data_lowest_mean>> was.</p><p>De meest rechter <<var_group_datapoint_id>> laat zien dat, voor de <<data_percentage_per_bin>> <<input_population>> met ouders met de hoogste inkomens in de blauwe groep (gemiddeld € <<var_data_parent_highest_income>> per jaar), het <<statistic_type>> met een <<input_outcome_name_lowercase>> <<var_data_highest_mean>> was.</p>" 

lang[["what_do_i_see_text_parent_income_single_datapoint"]] <- "De <<var_group_datapoint_id>> met een jaarlijks inkomen ouders van € <<var_data_parent_income>>, laat zien dat, voor de <<data_percentage_per_bin>> <<input_population>> het <<statistic_type>> met een <<input_outcome_name_lowercase>> <<var_data_mean>> was."

lang[["what_do_i_see_text_mean"]] <- "Het totale <<statistic_type>> <<input_outcome_name_lowercase>> van de <<var_group_id_colored>> is <<var_total_mean>>."