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
  
  
  #### FILTER DATA ####
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
        dat <- data_group1 %>% filter(type == bin)
      }
      
      
    } else if (input$parents_options == "Opleiding ouders") {
      
      # filter data with bin
      data_group1 <- data_group1 %>%  filter(type == "parents_edu") %>% mutate(group = "group1")
      dat <- data_group1
      
      if (!(input$OnePlot)) {
        data_group2 <- data_group2 %>% filter(type == "parents_edu") %>% mutate(group = "group2")
        dat <- bind_rows(data_group1, data_group2)
        
      } 
    }
  })
  
  
  # algemeen text
  algemeen_text <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    stat <- get_stat_per_outcome_html(labels_dat)
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "group1")
    N1 <- decimal0(sum(data_group1$N))
    
    if (!(input$OnePlot)) {
      data_group2 <- subset(dat, dat$group == "group2")
      N2 <- decimal0(sum(data_group2$N))
    }
    
    
    if (input$parents_options == "Inkomen ouders") {
    
      bin_html <- get_perc_per_bin_html(data_group1)
      if (!(input$OnePlot)) {bin_html <- get_bin_html(data_group1, data_group2)}
      
      
      # if dat has more than 1 bin then add range to text
      if (!("100" %in% dat$type)) {
        range <- paste0(" gerangschikt van laag naar hoog ouderlijk inkomen.")
      } else {range <- "."}
      
      axis_text <- HTML(paste0("Elke stip in het figuur is gebaseerd op ", bin_html, 
                              " procent van de ", labels_dat$population, range, 
                              " De verticale as toont het eigen", stat, tolower(input$outcome),
                              ". De horizontale as toont het gemiddelde inkomen van hun ouders."))
      
      
    } else if(input$parents_options == "Opleiding ouders") {
      
      axis_text <- HTML(paste0("Elke staaf in het figuur toont het ", stat, tolower(input$outcome), 
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
    
    algemeen_text()
    
  })
  
  
  #### WAT ZIE JE? ####
  output$sample_uitleg <- renderPrint({
    
    if (input$parents_options == "Inkomen ouders") {
      
      labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
      data_group1 <- dataInput1() %>% filter(opleiding_ouders == "Totaal")
      data_group2 <- dataInput2() %>% filter(opleiding_ouders == "Totaal")
      
      # get total
      total_group1 <- data_group1 %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
      total_group2 <- data_group2 %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
      
      
      # get signs for outcomes
      sign1 <- sign1_func(input$outcome)
      sign2 <- sign2_func(input$outcome)
      stat <- get_stat_per_outcome_html(labels_dat)
      
      # filter data with bin
      if (!(input$OnePlot)) {
        bin <- get_bin(data_group1, data_group2)
        bin_html <- get_bin_html(data_group1, data_group2)
        data_group1 <- data_group1 %>% filter(type == bin)
        data_group2 <- data_group2 %>% filter(type == bin)
        
      } else {
        bin <- as.character(get_perc_per_bin(data_group1))
        bin_html <- get_perc_per_bin_html(data_group1)
        data_group1 <- data_group1 %>% filter(type == bin)
      }
      
      if (bin != "100") {
        
        blue_text <- paste("De meest linker ", add_bold_text_html(text="blauwe stip", color=data_group1_color), " laat zien dat voor de", paste0(bin_html, "%"), 
                           labels_dat$population, "het", stat, tolower(input$outcome), 
                           paste0(sign1, round(data_group1$mean[1], 2), sign2), "was.
                         De meest rechter ", add_bold_text_html(text="blauwe stip", color=data_group1_color), " laat zien dat voor de", paste0(bin_html, "%"), 
                           labels_dat$population,
                           "het", stat, tolower(input$outcome),
                           paste0(sign1, decimal2(data_group1$mean[as.numeric(bin)]), sign2), "was.")
        
        if (!(input$OnePlot)) {
          green_text <- paste("De meest linker ", add_bold_text_html(text="groene stip", color=data_group2_color), " laat zien dat voor de", paste0(bin_html, "%"), 
                              labels_dat$population, "het", stat, tolower(input$outcome), 
                              paste0(sign1, round(data_group2$mean[1], 2), sign2), "was.
                         De meest rechter ", add_bold_text_html(text="groene stip", color=data_group2_color), " laat zien dat voor de", paste0(bin_html, "%"), 
                              labels_dat$population, "het", stat, tolower(input$outcome),
                              paste0(sign1, decimal2(data_group2$mean[as.numeric(bin)]), sign2), "was.")
        } else {green_text <- ""}
        
        
      } else if (bin == "100") {
        
        blue_text <- paste("De", add_bold_text_html(text="blauwe stip", color=data_group1_color),
                           "laat zien dat voor de", paste0(bin_html, "%"), 
                           labels_dat$population, " het", stat, tolower(input$outcome),
                           paste0(sign1, decimal2(data_group1$mean), sign2), "was.")
        
        if (!(input$OnePlot)) {
          green_text <- paste("De", add_bold_text_html(text="groene stip", color=data_group2_color),
                              "laat zien dat voor de", paste0(bin_html, "%"), 
                              labels_dat$population, "het", stat, tolower(input$outcome),
                              paste0(sign1, decimal2(data_group2$mean), sign2), "was.")
          
        } else {green_text <- ""}
        
      }
      mean_text <- ""
      # if user has clicked on the mean button
      if (!is.null(input$line_options)) {
        
        if ("Gemiddelde" %in% input$line_options) {
          
          mean_text <- HTML(paste0("Het totale ", stat, " ", tolower(input$outcome), " van de ",  
                                   add_bold_text_html(text="blauwe groep", color=data_group1_color), " is ",
                                   paste0(sign1, decimal2(total_group1$mean), sign2), "."))
          
          if (!(input$OnePlot)) {
            mean_text <- 
              HTML(paste0("Het totale ", stat, " ", tolower(input$outcome), " van de ",  
                          add_bold_text_html(text="blauwe groep", color=data_group1_color), " is ",
                          paste0(sign1, decimal2(total_group1$mean), sign2), ". Het totale ", 
                          stat, " ", tolower(input$outcome), " van de ",
                          add_bold_text_html(text="groene groep", color=data_group2_color), " is ",
                          paste0(sign1, decimal2(total_group2$mean), sign2), "."))
            
          } 
        }
      }
      
      HTML(paste0("<p>", blue_text, "</p>",
                  "<p>", green_text, "</p>", 
                  "<p>", mean_text, "</p>"))
      
      
    } else if(input$parents_options == "Opleiding ouders") {
      
      # data_group1 <- dataInput1() %>% filter(opleiding_ouders != "Totaal") 
      # if (!(input$OnePlot)) {
      #   data_group2 <- dataInput2() %>% filter(opleiding_ouders != "Totaal") 
      # }
      
      
      HTML(paste0("<p>HIER KOMT EEN TEKST VOOR DE STAAFDIAGRAMMEN. </p>"))
      
    }
    
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
    
    # get signs for outcomes
    sign1 <- sign1_func(input$outcome)
    sign2 <- sign2_func(input$outcome)
    
    
    # subset data
    data_group1 <- dataInput1()
    if (!(input$OnePlot)) {data_group2 <- dataInput2()} else (data_group2 <- data.frame())
    
    #### GRADIENT ####
    if (input$parents_options == "Inkomen ouders") {
      
      # get average of the groups
      total_group1 <- data_group1 %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
      if (!(input$OnePlot)) {
        total_group2 <- data_group2 %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
      }
      
      # filter data with bin
      if (!(input$OnePlot)) {
        bin <- get_bin(data_group1, data_group2)
        data_group1 <- data_group1 %>% filter(type == bin)
        data_group2 <- data_group2 %>% filter(type == bin)
        dat <- bind_rows(data_group1, data_group2)

        
      } else {
        bin <- as.character(get_perc_per_bin(data_group1))
        data_group1 <- data_group1 %>% filter(type == bin)
        dat <- data_group1
      }
      
      # make plot
      plot <- ggplot() +
        geom_point(data = data_group1, 
                   aes(x = parents_income, y = mean,
                       text = paste0("<b>", input$geografie1, "</b></br>",
                                     "</br>Inkomen ouders: €", decimal2(parents_income),
                                     "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                     "</br>Aantal mensen: ", decimal2(N))),
                   color = data_group1_color, size = 3) +
        scale_x_continuous(labels = function(x) paste0("€ ", x)) +
        scale_y_continuous(labels = function(x) paste0(sign1, decimal2(x), sign2)) +
        theme_minimal() +
        labs(x ="Jaarlijks inkomen ouders (keer € 1.000)", y ="") +
        thema 
      
      # if user clicks on tabbox "Wat zie ik?" highlight left and right points
      if (input$tabset1 == "Wat zie ik?") {

        # get min and max of the data for highlighting the blue group
        min_max1 <- data_group1 %>%
          filter(parents_income == min(parents_income) |
                   parents_income == max(parents_income))

        plot <- plot +
          geom_point(data = min_max1, aes(x = parents_income, y = mean),
                     color = data_group1_color, size = 9, alpha = 0.35)

        # if user shows two groups then also highlight green group
        if (!(input$OnePlot)) {
          
        min_max2 <- data_group2 %>%
          filter(parents_income == min(parents_income) |
                   parents_income == max(parents_income))
        
        plot <- plot +
          geom_point(data = min_max2, aes(x = parents_income, y = mean),
                     color = data_group2_color, size = 9, alpha = 0.35)
        
        }
      }
      
      if (!(input$OnePlot)) {
        
        plot <- plot +
          geom_point(data = data_group2, 
                     aes(x = parents_income, y = mean,
                         text = paste0("<b>", input$geografie2, "</b></br>",
                                       "</br>Inkomen ouders: €", decimal2(parents_income),
                                       "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                       "</br>Aantal mensen: ", decimal2(N))),
                     color = data_group2_color, size = 3, shape = 18) 
      } 
      
      
      # if user selected checkbox
      if (!is.null(input$line_options)) {
        
        line <- "Lijn"  %in% input$line_options
        mean <- "Gemiddelde" %in% input$line_options
        
        # regression line
        if (nrow(data_group1) == 5) {
          polynom <- 2
        } else {
          polynom <- 3
        }
        
        if (line & mean) {
          plot <- plot + 
            geom_smooth(data = data_group1, aes(x = parents_income, y = mean),  method = "lm",
                        se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), 
                        color = data_group1_color, linetype = "longdash") +
            geom_abline(aes(intercept = total_group1$mean, slope = 0),
                        linetype = "twodash", size=0.5, color = data_group1_color) 
          
    
          if (!(input$OnePlot)) {
            plot + geom_smooth(data = data_group2, aes(x = parents_income, y = mean),  method = "lm",
                               se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), 
                               color = data_group2_color, linetype = "longdash") +
              geom_abline(aes(intercept = total_group2$mean, slope = 0),
                          linetype="longdash", size=0.5, color = data_group2_color)
          }
          
          
        } else if (line){
          plot <- plot + 
            geom_smooth(data = data_group1, aes(x = parents_income, y = mean),  method = "lm",
                        se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), 
                        color = data_group1_color, linetype = "longdash") 
          
          if (!(input$OnePlot)) {
            plot + geom_smooth(data = data_group2, aes(x = parents_income, y = mean),  method = "lm",
                               se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), 
                               color = data_group2_color, linetype = "longdash") 
            
          }
          
        } else if (mean){
          plot <- plot + 
            geom_abline(aes(intercept = total_group1$mean, slope = 0),
                        linetype="twodash", size=0.5, color = data_group1_color)
          
          if (!(input$OnePlot)) {
            plot + geom_abline(aes(intercept = total_group2$mean, slope = 0),
                               linetype = "twodash", size=0.5, color = data_group2_color) 
          }
          
        }
      }
      
      ggplotly(x = plot, tooltip = c("text"))  %>% 
        config(displayModeBar = F, scrollZoom = F) %>%
        style(hoverlabel = label) %>%
        layout(font = font)
      
      
      #### BAR PLOT ####
    } else if(input$parents_options == "Opleiding ouders") {
      
      data_group1 <- data_group1 %>% filter(opleiding_ouders != "Totaal") %>% mutate(group = "group1")
      
      if (!(input$OnePlot)) {
        
        data_group2 <- data_group2 %>% filter(opleiding_ouders != "Totaal") %>% mutate(group = "group2")
        
        dat <- bind_rows(data_group1, data_group2)
        
        plot <- ggplot(dat, aes(x = opleiding_ouders, y = mean, fill = group, 
                                text = paste0("<b>", geografie, "</b></br>",
                                              "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                              "</br>Aantal mensen: ", decimal2(N)))) +
          geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
          scale_fill_manual(values=c(data_group1_color, data_group2_color)) + 
          scale_y_continuous(labels = function(x) paste0(sign1, decimal2(x), sign2)) +
          labs(x ="Hoogst behaalde opleiding ouders", y ="") +
          theme_minimal() +
          thema
        
      } else if (input$OnePlot) {
        
        plot <- ggplot(data_group1, aes(x = opleiding_ouders, y = mean, fill = group, 
                                        text = paste0("<b>", geografie, "</b></br>",
                                                      "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                                      "</br>Aantal mensen: ", decimal2(N)))) +
          geom_bar(stat="identity", position=position_dodge(), width = 0.4) +
          scale_fill_manual(values=c(data_group1_color, data_group2_color)) + 
          scale_y_continuous(labels = function(x) paste0(sign1, decimal2(x), sign2)) +
          labs(x ="Hoogst behaalde opleiding ouders", y ="") +
          theme_minimal() +
          thema
        
      } 
      
      ggplotly(x = plot, tooltip = c("text"))  %>% 
        config(displayModeBar = F, scrollZoom = F) %>%
        style(hoverlabel = label) %>%
        layout(font = font)      
      
    }
  }) # end plot
  
  
  
  #### DOWNLOAD ####

  # download data
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
      write.csv(filterData(), csv_name)
      zip_files <- c(zip_files, csv_name)
      
      # write txt file
      fileConn <- file("README.txt")
      writeLines(c(temp_txt, readme_sep, 
                   "ALGEMEEN","", HTML_to_plain_text(algemeen_text()), 
                   readme_sep, "WAT ZIE IK?", ""),
                 fileConn)
      
      
      close(fileConn)
      zip_files <- c(zip_files, "README.txt")
      
      zip(zipfile = file, files = zip_files)
      
    },
    contentType = "application/zip"
  )
  

  # download plot
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$dataset, '.png', sep='') },
    content = function(file) {
      png(file)
      print(plotInput())
      dev.off()
    })
  
  
  
}