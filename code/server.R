# KCO Dashboard 
#
# - server: a server function
# - The server function contains the instructions that your computer needs to build your app.
#
# (c) Erasmus School of Economics 2022



#### STYLING ####
source("./code/server_options.R")



#### DEFINE SERVER ####
server <- function(input, output, session) {
  
  # welcome pop-up
  observeEvent(input$beginscherm, {
      sendSweetAlert(
        session = session,
        title = lang[["welcome_popup_title"]],
        text = HTML(lang[["welcome_popup_text"]]),
        btn_labels = lang[["welcome_popup_continue"]],
        btn_colors = "#fff846",
        html = TRUE,
        closeOnClickOutside = TRUE,
        showCloseButton = TRUE,
        imageUrl = "KCO_logo.png",
        imageWidth = 210,
        imageHeight = 140
      )
  })

  observeEvent(input$reset_cookies, {
    confirmSweetAlert(
      session = getDefaultReactiveDomain(),
      "remove_cookies",
      title = lang[["cookie_popup_title"]],
      text = lang[["cookie_popup_text"]],
      type = NULL,
      btn_labels = c(lang[["no"]], lang[["yes"]] ),
      btn_colors = c("#fff846", "#fff846"),
      closeOnClickOutside = TRUE,
      showCloseButton = TRUE,
      allowEscapeKey = TRUE,
      cancelOnDismiss = TRUE,
      html = TRUE,
      imageUrl = "KCO_logo.png",
      imageWidth = 210,
      imageHeight = 140
    )
  })

  observeEvent(input$remove_cookies, {
    if(input$remove_cookies) {
      runjs('Object.keys(Cookies.get()).forEach(function(cookieName) {Cookies.remove(cookieName);});')
    }
  })

  
  # text of tabbox 1 for parents characteristics
  observeEvent(input$parents_options, {
    selected_option <- input$SwitchTabbox1
    
    if (input$parents_options == lang[["parent_education"]] ) {
      
      if (selected_option != lang[["outcome_measure"]] ) {selected_option <- lang[["parent_education"]] }
      
      updatePrettyRadioButtons(session, "SwitchTabbox1", label = lang[["box_text_switch_label"]], 
                               choices = c(lang[["outcome_measure"]] , lang[["parent_education"]] ),
                               inline = TRUE, 
                               selected = selected_option, 
                               prettyOptions = list(
                                 icon = icon("check"),
                                 bigger = TRUE,
                                 status = "info", 
                                 animation = "smooth"))
                               
    } else {
      
      if (selected_option != lang[["outcome_measure"]] ) {selected_option <- lang[["parent_income"]] }
      
      updatePrettyRadioButtons(session, "SwitchTabbox1", label = lang[["box_text_switch_label"]], 
                               choices = c(lang[["outcome_measure"]] , lang[["parent_income"]] ),
                               inline = TRUE, 
                               selected = selected_option, 
                               prettyOptions = list(
                                 icon = icon("check"),
                                 bigger = TRUE,
                                 status = "info", 
                                 animation = "smooth"))
    }
  })

  # take a screenshot
  observeEvent(input$screenshot, {
    screenshot(scale = 1,
               filename = paste0("screenshot ", get_datetime()))
  }, ignoreInit = FALSE)
  
  
  vals <- reactiveValues()

  # REACTIVE ----------------------------------------------------------
  
  dataInput1 <- reactive({
    if (input$geografie1_2 == "") {
    data_group1 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                            gradient_dat$geografie == input$geografie1_1 & 
                            gradient_dat$geslacht == input$geslacht1 &
                            gradient_dat$migratieachtergrond == input$migratie1 & 
                            gradient_dat$huishouden == input$huishouden1)
    } else {
      data_group1 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                              gradient_dat$geografie == input$geografie1_2 & 
                              gradient_dat$geslacht == input$geslacht1 &
                              gradient_dat$migratieachtergrond == input$migratie1 & 
                              gradient_dat$huishouden == input$huishouden1)
    }
  })
  
  dataInput2 <- reactive({
    if (input$geografie2_2 == "") {
      data_group2 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                              gradient_dat$geografie == input$geografie2_1 & 
                              gradient_dat$geslacht == input$geslacht2 &
                              gradient_dat$migratieachtergrond == input$migratie2 & 
                              gradient_dat$huishouden == input$huishouden2)
    } else {
      data_group2 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                              gradient_dat$geografie == input$geografie2_2 & 
                              gradient_dat$geslacht == input$geslacht2 &
                              gradient_dat$migratieachtergrond == input$migratie2 & 
                              gradient_dat$huishouden == input$huishouden2)
    }
  })
  
  output$geografie1_2 <- renderUI({
    GeoChoices_2_1 <- list("",
                           sort(subset(area_dat$area, area_dat$type == lang[["label_district"]] & area_dat$gemeente == input$geografie1_1)),
                           sort(subset(area_dat$area, area_dat$type == lang[["label_pc3"]] & area_dat$gemeente == input$geografie1_1)),
                           sort(subset(area_dat$area, area_dat$type == lang[["label_neighborhood"]] & area_dat$gemeente == input$geografie1_1)),
                           sort(subset(area_dat$area, area_dat$type == lang[["label_area"]] & area_dat$gemeente == input$geografie1_1))
    )
    
    names(GeoChoices_2_1) <- c(
      lang[["geography_label_whole_municipality"]],
      lang[["geography_label_districts_amsterdam"]],
      lang[["geography_label_pc3"]],
      lang[["geography_label_neighborhood"]],
      lang[["geography_label_areas_amsterdam"]]
    )
    
    # Generate the pickerInput UI
    pickerInput(
      "geografie1_2",
      label = lang[["smaller_area"]],
      selected = "",  # Default to blank
      choices = GeoChoices_2_1,  # Use grouped options
      options = list(`live-search` = TRUE, style = "", size = 10)
    )
  })
    
    output$geografie2_2 <- renderUI({
      GeoChoices_2_2 <- list("",
                             sort(subset(area_dat$area, area_dat$type == lang[["label_district"]] & area_dat$gemeente == input$geografie2_1)),
                             sort(subset(area_dat$area, area_dat$type == lang[["label_pc3"]] & area_dat$gemeente == input$geografie2_1)),
                             sort(subset(area_dat$area, area_dat$type == lang[["label_neighborhood"]] & area_dat$gemeente == input$geografie2_1)),
                             sort(subset(area_dat$area, area_dat$type == lang[["label_area"]] & area_dat$gemeente == input$geografie2_1))
      )
      
      names(GeoChoices_2_2) <- c(
        lang[["geography_label_whole_municipality"]],
        lang[["geography_label_districts_amsterdam"]],
        lang[["geography_label_pc3"]],
        lang[["geography_label_neighborhood"]],
        lang[["geography_label_areas_amsterdam"]]
      )
    pickerInput(
      "geografie2_2",
      label = lang[["smaller_area"]],
      selected = "",  # Default to blank
      choices = GeoChoices_2_2,  # Use grouped options
      options = list(`live-search` = TRUE, style = "", size = 10)
    )
  })
  
  # FILTER DATA ----------------------------------------------------
  filterData <- reactive({
    
    if (input$geografie1_2 == "") {
      data_group1 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                              gradient_dat$geografie == input$geografie1_1 & 
                              gradient_dat$geslacht == input$geslacht1 &
                              gradient_dat$migratieachtergrond == input$migratie1 & 
                              gradient_dat$huishouden == input$huishouden1)
    } else {
      data_group1 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                              gradient_dat$geografie == input$geografie1_2 & 
                              gradient_dat$geslacht == input$geslacht1 &
                              gradient_dat$migratieachtergrond == input$migratie1 & 
                              gradient_dat$huishouden == input$huishouden1)
    }
    
    if (input$geografie2_2 == "") {
      data_group2 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                              gradient_dat$geografie == input$geografie2_1 & 
                              gradient_dat$geslacht == input$geslacht2 &
                              gradient_dat$migratieachtergrond == input$migratie2 & 
                              gradient_dat$huishouden == input$huishouden2)
    } else {
      data_group2 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                              gradient_dat$geografie == input$geografie2_2 & 
                              gradient_dat$geslacht == input$geslacht2 &
                              gradient_dat$migratieachtergrond == input$migratie2 & 
                              gradient_dat$huishouden == input$huishouden2)
    }
    
    # Flag to check whether to use the user input
    # When false to the UI slider is updated to reflect the new data
    input$OnePlot # This is just to update the y-axis when oneplot is enabled
    isolate({
      vals$use_user_input <- FALSE
      vals$run_plot <- FALSE
    })
    
    if (input$parents_options == lang[["parent_income"]]) {
      if(!is.null(input$OnePlot) && input$OnePlot) {
        bin <- get_perc_per_bin(data_group1)
      } else {
        bin <- get_bin(data_group1, data_group2) 
      }
       
      data_group1 <- data_group1 %>% filter(type == bin) %>% mutate(group = lang[["black_group"]] )
      data_group2 <- data_group2 %>% filter(type == bin) %>% mutate(group = lang[["yellow_group"]])
      dat <- bind_rows(data_group1, data_group2)      
        
    } else if (input$parents_options == lang[["parent_education"]] ) {
      data_group1 <- data_group1 %>%  filter(type == "parents_edu") %>% mutate(group = lang[["black_group"]] )
      data_group2 <- data_group2 %>% filter(type == "parents_edu") %>% mutate(group = lang[["yellow_group"]])
      dat <- bind_rows(data_group1, data_group2)
    }
  })

  
  # DOWNLOAD DATA ----------------------------------------------------
  # filter data for downloading
  DataDownload <- reactive({
    
    dat <- filterData() 
    dat <- dat %>%
      select(-c(group, type, uitkomst)) %>%
      relocate(uitkomst_NL) %>%
      dplyr::rename(uitkomst = uitkomst_NL)
    
  })


  # DOWNLOAD REACTIVE ----------------------------------------------------
  
  TxtFile <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$analyse_outcome == input$outcome)

    
    caption1 <- paste(
        sprintf("%s:", toupper(lang[["black_group"]])), 
        input$geografie1_1, sprintf("(%s) -",tolower(lang[["area"]])), 
        input$geografie1_2, sprintf("(%s) -",tolower(lang[["smaller_area"]])), 
        input$geslacht1, sprintf("(%s) -",tolower(lang[["gender"]])), 
        input$migratie1, sprintf("(%s) -",tolower(lang[["migration_background"]])), 
        input$huishouden1, sprintf("(%s)",tolower(lang[["parent_amount_label"]]))
    )
    caption2 <- ""
    if(!input$OnePlot) {
      caption2 <- paste(
        sprintf("%s:", toupper(lang[["yellow_group"]])), 
        input$geografie2_1, sprintf("(%s) -",tolower(lang[["area"]])), 
        input$geografie2_2, sprintf("(%s) -",tolower(lang[["smaller_area"]])), 
        input$geslacht2, sprintf("(%s) -",tolower(lang[["gender"]])), 
        input$migratie2, sprintf("(%s) -",tolower(lang[["migration_background"]])), 
        input$huishouden2, sprintf("(%s)",tolower(lang[["parent_amount_label"]]))
    )
    }
    
    caption <- paste(strwrap(paste0(caption1, "\n\n", caption2), width = 75), collapse = "\n")
    
    text <- c(temp_txt,
              paste0(labels_dat$outcome_name, " (", labels_dat$population, ")\n"), caption, readme_sep, 
              "\n", paste0(toupper(lang[["box_text_general"]]), "\n", paste(strwrap(HTML_to_plain_text(algemeenText()), width = 75), collapse = "\n")),
              "\n", paste0(toupper(lang[["box_text_what_do_i_see"]]), "\n",paste(strwrap(HTML_to_plain_text(watzieikText()), width = 75), collapse = "\n")), 
              "\n", paste0(toupper(lang[["box_text_causality"]]), "\n", lang[["box_text_causality_text"]] ), 
              "\n", paste0(toupper(lang[["box_text_licence"]]), "\n", caption_license))
    
  })
  
  # caption of the groups in download file
  CaptionFile <- reactive({
    
    caption1 <- paste(
        sprintf("%s:", toupper(lang[["black_group"]])), 
        input$geografie1_1, sprintf("(%s) -",tolower(lang[["area"]])), 
        input$geografie1_2, sprintf("(%s) -",tolower(lang[["smaller_area"]])), 
        input$geslacht1, sprintf("(%s) -",tolower(lang[["gender"]])), 
        input$migratie1, sprintf("(%s) -",tolower(lang[["migration_background"]])), 
        input$huishouden1, sprintf("(%s)",tolower(lang[["parent_amount_label"]])) 
    )
    caption2 <- ""
    if(!input$OnePlot) {
      caption2 <- paste(
        sprintf("%s:", toupper(lang[["yellow_group"]])), 
        input$geografie2_1, sprintf("(%s) -",tolower(lang[["area"]])), 
        input$geografie2_2, sprintf("(%s) -",tolower(lang[["smaller_area"]])), 
        input$geslacht2, sprintf("(%s) -",tolower(lang[["gender"]])), 
        input$migratie2, sprintf("(%s) -",tolower(lang[["migration_background"]])), 
        input$huishouden2, sprintf("(%s)",tolower(lang[["parent_amount_label"]]))
    )
    }
    
    caption <- paste(strwrap(paste0(caption1, "\n\n", caption2), width = 85), collapse = "\n")
    
  })
  
  
  # CHECK FOR DATA ----------------------------------------------------
  # Flags on whether there is any data
  data_group1_has_data = reactive({
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == lang[["black_group"]])
    data_group1_has_data = ifelse(nrow(data_group1) > 0, TRUE, FALSE)
  })

  data_group2_has_data = reactive({
    if(input$OnePlot) {
      data_group2_has_data = FALSE
    } else {
      dat <- filterData()
      data_group2 <- subset(dat, dat$group == lang[["yellow_group"]] )
      data_group2_has_data = ifelse(nrow(data_group2) > 0, TRUE, FALSE)
    }
  })
  
  
  
  # ALGEMEEN TEXT REACTIVE ---------------------------------------------
  
  algemeenText <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$analyse_outcome == input$outcome)
    statistic_type_text <- get_stat_per_outcome_html(labels_dat)

    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == lang[["black_group"]])
    N1 <- decimal0(sum(data_group1$N))

    data_group2 <- subset(dat, dat$group == lang[["yellow_group"]])
    N2 <- decimal0(sum(data_group2$N))

    lang_dynamic_map <- hashmap()
    lang_dynamic_map[["<<statistic_type>>"]] <- statistic_type_text
    lang_dynamic_map[["<<input_outcome_name_lowercase>>"]] <- tolower(labels_dat$outcome_name)
    lang_dynamic_map[["<<input_outcome_name>>"]] <- labels_dat$outcome_name
    lang_dynamic_map[["<<input_outcome_name_definition>>"]] <- labels_dat$definition
    lang_dynamic_map[["<<input_population>>"]] <- tolower(labels_dat$population)
    axis_text <- HTML(add_dynamic_text(lang[["general_text_axis_parent_education"]], lang_dynamic_map))

    if(!data_group1_has_data() && !data_group2_has_data()) {
      # No data
      axis_text <- ""
    } else if (input$parents_options == lang[["parent_income"]] ) {
      # get html bin
      perc_html <- get_perc_per_bin_html(data_group1)
      if (!(input$OnePlot)) {
        perc_html <- get_perc_html(data_group1, data_group2)
      }
      lang_dynamic_map[["<<data_percentage_per>>"]] = paste0(perc_html, "%")
      lang_dynamic_map[["<<general_text_plot_order_if_available>>"]] <- ""
      if(perc_html != 100)
        lang_dynamic_map[["<<general_text_plot_order_if_available>>"]] <- lang[["general_text_plot_order"]]

      axis_text <- HTML(add_dynamic_text(lang[["general_text_axis_parent_income"]], lang_dynamic_map))

    } else if(input$parents_options == lang[["parent_education"]]  & !input$change_barplot) {
      axis_text <- HTML(add_dynamic_text(lang[["general_text_axis_parent_education"]], lang_dynamic_map))

    } else if(input$parents_options == lang[["parent_education"]] & input$change_barplot) {
      axis_text <- HTML(add_dynamic_text(lang[["general_text_axis_parent_education_lollipop"]], lang_dynamic_map))
    }
    
    group1_text <- gen_algemeen_group_text(
      group_type_text = add_bold_text_html(text=tolower(lang["black_group"]), color=data_group1_color),
      group_data_size = N1,
      geslacht_input = input$geslacht1,
      migratie_input = input$migratie1,
      huishouden_input = input$huishouden1,
      geografie1_input = input$geografie1_1,
      geografie2_input = input$geografie1_2,
      populatie_input = labels_dat$population,
      lang_dynamic_map = lang_dynamic_map
    )
    
    group2_text <- ""
    if (!input$OnePlot) {
      group2_text <- gen_algemeen_group_text(
        group_type_text = add_bold_text_html(
          text=tolower(lang[["yellow_group"]]), 
          color= "black"),
        group_data_size = N2,
        geslacht_input = input$geslacht2,
        migratie_input = input$migratie2,
        huishouden_input = input$huishouden2,
        geografie1_input = input$geografie2_1,
        geografie2_input = input$geografie2_2,
        populatie_input = labels_dat$population,
        lang_dynamic_map = lang_dynamic_map
      )
    }    
    lang_dynamic_map[["<<general_text_group1>>"]] <- group1_text
    lang_dynamic_map[["<<general_text_group2>>"]] <- group2_text
    lang_dynamic_map[["<<general_text_axis>>"]] <- axis_text

    # output
    HTML(add_dynamic_text(lang[["general_text"]], lang_dynamic_map))
    
  })
  
  
  # WAT ZIE IK? TEXT REACTIVE ---------------------------------------------
  
  watzieikText <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$analyse_outcome == input$outcome)
    stat <- get_stat_per_outcome_html(labels_dat)
    statistic_type_text <- get_stat_per_outcome_html(labels_dat)
    
    # get prefix and postfix for outcomes
    prefix_text <- get_prefix(input$outcome)
    postfix_text <- get_postfix(input$outcome)
    
    # get average of total group
    total_group1 <- dataInput1()  %>% filter(parent_income_wealth_bins_levels == lang[["total"]], opleiding_ouders == lang[["total"]])
    total_group2 <- dataInput2()  %>% filter(parent_income_wealth_bins_levels == lang[["total"]], opleiding_ouders == lang[["total"]])
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == lang[["black_group"]])
    data_group2 <- subset(dat, dat$group == lang[["yellow_group"]])
    num_rows <- max(nrow(data_group1), nrow(data_group2))

    lang_dynamic_map <- hashmap()
    lang_dynamic_map[["<<statistic_type>>"]] <- statistic_type_text
    lang_dynamic_map[["<<input_outcome_name_lowercase>>"]] <- tolower(labels_dat$outcome_name)
    lang_dynamic_map[["<<input_population>>"]] <- tolower(labels_dat$population)


    has_data <- FALSE
    if (input$SwitchColor == lang[["black_group"]]) { 
        lang_dynamic_map[["<<var_group_id>>"]] <- tolower(lang[["black_group"]])
        lang_dynamic_map[["<<var_group_id_colored>>"]] <- add_bold_text_html(text=lang_dynamic_map[["<<var_group_id>>"]], color= "black")
        if (data_group1_has_data()) {
          # Fill lang_dynamic map
          has_data <- TRUE 
          data_identifier <- lang[["bar"]]
          if (input$parents_options == lang[["parent_income"]])
            data_identifier <- lang[["dot"]]

          lang_dynamic_map[["<<var_group_datapoint_id>>"]] <-  add_bold_text_html(text=paste(lang[["black_adjective"]], data_identifier), color= "black")
          lang_dynamic_map[["<<var_data_parent_lowest_income>>"]] <- decimal0(data_group1$parents_income[as.numeric(1)]*1000)
          lang_dynamic_map[["<<var_data_parent_highest_income>>"]] <- decimal0(data_group1$parents_income[as.numeric(num_rows)]*1000)
          lang_dynamic_map[["<<var_data_lowest_mean>>"]] <- paste0(prefix_text, decimal1(data_group1$mean[1]), postfix_text)
          lang_dynamic_map[["<<var_data_highest_mean>>"]] <- paste0(prefix_text, decimal1(data_group1$mean[as.numeric(num_rows)]), postfix_text)

          # Single point (1 point is 100%)
          lang_dynamic_map[["<<var_data_parent_income>>"]] <- lang_dynamic_map[["<<var_data_parent_lowest_income>>"]]
          lang_dynamic_map[["<<var_data_mean>>"]] <- lang_dynamic_map[["<<var_data_lowest_mean>>"]]

          # Mean
          lang_dynamic_map[["<<var_total_mean>>"]] <- paste0(prefix_text, decimal1(total_group1$mean), postfix_text)
          
          # Opleidng ouders
          lang_dynamic_map[["<<var_data_left_mean>>"]] <- paste0(prefix_text, decimal1(data_group1$mean[3]), postfix_text)
          lang_dynamic_map[["<<var_data_middle_mean>>"]] <- paste0(prefix_text, decimal1(data_group1$mean[2]), postfix_text)
          lang_dynamic_map[["<<var_data_right_mean>>"]] <- paste0(prefix_text, decimal1(data_group1$mean[1]), postfix_text)
        }
    } else if (input$SwitchColor == lang[["yellow_group"]]) {
        lang_dynamic_map[["<<var_group_id>>"]] <- tolower(lang[["yellow_group"]])
        lang_dynamic_map[["<<var_group_id_colored>>"]] <- add_bold_text_html(
          text=lang_dynamic_map[["<<var_group_id>>"]], 
          color= "black")
        if (data_group2_has_data()) {
          # Fill lang_dynamic map
          has_data <- TRUE 
          data_identifier <- lang[["bar"]]
          if (input$parents_options == lang[["parent_income"]])
            data_identifier <- lang[["dot"]]

          lang_dynamic_map[["<<var_group_datapoint_id>>"]] <- add_bold_text_html(
            text = paste(lang[["yellow_adjective"]], data_identifier), 
            color = "black"
          )          
          lang_dynamic_map[["<<var_data_parent_lowest_income>>"]] <- decimal0(data_group2$parents_income[as.numeric(1)]*1000)
          lang_dynamic_map[["<<var_data_parent_highest_income>>"]] <- decimal0(data_group2$parents_income[as.numeric(num_rows)]*1000)
          lang_dynamic_map[["<<var_data_lowest_mean>>"]] <- paste0(prefix_text, decimal1(data_group2$mean[1]), postfix_text)
          lang_dynamic_map[["<<var_data_highest_mean>>"]] <- paste0(prefix_text, decimal1(data_group2$mean[as.numeric(num_rows)]), postfix_text)

          # Single point (1 point is 100%)
          lang_dynamic_map[["<<var_data_parent_income>>"]] <- lang_dynamic_map[["<<var_data_parent_lowest_income>>"]]
          lang_dynamic_map[["<<var_data_mean>>"]] <- lang_dynamic_map[["<<var_data_lowest_mean>>"]]

          # Mean
          lang_dynamic_map[["<<var_total_mean>>"]] <- paste0(prefix_text, decimal1(total_group2$mean), postfix_text)
          
          # Opleidng ouders
          lang_dynamic_map[["<<var_data_left_mean>>"]] <- paste0(prefix_text, decimal1(data_group2$mean[3]), postfix_text)
          lang_dynamic_map[["<<var_data_middle_mean>>"]] <- paste0(prefix_text, decimal1(data_group2$mean[2]), postfix_text)
          lang_dynamic_map[["<<var_data_right_mean>>"]] <- paste0(prefix_text, decimal1(data_group2$mean[1]), postfix_text)
        }
    }

    if(has_data == FALSE) {
      # Generate no data message
      # HTML(gen_nodata_found(lang_dynamic_map[["<<var_group_id_colored>>"]]))
      HTML(add_dynamic_text(lang[["no_group_data"]], lang_dynamic_map))
    } else {
      if (input$parents_options == lang[["parent_income"]]) {
        perc_html <- get_perc_per_bin_html(data_group1)
        if (!(input$OnePlot)) {
          perc_html <- get_perc_html(data_group1, data_group2)
        }
        lang_dynamic_map[["<<data_percentage_per>>"]] = paste0(perc_html, "%")

        main_text <- ""
        if (perc_html == "100") {
          # One dot is 100%
          main_text <- HTML(add_dynamic_text(lang[["what_do_i_see_text_parent_income_single_datapoint"]], lang_dynamic_map))
        } else {
          # One dot is less than 100%
          main_text <-HTML(add_dynamic_text(lang[["what_do_i_see_text_parent_income_multiple_datapoints"]], lang_dynamic_map))
        }

      } else if(input$parents_options == lang[["parent_education"]]) {
        main_text <- HTML(add_dynamic_text(lang[["what_do_i_see_text_parent_education"]], lang_dynamic_map))
      }

      # Mean text
      mean_text <- ""
      if (!is.null(input$line_options) && lang[["average"]]%in% input$line_options) {
        mean_text <- HTML(add_dynamic_text(lang[["what_do_i_see_text_mean"]], lang_dynamic_map))
      }

      HTML(paste0("<p>", main_text, "</p>",
                  "<p>", mean_text, "</p>"))
    }
  })
  
  
  # FIGURE PLOT REACTIVE ----------------------------------------------------
  
  makePlot <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$analyse_outcome == input$outcome)
    
    # get prefix and postfix for outcomes
    prefix_text <- get_prefix(input$outcome)
    postfix_text <- get_postfix(input$outcome)
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == lang[["black_group"]])
    if (!(input$OnePlot)) {data_group2 <- subset(dat, dat$group == lang[["yellow_group"]])}


    # Parse additional input options
    line_option_selected <- FALSE
    mean_option_selected <- FALSE
    if (!is.null(input$line_options)) {
  
      line_option_selected <- lang[["line"]]  %in% input$line_options
      mean_option_selected <- lang[["average"]] %in% input$line_options
      
      # regression line
      # TODO: Add check for data_group2 when data_group1 is empty
      if (nrow(data_group1) == 5) {
        polynom <- 2
      } else {
        polynom <- 3
      }
    }
        

    #### GRADIENT ####
    if (input$parents_options == lang[["parent_income"]])  {

      # Initialize plot with formatted axis and theme
      plot <- ggplot()

      if (data_group1_has_data() && data_group2_has_data()) 
        plot <- gen_geom_point(dat, color=c(data_group1_outline, data_group2_outline), fill=c(data_group1_color, data_group2_color), prefix_text, postfix_text, shape=c(19, 15))
      else if (data_group1_has_data())
        plot <- gen_geom_point(data_group1, color=data_group1_outline, fill=data_group1_color, prefix_text, postfix_text, shape=19)
      else if (data_group2_has_data())
        plot <- gen_geom_point(data_group2, color=data_group2_outline, fill=data_group2_color, prefix_text, postfix_text, shape=15)

      plot <- plot + # scale_x_continuous(labels = function(x) paste0("€ ", x)) +
              theme_minimal() +
              labs(x =lang[["plot_graph_x_label"]], y ="") +
              thema

      # Plot for data_group1 
      if (data_group1_has_data()) {
        
        # Highlight points
        if (input$tabset1 == lang[["box_text_what_do_i_see"]])
          plot <- plot + gen_highlight_points(data_group1, data_group1_color)

        # Plot regression line if it is selected
        if (line_option_selected)
          plot <- plot + gen_regression_line(data_group1, color=data_group1_outline, polynom, linetype1_reg)

        # Plot mean line if it is selected
        if (mean_option_selected) {
          total_group1 <- dataInput1() %>% filter(parent_income_wealth_bins_levels == lang[["total"]], opleiding_ouders == lang[["total"]])
          plot <- plot + gen_mean_line(total_group1, color=data_group1_outline, linetype1_mean)
        }
      }

      # Plot for data_group2
      if (data_group2_has_data()) { 
        
        # Highlight points
        if (input$tabset1 == lang[["box_text_what_do_i_see"]])
          plot <- plot + gen_highlight_points(data_group2, data_group2_color)

        # Plot the additional options
        if (line_option_selected)
          plot <- plot + gen_regression_line(data_group2, color=data_group2_outline, polynom, linetype2_reg)

        if (mean_option_selected) {
          total_group2 <- dataInput2() %>% filter(parent_income_wealth_bins_levels == lang[["total"]], opleiding_ouders == lang[["total"]])
          plot <- plot + gen_mean_line(total_group2, color=data_group2_outline, linetype2_mean)
        }
      }   
      
       
      #### BAR PLOT ####
    } else if(input$parents_options == lang[["parent_education"]]) {
      
      plot <- ggplot()
      
    if (!(input$change_barplot)) {
  
      if (data_group1_has_data() && data_group2_has_data())
        plot <- gen_bar_plot(dat, prefix_text, postfix_text)+ 
          scale_color_manual("", values = c(data_group1_outline, data_group2_outline))+ # Outline color for each group
          scale_fill_manual("", values = c(data_group1_color, data_group2_color))
      else if (data_group1_has_data())
        plot <- gen_bar_plot(data_group1, prefix_text, postfix_text) + 
          scale_color_manual("", values = c(data_group1_outline))+ # Outline color for each group
          scale_fill_manual("", values=c(data_group1_color))
      else if (data_group2_has_data())
        plot <- gen_bar_plot(data_group2, prefix_text, postfix_text) + scale_fill_manual("", values=c(data_group2_color))

      plot <- plot +
          geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
          labs(x =lang[["plot_bar_x_label"]], y ="") +
          theme_minimal() +
          thema
       
      if (mean_option_selected) {
        # get average of the groups
        if (data_group1_has_data()) {
          total_group1 <- dataInput1() %>% filter(parent_income_wealth_bins_levels == lang[["total"]], opleiding_ouders == lang[["total"]])
          plot <- plot + gen_mean_line(total_group1, color=data_group1_outline, linetype1_mean) 
        }
        
        if (data_group2_has_data()) {
          total_group2 <- dataInput2() %>% filter(parent_income_wealth_bins_levels == lang[["total"]], opleiding_ouders == lang[["total"]])
          plot <- plot + gen_mean_line(total_group2, color=data_group2_outline, linetype2_mean) 
          
        }
      }
      
      
      #### ALTERNATIVE BUBBLE PLOT ####
     } else if (input$change_barplot) {

        if (data_group1_has_data() && data_group2_has_data()) {
          dat <- dat %>%  dplyr::group_by(group) %>% dplyr::mutate(bubble_size = (N / sum(N)) * 100)
          plot <- gen_bubble_plot(dat, prefix_text, postfix_text) + scale_color_manual("", values=c(data_group1_color, data_group2_color))
          
        } else if (data_group1_has_data()) {
          data_group1 <- data_group1 %>% dplyr::mutate(bubble_size = (N / sum(N)) * 100)
          plot <- gen_bubble_plot(data_group1, prefix_text, postfix_text) + scale_color_manual("", values=c(data_group1_color))
          
          
        } else if (data_group2_has_data()) {
          data_group2 <- data_group2 %>% dplyr::mutate(bubble_size = (N / sum(N)) * 100)
          plot <- gen_bubble_plot(data_group2, prefix_text, postfix_text) + scale_color_manual("", values=c(data_group2_color))
          
        }
       
       if (mean_option_selected) {
         # get average of the groups
         if (data_group1_has_data()) {
           total_group1 <- dataInput1() %>% filter(parent_income_wealth_bins_levels == lang[["total"]], opleiding_ouders == lang[["total"]])
           plot <- plot + gen_mean_line(total_group1, data_group1_outline, linetype1_mean) 
         }
         
         if (data_group2_has_data()) {
           total_group2 <- dataInput2() %>% filter(parent_income_wealth_bins_levels == lang[["total"]], opleiding_ouders == lang[["total"]])
           plot <- plot + gen_mean_line(total_group2, data_group2_outline, linetype2_mean) 
           
         }
       }
       
       
        # BUBBLE PLOT
        plot <- plot +
        labs(x = lang[["plot_bubble_x_label"]], y ="") +
          theme_minimal() +
          thema
     }
    }

    # Add user inputted ylim and xlim
    vals$run_plot;
    if (isolate({vals$use_user_input == FALSE}) && (data_group1_has_data() || data_group2_has_data())) {
      # Y-axis
      ylim = ggplot_build(plot)$layout$panel_params[[1]]$y.range
      update_yaxis_slider(data_min=ylim[1], data_max=ylim[2])
      vals$ylim = c(max(ylim[1], 0), ylim[2])
      
      # X-axis
      if (input$parents_options == lang[["parent_income"]] ) {
        # Only update the x-axis slider at "inkomen ouders"
        vals$xlim <- layer_scales(plot)$x$range$range
        update_xaxis_slider(data_min=vals$xlim[1], data_max=vals$xlim[2])   
      }
      vals$use_user_input <- TRUE
    } 


    plot <- plot + scale_y_continuous(labels = function(x) paste0(prefix_text, decimal2(x), postfix_text), limits=vals$ylim) 
    
    if (input$parents_options == lang[["parent_income"]] )
      plot <- plot + scale_x_continuous(labels = function(x) paste0("€ ", x), limits=vals$xlim)

    if (!data_group1_has_data() && !data_group2_has_data()) {
      # Return empty plot when there is no data available
      plot <- ggplot() + annotate(geom="text", x=3, y=3, size = 8,
                                  label=lang[["plot_no_data"]]) + theme_void() +
        theme(
          axis.line=element_blank(),
          panel.grid.major=element_blank()
        )
    }

    # Hide the legend when it is in mobile mode
    input$hide_legend;
    if(!is.null(input$hide_legend) && input$hide_legend == "true") {
      plot <- plot + theme(legend.position="none")
    }
    
    vals$plot <- plot
  })
  


  # UI RADIOBUTTON TOOLTIP ---------------------------------------------
  
