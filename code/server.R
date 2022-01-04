# KCO Dashboard 
#
# - server: a server function
# - The server function contains the instructions that your computer needs to build your app.
#
# (c) Erasmus School of Economics 2022



#### DEFINE SERVER ####
server <- function(input, output, session) {
  

  
  
  # CHANGING THEME ----------------------------------------------------------
  callModule(module = serverChangeTheme, id = "moduleChangeTheme")
  
  
  
  # GRADIENT ----------------------------------------------------------
  
  ##### WIDGETS ##### 

  # Outcome widget
  output$selected_outcome <- renderPrint({ 
    uitleg <- subset(uitkomst_dat$definitie, uitkomst_dat$uitkomstmaat == input$outcome)
    HTML(paste0("<b>", input$outcome, ":</b> ", uitleg))
  })
  
  # Sample widget
  output$sample <- renderPrint({ 
    sample_name <- subset(uitkomst_dat$sample, uitkomst_dat$uitkomstmaat == input$outcome)
    HTML(paste0(sample_name, " geboortecohort"))
  })
  
  # outcome explanation widget
  output$selected_outcome <- renderPrint({ 
    uitleg <- subset(uitkomst_dat$definitie, uitkomst_dat$uitkomstmaat == input$outcome)
    HTML(paste0("<b>", input$outcome, ":</b> ", uitleg))
  })
  
  # title plot widget
  # Sample widget
  output$title_plot <- renderPrint({ 
    HTML(input$outcome)
  })

  # observeEvent(input$geografie,
  #              {updateSelectizeInput(
  #                session, input = "keuze",
  #                choices = subset(geo_dat$naam, geo_dat$geografie == input$geografie))
  #              })
  
  
  ##### FIGURE ##### 
  # output$gradient <- renderPlot({
  output$gradient <- renderPlotly({
    
  plot <- ggplot() + 
      geom_point(data = gradient_dat %>% 
                   filter(uitkomst == input$outcome, geografie == input$geografie1, 
                          geslacht == input$geslacht1),
                 aes(x = parents_income, y = mean), color = "steelblue2", size = 3) +
      geom_point(data = gradient_dat %>% 
                   filter(uitkomst == input$outcome, geografie == input$geografie2, 
                          geslacht == input$geslacht2), 
                 aes(x = parents_income, y = mean), color = "slategray4", size = 3) +
      scale_x_continuous(labels = function(x) paste0("€ ", x)) +
      theme_minimal() +
      labs(x ="Jaarlijks inkomen ouders (x € 1.000)",
           y ="") +
      theme(plot.title=element_text(hjust = 0, size = 22, face="bold",
                                    vjust = 1, margin = margin(0,0,20,0)),
            plot.subtitle=element_text(hjust = 0, size = 20, 
                                       vjust = 1, margin = margin(0,0,20,0)),
            legend.text=element_text(colour = "grey20", size = 20),
            legend.position = "none",
            axis.title.y = element_text(size = 20, face = "italic",
                                        margin = margin(0,15,0,0)),
            axis.title.x = element_text(size = 20, face = "italic",
                                        margin = margin(15,0,15,0), vjust = 1),
            axis.text.y=element_text(size = 20, color="#000000",  hjust = 0.5,
                                     margin = margin(0,5,0,0)),
            axis.text.x=element_text(size = 20, color="#000000", margin = margin(5,0,0,0)),
            axis.line.x=element_line(color= "#000000", size = 0.5),
            axis.line.y=element_line(color = "#000000", size = 0.5),
            axis.ticks.x = element_line(color = "#000000", size = 0.5),
            axis.ticks.y = element_line(color = "#000000", size = 0.5),
            axis.ticks.length = unit(1.5, "mm"),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank())


  ggplotly(plot) %>% config(displayModeBar = F, dragMode = F, scrollZoom = F)
    
  })
  

  
}