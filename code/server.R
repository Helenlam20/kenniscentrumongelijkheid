# KCO Dashboard 
#
# - server: a server function
# - The server function contains the instructions that your computer needs to build your app.
#
# (c) Erasmus School of Economics 2022

thema <- theme(plot.title = element_text(hjust = 0, size = 16, face="bold",
                                         vjust = 1, margin = margin(0,0,20,0)),
               plot.subtitle = element_text(hjust = 0, size = 16,
                                            vjust = 1, margin = margin(0,0,20,0)),
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


#### DEFINE SERVER ####
server <- function(input, output, session) {
  
  
  
  
  # CHANGING THEME ----------------------------------------------------------
  callModule(module = serverChangeTheme, id = "moduleChangeTheme")
  
  
  
  # GRADIENT ----------------------------------------------------------
  
  ##### WIDGETS #####
  
  # Outcome widget
  output$selected_outcome <- renderPrint({
    uitleg <- subset(outcome_dat$definition, outcome_dat$outcome_name == input$outcome)
    HTML(paste0("<b>", input$outcome, ":</b> ", uitleg))
  })
  
  # # sample explanation
  # output$sample_uitleg <- renderPrint({ 
  #   sample_dat <- subset(uitkomst_dat, uitkomst_dat$uitkomstmaat == input$outcome)
  # 
  #   N1 <- sum(gradient_dat %>% filter(uitkomst == input$outcome, geografie ==input$geografie1, 
  #                             geslacht == input$geslacht1) %>% select(N))
  #   
  #   N2 <- sum(gradient_dat %>% 
  #               filter(uitkomst == input$outcome, geografie ==input$geografie2, 
  #                      geslacht == input$geslacht2) %>% select(N))
  #   
  #   HTML(paste("Voor de uitkomst", input$outcome, "gebruiken we", sample_dat$sample_uitleg, 
  #              "In heel Nederland gaat dit om van", sample_dat$sample_size, sample_dat$sample, 
  #              "geboren in ", sample_dat$geboortejaar_start, "en", sample_dat$geboortejaar_end,  
  #              "Dit figuur gebruikt gegevens van", format(N1, big.mark = "."), sample_dat$sample, "uit", input$geografie1, "en", 
  #              format(N2, big.mark = "."), sample_dat$sample, "uit", input$geografie2, "."))
  # })
  # 
  # # gradient explanation
  # output$gradient_uitleg <- renderPrint({ 
  #   sample <- subset(uitkomst_dat$sample, uitkomst_dat$uitkomstmaat == input$outcome)
  #   gradient_uitleg <- subset(uitkomst_dat$gradient_uitleg, uitkomst_dat$uitkomstmaat == input$outcome)
  # 
  #   dat1 <- gradient_dat %>% filter(uitkomst == input$outcome, geografie ==input$geografie1, 
  #                                   geslacht == input$geslacht1)
  #   N1 <- format(round(mean(dat1$N)), big.mark = ".")
  #   
  #   dat2 <- gradient_dat %>% filter(uitkomst == input$outcome, geografie ==input$geografie2, 
  #                                   geslacht == input$geslacht2)
  #   N2 <- format(round(mean(dat2$N)), big.mark = ".")
  #   
  #   HTML(paste("Iedere stip in het figuur toont op de verticale as het percentage",
  #               gradient_uitleg, "per 5 procent van de ouderlijke inkomensverdeling van laag naar hoog inkomen. Voor",
  #               input$geografie1, "zijn dit", N1, sample, "per stip (blauw) en voor", input$geografie2,
  #              "zijn dit", N2, sample, "per stip (groen)."))
  # })
  
  
  
  ##### FIGURE #####
  
  # title plot widget
  output$title_plot <- renderPrint({
    if (input$outcome == "Persoonlijk inkomen" | input$outcome == "Vermogen") {
      HTML(input$outcome, " (x € 1.000)")
    } else {
      HTML(input$outcome)
    }
  })

  
  output$main_figure <- renderPlotly({
    
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

    dat1 <- subset(gradient_dat, 
                   gradient_dat$uitkomst_NL == input$outcome &
                   gradient_dat$geografie == input$geografie1 &
                   gradient_dat$geslacht == input$geslacht1 & 
                   gradient_dat$migratieachtergrond == input$migratie1 &
                   gradient_dat$huishouden == input$huishouden1)

    dat2 <- subset(gradient_dat, 
                   gradient_dat$uitkomst_NL == input$outcome &
                   gradient_dat$geografie == input$geografie2 &
                   gradient_dat$geslacht == input$geslacht2 &
                   gradient_dat$migratieachtergrond == input$migratie2 &
                   gradient_dat$huishouden == input$huishouden2)
    
    
    # dat1 <- subset(gradient_dat,
    #                gradient_dat$uitkomst_NL == "Zuigelingensterfte" &
    #                  gradient_dat$geografie == "Nederland" &
    #                  gradient_dat$geslacht == "Totaal" &
    #                  gradient_dat$migratieachtergrond == "Totaal" &
    #                  gradient_dat$huishouden == "Totaal")
    # 
    # dat2 <- subset(gradient_dat,
    #                gradient_dat$uitkomst_NL == "Zuigelingensterfte" &
    #                  gradient_dat$geografie == "Amsterdam" &
    #                  gradient_dat$geslacht == "Totaal" &
    #                  gradient_dat$migratieachtergrond == "Totaal" &
    #                  gradient_dat$huishouden == "Totaal")
    
    
    if (input$parents_options == "Inkomen ouders") {
      
      # use bins that are available for both subgroups
      if ("bins_20" %in% unique(dat1$type) & "bins_20" %in% unique(dat2$type)) {
        dat1 <- dat1 %>% filter(type == "bins_20")
        dat2 <- dat2 %>% filter(type == "bins_20")
        
      } else if ("bins_10" %in% unique(dat1$type) & "bins_10" %in% unique(dat2$type)) {
        dat1 <- dat1 %>% filter(type == "bins_10")
        dat2 <- dat2 %>% filter(type == "bins_10")
        
      } else if ("bins_5" %in% unique(dat1$type) & "bins_5" %in% unique(dat2$type)) {
        dat1 <- dat1 %>% filter(type == "bins_5")
        dat2 <- dat2 %>% filter(type == "bins_5")
        
      } else if ("total" %in% unique(dat1$type) & "total" %in% unique(dat2$type)) {
        dat1 <- dat1 %>% filter(type == "total")
        dat2 <- dat2 %>% filter(type == "total")
        
      }
      
      if ((nrow(dat1) + nrow(dat2)) != 0) {
      
      plot <- ggplot() +
        geom_point(data = dat1, aes(x = parents_income, y = mean,
                                    text = paste0("<b>", input$geografie1, "</b></br>",
                                                  "</br>Inkomen ouders: €", format(round(parents_income, 2), decimal.mark = ",", big.mark = "."),
                                                  "</br>Uitkomst: ", sign1, format(round(mean, 2), decimal.mark = ",", big.mark = "."), sign2,
                                                  "</br>Aantal mensen: ", format(round(N), decimal.mark = ",", big.mark = "."))),
                   color = "#3E87CF", size = 3) +
        geom_point(data = dat2, aes(x = parents_income, y = mean,
                                    text = paste0("<b>", input$geografie2, "</b></br>",
                                                  "</br>Inkomen ouders: €", format(round(parents_income, 2), decimal.mark = ",", big.mark = "."),
                                                  "</br>Uitkomst: ", sign1, format(round(mean, 2), decimal.mark = ",", big.mark = "."), sign2,
                                                  "</br>Aantal mensen: ", format(round(N), big.mark = ".", decimal.mark = ","))),
                   color = "#4CAA88", size = 3) +
        scale_x_continuous(labels = function(x) paste0("€ ", x)) +
        scale_y_continuous(
          labels = function(x) paste0(sign1, x, sign2)) +
        theme_minimal() +
        labs(x ="Jaarlijks inkomen ouders (x € 1.000)", y ="") +
        thema
      
    } else {
      plot <- ggplot() 
      
    }
      
      ggplotly(x = plot, tooltip = c("text"))  %>% config(displayModeBar = F, scrollZoom = F)

      
    } else if(input$parents_options == "Opleiding ouders") {
      
      dat1 <- dat1 %>% dplyr::filter(opleiding_ouders != "Totaal") %>% mutate(group = "group1")
      dat2 <- dat2 %>% dplyr::filter(opleiding_ouders != "Totaal") %>% mutate(group = "group2")
      dat <- rbind(dat1, dat2)
      
      if (nrow(dat) == 3 | nrow(dat) == 6) {
        
        # create figure
        plot <- ggplot(dat, aes(x = opleiding_ouders, y = mean, fill = group, 
                                text = paste0("<b>", input$geografie1, "</b></br>",
                                              "</br>opleiding ouders: ", opleiding_ouders,
                                              "</br>Uitkomst: ", sign1, format(round(mean, 2), decimal.mark = ",", big.mark = "."), sign2,
                                              "</br>Aantal mensen: ", format(round(N), decimal.mark = ",", big.mark = ".")))) +
          geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
          scale_fill_manual(values=c("#3E87CF", "#4CAA88")) + 
          scale_y_continuous(labels = function(x) paste0(sign1, x, sign2)) +
          labs(x ="Hoogst behaalde opleiding ouders", y ="") +
          theme_minimal() +
          thema
        
      } else {
        plot <- ggplot() 
        
      }
    
      ggplotly(x = plot, tooltip = c("text"))  %>% config(displayModeBar = F, scrollZoom = F)
      
      
    }
    

  })
  
}