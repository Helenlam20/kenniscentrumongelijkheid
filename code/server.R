# KCO Dashboard 
#
# - server: a server function
# - The server function contains the instructions that your computer needs to build your app.
#
# (c) Erasmus School of Economics 2022



#### DEFINE SERVER ####
server <- function(input, output) {
  
  # CHANGING THEME ----------------------------------------------------------
  callModule(module = serverChangeTheme, id = "moduleChangeTheme")
  
  
  
  # GRADIENT ----------------------------------------------------------
  
  ##### WIDGETS ##### 
  
  # Outcome widget
  output$selected_outcome <- renderPrint({ 
    
    uitleg <- subset(uitkomst_dat$definitie, uitkomst_dat$uitkomstmaat == input$outcome)
    HTML(paste0("<b>", input$outcome, ":</b> ", uitleg))
  })
  
  output$selected_outcome <- renderPrint({ 
    
    uitleg <- subset(uitkomst_dat$definitie, uitkomst_dat$uitkomstmaat == input$outcome)
    HTML(paste0("<b>", input$outcome, ":</b> ", uitleg))
  })
  
  # Sample widget
  output$sample <- renderPrint({ 
    
    sample_name <- subset(uitkomst_dat$sample, uitkomst_dat$uitkomstmaat == input$outcome)
    HTML(paste0(sample_name, " geboortecohort"))
  })
  
  
  
  ##### FIGURE ##### 
  output$gradient <- renderPlot({
    
    
  })
  
  
  
  
}