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
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Gradiënt", tabName = "gradient", icon = icon("signal", lib = "glyphicon")),
      # menuItem("Staafdiagram", tabName = "bar", icon = icon("stats", lib = "glyphicon")),
      menuItem("Info", tabName = "info", icon = icon("question")),
      menuItem("Contact", tabName = "contact", icon = icon("envelope", lib = "glyphicon")),
      
      HTML(paste0("<br>")),
      
      sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                        label = "Search..."),
      
      HTML(paste0(
        "<br><br><br><br><br><br><br><br><br>",
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
    # home tab content
    tabItem(tabName = "home",
            # home section
            includeMarkdown("www/home.Rmd")
    ),
    
    # gradient
    tabItem(tabName = "gradient",
            fluidRow(
              column(width = 4, 
                     box(height = 220, 
                         title = "Uitkomstmaat", width = NULL, status = "primary", solidHeader = TRUE,
                         selectInput(inputId = "outcome", label = "Selecteer hier een uitkomstmaat",
                                     choices = sort(unique(gradient_dat$uitkomst)),
                                     selected = unique(gradient_dat$uitkomst)[1]),
                         htmlOutput("selected_outcome")
                     ),
              ),
              column(width = 4,
                     box(height = 220, 
                       title = "Demografie (1)", width = NULL, status = "info", solidHeader = TRUE,
                       selectizeInput(inputId = "geografie1", label = "Selecteer hier een gebied", 
                                      choices  = unique(gradient_dat$geografie),
                                      selected = unique(gradient_dat$geografie)[1],
                                      multiple = FALSE,
                                      options = list(maxItems = 1, placeholder = "Demografie", 
                                                     plugins = list('remove_button', 'drag_drop'))),
                       selectizeInput(inputId = "geslacht1", label = "Selecteer hier een geslacht",
                                    choices = unique(gradient_dat$geslacht), 
                                    selected = unique(gradient_dat$geslacht)[1])
                     ),
              ),
              column(width = 4,
                     box(height = 220, 
                       title = "Demografie (2)", width = NULL, status = "success", solidHeader = TRUE,
                       selectizeInput(inputId = "geografie2", label = "Selecteer hier een gebied", 
                                      choices  = unique(gradient_dat$geografie),
                                      selected = unique(gradient_dat$geografie)[6],
                                      multiple = FALSE,
                                      options = list(maxItems = 1, placeholder = "Demografie", 
                                                     plugins = list('remove_button', 'drag_drop'))),
                       selectizeInput(inputId = "geslacht2", label = "Selecteer hier een geslacht",
                                    choices = unique(gradient_dat$geslacht), 
                                    selected = unique(gradient_dat$geslacht)[1])
                       ),
                     ),
              # column(width = 2,
              #        box(height = 220, 
              #          title = "Options", width = NULL, status = "primary", solidHeader = TRUE,
              #          checkboxInput("smooth_line", label = "Smoothed line", value = TRUE),
              #          checkboxInput("mean_line", label = "mean line", value = TRUE)
              #        ),
              # ),
              ),
            fluidRow(
            column(width = 8,
                   box(collapsible = FALSE, 
                     title = textOutput("title_plot"), width = NULL, solidHeader = TRUE, 
                     status = "primary",
                     plotlyOutput("gradient", height = 460)
                     )
                   ),
            
              column(width = 4,
                     box(height = NULL, collapsible = TRUE,
                         width = NULL, background = "light-blue",
                         title = "Welke gegevens gebruikt dit figuur?",
                         textOutput("sample_uitleg")),
                     
                     box(height = NULL, collapsible = TRUE,
                       width = NULL, background = "olive",
                       title = "Wat laat het figuur zien?",
                       textOutput("gradient_uitleg")),
                     
                     box(height = NULL,
                         width = NULL, background = "purple",
                         title = "Causaliteit", collapsible = TRUE,
                         "Het dashboard brengt de samenhang in beeld tussen de omstandigheden 
                         waarin kinderen opgroeien — zoals samenstelling van het huishouden, 
                         inkomen van de ouders en migratieachtergrond — en hun uitkomsten over de 
                         levensloop. Echter, omstandigheden hangen vaak met elkaar samen en hangen 
                         samen met andere factoren waar niet voor te controleren valt. We meten hier 
                         dus alleen een samenhang met omstandigheden en geen causaal effect van 
                         bijvoorbeeld inkomen van de ouders op uitkomsten.")
                     )
            )
            
            
    ),
    
    # barplot tab content
    # tabItem(tabName = "bar",  br(),
    #         h2("Staafdiagrammen over Kansenongelijkheid in Amsterdam"), br(), br(),
    #         h2("COMING SOON!!")
    # ),
    
    # info tab content
    tabItem(tabName = "info", 
            includeMarkdown("www/info.Rmd")
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
    badgeText = "BETA"), titleWidth = 300),
  
sidebar,
body  

)