observeEvent(input$outcome,{
  labels_dat <- subset(outcome_dat, outcome_dat$analyse_outcome == input$outcome)
  if (lang[["label_newborn"]]  %in% labels_dat$population || lang[["label_students_in_grade_8"]]  %in% labels_dat$population) {
    selected_option = input$parents_options
    parent_choices <- c(lang[["parent_income"]], lang[["parent_education"]])
  } else {
    selected_option <- lang[["parent_income"]]
    parent_choices <- lang[["parent_income"]]
  }
  updatePrettyRadioButtons(
    session = getDefaultReactiveDomain(),
    inputId = "parents_options",
    choices = parent_choices,
    selected = selected_option,
    inline = TRUE,
    prettyOptions = list(
        icon = icon("check"),
        bigger = TRUE,
        status = "info", 
        animation = "smooth"
    ),
  )
})

observeEvent(input$parents_options,{
  if (input$parents_options == lang[["parent_education"]] ) {
    # Make the "Toon alternatief grafiek" only visible when "Opleiding ouders" is selected
    runjs("document.getElementById('change_barplot').closest('div').style.display='block'")
    # Disable "Lijn" option when "Opleiding ouders" is selected
    runjs("document.getElementsByName('line_options')[0].disabled=true")
    # Remove x-axis slider when "Opleiding ouders" is selected
    runjs("document.getElementById('x_axis').closest('div').style.display='none'")
  } else {
    runjs("document.getElementById('change_barplot').closest('div').style.display='none'")
    runjs("document.getElementsByName('line_options')[0].disabled=false")
    runjs("document.getElementById('x_axis').closest('div').style.display='block'")
  }
})

