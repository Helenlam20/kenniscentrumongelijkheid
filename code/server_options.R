# KCO Dashboard 
#
# - styling and functions for the server
#
# (c) Erasmus School of Economics 2022



#### DECIMALS ####

# function decimals and thousand seperator
decimal0 <- function(x) {
  num <- format(round(x), big.mark = ".", decimal.mark = ",", scientific = F)
}

decimal2 <- function(x) {
  num <- format(round(x, 2), decimal.mark = ",", big.mark = ".", scientific = F)
}




#### HTML COLOR ####

# data group colors
data_group1_color <- "#3498db"
data_group2_color <- "#18bc9c" 


# Add color functions
add_text_color_html <- function(text, color) {
  # Constructs a string of the form: <span style='color:[[text_color]]'>[[text]]</span>'
  formatted_string <- paste0("<span style='color:", color, "'>", text, "</span>")
  return(formatted_string)
}

add_bold_text_html <- function(text, color) {
  if (missing(color)) {
    formatted_string <-  paste0("<b>", text, "</b>")
  } else {
    formatted_string <-  paste0("<b style='color:", color, "'>", text, "</b>")
  }
  return(formatted_string)
}



#### HTML TEXT ####
dummy <- c("c00_infant_mortality", "c00_sga", "c00_preterm_birth", 
           "c11_vmbo_gl_final", "c11_havo_final", "c11_vwo_final", 
           "c11_vmbo_gl_test", "c11_havo_test", "c11_vwo_test",
           "c11_over_advice", "c11_under_advice", "c11_math", "c11_language", 
           "c11_reading", "c11_youth_protection", 
           "c16_vmbo_gl", "c16_havo", "c16_vwo", "c16_youth_protection",  
           "c21_high_school_attained", "c21_hbo_followed", "c21_uni_followed", 
           "c30_hbo_attained", "c30_wo_attained", "c30_flex_contract",
           "c30_employed", "c30_social_assistance", "c30_disability", 
           "c30_basic_mhc", "c30_specialist_mhc", "c30_hospital", "c30_pharma", 
           "c30_debt", "c30_home_owner")


costs <- c("c11_youth_health_costs", "c16_youth_health_costs", "c30_income",
           "c30_wealth", "c30_hourly_wage", "c30_total_health_costs")

continuous <- c("c16_living_space_pp", "c11_living_space_pp", "c30_hrs_work_pw", costs) 


# html text
html_text <- data.frame(
  input_text = c("Totaal", "Mannen", "Vrouwen", "Nederland", "Turkije", "Marokko", "Suriname", "Nederlandse Antillen"),
  html_text = c("", "mannelijke", "vrouwelijke", "Nederlandse", "Turkse", "Marokkaanse", "Surinaamse", "Antilliaanse")
)

#### SIGNS FOR HTML TEXT ####

# select percentage based on the data
get_perc_per_bin_html <- function(data_group) {
  perc <- NULL
  if ("20" %in% unique(data_group$type)) {
    perc <- 5
  } else if ("10" %in% unique(data_group$type)) {
    perc <- 10
  } else if ("5" %in% unique(data_group$type)) {
    perc <- 20
  } else if ("1" %in% unique(data_group$type)) {
    perc <- 100
  }
  return(perc)
}

# get bin 
get_bin_html <- function(data_group1, data_group2) {
  perc1 <- get_perc_per_bin_html(data_group1)
  if (!is.null(data_group2)) {perc2 <- get_perc_per_bin_html(data_group2)} else {perc2 <- 0}
  perc <- as.character(max(perc1, perc2))
  return(perc)
}

# select statistics based on an outcome
get_stat_per_outcome_html <- function(sample_dat){
  if (sample_dat$analyse_outcome %in% continuous) {
    stat <- " gemiddelde "
  } else if (sample_dat$analyse_outcome %in% dummy) {
    stat <- " percentage "
  }
  return(stat)
} 


# get signs for the outcomes
get_prefix <- function(outcome) {
  prefix <- ""
  if (outcome == "Persoonlijk inkomen" | outcome == "Uurloon" |
      outcome == "Zorgkosten" | outcome == "Vermogen" |
      outcome == "Jeugd zorgkosten van tieners" |
      outcome == "Jeugd zorgkosten van kinderen" ) {
    prefix <- "€ "
  } 
  return(prefix)
}

get_postfix <- function(outcome) {
  postfix <- ""
  if (outcome != "Uren werk per week" &
      outcome != "Woonoppervlak per lid huishouden van kinderen" &
      outcome != "Woonoppervlak per lid huishouden van tieners" & 
      outcome != "Persoonlijk inkomen" & outcome != "Uurloon"&
      outcome != "Zorgkosten" & outcome != "Vermogen" &
      outcome != "Jeugd zorgkosten van tieners" &
      outcome != "Jeugd zorgkosten van kinderen") {
    postfix <- "%"
  }
  return(postfix)
}



