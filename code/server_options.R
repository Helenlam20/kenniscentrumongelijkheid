# KCO Dashboard 
#
# - styling and functions for the server
#
# (c) Erasmus School of Economics 2022



#### DECIMALS ####

# function decimals and thousand separator
decimal0 <- function(x) {
  num <- format(round(x), big.mark = ".", decimal.mark = ",", scientific = F)
}

decimal1 <- function(x) {
  num <- format(round(x, 1), decimal.mark = ",", big.mark = ".", scientific = F)
}

decimal2 <- function(x) {
  num <- format(round(x, 2), decimal.mark = ",", big.mark = ".", scientific = F)
}




#### HTML COLOR ####

# data group colors

data_group1_color <- "#000000" #fill colors
data_group2_color <- "#fff846" 
data_group1_outline <- "#000000" # outline colors
data_group2_outline <- "#000000" 


# linetype
linetype1_reg <- "longdash"
linetype1_mean <- "longdash"

linetype2_reg <- "dotted"
linetype2_mean <- "dotted"

# Add color functions
add_text_color_html <- function(text, color) {
  # Constructs a string of the form: <span style='color:[[text_color]]'>[[text]]</span>'
  formatted_string <- paste0("<span style='color:", color, "'>", text, "</span>")
  return(formatted_string)
}

add_bold_text_html <- function(text, color, style) {
  formatted_string <- paste0("<b ")
  if (missing(color)) {
    if (missing(style)) {
      formatted_string <- paste0(formatted_string, ">", text)
    } else {
      formatted_string <- paste0(formatted_string, "style=", style, "'>", text)
    }
  } else {
    formatted_string <- paste0(formatted_string, "style='color:", color)
    if (!missing(style)) {
      formatted_string <- paste0(formatted_string, ";", style)
    }
    formatted_string <- paste0(formatted_string, "'>", text)
  }
  formatted_string <- paste0(formatted_string, "</b>")
  return(formatted_string)
}


#### HTML TEXT ####
dummy <- subset(outcome_dat$analyse_outcome, outcome_dat$prefix_postfix == "dummy") 
costs <- subset(outcome_dat$analyse_outcome, outcome_dat$prefix_postfix == "costs") 
years <- subset(outcome_dat$analyse_outcome, outcome_dat$prefix_postfix == "years") 
continuous <- c(subset(outcome_dat$analyse_outcome, outcome_dat$prefix_postfix == "continuous"), costs, years)
# years <- subset(outcome_dat$analyse_outcome, outcome_dat$prefix_postfix == "years") 


# get signs for the outcomes
get_prefix <- function(outcome) {
  prefix <- ""
  if (outcome %in% costs) {
    prefix <- "€ "
  } 
  return(prefix)
}

get_postfix <- function(outcome) {
  postfix <- ""
  if (outcome %in% dummy) {
    postfix <- "%"
  }
  return(postfix)
}



# html text
# html_text <- data.frame(
#   input_text = c("Totaal", "Mannen", "Vrouwen", "Nederland", "Turkije", "Marokko", 
#                  "Suriname", "Nederlandse Antillen"),
#   html_text = c("", "mannelijke", "vrouwelijke", "Nederlandse", "Turkse", "Marokkaanse", 
#                 "Surinaamse", "Antilliaanse")
# )

#### SIGNS FOR HTML TEXT ####

# select percentage based on the data
get_perc_per_bin_html <- function(data_group) {
  perc <- 0
  if ("20_income" %in% unique(data_group$type)) {
    perc <- 5
  } else if ("10_income" %in% unique(data_group$type)) {
    perc <- 10
  } else if ("5_income" %in% unique(data_group$type)) {
    perc <- 20
  } else if ("1_income" %in% unique(data_group$type)) {
    perc <- 100
  }
  return(perc)
}

# get bin 
get_perc_html <- function(data_group1, data_group2) {
  perc1 <- get_perc_per_bin_html(data_group1)
  perc2 <- get_perc_per_bin_html(data_group2)
  # if (!is.null(data_group2)) {perc2 <- get_perc_per_bin_html(data_group2)} else {perc2 <- 0}
  perc <- as.character(max(perc1, perc2))
  return(perc)
}

