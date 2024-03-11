# Adjextive_map
# For "lang[["adjective_map"]]" only change the lines with starting with "insert". In those lines change what is after "lang[["adjective_map"]],"
lang[["adjective_map"]] = hashmap()
insert(lang[["adjective_map"]], "Total", "")
insert(lang[["adjective_map"]], "Men", "male")
insert(lang[["adjective_map"]], "Women", "female")
insert(lang[["adjective_map"]], "The Netherlands", "Dutch")
insert(lang[["adjective_map"]], "Turkey", "Turkish")
insert(lang[["adjective_map"]], "Morocco", "Moroccan")
insert(lang[["adjective_map"]], "Suriname", "Surinamese")
insert(lang[["adjective_map"]], "Dutch Caribbean", "Dutch Caribbean")
insert(lang[["adjective_map"]], "With migration background", "")

# Algemeen tekst
# Note: alles tussen <<...>> is een variable die in de server vervangen wordt door dynamische waarde. De betekenis daarvan staan apart gedocumenteerd in een OneDrive excel.
lang[["general_text_plot_order"]] <- "ranked from low to high income "

lang[["general_text_axis_parent_income"]] <- "Each dot in the figure is based on <<data_percentage_per>> of <<input_population>> ranked on the horizontal axis <<general_text_plot_order_if_available>> within the respective group. The vertical axis shows the <<statistic_type>> <<input_outcome_name_lowercase>>."

lang[["general_text_axis_parent_education"]] <- "Each bar in the figure shows the <<statistic_type>> <<input_outcome_name_lowercase>> of <<input_population>>, by highest parental educational attainment"

lang[["general_text_axis_parent_education_lollipop"]] <- "Each lollipop (line and dot) in the figure show the <<statistic_type>> <<input_outcome_name_lowercase>> of <<input_population>>, by highest parental educational attainment. The size of the dot represents the number of individuals within a group mensen dat in de lollipop zit binnen een groep."

lang[["general_text_groupX"]] <- "The <<var_group_id_colored>> consists of <<var_group_size>> <<var_input_gender_adjective>> <<var_input_population>> <<general_text_migration_if_available>> who grew up <<general_text_household_if_available>> in <<var_input_geography>>."

lang[["general_text_group_text_with_migration"]] <- "with a <<var_input_migration_adjective>> migration background"
lang[["general_text_group_text_without_migration"]] <- "without a migration background"

lang[["general_text_group_text_household"]] <- "in a <<var_input_household>> household"

lang[["no_group_data"]] <- "Insufficient data for the <<var_group_id_colored>>."

lang[["general_text"]] <- "<p><b> <<input_outcome_name>> </b> <<input_outcome_name_definition>> </p><p> <<general_text_group1>>   <<general_text_group2>> </p><p> <<general_text_axis>> </p>"

lang[["general_text_explanation_parent_education"]] <- "<p><b>Parental education</b> is defined as the highest completed educational degree of the most highly educated parent. Education consist of three categories: neither higher professional  education nor university; higher professional education; and university.</p> <p>We can only determine the educational attainment of parents for the youngest two cohorts (newborns and pupils in the final grade of primary school) because the information on parental education is only available since 1983 for university, since 1986 for higher professional education, and since 2004 for post-secondary vocational education. Therefore, the category <i>neither higher professional  education nor university</i> cannot be further differentiated.</p>"

lang[["general_text_explanation_parent_income"]] <- "<p><b>Parental income</b> is defined as the average annual joint gross income of the legal parents.</p> <p>We first calculate the average gross annual income of each parent over 2017 and 2018, in 2018 prices. For children for whom we observe both legal parents, we sum the average income of both parents. If only one parent is known, we use only that parent's income.</p>"

# Wat zie ik 
lang[["dot"]] <- "dot"
lang[["bar"]] <- "bar"

lang[["what_do_i_see_text_parent_income_multiple_datapoints"]] <- "<p>The leftmost <<var_group_datapoint_id>> shows that, among the <<data_percentage_per>> <<input_population>> with parents with the lowest incomes in the <<var_group_id>> (on average € <<var_data_parent_lowest_income>> per year), the <<statistic_type>> with a <<input_outcome_name_lowercase>> was <<var_data_lowest_mean>>.</p><p>The rightmost <<var_group_datapoint_id>> shows that, among the <<data_percentage_per>> <<input_population>> with parents with the lowest incomes in the <<var_group_id>> (on average € <<var_data_parent_highest_income>> per year), the <<statistic_type>> with a <<input_outcome_name_lowercase>> was <<var_data_highest_mean>>.</p>" 

lang[["what_do_i_see_text_parent_income_single_datapoint"]] <- "The <<var_group_datapoint_id>> with an annual parental income of on average € <<var_data_parent_income>>, shows that, among <<data_percentage_per>> <<input_population>> the <<statistic_type>> with a <<input_outcome_name_lowercase>> was <<var_data_mean>>."

lang[["what_do_i_see_text_mean"]] <- "The total <<statistic_type>> <<input_outcome_name_lowercase>> of the <<var_group_id_colored>> is <<var_total_mean>>."

lang[["what_do_i_see_text_parent_education"]] <- "The leftmost <<var_group_datapoint_id>> shows that, amond <<input_population>> whose parents have not completed either a higher professional  education or university degree, the <<statistic_type>> <<input_outcome_name_lowercase>> was <<var_data_left_mean>>. The middle <<var_group_datapoint_id>> shows that, among <<input_population>> for whom the highest-educated parent(s) obtained a higher professional  education degree, het <<statistic_type>> <<input_outcome_name_lowercase>> was <<var_data_middle_mean>>. The rightmost <<var_group_datapoint_id>> shows that, among <<input_population>> for whom the highest-educated parent(s) obtained a university degree, the <<statistic_type>> <<input_outcome_name_lowercase>> was <<var_data_right_mean>>"
