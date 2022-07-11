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
  
  # # welcome pop-up
  # shinyalert(
  #   title = "Welkom op Dashboard Ongelijkheid in Amsterdam!",
  #   text = HTML("Het dashboard <i>Ongelijkheid in Amsterdam</i> geeft inzicht in de samenhang tussen de omstandigheden
  #   waarin kinderen opgroeien en hun uitkomsten die later in het leven worden gemeten. Voor het maken van een eigen figuur:
  #               <br><br><b>Stap 1:</b> kies een uitkomstmaat.
  #               <br><b>Stap 2:</b> kies een kenmerk van ouders.
  #               <br><b>Stap 3:</b> kies geografische en demografische kenmerken van kinderen.
  #               <br><br>Voor meer informatie over het dashboard, zie tabblad <i>Help.</i>"),
  #   size = "s",
  #   closeOnEsc = TRUE,
  #   closeOnClickOutside = TRUE,
  #   html = TRUE,
  #   showConfirmButton = TRUE,
  #   showCancelButton = FALSE,
  #   confirmButtonText = "Doorgaan",
  #   confirmButtonCol = "#18BC9C",
  #   timer = 0,
  #   imageUrl = "logo_button_shadow.svg",
  #   imageWidth = 150,
  #   imageHeight = 150,
  #   animation = TRUE
  # )
  # 
  # 
  # observeEvent(input$beginscherm, {
  #   sendSweetAlert(
  #     session = session,
  #     title = "Welkom op Dashboard Ongelijkheid in Amsterdam!",
  #     text = HTML("Het dashboard <i>Ongelijkheid in Amsterdam</i> geeft inzicht in de samenhang tussen de omstandigheden
  #   waarin kinderen opgroeien en hun uitkomsten die later in het leven worden gemeten. Voor het maken van een eigen figuur:
  #               <br><br><b>Stap 1:</b> kies een uitkomstmaat.
  #               <br><b>Stap 2:</b> kies een kenmerk van ouders.
  #               <br><b>Stap 3:</b> kies geografische en demografische kenmerken van kinderen.
  #               <br><br>Voor meer informatie over het dashboard, zie tabblad <i>Help.</i>"),
  #     size = "s",
  #     closeOnEsc = TRUE,
  #     closeOnClickOutside = TRUE,
  #     html = TRUE,
  #     showConfirmButton = TRUE,
  #     showCancelButton = FALSE,
  #     confirmButtonText = "Doorgaan",
  #     confirmButtonCol = "#18BC9C",
  #     timer = 0,
  #     imageUrl = "logo_button_shadow.svg",
  #     imageWidth = 150,
  #     imageHeight = 150,
  #     animation = TRUE
  #   )
  # })
  
  
  # text of tabbox 1 for parents characteristics
  observe({
    if (input$parents_options == "Opleiding ouders") {
      
      updatePrettyRadioButtons(session, "SwitchTabbox1", label = "Toon uitleg van:", 
                               choices = c("Uitkomstmaat", "Opleiding ouders"),
                               inline = TRUE, 
                               prettyOptions = list(
                                 icon = icon("check"),
                                 bigger = TRUE,
                                 status = "info", 
                                 animation = "smooth"))
                               
    } else {
      updatePrettyRadioButtons(session, "SwitchTabbox1", label = "Toon uitleg van:", 
                               choices = c("Uitkomstmaat", "Inkomen ouders"),
                               inline = TRUE, 
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
    data_group1 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                            gradient_dat$geografie == input$geografie1 & 
                            gradient_dat$geslacht == input$geslacht1 &
                            gradient_dat$migratieachtergrond == input$migratie1 & 
                            gradient_dat$huishouden == input$huishouden1)
  })
  
  dataInput2 <- reactive({
    data_group2 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                            gradient_dat$geografie == input$geografie2 & 
                            gradient_dat$geslacht == input$geslacht2 &
                            gradient_dat$migratieachtergrond == input$migratie2 & 
                            gradient_dat$huishouden == input$huishouden2)
    
  })
  
  
  # FILTER DATA ----------------------------------------------------
  filterData <- reactive({
    
    data_group1 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                            gradient_dat$geografie == input$geografie1 & 
                            gradient_dat$geslacht == input$geslacht1 &
                            gradient_dat$migratieachtergrond == input$migratie1 & 
                            gradient_dat$huishouden == input$huishouden1)
    
    data_group2 <- subset(gradient_dat, gradient_dat$uitkomst == input$outcome &
                            gradient_dat$geografie == input$geografie2 & 
                            gradient_dat$geslacht == input$geslacht2 &
                            gradient_dat$migratieachtergrond == input$migratie2 & 
                            gradient_dat$huishouden == input$huishouden2)
    
    # Flag to check whether to use the user input
    # When false to the UI slider is updated to reflect the new data
    input$OnePlot # This is just to update the y-axis when oneplot is enabled
    isolate({
      vals$use_user_input <- FALSE
      vals$run_plot <- FALSE
    })
    
    if (input$parents_options == "Inkomen ouders") {
      if(!is.null(input$OnePlot) && input$OnePlot) {
        bin <- get_perc_per_bin(data_group1)
      } else {
        bin <- get_bin(data_group1, data_group2) 
      }
       
      data_group1 <- data_group1 %>% filter(type == bin) %>% mutate(group = "Blauwe groep")
      data_group2 <- data_group2 %>% filter(type == bin) %>% mutate(group = "Groene groep")
      dat <- bind_rows(data_group1, data_group2)      
        
    } else if (input$parents_options == "Opleiding ouders") {
      data_group1 <- data_group1 %>%  filter(type == "parents_edu") %>% mutate(group = "Blauwe groep")
      data_group2 <- data_group2 %>% filter(type == "parents_edu") %>% mutate(group = "Groene groep")
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

    
    caption1 <- paste("BLAUWE GROEP:", input$geografie1, "(gebied) -", input$geslacht1, 
                      "(geslacht) -", input$migratie1, "(migratieachtergrond) -", 
                      input$huishouden1, "(aantal ouders in gezin)")
    caption2 <- ""
    if(!input$OnePlot) {
      caption2 <- paste("GROENE GROEP:", input$geografie2, "(gebied) -", input$geslacht2, 
                        "(geslacht) -", input$migratie2, "(migratieachtergrond) -", 
                        input$huishouden2, "(aantal ouders in gezin)")
    }
    
    caption <- paste(strwrap(paste0(caption1, "\n\n", caption2), width = 75), collapse = "\n")
    
    text <- c(temp_txt,
              paste0(labels_dat$outcome_name, " (", labels_dat$population, ")\n"), caption, 
              readme_sep, "ALGEMENE UITLEG","", 
              paste(strwrap(HTML_to_plain_text(algemeenText()), width = 75), collapse = "\n"),
              readme_sep, "WAT ZIE IK?", "", 
              paste(strwrap(HTML_to_plain_text(watzieikText()), width = 75), collapse = "\n"), 
              readme_sep, "CAUSALITEIT", "", causal_text, 
              readme_sep, "LICENTIE", "", caption_license)
    
    
  })
  
  # caption of the groups in download file
  CaptionFile <- reactive({
    
    caption1 <- paste("BLAUWE GROEP:", input$geografie1, "(gebied) -", input$geslacht1, 
                      "(geslacht) -", input$migratie1, "(migratieachtergrond) -", 
                      input$huishouden1, "(aantal ouders in gezin)")
    caption2 <- ""
    if(!input$OnePlot) {
      caption2 <- paste("GROENE GROEP:", input$geografie2, "(gebied) -", input$geslacht2, 
                        "(geslacht) -", input$migratie2, "(migratieachtergrond) -", 
                        input$huishouden2, "(aantal ouders in gezin)")
    }
    
    caption <- paste(strwrap(paste0(caption1, "\n\n", caption2), width = 85), collapse = "\n")
    
  })
  
  
  # CHECK FOR DATA ----------------------------------------------------
  # Flags on whether there is any data
  data_group1_has_data = reactive({
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "Blauwe groep")
    data_group1_has_data = ifelse(nrow(data_group1) > 0, TRUE, FALSE)
  })

  data_group2_has_data = reactive({
    if(input$OnePlot) {
      data_group2_has_data = FALSE
    } else {
      dat <- filterData()
      data_group2 <- subset(dat, dat$group == "Groene groep")
      data_group2_has_data = ifelse(nrow(data_group2) > 0, TRUE, FALSE)
    }
  })
  
  
  
  # GET MEDIAN, 25E & 75E QUANTILE --------------------------------------

  get_median_dat1 <- reactive({
    
    if (input$outcome %in% continuous) {
      median_dat1 <- subset(median_dat, median_dat$uitkomst == input$outcome &
                              median_dat$geografie == input$geografie1 & 
                              median_dat$geslacht == input$geslacht1 &
                              median_dat$migratieachtergrond == input$migratie1 & 
                              median_dat$huishouden == input$huishouden1)
    }
  })
  
  get_median_dat2 <- reactive({
    
    if (input$outcome %in% continuous) {
      median_dat2 <- subset(median_dat, median_dat$uitkomst == input$outcome &
                              median_dat$geografie == input$geografie2 & 
                              median_dat$geslacht == input$geslacht2 &
                              median_dat$migratieachtergrond == input$migratie2 & 
                              median_dat$huishouden == input$huishouden2)
    }
  })
  
  
  # ALGEMEEN TEXT REACTIVE ---------------------------------------------
  
  algemeenText <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$analyse_outcome == input$outcome)
    statistic_type_text <- get_stat_per_outcome_html(labels_dat)

    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "Blauwe groep")
    N1 <- decimal0(sum(data_group1$N))

    data_group2 <- subset(dat, dat$group == "Groene groep")
    N2 <- decimal0(sum(data_group2$N))

    if(!data_group1_has_data() && !data_group2_has_data()) {
      # No data
      axis_text <- ""
    } else if (input$parents_options == "Inkomen ouders") {
      # get html bin
      perc_html <- get_perc_per_bin_html(data_group1)
      if (!(input$OnePlot)) {perc_html <- get_perc_html(data_group1, data_group2)}
      # if dat has more than 1 bin then add range to text
      if (perc_html != 100) {
        range <- paste0(" gerangschikt van laag naar hoog ouderlijk inkomen ")
      } else {range <- ""}
      
      axis_text <- HTML(paste0("Elke stip in het figuur is gebaseerd op ", perc_html, 
                              "% van de ", labels_dat$population, " op de horizontale as", range, 
                              " binnen de betreffende groep. De verticale as toont het ", 
                              statistic_type_text, " met een ", tolower(labels_dat$outcome_name)))
      
    } else if(input$parents_options == "Opleiding ouders" & !input$change_barplot) {
      axis_text <- HTML(paste0("Elke staaf in het figuur toont het ", statistic_type_text, " met een ",
                               tolower(labels_dat$outcome_name), 
                               " van ", labels_dat$population,
                               ", uitgesplitst naar het hoogst behaalde opleidingsniveau van de ouders."))
    
      } else if(input$parents_options == "Opleiding ouders" & input$change_barplot) {
      axis_text <- HTML(paste0("Elke lollipop (lijn met stip) in het figuur toont het ", statistic_type_text, 
                               " met een ", tolower(labels_dat$outcome_name), " van ", labels_dat$population,
                               ", uitgesplitst naar het hoogst behaalde opleidingsniveau van de ouders. 
                               De bolgrootte is afhankelijk van het aantal mensen dat in de lollipop zit binnen een groep. 
                               Hierdoor kan de gebruiker in één oogopslag zien hoeveel mensen er in een lollipop zitten."))
      }
    
    group1_text <- gen_algemeen_group_text(
      group_type_text = add_bold_text_html(text="blauwe groep", color=data_group1_color),
      group_data_size = N1,
      geslacht_input = input$geslacht1,
      migratie_input = input$migratie1,
      huishouden_input = input$huishouden1,
      geografie_input = input$geografie1,
      populatie_input = labels_dat$population
    )
    
    group2_text <- ""
    if (!input$OnePlot) {
      group2_text <- gen_algemeen_group_text(
        group_type_text = add_bold_text_html(text="groene groep", color=data_group2_color),
        group_data_size = N2,
        geslacht_input = input$geslacht2,
        migratie_input = input$migratie2,
        huishouden_input = input$huishouden2,
        geografie_input = input$geografie2,
        populatie_input = labels_dat$population
      )
    }    
    
    # output
    HTML(paste0("<p><b>", labels_dat$outcome_name, "</b> ", labels_dat$definition, "</p>",
                "<p>", group1_text, " ", group2_text, "</p>", 
                "<p>", axis_text, "</p>"))
    
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
    total_group1 <- dataInput1()  %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
    total_group2 <- dataInput2()  %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
    
    # get median, 25e en 75e quantile
    median_dat1 <- get_median_dat1()
    median_dat2 <- get_median_dat2()
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "Blauwe groep")
    data_group2 <- subset(dat, dat$group == "Groene groep")
    num_rows <- max(nrow(data_group1), nrow(data_group2))
    
    # text for switch
    if (input$SwitchColor == "Blauwe groep") { # SHOW BLUE TEXT IF SWITCH IS OFF
      
      if (data_group1_has_data()) {
        
        if (input$parents_options == "Inkomen ouders") {
          
          # get html percentage
          perc_html <- get_perc_per_bin_html(data_group1)
          if (!(input$OnePlot)) {perc_html <- get_perc_html(data_group1, data_group2)}
          
          if (perc_html != "100") {
            main_text <- paste("De meest linker ", add_bold_text_html(text="blauwe stip", color=data_group1_color), 
                               " laat zien dat, voor de", paste0(perc_html, "%"), labels_dat$population, 
                               " met ouders met de laagste inkomens in de blauwe groep ", 
                               paste0("(gemiddeld € ",  decimal0(data_group1$parents_income[as.numeric(1)]*1000), 
                                      " per jaar),"), "het", statistic_type_text, " met een ", tolower(labels_dat$outcome_name), 
                               paste0(prefix_text, decimal1(data_group1$mean[1]), postfix_text), "was. De meest rechter ", 
                               add_bold_text_html(text="blauwe stip", color=data_group1_color), 
                               " laat zien dat, voor de", paste0(perc_html, "%"), labels_dat$population,
                               " met ouders met de hoogste inkomens in de blauwe groep ", 
                               paste0("(gemiddeld € ",  decimal0(data_group1$parents_income[as.numeric(num_rows)]*1000), 
                                      " per jaar),"), "het", statistic_type_text, " met een ", tolower(labels_dat$outcome_name),
                               paste0(prefix_text, decimal1(data_group1$mean[as.numeric(num_rows)]), postfix_text), "was.")
            
          } else if (perc_html == "100") {
            main_text <- paste("De", add_bold_text_html(text="blauwe stip", color=data_group1_color),
                               "met een jaarlijks inkomen ouders van", 
                               paste0("€ ",  decimal0(data_group1$parents_income*1000), ","),
                               "laat zien dat, voor de", paste0(perc_html, "%"), 
                               labels_dat$population, " het", statistic_type_text, "met een", tolower(labels_dat$outcome_name),
                               paste0(prefix_text, decimal1(data_group1$mean), postfix_text), "was.")
          }
          mean_text <- ""
          median_text <- ""
          # if user has clicked on the line button
          if (!is.null(input$line_options)) {
            
            # add mean text to tabbox
            if ("Gemiddelde" %in% input$line_options) {
              mean_text <- paste(mean_text, gen_mean_text(
                statistic_type_text, 
                labels_dat$outcome_name, 
                add_bold_text_html(text="blauwe groep", color=data_group1_color),
                total_group1$mean,
                prefix_text,
                postfix_text
              ))
            }
            # add median text to tabbox
            if ("Mediaan" %in% input$line_options & input$outcome %in% continuous) {
              median_text <- paste(median_text, gen_median_text(
                labels_dat$outcome_name, 
                add_bold_text_html(text="blauwe groep", color=data_group1_color),
                median_dat1$median,
                prefix_text,
                postfix_text
              ))
            }
          }
          
          HTML(paste0("<p>", main_text, "</p>",
                      "<p>", mean_text, median_text, "</p>"))
          
        } else if (input$parents_options == "Opleiding ouders") {
          
          if (data_group1_has_data()) {
            bar_text <- paste("De linker", add_bold_text_html(text="blauwe staaf", color=data_group1_color), 
                              "laat zien dat, voor", labels_dat$population, "met ouders die geen
                              hbo of wo opleiding hebben, het", statistic_type_text, tolower(labels_dat$outcome_name), 
                              paste0(prefix_text, decimal1(data_group1$mean[3]), postfix_text), 
                              "was. De middelste ", add_bold_text_html(text="blauwe staaf", color=data_group1_color), 
                              "laat zien dat, voor", labels_dat$population, "met tenminste één ouder die
                              een hbo opleiding heeft, het", statistic_type_text, tolower(labels_dat$outcome_name), 
                              paste0(prefix_text, decimal1(data_group1$mean[2]), postfix_text), 
                              "was. De rechter ", add_bold_text_html(text="blauwe staaf", color=data_group1_color), 
                              "laat zien dat, voor", labels_dat$population, "met tenminste één ouder die
                              een wo opleiding heeft, het", statistic_type_text, tolower(labels_dat$outcome_name), 
                              paste0(prefix_text, decimal1(data_group1$mean[1]), postfix_text), "was.")
            
          } else {
            bar_text <- bar_text_nodata
          }
          
          mean_text <- ""
          median_text <- ""
          # if user has clicked on the mean button
          if (!is.null(input$line_options)) {
            if ("Gemiddelde" %in% input$line_options) {
              mean_text <- ""
              mean_text <- paste(mean_text, gen_mean_text(
                statistic_type_text, 
                labels_dat$outcome_name, 
                add_bold_text_html(text="blauwe groep", color=data_group1_color),
                total_group1$mean,
                prefix_text,
                postfix_text
              ))
            }
            # add median text to tabbox
            if ("Mediaan" %in% input$line_options & input$outcome %in% continuous) {
              median_text <- paste(median_text, gen_median_text(
                labels_dat$outcome_name, 
                add_bold_text_html(text="blauwe groep", color=data_group1_color),
                median_dat1$median,
                prefix_text,
                postfix_text
              ))
            }
          }
          
          HTML(paste0("<p>", bar_text, "</p>",
                      "<p>", mean_text, median_text, "</p>"))
          
        }
        
      } else {
        HTML(gen_nodata_found(add_bold_text_html(text="blauwe groep", color=data_group1_color)))
        
      }

    } else if (input$SwitchColor == "Groene groep") { # SHOW GREEN TEXT IF SWITCH IS ON
     
      if (data_group2_has_data()) {

        if (input$parents_options == "Inkomen ouders") {
          
          # get html percentage
          perc_html <- get_perc_per_bin_html(data_group2)
          if (!(input$OnePlot)) {perc_html <- get_perc_html(data_group1, data_group2)}
          
          if (perc_html != "100") {
            main_text <- paste("De meest linker", add_bold_text_html(text="groene stip", color=data_group2_color), 
                               " laat zien dat, voor de", paste0(perc_html, "%"), labels_dat$population, 
                               " met ouders met de laagste inkomens in de groene groep ", 
                               paste0("(gemiddeld € ",  decimal0(data_group2$parents_income[as.numeric(1)]*1000), 
                                      " per jaar),"), "het", statistic_type_text, "met een", tolower(labels_dat$outcome_name), 
                               paste0(prefix_text, decimal1(data_group2$mean[1]), postfix_text), "was. De meest rechter", 
                               add_bold_text_html(text="groene stip", color=data_group2_color), 
                               "laat zien dat, voor de", paste0(perc_html, "%"), labels_dat$population,
                               "met ouders met de hoogste inkomens in de groene groep", 
                               paste0("(gemiddeld €",  decimal0(data_group2$parents_income[as.numeric(num_rows)]*1000), 
                                      "per jaar),"), "het", statistic_type_text, "met een", tolower(labels_dat$outcome_name),
                               paste0(prefix_text, decimal1(data_group2$mean[as.numeric(num_rows)]), postfix_text), "was.")
            
          } else if (perc_html == "100") {
            main_text <- paste("De", add_bold_text_html(text="groene stip", color=data_group2_color),
                               "met een jaarlijks inkomen ouders van", 
                               paste0("€ ",  decimal0(data_group2$parents_income*1000), ","),
                               "laat zien dat, voor de", paste0(perc_html, "%"), 
                               labels_dat$population, " het", statistic_type_text, "met een", 
                               tolower(labels_dat$outcome_name),
                               paste0(prefix_text, decimal1(data_group2$mean), postfix_text), "was.")
          }
          mean_text <- ""
          median_text <- ""
          # if user has clicked on the line button
          if (!is.null(input$line_options)) {
            
            # add mean text to tabbox
            if ("Gemiddelde" %in% input$line_options) {
              mean_text <- paste(mean_text, gen_mean_text(
                statistic_type_text, 
                labels_dat$outcome_name, 
                add_bold_text_html(text="groene groep", color=data_group2_color),
                total_group2$mean,
                prefix_text,
                postfix_text
              ))
            }
            # add median text to tabbox
            if ("Mediaan" %in% input$line_options & input$outcome %in% continuous) {
              median_text <- paste(median_text, gen_median_text(
                labels_dat$outcome_name, 
                add_bold_text_html(text="groene groep", color=data_group2_color),
                median_dat2$median,
                prefix_text,
                postfix_text
              ))
            }
          }
          
          HTML(paste0("<p>", main_text, "</p>",
                      "<p>", mean_text, median_text, "</p>"))
          
        } else if (input$parents_options == "Opleiding ouders") {
          
          if (data_group2_has_data()) {
            bar_text <- paste("De linker", add_bold_text_html(text="groene staaf", color=data_group2_color), 
                              "laat zien dat, voor", labels_dat$population, "die ouders hebben die geen
                              hbo of wo opleiding hebben, het", statistic_type_text, tolower(labels_dat$outcome_name), 
                              paste0(prefix_text, decimal1(data_group2$mean[3]), postfix_text), 
                              "was. De middelste ", add_bold_text_html(text="groene staaf", color=data_group2_color), 
                              "laat zien dat, voor", labels_dat$population, "met tenminste één ouder 
                              een hbo opleiding heeft, het", statistic_type_text, tolower(labels_dat$outcome_name), 
                              paste0(prefix_text, decimal1(data_group2$mean[2]), postfix_text), 
                              "was. De rechter ", add_bold_text_html(text="groene staaf", color=data_group2_color), 
                              "laat zien dat, voor", labels_dat$population, "met tenminste één ouder 
                              een wo opleiding heeft, het", statistic_type_text, tolower(labels_dat$outcome_name), 
                              paste0(prefix_text, decimal1(data_group2$mean[1]), postfix_text), "was.")
          } else {
            bar_text <- bar_text_nodata
          }
          
          mean_text <- ""
          median_text <- ""
          # if user has clicked on the mean button
          if (!is.null(input$line_options)) {
            if ("Gemiddelde" %in% input$line_options) {
              mean_text <- ""
              mean_text <- paste(mean_text, gen_mean_text(
                statistic_type_text, 
                labels_dat$outcome_name, 
                add_bold_text_html(text="groene groep", color=data_group2_color),
                total_group2$mean,
                prefix_text,
                postfix_text
              ))
            }
            # add median text to tabbox
            if ("Mediaan" %in% input$line_options & input$outcome %in% continuous) {
              median_text <- paste(median_text, gen_median_text(
                labels_dat$outcome_name, 
                add_bold_text_html(text="groene groep", color=data_group2_color),
                median_dat2$median,
                prefix_text,
                postfix_text
              ))
            }
          }
          
          HTML(paste0("<p>", bar_text, "</p>",
                      "<p>", mean_text, median_text, "</p>"))
          
        }

      } else {
        HTML(gen_nodata_found(add_bold_text_html(text="groene groep", color=data_group2_color)))
        
      }
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
    data_group1 <- subset(dat, dat$group == "Blauwe groep")
    if (!(input$OnePlot)) {data_group2 <- subset(dat, dat$group == "Groene groep")}


    # Parse additional input options
    line_option_selected <- FALSE
    mean_option_selected <- FALSE
    median_option_selected <- FALSE
    q25_option_selected <- FALSE
    q75_option_selected <- FALSE
    if (!is.null(input$line_options)) {
  
      line_option_selected <- "Lijn"  %in% input$line_options
      mean_option_selected <- "Gemiddelde" %in% input$line_options
      median_option_selected <- "Mediaan" %in% input$line_options & input$outcome %in% continuous
      q25_option_selected <- "25e kwantiel" %in% input$line_options & input$outcome %in% continuous
      q75_option_selected <- "75e kwantiel" %in% input$line_options & input$outcome %in% continuous
      
      # regression line
      # TODO: Add check for data_group2 when data_group1 is empty
      if (nrow(data_group1) == 5) {
        polynom <- 2
      } else {
        polynom <- 3
      }
    }
        

    #### GRADIENT ####
    if (input$parents_options == "Inkomen ouders") {

      # Initialize plot with formatted axis and theme
      plot <- ggplot()

      if (data_group1_has_data() && data_group2_has_data())
        plot <- gen_geom_point(dat, c(data_group1_color, data_group2_color), prefix_text, postfix_text, shape=c(19, 15))
      else if (data_group1_has_data())
        plot <- gen_geom_point(data_group1, data_group1_color, prefix_text, postfix_text, shape=19)
      else if (data_group2_has_data())
        plot <- gen_geom_point(data_group2, data_group2_color, prefix_text, postfix_text, shape=15)

      plot <- plot + # scale_x_continuous(labels = function(x) paste0("€ ", x)) +
              theme_minimal() +
              labs(x ="Jaarlijks inkomen ouders (keer € 1.000)", y ="") +
              thema

      # Plot for data_group1 
      if (data_group1_has_data()) {
        median_dat1 <- get_median_dat1()
        
        # Highlight points
        if (input$tabset1 == "Wat zie ik?")
          plot <- plot + gen_highlight_points(data_group1, data_group1_color)

        # Plot regression line if it is selected
        if (line_option_selected)
          plot <- plot + gen_regression_line(data_group1, data_group1_color, polynom, linetype1_reg)

        # Plot mean line if it is selected
        if (mean_option_selected) {
          total_group1 <- dataInput1() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group1, data_group1_color, linetype1_mean)
        }
        # Plot median line if it is selected
        if (median_option_selected) {
          plot <- plot + gen_median_line(median_dat1, data_group1_color, linetype1_median) 
        }
        # Plot 25e quantile line if it is selected
        if (q25_option_selected) {
          plot <- plot + gen_q25_line(median_dat1, data_group1_color, linetype1_q25) 
        }
        # Plot 75e quantile line if it is selected
        if (q75_option_selected) {
          plot <- plot + gen_q75_line(median_dat1, data_group1_color, linetype1_q75) 
        }
      }

      # Plot for data_group2
      if (data_group2_has_data()) { 
        median_dat2 <- get_median_dat2()
        
        # Highlight points
        if (input$tabset1 == "Wat zie ik?")
          plot <- plot + gen_highlight_points(data_group2, data_group2_color)

        # Plot the additional options
        if (line_option_selected)
          plot <- plot + gen_regression_line(data_group2, data_group2_color, polynom, linetype2_reg)

        if (mean_option_selected) {
          total_group2 <- dataInput2() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group2, data_group2_color, linetype2_mean)
        }
        
        if (median_option_selected) {
          # get the median of the groups
          plot <- plot + gen_median_line(median_dat2, data_group2_color, linetype2_median) 
        }
        # Plot 25e quantile line if it is selected
        if (q25_option_selected) {
          plot <- plot + gen_q25_line(median_dat2, data_group2_color, linetype1_q25) 
        }
        # Plot 75e quantile line if it is selected
        if (q75_option_selected) {
          plot <- plot + gen_q75_line(median_dat2, data_group2_color, linetype1_q75) 
        }
      }     
       
      #### BAR PLOT ####
    } else if(input$parents_options == "Opleiding ouders") {
      
      plot <- ggplot()
      
    if (!(input$change_barplot)) {
  
      if (data_group1_has_data() && data_group2_has_data())
        plot <- gen_bar_plot(dat, prefix_text, postfix_text) + scale_fill_manual("", values=c(data_group1_color, data_group2_color))
      else if (data_group1_has_data())
        plot <- gen_bar_plot(data_group1, prefix_text, postfix_text) + scale_fill_manual("", values=c(data_group1_color))
      else if (data_group2_has_data())
        plot <- gen_bar_plot(data_group2, prefix_text, postfix_text) + scale_fill_manual("", values=c(data_group2_color))

      plot <- plot +
          geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
          labs(x ="Hoogst behaalde opleiding ouders", y ="") +
          theme_minimal() +
          thema
       
      if (mean_option_selected) {
        # get average of the groups
        if (data_group1_has_data()) {
          total_group1 <- dataInput1() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group1, data_group1_color, linetype1_mean) 
        }
        
        if (data_group2_has_data()) {
          total_group2 <- dataInput2() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group2, data_group2_color, linetype2_mean) 
          
        }
      }
      
      if (median_option_selected) {
        # get median of the groups
        if (data_group1_has_data()) {
          median_dat1 <- get_median_dat1()
          plot <- plot + gen_median_line(median_dat1, data_group1_color, linetype1_mean) 
        }
        if (data_group2_has_data()) {
          median_dat2 <- get_median_dat2()
          plot <- plot + gen_median_line(median_dat2, data_group2_color, linetype2_mean) 
          
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
           total_group1 <- dataInput1() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
           plot <- plot + gen_mean_line(total_group1, data_group1_color, linetype1_mean) 
         }
         
         if (data_group2_has_data()) {
           total_group2 <- dataInput2() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
           plot <- plot + gen_mean_line(total_group2, data_group2_color, linetype2_mean) 
           
         }
       }
       
       if (median_option_selected) {
         # get median of the groups
         if (data_group1_has_data()) {
           median_dat1 <- get_median_dat1()
           plot <- plot + gen_median_line(median_dat1, data_group1_color, linetype1_mean) 
         }
         if (data_group2_has_data()) {
           median_dat2 <- get_median_dat2()
           plot <- plot + gen_median_line(median_dat2, data_group2_color, linetype2_mean) 
           
         }
       }

       
        # BUBBLE PLOT
        plot <- plot +
        labs(x ="Hoogst behaalde opleiding ouders", y ="") +
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
      if (input$parents_options == "Inkomen ouders") {
        # Only update the x-axis slider at "inkomen ouders"
        vals$xlim <- layer_scales(plot)$x$range$range
        update_xaxis_slider(data_min=vals$xlim[1], data_max=vals$xlim[2])   
      }
      vals$use_user_input <- TRUE
    } 


    plot <- plot + scale_y_continuous(labels = function(x) paste0(prefix_text, decimal2(x), postfix_text), limits=vals$ylim) 
    
    if (input$parents_options == "Inkomen ouders")
      plot <- plot + scale_x_continuous(labels = function(x) paste0("€ ", x), limits=vals$xlim)

    if (!data_group1_has_data() && !data_group2_has_data()) {
      # Return empty plot when there is no data available
      plot <- ggplot() + annotate(geom="text", x=3, y=3, size = 8,
                                  label="Geen data beschikbaar") + theme_void() +
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
  if ("pasgeborenen" %in% labels_dat$population || "leerlingen in groep 8" %in% labels_dat$population) {
    selected_option = input$parents_options
    parent_choices <- c("Inkomen ouders", "Opleiding ouders")
  } else {
    selected_option <- "Inkomen ouders"
    parent_choices <- "Inkomen ouders"
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
  if (input$parents_options == "Opleiding ouders") {
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
    group_choices <- c("Blauwe groep", "Groene groep")
  } else {
    group_choices <- "Blauwe groep"
  }
  
  updatePrettyRadioButtons(
    session = getDefaultReactiveDomain(),
    inputId = "SwitchColor",
    label = "Toon uitleg van:", 
    choices = group_choices,
    selected = "Blauwe groep",
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
  updateSliderInput(session, "y_axis", label = "Verticale as (Y-as):", value = c(data_min, data_max),
                    min = vals$yslider_min, max = vals$yslider_max, step = vals$ysteps)
}


update_xaxis_slider <- function(data_min, data_max) {
  # Update the x-axis slider
  vals$xsteps <- get_rounded_slider_steps(data_min = data_min, data_max = data_max)
  vals$xslider_max <- get_rounded_slider_max(data_max = data_max, vals$xsteps)
  vals$xslider_min <- get_rounded_slider_min(data_min = data_min, vals$xsteps, min_zero = FALSE)

  # Set UI slider
  updateSliderInput(session, "x_axis", label = "Horizontale as (X-as):", value = c(data_min, data_max),
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
    
    if (input$SwitchTabbox1 == "Uitkomstmaat") {
      algemeenText()
      
    } else if (input$SwitchTabbox1 == "Opleiding ouders") {
      HTML(paste0("<p><b>Opleiding ouders</b> wordt gedefinieerd als de hoogst 
                              behaalde opleiding van één van de ouders. Voor opleiding 
                              ouders hebben we drie categorieën: geen wo en hbo, hbo en wo.</p>
                              
                              <p>We kunnen alleen de opleidingen van de ouders bepalen voor de 
                              jongere geboortecohorten (groep 8 en pasgeborenen), omdat de 
                              gegevens over de opleidingen van ouders pas beschikbaar zijn 
                              vanaf 1983 voor wo, 1986 voor hbo en 2004 voor mbo. 
                             Het opleidingsniveau <i>geen hbo of wo</i> kan hierdoor niet verder 
                             gedifferentieerd worden.</p>"))
      
    } else if (input$SwitchTabbox1 == "Inkomen ouders") {
      
      HTML(paste0("<p><b>Inkomen ouders</b> wordt gedefinieerd als het gemiddelde 
      gezamelijk bruto-inkomen van ouders (zie tab <i>Werkwijze</i> voor meer informatie).</p>
      
      <p>We berekenen eerst het gemiddeld bruto-inkomen van elk ouder gemeten in 2018 euro's. 
      Voor de kinderen waarvan twee ouders bekend zijn, tellen we het gemiddelde inkomen van de 
      ouders bij elkaar op. Als slechts een ouder bekend is, dan gebruiken we alleen dat inkomen van 
      de ouder.</p>"))
      
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

    # call reactive
    makePlot()
    ggplotly(x = vals$plot, tooltip = c("text"))  %>% 
      config(displayModeBar = F, scrollZoom = F) %>%
      style(hoverlabel = label) %>%
      layout(font = font, xaxis=list(fixedrange=T), yaxis=list(fixedrange=T))  
      
  }) # end plot
  
  
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
          width = 9, height = 15)
      print(vals$plot + 
            labs(title = paste0(labels_dat$outcome_name, " (", labels_dat$population, ")"), 
                 caption = paste0(caption_sep, "UITLEG DASHBOARD ONGELIJKHEID IN AMSTERDAM\n\n\n", 
                                  CaptionFile(), caption_sep, 
                                  "ALGEMENE UITLEG\n\n", paste(strwrap(HTML_to_plain_text(algemeenText()), width = 85), collapse = "\n"),
                                  caption_sep, "WAT ZIE IK?\n\n", paste(strwrap(HTML_to_plain_text(watzieikText()), width = 85), collapse = "\n"),
                                  caption_sep, "CAUSALITEIT\n\n", paste(strwrap(causal_text, width = 85), collapse = "\n"), 
                                  caption_sep, "LICENTIE\n\n", caption_license)
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