observeEvent(input$outcome,{
  
  if (!(input$outcome %in% continuous)) {
  # remove "Mediaan" option if outcome is not a continuous
    runjs("document.getElementsByName('line_options')[2].disabled=true")
  } else {
    runjs("document.getElementsByName('line_options')[2].disabled=false")
  }
})

# remove button if user clicked on button to show one plot
observeEvent(input$OnePlot,{

  
  if (!input$OnePlot) {
    group_choices <- c(lang[["black_group"]], lang[["yellow_group"]] )
  } else {
    group_choices <- lang[["black_group"]] 
  }
  
  updatePrettyRadioButtons(
    session = getDefaultReactiveDomain(),
    inputId = "SwitchColor",
    label = lang[["box_text_switch_label"]],
    choices = group_choices,
    inline = TRUE,
    prettyOptions = list(
      icon = icon("check"),
      bigger = TRUE,
      status = "info", 
      animation = "smooth"
    ),
  )
})
  

update_yaxis_slider <- function(data_min, data_max) {
  # Update the y-axis slider
  vals$ysteps <- get_rounded_slider_steps(data_min = data_min, data_max = data_max)
  vals$yslider_max <- get_rounded_slider_max(data_max = data_max, vals$ysteps)
  vals$yslider_min <- get_rounded_slider_min(data_min = data_min, vals$ysteps)

  # Set UI slider
  updateSliderInput(session, "y_axis", label = lang[["y_axis_label"]], value = c(data_min, data_max),
                    min = vals$yslider_min, max = vals$yslider_max, step = vals$ysteps)
}