# Generate text for the "Algemeen" tab
gen_algemeen_group_text <- function(group_type_text, group_data_size, geslacht_input, 
                                    migratie_input, huishouden_input, geografie_input, 
                                    populatie_input) {
  
  if (group_data_size <= 0) {
    group_text <- paste0("Geen data gevonden voor de ", group_type_text, ".")
    return(group_text)
  }

  sex_text <- subset(html_text$html_text, html_text$input_text == geslacht_input)
  migration_text <- ""
  household_text <- ""

  if (migratie_input != "Totaal" & migratie_input != "Zonder migratieachtergrond")
    migration_text <- paste("met een", subset(html_text$html_text, html_text$input_text == migratie_input), "migratieachtergrond")
  else if (migratie_input == "Zonder migratieachtergrond")
    migration_text <- paste0(("zonder een migratieachtergrond"))

  
  if (huishouden_input != "Totaal")
    household_text <- paste("in een", tolower(huishouden_input))

  group_text <- HTML(paste("De", group_type_text, "bestaat uit", group_data_size, sex_text, 
                            populatie_input, migration_text, "die zijn opgegroeid", household_text, 
                            "in", paste0(geografie_input, "."))) # "paste0" to ensure the full stop (".") doesn't have a space before
  
  return(group_text)
}


#### FIGURE PLOT ####


thema <- theme(plot.title = element_text(hjust = 0, size = 18, 
                                         vjust = 1, margin = margin(10,0,10,0)),
               plot.subtitle = element_text(hjust = 0, size = 16,
                                            vjust = 1, margin = margin(0,0,10,0)),
               legend.text = element_text(colour = "grey20", size = 16),
               legend.position = "none",
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
  family = "Helvetica",
  size = 14,
  color = "white"
)
label <- list(
  bordercolor = "white",
  font = font
)


## function for plot ##
# select percentage based on the data
get_perc_per_bin <- function(data_group) {
  bin <- 100
  if ("20" %in% unique(data_group$type)) {
    bin <- 20
  } else if ("10" %in% unique(data_group$type)) {
    bin <- 10
  } else if ("5" %in% unique(data_group$type)) {
    bin <- 5
  } else if ("1" %in% unique(data_group$type)) {
    bin <- 1
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

# convert html text to plain txt
HTML_to_plain_text <- function(txt) {
  
  pattern <- "</?\\w+((\\s+\\w+(\\s*=\\s*(?:\".*?\"|'.*?'|[^'\">\\s]+))?)+\\s*|\\s*)/?>"
  plain_text <- gsub(pattern, " ", txt)
  
  # TODO: fix pattern to include style. Now it is hardcoded
  style_pattern <- "style='color:#18bc9c'|style='color:#3498db'"
  plain_text <- gsub(style_pattern, "", plain_text)
  plain_text <- gsub("  ", " ", plain_text)
  plain_text <- gsub("^ ", "", plain_text)
}


# Plotting functions
gen_geom_point <- function(data, input_geography, color, prefix_text, postfix_text, shape) {
  plot <- geom_point(
    data=data, 
    aes(x=parents_income, y=mean, text=paste0("<b>", input_geography, "</b></br>",
                                     "</br>Inkomen ouders: €", decimal2(parents_income),
                                     "</br>Uitkomst: ", prefix_text, decimal2(mean), postfix_text,
                                     "</br>Aantal mensen: ", decimal2(N))), 
    color=color, size=3, shape=shape
    )
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

gen_regression_line <- function(data, color, polynom) {
  plot <- geom_smooth(data = data, aes(x = parents_income, y = mean),  method = "lm",
            se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), 
            color = color, linetype = "longdash") 
  return(plot)
}


gen_mean_line <- function(total_group, color) {
  plot <- geom_abline(
            aes(intercept = total_group$mean, slope = 0),
            linetype = "twodash", size=0.5, color = color
          ) 
  return(plot)
}

gen_bar_plot <- function(data, prefix_text, postfix_text) {
  plot <- ggplot(data, aes(x = opleiding_ouders, y = mean, fill = group, 
                text = paste0("<b>", geografie, "</b></br>",
                "</br>Uitkomst: ", prefix_text, decimal2(mean), postfix_text,
                "</br>Aantal mensen: ", decimal2(N)))
                )
  return(plot)
}


# TEST
# data_group1 <- subset(gradient_dat, gradient_dat$uitkomst_NL == "Laag geboortegewicht" &
#                         gradient_dat$geografie == "Nederland" &
#                         gradient_dat$geslacht == "Totaal" &
#                         gradient_dat$migratieachtergrond == "Totaal" &
#                         gradient_dat$huishouden == "Totaal")
# 
# 
# data_group2 <- subset(gradient_dat, gradient_dat$uitkomst_NL == "Laag geboortegewicht" &
#                         gradient_dat$geografie == "Amsterdam" &
#                         gradient_dat$geslacht == "Totaal" &
#                         gradient_dat$migratieachtergrond == "Totaal" &
#                         gradient_dat$huishouden == "Totaal")







