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
  
  vals <- reactiveValues()
  
  
  # REACTIVE ----------------------------------------------------------
  
  dataInput1 <- reactive({
    data_group1 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                            gradient_dat$geografie == input$geografie1 & 
                            gradient_dat$geslacht == input$geslacht1 &
                            gradient_dat$migratieachtergrond == input$migratie1 & 
                            gradient_dat$huishouden == input$huishouden1)
  })
  
  dataInput2 <- reactive({
    data_group2 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                            gradient_dat$geografie == input$geografie2 & 
                            gradient_dat$geslacht == input$geslacht2 &
                            gradient_dat$migratieachtergrond == input$migratie2 & 
                            gradient_dat$huishouden == input$huishouden2)
    
  })
  
  
  # FILTER DATA ----------------------------------------------------
  filterData <- reactive({
    
    data_group1 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                            gradient_dat$geografie == input$geografie1 & 
                            gradient_dat$geslacht == input$geslacht1 &
                            gradient_dat$migratieachtergrond == input$migratie1 & 
                            gradient_dat$huishouden == input$huishouden1)
    
    if (!(input$OnePlot)) {
      data_group2 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                              gradient_dat$geografie == input$geografie2 & 
                              gradient_dat$geslacht == input$geslacht2 &
                              gradient_dat$migratieachtergrond == input$migratie2 & 
                              gradient_dat$huishouden == input$huishouden2)
      
    }
    
    if (input$parents_options == "Inkomen ouders") {
      
      if (!(input$OnePlot)) {
        bin <- get_bin(data_group1, data_group2)
        data_group1 <- data_group1 %>% filter(type == bin) %>% mutate(group = "group1")
        data_group2 <- data_group2 %>% filter(type == bin) %>% mutate(group = "group2")
        dat <- bind_rows(data_group1, data_group2)
        
      } else {
        bin <- as.character(get_perc_per_bin(data_group1))
        dat <- data_group1 %>% filter(type == bin) %>% mutate(group = "group1")
      }
      
      
    } else if (input$parents_options == "Opleiding ouders") {
      if (!(input$OnePlot)) {
        data_group1 <- data_group1 %>%  filter(type == "parents_edu") %>% mutate(group = "group1")
        data_group2 <- data_group2 %>% filter(type == "parents_edu") %>% mutate(group = "group2")
        dat <- bind_rows(data_group1, data_group2)
      } else {
        dat <- data_group1 %>%  filter(type == "parents_edu") %>% mutate(group = "group1")
      }
    }
  })

  # filter data for downloading
  DataDownload <- reactive({
    
    dat <- filterData() 
    dat <- dat %>%
      select(-c(subgroep, group, type)) %>%
      relocate(uitkomst_NL)
    
  })
  
  
  # ALGEMEEN TEXT REACTIVE ---------------------------------------------
  
  algemeenText <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    statistic_type_text <- get_stat_per_outcome_html(labels_dat)
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "group1")
    N1 <- decimal0(sum(data_group1$N))
    
    if (!(input$OnePlot)) {
      data_group2 <- subset(dat, dat$group == "group2")
      N2 <- decimal0(sum(data_group2$N))
    }
    
    if (input$parents_options == "Inkomen ouders") {
    
      # get html bin
      bin_html <- get_perc_per_bin_html(data_group1)
      if (!(input$OnePlot)) {bin_html <- get_bin_html(data_group1, data_group2)}
      
      # if dat has more than 1 bin then add range to text
      if (!("100" %in% dat$type)) {
        range <- paste0(", gerangschikt van laag naar hoog ouderlijk inkomen.")
      } else {range <- "."}
      
      axis_text <- HTML(paste0("Elke stip in het figuur is gebaseerd op ", bin_html, 
                              "% van de ", labels_dat$population, range, 
                              " De verticale as toont het eigen", statistic_type_text, tolower(input$outcome),
                              ". De horizontale as toont het gemiddelde inkomen van hun ouders."))
      
    } else if(input$parents_options == "Opleiding ouders") {
      
      axis_text <- HTML(paste0("Elke staaf in het figuur toont het ", statistic_type_text, tolower(input$outcome), 
                               " van ", labels_dat$population,
                               ", uitgesplitst naar het hoogst behaalde opleidingsniveau van de ouders."))
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
    if (!(input$OnePlot)) {
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
    HTML(paste0("<p><b>", input$outcome, "</b> is ", labels_dat$definition, "</p>",
                "<p>", axis_text, "</p>",
                "<p>", group1_text, " ", group2_text, "</p>"))
    
  })
  
  
  # WAT ZIE IK TEXT REACTIVE ---------------------------------------------
  
  watzieikText <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    stat <- get_stat_per_outcome_html(labels_dat)
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "group1")
    bin <- nrow(data_group1)
    if (!(input$OnePlot)) {data_group2 <- subset(dat, dat$group == "group2")}
    
    
    if (input$parents_options == "Inkomen ouders") {
      
      # get total
      total_group1 <- dataInput1()  %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
      total_group2 <- dataInput2()  %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
      
      # get prefix and postfix for outcomes
      prefix_text <- get_prefix(input$outcome)
      postfix_text <- get_postfix(input$outcome)
      statistic_type_text <- get_stat_per_outcome_html(labels_dat)
      
      # get html bin
      bin_html <- get_perc_per_bin_html(data_group1)
      if (!(input$OnePlot)) {bin_html <- get_bin_html(data_group1, data_group2)}
      
      if (bin_html != "100") {
        
        blue_text <- paste("De meest linker ", add_bold_text_html(text="blauwe stip", color=data_group1_color), 
                           " laat zien dat, voor de", paste0(bin_html, "%"), labels_dat$population, 
                           " met ouders met de laagste inkomens in de blauwe groep, het",
                           statistic_type_text, tolower(input$outcome), 
                           paste0(prefix_text, decimal2(data_group1$mean[1]), postfix_text), "was. De meest rechter ", 
                           add_bold_text_html(text="blauwe stip", color=data_group1_color), 
                           " laat zien dat, voor de", paste0(bin_html, "%"), labels_dat$population,
                           " met ouders met de hoogste inkomens in de blauwe groep, het", 
                           statistic_type_text, tolower(input$outcome),
                           paste0(prefix_text, decimal2(data_group1$mean[as.numeric(bin)]), postfix_text), "was.")
        
        if (!(input$OnePlot)) {
          green_text <- paste("De meest linker ", add_bold_text_html(text="groene stip", color=data_group2_color), 
                              " laat zien dat, voor de", paste0(bin_html, "%"), 
                              labels_dat$population, " met ouders met de laagste inkomens in de groene groep, het",
                              statistic_type_text, tolower(input$outcome), 
                              paste0(prefix_text, decimal2(data_group2$mean[1]), postfix_text), "was. De meest rechter ", 
                              add_bold_text_html(text="groene stip", color=data_group2_color), 
                              " laat zien dat, voor de", paste0(bin_html, "%"), labels_dat$population, 
                              " met ouders met de hoogste inkomens in de groene groep, het",
                              statistic_type_text, tolower(input$outcome),
                              paste0(prefix_text, decimal2(data_group2$mean[as.numeric(bin)]), postfix_text), "was.")
        } else {green_text <- ""}
        
      } else if (bin_html == "100") {
        
        blue_text <- paste("De", add_bold_text_html(text="blauwe stip", color=data_group1_color),
                           "laat zien dat, voor de", paste0(bin_html, "%"), 
                           labels_dat$population, " het", statistic_type_text, tolower(input$outcome),
                           paste0(prefix_text, decimal2(data_group1$mean), postfix_text), "was.")
        
        if (!(input$OnePlot)) {
          green_text <- paste("De", add_bold_text_html(text="groene stip", color=data_group2_color),
                              "laat zien dat, voor de", paste0(bin_html, "%"), 
                              labels_dat$population, "het", statistic_type_text, tolower(input$outcome),
                              paste0(prefix_text, decimal2(data_group2$mean), postfix_text), "was.")
          
        } else {green_text <- ""}
        
      }
      mean_text <- ""
      # if user has clicked on the mean button
      if (!is.null(input$line_options)) {
        
        if ("Gemiddelde" %in% input$line_options) {
          
          mean_text <- HTML(paste0("Het totale ", statistic_type_text, " ", tolower(input$outcome), " van de ",  
                                   add_bold_text_html(text="blauwe groep", color=data_group1_color), " is ",
                                   paste0(prefix_text, decimal2(total_group1$mean), postfix_text), "."))
          
          if (!(input$OnePlot)) {
            mean_text <- 
              HTML(paste0("Het totale ", statistic_type_text, " ", tolower(input$outcome), " van de ",  
                          add_bold_text_html(text="blauwe groep", color=data_group1_color), " is ",
                          paste0(prefix_text, decimal2(total_group1$mean), postfix_text), ". Het totale ", 
                          statistic_type_text, " ", tolower(input$outcome), " van de ",
                          add_bold_text_html(text="groene groep", color=data_group2_color), " is ",
                          paste0(prefix_text, decimal2(total_group2$mean), postfix_text), "."))
          } 
        }
      }
      
      HTML(paste0("<p>", blue_text, "</p>",
                  "<p>", green_text, "</p>", 
                  "<p>", mean_text, "</p>"))
      
      
    } else if(input$parents_options == "Opleiding ouders") {
      
      HTML(paste0("<p>HIER KOMT EEN TEKST VOOR DE STAAFDIAGRAMMEN. </p>"))
      
    }
    
  })
  
  
  # FIGURE PLOT REACTIVE ----------------------------------------------------
  
  makePlot <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    
    # get prefix and postfix for outcomes
    prefix_text <- get_prefix(input$outcome)
    postfix_text <- get_postfix(input$outcome)
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "group1")
    if (!(input$OnePlot)) {data_group2 <- subset(dat, dat$group == "group2")}


    data_group1_is_empty = ifelse(nrow(data_group1) <= 0, TRUE, FALSE)

    if(input$OnePlot) {
      data_group2_is_empty = TRUE
    } else {
      data_group2_is_empty = ifelse(nrow(data_group2) <= 0, TRUE, FALSE)
    }


    # Parse additional input options
    line_option_selected <- FALSE
    mean_option_selected <- FALSE
    if (!is.null(input$line_options)) {
  
      line_option_selected <- "Lijn"  %in% input$line_options
      mean_option_selected <- "Gemiddelde" %in% input$line_options

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
      plot <- ggplot() +
        scale_x_continuous(labels = function(x) paste0("€ ", x)) +
        scale_y_continuous(labels = function(x) paste0(prefix_text, decimal2(x), postfix_text)) +
        theme_minimal() +
        labs(x ="Jaarlijks inkomen ouders (keer € 1.000)", y ="") +
        thema

      # Plot for data_group1 
      if (!data_group1_is_empty) {
        # Main plot
        plot <- plot + gen_geom_point(data_group1, input$geografie1, data_group1_color, 
                                      prefix_text, postfix_text, shape=19)
        
        # Highlight points
        if (input$tabset1 == "Wat zie ik?")
          plot <- plot + gen_highlight_points(data_group1, data_group1_color)

        # Plot regression line if it is selected
        if (line_option_selected)
          plot <- plot + gen_regression_line(data_group1, data_group1_color, polynom)

        # Plot mean line if it is selected
        if (mean_option_selected) {
          # get average of the groups
          total_group1 <- dataInput1() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group1, data_group1_color)
        }
      }

      # Plot for data_group2
      if (!data_group2_is_empty) {
        # Main plot
        plot <- plot + gen_geom_point(data_group2, input$geografie2, data_group2_color, 
                                      prefix_text, postfix_text, shape=15)
        
        # Highlight points
        if (input$tabset1 == "Wat zie ik?")
          plot <- plot + gen_highlight_points(data_group2, data_group2_color)

        # Plot the additional options
        if (line_option_selected)
          plot <- plot + gen_regression_line(data_group2, data_group2_color, polynom)

        if (mean_option_selected) {
          total_group2 <- dataInput2() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group2, data_group2_color)
        }
      }      
      #### BAR PLOT ####
    } else if(input$parents_options == "Opleiding ouders") {
      
      plot <- ggplot()
      if (!data_group1_is_empty && !data_group2_is_empty)
        plot <- gen_bar_plot(dat, prefix_text, postfix_text)
      else if (!data_group1_is_empty)
        plot <- gen_bar_plot(data_group1, prefix_text, postfix_text)
      else if (!data_group2_is_empty)
        plot <- gen_bar_plot(data_group2, prefix_text, postfix_text)

      plot <- plot +
          geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
          scale_fill_manual(values=c(data_group1_color, data_group2_color)) + 
          scale_y_continuous(labels = function(x) paste0(prefix_text, decimal2(x), postfix_text)) +
          labs(x ="Hoogst behaalde opleiding ouders", y ="") +
          theme_minimal() +
          thema
       
      
    }
    
    vals$plot <- plot

    # Return whether or not there are any plots 
    if (!data_group1_is_empty || !data_group2_is_empty)
      has_plots = TRUE
    else
      has_plots = FALSE
  })
  
  
  # DOWNLOAD REACTIVE ----------------------------------------------------
  
  txtFile <- reactive({
    
    text <- c(temp_txt, readme_sep, 
              "ALGEMEEN","", 
              paste(strwrap(HTML_to_plain_text(algemeenText()), width = 75), collapse = "\n"), 
              readme_sep, "WAT ZIE IK?", "", 
              paste(strwrap(HTML_to_plain_text(watzieikText()), width = 75), collapse = "\n"), 
              readme_sep, "CAUSALITEIT", "", causal_text)
    
  })


  # UI RADIOBUTTON TOOLTIP ---------------------------------------------
  
  
  output$radio_button <- renderText({
    
    if(input$outcome %in% subset(outcome_dat$outcome_name,
                                 (outcome_dat$population != "pasgeborenen" &
                                  outcome_dat$population != "leerlingen van groep 8"))) {
      
      HTML("Niet beschikbaar voor deze uitkomstmaat!")
    } else {
      HTML("Beschikbaar voor deze uitkomst!")
    }
  })
  
  
  
  # HTML TEXT ----------------------------------------------------------
  
  #### ALGEMEEN ####
  output$selected_outcome <- renderPrint({
    
    algemeenText()
    
  })
  
  
  #### WAT ZIE JE? ####
  output$sample_uitleg <- renderPrint({
 
    watzieikText()
    
  })
  
  
  
  # GRADIENT ----------------------------------------------------------
  
  
  # title plot widget
  output$title_plot <- renderPrint({
    HTML(input$outcome)
  })
  
  
  # Create plot
  output$main_figure <- renderPlotly({
    
    # withProgress(message = "Even geduld! Bezig met figuren maken", value = 0, {
    #   for (i in 1:5) {
    #     incProgress(1/5)
    #     Sys.sleep(0.1)
    #   }
    # })
    
    # call reactive
    has_plots = makePlot()
    
    # load plot
    if(has_plots) {
      ggplotly(x = plot, tooltip = c("text"))  %>% 
        config(displayModeBar = F, scrollZoom = F) %>%
        style(hoverlabel = label) %>%
        layout(font = font)  
    } 
      
  }) # end plot
  
  
  
  #### DOWNLOAD DATA ####

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("data-", Sys.time(), ".zip")
    },
    content = function(file) {
      
      # set temporary dir
      tmpdir <- tempdir()
      setwd(tmpdir)
      zip_files <- c()
      
      # get files
      csv_name <- paste0("data-", Sys.time(), ".csv")
      write.csv(DataDownload(), csv_name)
      zip_files <- c(zip_files, csv_name)
      
      # write txt file
      fileConn <- file("README.txt")
      writeLines(txtFile(), fileConn)
      close(fileConn)
      zip_files <- c(zip_files, "README.txt")
      
      zip(zipfile = file, files = zip_files)
      
    },
    contentType = "application/zip"
  )
  

  #### DOWNLOAD PLOT ####
  output$downloadPlot <- downloadHandler(
    
    filename = function() {
      paste0("fig-", Sys.time(), ".zip")
    },
    content = function(file) {
      
      # set temporary dir
      tmpdir <- tempdir()
      setwd(tmpdir)
      zip_files <- c()
      
      # get plot
      # TODO: add legend
      fig_name <- paste0("fig-", Sys.time(), ".pdf")
      pdf(fig_name, encoding = "ISOLatin9.enc", 
          width = 7.5, height = 5)
      print(vals$plot + 
              labs(title = input$outcome, 
                   caption = "test")
            )
      dev.off()
      zip_files <- c(zip_files, fig_name)
      
      
      # write txt file
      fileConn <- file("README.txt")
      writeLines(txtFile(), fileConn)
      close(fileConn)
      zip_files <- c(zip_files, "README.txt")
      
      zip(zipfile = file, files = zip_files)
      
    },
    contentType = "application/zip"
  )
  
} # end of server