# select statistics based on an outcome
get_stat_per_outcome_html <- function(sample_dat){
  if (sample_dat$analyse_outcome %in% continuous) {
    stat <- paste0(" ", lang[["statistic_average"]]," ")
  } else if (sample_dat$analyse_outcome %in% dummy) {
    stat <- paste0(" ", lang[["statistic_percentage"]]," ")
  }
  return(stat)
} 

# no data found
# gen_nodata_found <- function(group_type_text) {
#     group_text <- paste0("Geen data gevonden voor de ", group_type_text, ".")
#     return(group_text)
#   }

# Generate text for the "Algemeen" tab
gen_algemeen_group_text <- function(group_type_text, group_data_size, geslacht_input, 
                                    migratie_input, huishouden_input, geografie1_input, geografie2_input, 
                                    populatie_input, lang_dynamic_map) {
  
  lang_dynamic_map[["<<var_group_id_colored>>"]] <- group_type_text
  if (group_data_size <= 0) {
    group_text <- add_dynamic_text(lang[["no_group_data"]], lang_dynamic_map)
    return(group_text)
  }
  
  
  migration_text <- ""
  if (migratie_input == lang[["no_migrationbackground"]])
    migration_text <- add_dynamic_text(lang[["general_text_group_text_without_migration"]], lang_dynamic_map)
  else if (migratie_input != "Totaal" & migratie_input != "Total") {
    lang_dynamic_map[["<<var_input_migration_adjective>>"]] <- lang[["adjective_map"]][[migratie_input]]
    migration_text <- lang[["general_text_group_text_with_migration"]]
  }
  
  lang_dynamic_map[["<<var_input_household>>"]] <- tolower(huishouden_input)
  household_text <- ""
  if (huishouden_input != lang[["total"]])
    household_text <- add_dynamic_text(lang[["general_text_group_text_household"]], lang_dynamic_map)
  
  
  
  lang_dynamic_map[["<<var_group_size>>"]] <- group_data_size
  lang_dynamic_map[["<<var_input_gender_adjective>>"]] <- lang[["adjective_map"]][[geslacht_input]]
  lang_dynamic_map[["<<var_input_population>>"]] <- tolower(populatie_input)
  lang_dynamic_map[["<<general_text_migration_if_available>>"]] <- migration_text
  lang_dynamic_map[["<<general_text_household_if_available>>"]] <- household_text
  lang_dynamic_map[["<<var_input_geography>>"]] <- geografie1_input
  lang_dynamic_map[["<<var_input_smaller_geography>>"]] <- geografie2_input
  
  group_text <- add_dynamic_text(lang[["general_text_groupX"]], lang_dynamic_map)
  
  return(group_text)
}

# # create mean text for tabbox
# gen_mean_text <- function(statistic_type_text, outcome_input, group_type_text, 
#                           total_group_mean, prefix_text, postfix_text) {
#   text <- HTML(paste0("Het totale ", statistic_type_text, tolower(outcome_input), " van de ",  
#                       group_type_text, " is ",paste0(prefix_text, decimal1(total_group_mean), postfix_text), "."))
#   return(text)
# }

# gen_wat_zie_ik_group_text <- function(group_id, lang_dynamic_map) {

  
# }


#### FIGURE PLOT ####


thema <- theme(plot.title = element_text(hjust = 0, size = 18, 
                                         vjust = 1, margin = margin(10,0,10,0)),
               plot.subtitle = element_text(hjust = 0, size = 16,
                                            vjust = 1, margin = margin(0,0,10,0)),
               plot.caption = element_text(hjust = 0, size = 12,
                                           vjust = 1, margin = margin(0,0,10,0)),
               legend.text = element_text(colour = "grey20", size = 16),
               legend.position="right",
               axis.title.y = element_text(size = 16, face = "italic",
                                           margin = margin(0,15,0,0)),
               axis.title.x = element_text(size = 16, face = "italic",
                                           margin = margin(15,0,15,0), vjust = 1),
               axis.text.y = element_text(size = 16, color="#000000",  hjust = 0.5,
                                          margin = margin(0,5,0,0)),
               axis.text.x = element_text(size = 16, color="#000000", margin = margin(5,0,10,0)),
               axis.line.x = element_line(color= "#000000", size = 0.5),
               axis.line.y = element_line(color = "#000000", size = 0.5),
               axis.ticks.x = element_line(color = "#000000", size = 0.5),
               axis.ticks.y = element_line(color = "#000000", size = 0.5),
               axis.ticks.length = unit(1.5, "mm"),
               panel.grid.major.x = element_blank(),
               panel.grid.minor.x = element_blank())


