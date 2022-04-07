# KCO Dashboard 
#
# - UI: a user interface object
# - The user interface (ui) object controls the layout and appearance of your app. 
#
# (c) Erasmus School of Economics 2022


sidebar <- 
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      HTML(paste0(
        "<br>",
        "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='temp_home.png' width = '186'>",
        "<br>"
      )),
      menuItem("Gradiënt", tabName = "gradient", icon = icon("signal", lib = "glyphicon")),
      menuItem("Werkwijze", tabName = "werkwijze", icon = icon("question")),
      menuItem("Contact", tabName = "contact", icon = icon("envelope", lib = "glyphicon")),

      HTML(paste0(
        "<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>",
        "<table style='margin-left:auto; margin-right:auto;'>",
        "<tr>",
        "<td style='padding: 5px;'><a href='https://www.facebook.com/' target='_blank'><i class='fab fa-facebook-square fa-lg'></i></a></td>",
        "<td style='padding: 5px;'><a href='https://www.youtube.com/' target='_blank'><i class='fab fa-youtube fa-lg'></i></a></td>",
        "<td style='padding: 5px;'><a href='https://www.twitter.com/' target='_blank'><i class='fab fa-twitter fa-lg'></i></a></td>",
        "<td style='padding: 5px;'><a href='https://www.github.com/' target='_blank'><i class='fab fa-github'></i></a></td>",
        "<td style='padding: 5px;'><a HREF='mailto:helenlam@hotmail.nl'target='_blank'><i class='far fa-envelope'></i></a></td>",
        "</tr>",
        "</table>",
        "<br>"),
        HTML(paste0(
          "<script>",
          "var today = new Date();",
          "var yyyy = today.getFullYear();",
          "</script>",
          "<p style = 'text-align: center;'><small>&copy; - Erasmus School of Economics - <script>document.write(yyyy);</script></small></p>"
        ))
      ) # end html
    ) # end sidebar menu
  ) # end shinydashboard



body <-   dashboardBody(
  uiChangeThemeOutput(),
  tabItems(
    # gradient
    tabItem(tabName = "gradient",
            fluidRow(
              column(width = 9,
                     fluidRow(
                       column(width = 5,
                              box(height = NULL, title = "Uitkomstmaat", width = NULL, 
                                  status = "primary", solidHeader = TRUE,
                                  selectInput(inputId = "outcome", label = "Selecteer hier een uitkomstmaat",
                                              choices = sort(outcome_dat$outcome_name),
                                              selected = "Persoonlijk inkomen"),
                                  HTML("<b>Selecteer hier een optie:</b>"),
                                  checkboxGroupInput(inputId = "line_options", label = "",
                                                     choices = c("Fitted lijn", "Gemiddelde lijn"), 
                                                     inline = TRUE),
                                  HTML("<b>Selecteer hier een kenmerk van ouders:</b>"),
                                  radioButtons(inputId = "parents_options", label = "",
                                               choices = c("Inkomen ouders", "Opleiding ouders"), 
                                               inline = TRUE, selected = "Inkomen ouders")
                              ),
                       ),
                       column(width = 7,
                              tabBox(
                                id = "tabset1", height = NULL, width = NULL, 
                                tabPanel("Figuur beschrijving", htmlOutput("selected_outcome"),),
                                tabPanel("Gegevens van figuur", "Test 2"),
                                tabPanel("Causaliteit", 
                                         "Het dashboard brengt de samenhang in beeld tussen de omstandigheden
                              waarin kinderen opgroeien — zoals samenstelling van het huishouden,
                              inkomen van de ouders en migratieachtergrond — en hun uitkomsten over de
                              levensloop. Echter, omstandigheden hangen vaak met elkaar samen en hangen
                              samen met andere factoren waar niet voor te controleren valt. We meten hier
                              dus alleen een samenhang met omstandigheden en geen causaal effect van
                              bijvoorbeeld inkomen van de ouders op uitkomsten."),
                                selected = "Figuur beschrijving"),
                       ),
                     ),
                     
                     box(collapsible = FALSE, 
                         title = textOutput("title_plot"), width = NULL, solidHeader = TRUE, 
                         status = "primary",
                         plotlyOutput("main_figure", height = 430),
                     ),
              ),
              column(width = 3,
                     box(height = NULL,
                         title = "Demografie (1)", width = NULL, status = "info", solidHeader = TRUE,
                         selectizeInput(inputId = "geografie1", label = "Selecteer hier een gebied",
                                        choices  = unique(gradient_dat$geografie),
                                        selected = unique(gradient_dat$geografie)[4]),
                         selectizeInput(inputId = "geslacht1", label = "Selecteer hier een geslacht",
                                        choices = c("Totaal", "Mannen", "Vrouwen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "migratie1", label = "Selecteer hier een migratie",
                                        choices = c("Totaal", "Nederland", "Turkije", "Marokko", 
                                                    "Suriname", "Nederlandse Antillen"), 
                                        selected = "Totaal"),
                         selectizeInput(inputId = "huishouden1", label = "Selecteer hier een huishouden",
                                        choices = c("Totaal", "Eenoudergezin", "Tweeoudergezin"),
                                        selected = "Totaal")
                     ),
                     box(height = NULL,
                         title = "Demografie (2)", width = NULL, status = "success", solidHeader = TRUE,
                         selectizeInput(inputId = "geografie2", label = "Selecteer hier een gebied",
                                        choices  = unique(gradient_dat$geografie),
                                        selected = unique(gradient_dat$geografie)[2]),
                         selectizeInput(inputId = "geslacht2", label = "Selecteer hier een geslacht",
                                        choices = c("Totaal", "Mannen", "Vrouwen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "migratie2", label = "Selecteer hier een migratie",
                                        choices = c("Totaal", "Nederland", "Turkije", "Marokko", 
                                                   "Suriname", "Nederlandse Antillen"), 
                                        selected = "Totaal"),
                         selectizeInput(inputId = "huishouden2", label = "Selecteer hier een huishouden",
                                        choices = c("Totaal", "Eenoudergezin", "Tweeoudergezin"),
                                        selected = "Totaal")
                     ),
              )
            ),
    ),
    
    # info tab content
    tabItem(tabName = "werkwijze",
            includeMarkdown("www/werkwijze.Rmd")
    ),
    
    # contact tab content
    tabItem(tabName = "contact",
            includeMarkdown("www/contact.Rmd"),
            uiChangeThemeDropdown()
    )
    
  )
)


#### DEFINE UI ####
ui <- dashboardPage(
  dashboardHeader(title = shinyDashboardLogo(
    theme = "poor_mans_flatly",
    boldText = "KCO Dashboard",
    mainText = "",
    badgeText = "BETA"),
    titleWidth = 300),
  
  sidebar,
  body  
  
)