update_xaxis_slider <- function(data_min, data_max) {
  # Update the x-axis slider
  vals$xsteps <- get_rounded_slider_steps(data_min = data_min, data_max = data_max)
  vals$xslider_max <- get_rounded_slider_max(data_max = data_max, vals$xsteps)
  vals$xslider_min <- get_rounded_slider_min(data_min = data_min, vals$xsteps, min_zero = FALSE)

  # Set UI slider
  updateSliderInput(session, "x_axis", label = lang[["x_axis_label"]], value = c(data_min, data_max),
                    min = vals$xslider_min, max = vals$xslider_max, step = vals$xsteps)
}



# Y-axis slider range updater
observeEvent(input$y_axis,{
  req(input$y_axis, vals$yslider_min, vals$yslider_max, vals$ysteps)
  if(vals$use_user_input == TRUE) {

    ylim_min <- input$y_axis[1]
    ylim_max <- input$y_axis[2]
    yslider_diff <- abs(vals$yslider_max - vals$yslider_min)

    # Only update the slider when the max/min of the slider is reached or
    # the distance between the selected value and the edge is more than 
    # half of the slider
    if((ylim_min != 0 && 
        (abs(ylim_min - vals$yslider_min) <= vals$ysteps ||
        (abs(ylim_min - vals$yslider_min) >= yslider_diff/2))) || 
        abs(ylim_max - vals$yslider_max) <= vals$ysteps ||
        (abs(ylim_max - vals$yslider_max) >= yslider_diff/2)) {
        update_yaxis_slider(ylim_min, ylim_max)
       }
    
  }
})