# hovertext
font <- list(
  family = "Arial",
  size = 14,
  color = "#a6a6a6"
)
label <- list(
  bordercolor = "white",
  font = font
)


## function for plot ##
# select percentage based on the data
get_perc_per_bin <- function(data_group) {
  bin <- 100
  if ("20_income" %in% unique(data_group$type)) {
    bin <- "20_income"
  } else if ("10_income" %in% unique(data_group$type)) {
    bin <- "10_income"
  } else if ("5_income" %in% unique(data_group$type)) {
    bin <- "5_income"
  } else if ("1_income" %in% unique(data_group$type)) {
    bin <- "1_income"
  }
  return(bin)
}

# get bin 
get_bin <- function(data_group1, data_group2) {
  bin1 <- get_perc_per_bin(data_group1)
  if (!is.null(data_group2)) {bin2 <- get_perc_per_bin(data_group2)} else {bin2 <- 0}
  
  if (bin2 == 0) {
    bin <- bin1
  } else if (bin1 < bin2) {
    bin <- bin1
  } else if (bin1 > bin2) {
    bin <- bin2
  } else if (bin1 == bin2) {
    bin <- bin1
  }
  bin <- as.character(bin)
  return(bin)
}


#### DOWNLOAD DATA AND FIGURE ####

readme_sep <- c("",                                                                                 
  "================================================================================"
)

caption_sep <- 
"\n\n=========================================================================\n"
caption_license <- paste0(lang[["license_text"]])



# convert html text to plain txt
HTML_to_plain_text <- function(txt) {
  
  pattern <- "</?\\w+((\\s+\\w+(\\s*=\\s*(?:\".*?\"|'.*?'|[^'\">\\s]+))?)+\\s*|\\s*)/?>"
  plain_text <- gsub(pattern, " ", txt)
  
  # TODO: fix pattern to include style. Now it is hardcoded
  style_pattern <- "style='color:#fff846'|style='color:#000000'"
  plain_text <- gsub(style_pattern, "", plain_text)
  plain_text <- gsub("  ", " ", plain_text)
  plain_text <- gsub("^ ", "", plain_text)
}


gen_geom_point <- function(data, color, fill, prefix_text, postfix_text, shape) {
  # Ensure groups are ordered correctly
  data$group <- factor(data$group, levels = c(lang[["black_group"]], lang[["yellow_group"]]))
  
  plot <- ggplot() +
    suppressWarnings(
      geom_point(
        data = data,
        aes(
          x = parents_income,
          y = mean,
          color = group,     # Outline color set by group
          fill = group,
          shape = group,
          text = paste0(
            "<b>", geografie, "</b></br>",
            "</br>", lang[["plot_hover_outcome"]], prefix_text, decimal2(mean), postfix_text,
            "</br>", lang[["plot_hover_parent_income"]], decimal0(parents_income * 1000),
            "</br>", lang[["plot_hover_number_of_people"]], decimal0(N)
          )
        ),
        size = 3,
      )
    ) +
    scale_shape_manual("", values = shape) +
    scale_color_manual("", values = color) + # Outline color for each group
    scale_fill_manual("", values = fill)                  # Fill color for each group
  
  return(plot)
}

gen_highlight_points <- function(data, color) {
  min_max <- data %>%
    filter(parents_income == min(parents_income) |
              parents_income == max(parents_income))

  plot <- geom_point(data = min_max, aes(x = parents_income, y = mean),
                color = color, size = 9, alpha = 0.35)
  return(plot)
}

gen_regression_line <- function(data, color, polynom, linetype) {
  plot <- geom_smooth(data = data, aes(x = parents_income, y = mean),  method = "lm",
            se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), 
            color = color, linetype = linetype) 
  return(plot)
}


gen_mean_line <- function(dat, color, linetype) {
  plot <- geom_abline(
            aes(intercept = dat$mean, slope = 0),
            linetype = linetype, size=0.5, color = color
          ) 
  return(plot)
}


gen_q25_line <- function(dat, color, linetype) {
  plot <- geom_abline(
    aes(intercept = dat$quantile_25, slope = 0),
    linetype = linetype, size=0.5, color = color
  ) 
  return(plot)
}

