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
      menuItem("Gradiënt", tabName = "gradient", icon = icon("signal", lib = "glyphicon"),
               badgeLabel = "Nieuw", badgeColor = "teal"),
      menuItem("Staafdiagram", tabName = "bar", icon = icon("stats", lib = "glyphicon")),
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
            br(),
            # h2("Gradienten over Kansenongelijkheid in Amsterdam"), br(),
            fluidRow(
              column(width = 4, 
              box(height = 200,  
                width = NULL, background = "light-blue",
                title = textOutput("sample"),
                "Hier komt een beschrijving van een geboortecohort. De rest is 
                       gewoon beschrijving om dit op te vullen. Dus je kan nu stoppen met lezen.
                       Ik meen het. Ik ga hier niks bijzonders vertellen, want dit is gewoon tekst 
                       om te laten zien hoe het er uit komt te zien.")
              ),
              column(width = 4,
              box(height = 200, 
                width = NULL, background = "olive", 
                title = "Uitleg",
                "Hier komt een uitleg/interpretatie van de gradiënt. De rest is 
                       gewoon beschrijving om dit op te vullen. Dus je kan nu stoppen met lezen. 
                       Ik meen het. Ik ga hier niks bijzonders vertellen, want dit is gewoon tekst 
                       om te laten zien hoe het er uit komt te zien.")
              ),
              column(width = 4, 
              box(height = 200, 
                  title = "Uitkomstmaat", width = NULL, status = "info", solidHeader = TRUE,
                  selectInput(inputId = "outcome", label = "Selecteer hier een uitkomstmaat",
                              choices = unique(gradient_dat$uitkomst),
                              selected = unique(gradient_dat$uitkomst)[1]),
                  htmlOutput("selected_outcome")
                  )
              ),
            ),
            fluidRow(
            column(width = 8,
                   box(collapsible = FALSE,
                     title = textOutput("title_plot"), width = NULL, solidHeader = TRUE, 
                     status = "primary",
                     # plotOutput("gradient", height = 480)
                     plotlyOutput("gradient", height = 480)
                     )
                   ),
            
              column(width = 4,
                     box(
                       title = "Demografie", width = NULL, status = "primary", solidHeader = TRUE,
                       selectizeInput(inputId = "geografie1", label = "Selecteer hier een gebied", 
                                      choices  = unique(gradient_dat$geografie),
                                      selected = unique(gradient_dat$geografie)[1],
                                      # choices  = c("Metropoolregio Amsterdam", "Stadsdeel Amsterdam", "Gebied Amsterdam"),
                                      # selected = c("Metropool Amsterdam"), 
                                      multiple = FALSE,
                                      options = list(maxItems = 1, placeholder = "Demografie", 
                                                     plugins = list('remove_button', 'drag_drop'))),
                       # br(),
                       # selectizeInput(inputId = "keuze", label = "Selecteer hier een subgroep",
                       #                choices  = textOutput("geo"),
                       #                multiple = TRUE,
                       #                options = list(maxItems = 2, placeholder = "Subgroepen",
                       #                               plugins = list('remove_button', 'drag_drop'))),
                       radioButtons(inputId = "geslacht1", label = "Selecteer hier een geslacht",
                                    choices = unique(gradient_dat$geslacht), 
                                    selected = unique(gradient_dat$geslacht)[1])
                        ),
                     box(
                       title = "Demografie", width = NULL, status = "success", solidHeader = TRUE,
                       selectizeInput(inputId = "geografie2", label = "Selecteer hier een gebied", 
                                      choices  = unique(gradient_dat$geografie),
                                      selected = unique(gradient_dat$geografie)[3],
                                      multiple = FALSE,
                                      options = list(maxItems = 1, placeholder = "Demografie", 
                                                     plugins = list('remove_button', 'drag_drop'))),
                       radioButtons(inputId = "geslacht2", label = "Selecteer hier een geslacht",
                                    choices = unique(gradient_dat$geslacht), 
                                    selected = unique(gradient_dat$geslacht)[1])
                     ),
                     
                     
                     )
            )
            
            
    ),
    
    # barplot tab content
    tabItem(tabName = "bar",  br(),
            h2("Staafdiagrammen over Kansenongelijkheid in Amsterdam"), br(), br(),
            h2("COMING SOON!!")
    ),
    
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