# X-axis slider range updater
observeEvent(input$x_axis,{
  req(input$x_axis, vals$xslider_min, vals$xslider_max, vals$xsteps)
  if(vals$use_user_input == TRUE) {

    xlim_min <- input$x_axis[1]
    xlim_max <- input$x_axis[2]
    xslider_diff <- abs(vals$xslider_max - vals$xslider_min)

    # Only update the slider when the max/min of the slider is reached or
    # the distance between the selected value and the edge is more than 
    # half of the slider
    if(((abs(xlim_min - vals$xslider_min) <= vals$xsteps ||
        (abs(xlim_min - vals$xslider_min) >= xslider_diff/2))) || 
        abs(xlim_max - vals$xslider_max) <= vals$xsteps ||
        (abs(xlim_max - vals$xslider_max) >= xslider_diff/2)) {
        update_xaxis_slider(xlim_min, xlim_max)
       }
  }
})


# Input axis filter
# This function filters updates to the plot when the values for ylim hasn't changed
# Because when updateSliderInput is called it fires an input$y_axis event
observeEvent(input$y_axis, {
  req(vals$ylim)
  if(vals$use_user_input == TRUE) {
    if(abs(vals$ylim[1] - input$y_axis[1]) >= vals$ysteps/2 ||abs(vals$ylim[2] - input$y_axis[2]) >= vals$ysteps/2) {
      vals$run_plot = xor(vals$run_plot, TRUE) # TODO: Ugly toggle to run plot
      vals$ylim <- input$y_axis
    }
  }
})

