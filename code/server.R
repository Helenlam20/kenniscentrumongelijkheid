# KCO Dashboard 
#
# - server: a server function
# - The server function contains the instructions that your computer needs to build your app.
#
# (c) Erasmus School of Economics 2022



#### DEFINE SERVER ####
server <- function(input, output) {
  
  # Changing theme ----------------------------------------------------------
  callModule(module = serverChangeTheme, id = "moduleChangeTheme")
  
  output$gradient <- renderPlot({
    
    
  })
  
}