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



  # HTML TEXT ----------------------------------------------------------
  
  #### ALGEMEEN ####
  output$selected_outcome <- renderPrint({

    # select outcome from outcome_dat
    sample_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    stat <- get_stat_per_outcome_html(sample_dat)

    # get data
    data_group1 <- dataInput1()
    if (!(input$OnePlot)) {
      data_group2 <- dataInput2()
    } else {data_group2 <- data.frame()}


    if (input$parents_options == "Inkomen ouders") {

      # filter data with bin
      if (!(input$OnePlot)) {
        bin <- get_bin(data_group1, data_group2)
        bin_html <- get_bin_html(data_group1, data_group2)

        data_group1 <- data_group1 %>% dplyr::filter(type == bin)
        data_group2 <- data_group2 %>% dplyr::filter(type == bin)

        # select info from data for html text
        N1 <- decimal0(sum(data_group1$N))
        N2 <- decimal0(sum(data_group2$N))


        # if user clicked on showing only one group
      } else {
        bin <- as.character(get_perc_per_bin(data_group1))
        bin_html <- get_perc_per_bin_html(data_group1)

        data_group1 <- data_group1 %>% dplyr::filter(type == bin)
        N1 <- decimal0(sum(data_group1$N))

      }

      axis_text <- HTML(paste0("Elke stip in het figuur is gebaseerd op ", bin_html, " procent van de ",
                               sample_dat$population, " gerangschikt van laag naar hoog ouderlijk inkomen.
                              De verticale as toont het eigen", stat, tolower(input$outcome),
                               ". De horizontale as toont het gemiddelde inkomen van hun ouders."))

    } else if(input$parents_options == "Opleiding ouders") {

      # filter data with bin
      data_group1 <- data_group1 %>% dplyr::filter(type == "parents_edu")
      N1 <- decimal0(sum(data_group1$N))

      if (!(input$OnePlot)) {
        data_group2 <- data_group2 %>% dplyr::filter(type == "parents_edu")
        N2 <- decimal0(sum(data_group2$N))
      }

      axis_text <- HTML(paste0("Elke staaf in het figuur toont het", stat, tolower(input$outcome), " van ",
                               sample_dat$population,
                               ", uitgesplitst naar het hoogst behaalde opleidingsniveau van de ouders."))
    }

    sex1 <- subset(html_text$html_text, html_text$input_text == input$geslacht1)
    if (input$migratie1 != "Totaal") {
      mig1 <- paste0(" met een ", subset(html_text$html_text, html_text$input_text == input$migratie1), " achtergrond")
    } else {mig1 <- ""}
    if (input$huishouden1 != "Totaal") {
      hh1 <- paste0("in een ", tolower(input$huishouden1))
    } else {hh1 <- ""}

    group1_text <- HTML(paste0("De blauwe groep (groep 1) bestaat uit ", N1, " ", sex1, " ",
                sample_dat$population, " ", mig1, " die zijn opgegroeid ", hh1, " in ",
                input$geografie1, "."))


    if (!(input$OnePlot)) {
      sex2 <- subset(html_text$html_text, html_text$input_text == input$geslacht2)
      if (input$migratie2 != "Totaal") {
        mig2 <- paste0("met een ", subset(html_text$html_text, html_text$input_text == input$migratie2), " achtergrond")
      } else {mig2 <- ""}
      if (input$huishouden2 != "Totaal") {
        hh2 <- paste0("in een ", tolower(input$huishouden2))
      } else {hh2 <- ""}

      group2_text <- HTML(paste0("De groene groep (groep 2) bestaat uit ", N2, " ", sex2, " ",
                                 sample_dat$population, " ", mig2, " die zijn opgegroeid ", hh2,
                                 " in ", input$geografie2, "."))

    } else {group2_text <- ""}

    # output
    HTML(paste0("<p><b>", input$outcome, "</b> is ", sample_dat$definition, "</p>",
                "<p>", axis_text, "</p>",
                "<p>", group1_text, " ", group2_text, "</p>"))

  })


  #### WAT ZIE JE? ####
  output$sample_uitleg <- renderPrint({

    # get total
    # total_group1 <- data_group1 %>% dplyr::filter(bins == "Totaal", opleiding_ouders == "Totaal")
    # total_group2 <- data_group2 %>% dplyr::filter(bins == "Totaal", opleiding_ouders == "Totaal")
    
    sample_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    data_group1 <- dataInput1() %>% dplyr::filter(opleiding_ouders == "Totaal")
    data_group2 <- dataInput2() %>% dplyr::filter(opleiding_ouders == "Totaal")
    
    
    stat <- get_stat_per_outcome_html(sample_dat)

    # get signs for outcomes
    sign1 <- sign1_func(input$outcome)
    sign2 <- sign2_func(input$outcome)

    
    # filter data with bin
    if (!(input$OnePlot)) {
      bin <- get_bin(data_group1, data_group2)
      bin_html <- get_bin_html(data_group1, data_group2)
      data_group1 <- data_group1 %>% dplyr::filter(type == bin)
      data_group2 <- data_group2 %>% dplyr::filter(type == bin)

    } else {
      bin <- get_perc_per_bin(data_group1)
      bin_html <- get_perc_per_bin_html(data_group1)
      data_group1 <- data_group1 %>% dplyr::filter(type == bin)
    }

    if (bin != "100") {

      blue_text <- paste("De meest linker ", add_bold_text_html(text="blauwe stip", color=data_group1_color), " (groep 1) laat zien dat voor de", paste0(bin_html, "%"), 
                         sample_dat$population, "het", stat, tolower(input$outcome), 
                         paste0(sign1, round(data_group1$mean[1], 2), sign2), "was.
                         De meest rechter ", add_bold_text_html(text="blauwe stip", color=data_group1_color), " (groep 1) laat zien dat voor de", paste0(bin_html, "%"), 
                         sample_dat$population,
                         "het", stat, tolower(input$outcome),
                         paste0(sign1, decimal2(data_group1$mean[as.numeric(bin)]), sign2), "was.")


      green_text <- paste("De meest linker ", add_bold_text_html(text="groene stip", color=data_group2_color), " (groep 2) laat zien dat voor de", paste0(bin_html, "%"), 
                          sample_dat$population, "het", stat, tolower(input$outcome), 
                          paste0(sign1, round(data_group2$mean[1], 2), sign2), "was.
                         De meest rechter ", add_bold_text_html(text="groene stip", color=data_group2_color), " (groep 2) laat zien dat voor de", paste0(bin_html, "%"), 
                          sample_dat$population, "het", stat, tolower(input$outcome),
                         paste0(sign1, decimal2(data_group2$mean[as.numeric(bin)]), sign2), "was.")



    } else if (bin == "100") {

      blue_text <- paste("De blauwe stip (groep 1) laat zien dat voor de", paste0(bin_html, "%"), 
                         sample_dat$population, " het", stat, tolower(input$outcome),
                         paste0(sign1, decimal2(data_group1$mean), sign2), "was.")

      green_text <- paste("De groene stip (groep 2) laat zien dat voor de", paste0(bin_html, "%"), 
                          sample_dat$population, "het", stat, tolower(input$outcome),
                          paste0(sign1, decimal2(data_group2$mean), sign2), "was.")


    }
    mean_text <- ""
    # if user has clicked on the mean button
    # if (!is.null(input$line_options)) {
    # 
    #   if (input$line_options == "Gemiddelde") {
    # 
    #     mean_text <- HTML(paste0("Het totale ", stat, " ", tolower(input$outcome), " van groep 1 is ",
    #                              paste0(sign1, decimal2(total_group1$mean), sign2), ". 
    #                              het gemiddelde van groep 2 is ", 
    #                              paste0(sign1, decimal2(total_group2$mean), sign2, ".")))
    #   }
    # }
    

 HTML(paste0("<p>", blue_text, "</p>",
             "<p>", green_text, "</p>", 
             "<p>", mean_text, "</p>"))


  })
  
  
  # GRADIENT ----------------------------------------------------------

  
  # title plot widget
  output$title_plot <- renderPrint({
    HTML(input$outcome)
  })

  
  # Create plot
  output$main_figure <- renderPlotly({

    withProgress(message = "Even geduld! Bezig met figuren maken", value = 0, {
                   for (i in 1:5) {
                     incProgress(1/5)
                     Sys.sleep(0.15)
                   }
                 })

    # get signs for outcomes
    sign1 <- sign1_func(input$outcome)
    sign2 <- sign2_func(input$outcome)


    # subset data
    data_group1 <- dataInput1()
    if (!(input$OnePlot)) {data_group2 <- dataInput2()} else (data_group2 <- data.frame())
    
    #### GRADIENT ####
    if (input$parents_options == "Inkomen ouders") {
      
      # get average of the groups
      total_group1 <- data_group1 %>% dplyr::filter(bins == "Totaal", opleiding_ouders == "Totaal")
      if (!(input$OnePlot)) {
        total_group2 <- data_group2 %>% dplyr::filter(bins == "Totaal", opleiding_ouders == "Totaal")
      }
      
      # filter data with bin
      if (!(input$OnePlot)) {
        bin <- get_bin(data_group1, data_group2)
        data_group1 <- data_group1 %>% dplyr::filter(type == bin)
        data_group2 <- data_group2 %>% dplyr::filter(type == bin)
        
        } else {
        bin <- as.character(get_perc_per_bin(data_group1))
        data_group1 <- data_group1 %>% dplyr::filter(type == bin)
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
        scale_y_continuous(
          labels = function(x) paste0(sign1, decimal2(x), sign2)) +
        theme_minimal() +
        labs(x ="Jaarlijks inkomen ouders (keer € 1.000)", y ="") +
        thema 
      
      if (!(input$OnePlot)) {
        
        plot <- plot + geom_point(data = data_group2, 
                          aes(x = parents_income, y = mean,
                              text = paste0("<b>", input$geografie2, "</b></br>",
                                            "</br>Inkomen ouders: €", decimal2(parents_income),
                                            "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                            "</br>Aantal mensen: ", decimal2(N))),
                          color = data_group2_color, size = 3) 
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
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = data_group1_color) +
            geom_abline(aes(intercept = total_group1$mean, slope = 0),
                          linetype="longdash", size=0.5, color = data_group1_color) 
            
            if (!(input$OnePlot)) {
              plot + geom_smooth(data = data_group2, aes(x = parents_income, y = mean),  method = "lm",
                            se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = data_group2_color) +
                geom_abline(aes(intercept = total_group2$mean, slope = 0),
                            linetype="longdash", size=0.5, color = data_group2_color)
            }
            
            
          } else if (line){
            plot <- plot + 
              geom_smooth(data = data_group1, aes(x = parents_income, y = mean),  method = "lm",
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = data_group1_color) 
            
            if (!(input$OnePlot)) {
              plot + geom_smooth(data = data_group2, aes(x = parents_income, y = mean),  method = "lm",
                            se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = data_group2_color) 
            }
            
          } else if (mean){
            plot <- plot + 
              geom_abline(aes(intercept = total_group1$mean, slope = 0),
                          linetype="longdash", size=0.5, color = data_group1_color)
            
            if (!(input$OnePlot)) {
              plot + geom_abline(aes(intercept = total_group2$mean, slope = 0),
                            linetype="longdash", size=0.5, color = data_group2_color)
            }
            
          }
        }
      
      ggplotly(x = plot, tooltip = c("text"))  %>% 
        config(displayModeBar = F, scrollZoom = F) %>%
        style(hoverlabel = label) %>%
        layout(font = font)

      
      #### BAR PLOT ####
    } else if(input$parents_options == "Opleiding ouders") {
      
      data_group1 <- data_group1 %>% dplyr::filter(opleiding_ouders != "Totaal") %>% mutate(group = "group1")
      data_group2 <- data_group2 %>% dplyr::filter(opleiding_ouders != "Totaal") %>% mutate(group = "group2")
      dat <- rbind(data_group1, data_group2)
      
      if (nrow(dat) == 3 | nrow(dat) == 6) {
        
        # create figure
        plot <- ggplot(dat, aes(x = opleiding_ouders, y = mean, fill = group, 
                                text = paste0("<b>", geografie, "</b></br>",
                                              "</br>opleiding ouders: ", opleiding_ouders,
                                              "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                              "</br>Aantal mensen: ", decimal2(N)))) +
          geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
          scale_fill_manual(values=c(data_group1_color, data_group2_color)) + 
          scale_y_continuous(labels = function(x) paste0(sign1, decimal2(x), sign2)) +
          labs(x ="Hoogst behaalde opleiding ouders", y ="") +
          theme_minimal() +
          thema
        
      } else {
        plot <- ggplot() 
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
      paste("dataset-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(mtcars, file)
    })
  

  # download plot
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$dataset, '.png', sep='') },
    content = function(file) {
      png(file)
      print(plotInput())
      dev.off()
    })
  
  
  
}