observeEvent(input$x_axis, {
  req(vals$xlim)
  if(vals$use_user_input == TRUE) {
    if(abs(vals$xlim[1] - input$x_axis[1]) >= vals$xsteps/2 ||abs(vals$xlim[2] - input$x_axis[2]) >= vals$xsteps/2) {
      vals$run_plot = xor(vals$run_plot, TRUE) # TODO: Ugly toggle to run plot
      vals$xlim <- input$x_axis
    }
  }
})



observeEvent(input$user_reset, {
  vals$use_user_input=FALSE
  vals$run_plot = xor(vals$run_plot, TRUE) # TODO: Ugly toggle to run plot
  })


  
  # HTML TEXT ----------------------------------------------------------
  
  #### ALGEMEEN ####
  output$selected_outcome <- renderPrint({
    
    if (input$SwitchTabbox1 == lang[["outcome_measure"]] ) {
      algemeenText()
      
    } else if (input$SwitchTabbox1 == lang[["parent_education"]] ) {
      HTML(lang[["general_text_explanation_parent_education"]])
    } else if (input$SwitchTabbox1 == lang[["parent_income"]] ) {
      HTML(lang[["general_text_explanation_parent_income"]])
      
    }
    
  })


  #### WAT ZIE JE? ####
  output$sample_uitleg <- renderPrint({
 
    watzieikText()
    
  })
  
  
  
  # GRADIENT ----------------------------------------------------------
  
  
  # title plot widget
  output$title_plot <- renderPrint({
    labels_dat <- subset(outcome_dat, outcome_dat$analyse_outcome == input$outcome);
    HTML(paste0(labels_dat$outcome_name, " (", labels_dat$population, ")"))
  })
  
  
  # Create plot

  output$main_figure <- renderPlotly({
    tryCatch({

    # call reactive
    makePlot()
    ggplotly(x = vals$plot, tooltip = c("text"))  %>% 
      config(displayModeBar = F, scrollZoom = F) %>%
      style(hoverlabel = label) %>%
      layout(font = font, xaxis=list(fixedrange=T), yaxis=list(fixedrange=T))  
      
  }, 
  error = function(e) {
    showNotification("Not enough data to generate plot", type = "message")
    return(NULL)
  })})  # end plot
    
  
  # DOWNLOAD --------------------------------------------------------

  
  #### DOWNLOAD DATA ####

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("data_", get_datetime(), ".zip")
    },
    content = function(file) {
      
      # set temporary dir
      tmpdir <- tempdir()
      setwd(tmpdir)
      zip_files <- c()
      
      # get files
      csv_name <- paste0("data_", get_datetime(), ".csv")
      write.csv(DataDownload(), csv_name)
      zip_files <- c(zip_files, csv_name)
      
      # write txt file
      fileConn <- file("README.txt")
      writeLines(TxtFile(), fileConn)
      close(fileConn)
      zip_files <- c(zip_files, "README.txt")
      
      zip(zipfile = file, files = zip_files)
      
    },
    contentType = "application/zip"
  )
  

  #### DOWNLOAD PLOT ####
  output$downloadPlot <- downloadHandler(
    
    filename = function() {
      paste0("fig_", get_datetime(), ".zip")
    },
    content = function(file) {
      
      
      # set temporary dir
      labels_dat <- subset(outcome_dat, outcome_dat$analyse_outcome == input$outcome)
      tmpdir <- tempdir()
      setwd(tmpdir)
      zip_files <- c()
      
      # get plot
      # TODO: add legend
      fig_name <- paste0("fig_with_caption_", get_datetime(), ".pdf")
      pdf(fig_name, encoding = "ISOLatin9.enc", 
          width = 9, height = 14)
      print(vals$plot + 
              labs(title = paste0(labels_dat$outcome_name, " (", labels_dat$population, ")"), 
                   caption = paste0(caption_sep, paste0(lang[["download_readme_title"]],"\n\n\n"), 
                                    CaptionFile(), caption_sep, 
                                    paste0("\n", toupper(lang[["box_text_general"]]) ,"\n"), paste(strwrap(HTML_to_plain_text(algemeenText()), width = 85), collapse = "\n"),
                                    paste0("\n\n", toupper(lang[["box_text_what_do_i_see"]]) ,"\n"), paste(strwrap(HTML_to_plain_text(watzieikText()), width = 85), collapse = "\n"),
                                    paste0("\n\n", toupper(lang[["box_text_causality"]]) ,"\n"), paste(strwrap(lang[["box_text_causality_text"]] , width = 85), collapse = "\n"), 
                                    paste0("\n\n", toupper(lang[["box_text_licence"]]) ,"\n"), caption_license)
              ) 
      )
      
      dev.off()
      zip_files <- c(zip_files, fig_name)
      
      # figure no caption 
      fig_name <- paste0("fig_", get_datetime(), ".pdf")
      pdf(fig_name, encoding = "ISOLatin9.enc", 
          width = 10, height = 6)
      print(vals$plot + labs(title = paste0(labels_dat$outcome_name, " (", labels_dat$population, ")")))
      dev.off()
      zip_files <- c(zip_files, fig_name)
      
      # write txt file
      fileConn <- file("README.txt")
      writeLines(TxtFile(), fileConn)
      close(fileConn)
      zip_files <- c(zip_files, "README.txt")
      
      zip(zipfile = file, files = zip_files)
      
    },
    contentType = "application/zip"
  )
  
} # end of server
