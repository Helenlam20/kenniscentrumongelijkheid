# KCO Dashboard 
#
# - server: a server function
# - The server function contains the instructions that your computer needs to build your app.
#
# (c) Erasmus School of Economics 2022



#### STYLING ####
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

# hovertext
font <- list(
  family = "Helvetica",
  size = 14,
  color = "white"
)
label <- list(
  # bordercolor = "transparent",
  bordercolor = "white",
  font = font
)

# function decimals and thousand seperator
decimal0 <- function(x) {
  num <- format(round(x), big.mark = ".", decimal.mark = ",")
}


decimal2 <- function(x) {
  num <- format(round(x, 2), decimal.mark = ",", big.mark = ".")
  }



#### DEFINE SERVER ####
server <- function(input, output, session) {

  
  # GRADIENT ----------------------------------------------------------
  
  ##### WIDGETS #####

  # Outcome widget
  output$selected_outcome <- renderPrint({
    
    sample_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    
    dat1 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                     gradient_dat$geografie == input$geografie1 &
                     gradient_dat$geslacht == input$geslacht1 & 
                     gradient_dat$migratieachtergrond == input$migratie1 &
                     gradient_dat$huishouden == input$huishouden1)
    N1 <- decimal0(mean(dat1$N))
    
    dat2 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                     gradient_dat$geografie == input$geografie2 &
                     gradient_dat$geslacht == input$geslacht2 &
                     gradient_dat$migratieachtergrond == input$migratie2 &
                     gradient_dat$huishouden == input$huishouden2)
    N2 <- decimal0(mean(dat2$N))
    
    # use bins that are available for both subgroups
    if ("bins_20" %in% unique(dat1$type) & "bins_20" %in% unique(dat2$type)) {
      bin <- "5"
    } else if ("bins_10" %in% unique(dat1$type) & "bins_10" %in% unique(dat2$type)) {
      bin <- "10"
    } else if ("bins_5" %in% unique(dat1$type) & "bins_5" %in% unique(dat2$type)) {
      bin <- "20"
    } else if ("total" %in% unique(dat1$type) & "total" %in% unique(dat2$type)) {
      bin <- "100"
    }

    
    HTML(paste0("<b>", input$outcome, ":</b> ", sample_dat$definition, "<br><br>",
                "Iedere stip in het figuur toont op de verticale as het percentage ", sample_dat$population, 
                " per ", bin,"  procent van de ouderlijke inkomensverdeling van laag naar hoog inkomen. Voor ",
                input$geografie1, " zijn dit ", N1, " ", sample_dat$population, 
                " per stip (blauw) en voor ", input$geografie2, " zijn dit ", N2, " ",
                sample_dat$population, " per stip (groen)."))
  })

  
  # sample explanation
  output$sample_uitleg <- renderPrint({
    
    sample_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    
    dat1 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                     gradient_dat$geografie == input$geografie1 &
                     gradient_dat$geslacht == input$geslacht1 & 
                     gradient_dat$migratieachtergrond == input$migratie1 &
                     gradient_dat$huishouden == input$huishouden1)
    N1 <- decimal0(sum(dat1$N))
    
    dat2 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                     gradient_dat$geografie == input$geografie2 &
                     gradient_dat$geslacht == input$geslacht2 &
                     gradient_dat$migratieachtergrond == input$migratie2 &
                     gradient_dat$huishouden == input$huishouden2)
    N2 <- decimal0(sum(dat2$N))
    
    HTML(paste0("Voor de uitkomst <b>", input$outcome, "</b> gebruiken we gegevens van ", sample_dat$population,
               ". In heel Nederland gaat dit om  ", sample_dat$sample_size, " ", sample_dat$population,
               " geboren in ", sample_dat$birth_year, ". Dit figuur gebruikt gegevens van ", 
               N1, " ", sample_dat$population, " uit ", input$geografie1, " en ",
               N2, " ", sample_dat$population, " uit ", input$geografie2, "."))
  })
  
  
  ##### FIGURE #####
  
  # title plot widget
  output$title_plot <- renderPrint({
    HTML(input$outcome)
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

    dat1 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                   gradient_dat$geografie == input$geografie1 &
                   gradient_dat$geslacht == input$geslacht1 & 
                   gradient_dat$migratieachtergrond == input$migratie1 &
                   gradient_dat$huishouden == input$huishouden1)

    dat2 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                   gradient_dat$geografie == input$geografie2 &
                   gradient_dat$geslacht == input$geslacht2 &
                   gradient_dat$migratieachtergrond == input$migratie2 &
                   gradient_dat$huishouden == input$huishouden2)
    
    
    #### GRADIENT ####
    if (input$parents_options == "Inkomen ouders") {
      
      # get average of the groups
      total_group1 <- dat1 %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
      total_group2 <- dat2 %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
      
      
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

      plot <- ggplot() +
        geom_point(data = dat1, aes(x = parents_income, y = mean,
                                    text = paste0("<b>", input$geografie1, "</b></br>",
                                                  "</br>Inkomen ouders: €", decimal2(parents_income),
                                                  "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                                  "</br>Aantal mensen: ", decimal2(N))),
                   color = "#3498db", size = 3) +
        geom_point(data = dat2, aes(x = parents_income, y = mean,
                                    text = paste0("<b>", input$geografie2, "</b></br>",
                                                  "</br>Inkomen ouders: €", decimal2(parents_income),
                                                  "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                                  "</br>Aantal mensen: ", decimal2(N))),
                   color = "#18bc9c", size = 3) +
        scale_x_continuous(labels = function(x) paste0("€ ", x)) +
        scale_y_continuous(
          labels = function(x) paste0(sign1, decimal0(x), sign2)) +
        theme_minimal() +
        labs(x ="Jaarlijks inkomen ouders (x € 1.000)", y ="") +
        thema 

      
      # if user selected checkbox
        if (!is.null(input$line_options)) {
          
          line <- "Lijn"  %in% input$line_options
          mean <- "Gemiddelde" %in% input$line_options
 
          # regression line
          if (nrow(dat1) == 5) {
            polynom <- 2
          } else {
            polynom <- 3
          }
          
          if (line & mean) {
           plot +  
              geom_smooth(data = dat1, aes(x = parents_income, y = mean),  method = "lm",
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = "#3498db") +
              geom_smooth(data = dat2, aes(x = parents_income, y = mean),  method = "lm",
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = "#18bc9c") + 
              geom_abline(aes(intercept = total_group1$mean, slope = 0),
                          linetype="longdash", size=0.5, color = "#3498db") +
              geom_abline(aes(intercept = total_group2$mean, slope = 0),
                          linetype="longdash", size=0.5, color = "#18bc9c")
            
          } else if (line){
           plot +  
              geom_smooth(data = dat1, aes(x = parents_income, y = mean),  method = "lm",
                          se = FALSE, formula = paste0("y ~ poly(x, ", polynom, ")"), color = "#3498db") +
              geom_smooth(data = dat2, aes(x = parents_income, y = mean),  method = "lm",
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
      
      dat1 <- dat1 %>% dplyr::filter(opleiding_ouders != "Totaal") %>% mutate(group = "group1")
      dat2 <- dat2 %>% dplyr::filter(opleiding_ouders != "Totaal") %>% mutate(group = "group2")
      dat <- rbind(dat1, dat2)
      
      if (nrow(dat) == 3 | nrow(dat) == 6) {
        
        # create figure
        plot <- ggplot(dat, aes(x = opleiding_ouders, y = mean, fill = group, 
                                text = paste0("<b>", geografie, "</b></br>",
                                              "</br>opleiding ouders: ", opleiding_ouders,
                                              "</br>Uitkomst: ", sign1, decimal2(mean), sign2,
                                              "</br>Aantal mensen: ", decimal2(N)))) +
          geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
          scale_fill_manual(values=c("#3498db", "#18bc9c")) + 
          scale_y_continuous(labels = function(x) paste0(sign1, x, sign2)) +
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
    

  })
  
}