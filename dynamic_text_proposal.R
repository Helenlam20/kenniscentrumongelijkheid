#### Dynamic text proposal ####


## identifiers

data_group1_color = <<color_group1>>
labels_dat$population = <<label_population>>
paste0(perc_html, "%") = <<data_percentage_per_bin>>
decimal0(data_group1$parents_income[as.numeric(1)]*1000) = <<data1_parents_lowest_income>>
decimal0(data_group1$parents_income[as.numeric(num_rows)]*1000) = <<data1_parents_highest_income>>
decimal0(data_group1$parents_income*1000) = <<data2_parents_income>>

paste0(prefix_text, decimal1(data_group1$mean[1]), postfix_text) = <<data1_lowest_mean>>
statistic_type_text = <<statistic_type>>
tolower(labels_dat$outcome_name) = <<label_outcome_name>>
paste0(prefix_text, decimal1(data_group1$mean[1]), postfix_text) = <<data1_lowest_mean>>
paste0(prefix_text, decimal1(data_group1$mean[as.numeric(num_rows)]), postfix_text) = <<data1_highest_mean>>
paste0(prefix_text, decimal1(data_group1$mean), postfix_text) = <<data1_mean>>


labels_dat$outcome_name = <<label_outcome_name>>
labels_dat$population = <<label_population>>
total_group1$mean = <<var_data_total_mean>>


## colors
# Hardcode colors in html
# <b style='color: <<color_group1>>> </b>"


# Implementation
lang_dynamic_map <- hasmap()
lang_dynamic_map[["<<color_group1>>"]] <- data_group2_color

add_dynamic_text <- function(text, lang_dynamic_map) {
    for (identifier in keys(lang_dynamic_map)) {
        str_replace_all(text, identifier, lang_dynamic_map[[identifier]])
    }
    return(text)
}