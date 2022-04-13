# KCO Dashboard 
#
# - server: a server function
# - The server function contains the instructions that your computer needs to build your app.
#
# (c) Erasmus School of Economics 2022



#### STYLING ####
source("server_options.R")



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
    
    sample_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    stat <- get_stat_per_outcome_html(sample_dat)
    
    data_group1 <- dataInput1()
    N1 <- decimal0(sum(data_group1$N))
    bin <- get_perc_per_bin_html(data_group1)
    
    data_group2 <- data.frame()
    if (!(input$OnePlot)) {
      data_group2 <- dataInput2()
      N2 <- decimal0(sum(data_group2$N))
      bin <- get_bin_html(data_group1, data_group2)
    }
    
    if (input$parents_options == "Inkomen ouders") {
      axis_text <- HTML(paste0("Elke stip in het figuur is gebaseerd op ", bin, " procent van de ", 
                               sample_dat$population, " gerangschikt van laag naar hoog ouderlijk inkomen.   
                              De verticale as toont het eigen", stat, tolower(input$outcome), 
                               ". De horizontale as toont het gemiddelde inkomen van hun ouders."))
      
    } else if(input$parents_options == "Opleiding ouders") {
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
    HTML(paste0("<p><b>", input$outcome, "</b> is ", sample_dat$definition, ".</p>", 
                "<p>", axis_text, "</p>", 
                "<p>", group1_text, " ", group2_text, "</p>"))
    
  })
  
  
  #### WAT ZIE JE? ####
  # output$sample_uitleg <- renderPrint({
  #   
  #   sample_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
  #   data_group1 <- dataInput1()
  #   data_group2 <- dataInput2()
  #   
  #   # get total 
  #   total_group1 <- data_group1 %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
  #   total_group2 <- data_group2 %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
  # 
  #   
  #   bin1 <- get_perc_per_bin_html(data_group1)
  #   if (!is.null(data_group2)) {bin2 <- get_perc_per_bin_html(data_group2)} else {bin <- 0}
  #   bin <- as.character(max(bin1, bin2))
  #   
  #   stat <- get_stat_per_outcome_html(sample_dat)
  #   
  #   # if user has clicked on the mean button
  #   if (input$line_options == "Gemiddelde") {
  #     mean_text <- HTML(paste0("Het totale ", stat, " ", tolower(input$outcome), " van groep 1 is ", 
  #                              total_group1$N, ". het gemiddelde van groep 2 is ", total_group2$N))
  #     
  #   }
  #   
  #   HTML(paste0("Voor de uitkomst <b>", input$outcome, "</b> gebruiken we gegevens van ", sample_dat$population,
  #               ". In heel Nederland gaat dit om  ", sample_dat$sample_size, " ", sample_dat$population,
  #               " geboren in ", sample_dat$birth_year, ". Dit figuur gebruikt gegevens van ", 
  #               N1, " ", sample_dat$population, " uit ", input$geografie1, " en ",
  #               N2, " ", sample_dat$population, " uit ", input$geografie2, "."))
  # })
  
  
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

    sign1 <- ""
    sign2 <- ""
    if (input$outcome == "Persoonlijk inkomen" | input$outcome == "Uurloon" |
        input$outcome == "Zorgkosten" | input$outcome == "Vermogen" |
        input$outcome == "Jeugd zorgkosten van tieners" |
        input$outcome == "Jeugd zorgkosten van kinderen" ) {
      sign1 <- "€ "
    } else if (input$outcome != "Uren werk per week" &
               input$outcome != "Woonoppervlak per lid huishouden van kinderen" &
               input$outcome != "Woonoppervlak per lid huishouden van tieners") {
      sign2 <- "%"
    }

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
        } else {
          bin <- get_perc_per_bin(data_group1)
          data_group1 <- data_group1 %>% filter(type == bin)
          }
      
      # make plot
      plot <- ggplot() +
        geom_point(data = data_group1, 
                   aes(x = parents_income, y = mean,
                       text = paste0("<b>", input$geografie1, "</b></br>",
                                     "</br>Inkomen ouders: €", decimal2(parents_income),
                                     "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                     "</br>Aantal mensen: ", decimal2(N))
                       ),
                   color = "#3498db", size = 3) +
        scale_x_continuous(labels = function(x) paste0("€ ", x)) +
        scale_y_continuous(
          labels = function(x) paste0(sign1, decimal2(x), sign2)) +
        theme_minimal() +
        labs(x ="Jaarlijks inkomen ouders (x € 1.000)", y ="") +
        thema 
      
      if (!(input$OnePlot)) {
        
        plot + geom_point(data = data_group2, 
                          aes(x = parents_income, y = mean,
                              text = paste0("<b>", input$geografie2, "</b></br>",
                                            "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                            "</br>Aantal mensen: ", decimal2(N))),
                          color = "#18bc9c", size = 3) 
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
           plot +  
              geom_smooth(data = data_group1, aes(x = parents_income, y = mean),  method = "lm",
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = "#3498db") +
              geom_smooth(data = data_group2, aes(x = parents_income, y = mean),  method = "lm",
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = "#18bc9c") + 
              geom_abline(aes(intercept = total_group1$mean, slope = 0),
                          linetype="longdash", size=0.5, color = "#3498db") +
              geom_abline(aes(intercept = total_group2$mean, slope = 0),
                          linetype="longdash", size=0.5, color = "#18bc9c")
            
          } else if (line){
           plot +  
              geom_smooth(data = data_group1, aes(x = parents_income, y = mean),  method = "lm",
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = "#3498db") +
              geom_smooth(data = data_group2, aes(x = parents_income, y = mean),  method = "lm",
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = "#18bc9c")
            
          } else if (mean){
            plot + 
              geom_abline(aes(intercept = total_group1$mean, slope = 0),
                          linetype="longdash", size=0.5, color = "#3498db") +
              geom_abline(aes(intercept = total_group2$mean, slope = 0),
                          linetype="longdash", size=0.5, color = "#18bc9c")
            
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
          scale_fill_manual(values=c("#3498db", "#18bc9c")) + 
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