gen_q75_line <- function(dat, color, linetype) {
  plot <- geom_abline(
    aes(intercept = dat$quantile_75, slope = 0),
    linetype = linetype, size=0.5, color = color
  ) 
  return(plot)
}

gen_bar_plot <- function(data, prefix_text, postfix_text) {
  data$group <- factor(data$group, levels = c(lang[["black_group"]], lang[["yellow_group"]]))
  plot <- ggplot(data, aes(
                x = opleiding_ouders, 
                y = mean, 
                color = group, 
                fill = group,
                text = paste0("<b>", geografie, "</b></br>",
                  "</br>", lang[["plot_hover_outcome"]], prefix_text, decimal2(mean), postfix_text,
                  "</br>", lang[["plot_hover_number_of_people"]], decimal0(N)
                  )
                ))
  
  return(plot)
}

gen_bubble_plot <- function(data, prefix_text, postfix_text) {
  data$group <- factor(data$group, levels = c(lang[["black_group"]], lang[["yellow_group"]]))
  plot <- ggplot() +
    geom_linerange(data = data, aes(x = opleiding_ouders, ymin = 0, ymax = mean, colour = group), 
                   position = position_dodge(width = 1)) +
    suppressWarnings(geom_point(data = data, aes(x = opleiding_ouders, y = mean, colour = group, size = bubble_size, 
                                text = paste0("<b>", geografie, "</b></br>",
                                              "</br>", lang[["plot_hover_outcome"]], prefix_text, decimal2(mean), postfix_text,
                                              # "</br>Bubble size: ", decimal2(bubble_size), "%", 
                                              "</br>", lang[["plot_hover_number_of_people"]], decimal0(N))),
               position = position_dodge(width = 1))) +
    scale_size("", range = c(5, 25), guide = 'none')
  return(plot)
}


get_rounded_slider_steps <- function(data_min, data_max) {
  possible_steps <- c(0.05, 0.1, 0.25, 0.5, 1, 5, 10, 20, 50, 100, 250, 500, 1000, 2500, 5000)
  steps_between = 50

  # Calculate the size of the step
  steps_raw <- (data_max - data_min) / steps_between
  # Round to to the closest possible step
  steps_rounded <- possible_steps[which.min(abs(possible_steps - steps_raw))]
  return(steps_rounded)
}

get_rounded_slider_max <- function(data_max, steps) {
  num_padding_steps = 25
  
  # Calculate the maximum value of the slider to be 20 steps above 
  # the currently selected max value
  slider_max_raw <- data_max + steps*num_padding_steps
  # Round to it to be a multiple of "steps"
  slider_max_rounded <- round_any(slider_max_raw, steps, f = ceiling)
  return(slider_max_rounded)
}

get_rounded_slider_min <- function(data_min, steps, min_zero=FALSE) {
  num_padding_steps = 25

  # Calculate the minimum value of the slider to be 20 steps below 
  # the currently selected max value
  slider_min_raw <- data_min - steps*num_padding_steps
  # Round to it to be a multiple of "steps"
  slider_min_rounded <- round_any(slider_min_raw, steps, f = floor)
  if (min_zero)
    slider_min_rounded <- max(slider_min_rounded, 0)
  return(slider_min_rounded)
}


# tabbox for opleiding ouders
# bar_text_data <- HTML(paste0("<p><b>Opleiding ouders</b> wordt gedefinieerd als de hoogst 
#                               behaalde opleiding van één van de ouders. Voor opleiding 
#                               ouders hebben we drie categorieën: geen wo en hbo, hbo en wo.</p>
  
#                               <p>We kunnen alleen de opleidingen van de ouders bepalen voor de 
#                               jongere geboortecohorten (groep 8 en pasgeborenen), omdat de 
#                               gegevens over de opleidingen van ouders pas beschikbaar zijn 
#                               vanaf 1983 voor wo, 1986 voor hbo en 2004 voor mbo</p>"))

# bar_text_nodata <- HTML(paste0("Geen data gevonden voor de staafdiagrammen"))


# Get formatted datetime
get_datetime <- function() {
  str_replace(format(Sys.time(), "%Y-%m-%d %H-%M-%S"), " ", "_")
} 

add_dynamic_text <- function(text, lang_dynamic_map) {
  for (identifier in keys(lang_dynamic_map)) {
    text <- str_replace_all(text, identifier, paste0(lang_dynamic_map[[identifier]]))
    
  }
  return(text)
}