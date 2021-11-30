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
      menuItem("Gradient", tabName = "gradient", icon = icon("signal", lib = "glyphicon"),
               badgeLabel = "Nieuw", badgeColor = "teal"),
      menuItem("Staafdiagram", tabName = "bar", icon = icon("stats", lib = "glyphicon")),
      menuItem("Info", tabName = "info", icon = icon("question")),
      menuItem("Contact", tabName = "contact", icon = icon("envelope", lib = "glyphicon")),
      
      HTML(paste0("<br><br><br><br>")),
      
      # sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
      #                   label = "Search..."),
      
      HTML(paste0(
        "<br><br><br><br><br><br><br><br><br><br>",
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
  
  ### changing theme
  shinyDashboardThemes(
    theme = "blue_gradient"
  ),
  
  tabItems(
    # home tab content
    tabItem(tabName = "home",
            # home section
            includeMarkdown("www/home.Rmd")
    ),
    
    # gradient
    tabItem(tabName = "gradient",
            h1("Gradienten over Kansenongelijkheid in Amsterdam"),
            br(), br(),
            
            fluidRow(
              box(
                title = "Uitkomstmaat", width = 4, status = "primary", solidHeader = TRUE,
                selectInput("select", label = "",
                            choices = list("Inkomen" = 1, "HBO en hoger" = 2, "WO en hoger" = 3),
                             selected = 1)
              ),
              box(
                title = "Geografie", width = 4, status = "info", solidHeader = TRUE,
                selectInput("select", label = "",
                            choices = list("Nederland" = 1, "Amsterdam" = 2, "Metropool Amsterdam" = 3),
                            selected = 1),
                selectInput("select", label = "",
                            choices = list("Nederland" = 1, "Amsterdam" = 2, "Metropool Amsterdam" = 3),
                            selected = 2),
              ),
              box(width = 4,
                title = "Controls",
                sliderInput("slider", "Number of observations:", 1, 100, 50)
              )
              # box(
              #   title = "Demografie", width = 4, status = "success", solidHeader = TRUE,
              #   selectInput("select", label = "",
              #               choices = list("Choice" = 1, "Choice 2" = 2, "Choice 3" = 3),
              #               selected = 1)
              # )
            ),
  
            column(width = 12,
                   box(collapsible = TRUE,
                     title = "Keuzemenu", width = NULL, solidHeader = FALSE, status = "primary",
                     plotOutput("plot1", height = 425)
                   )
            )
    ),
    
    # barplot tab content
    tabItem(tabName = "bar",
            h1("Staafdiagrammen over Kansenongelijkheid in Amsterdam"),
            br(), br(),
            h1("COMING SOON!!")
    ),
    
    # info tab content
    tabItem(tabName = "info",
            includeMarkdown("www/info.Rmd")
    ),

    # contact tab content
    tabItem(tabName = "contact",
            includeMarkdown("www/contact.Rmd")
    )
    
  )
)


#### DEFINE UI ####
ui <- dashboardPage(
  dashboardHeader(title = shinyDashboardLogo(
    theme = "blue_gradient",
    boldText = "KCO Dashboard",
    mainText = "",
    badgeText = "BETA"), titleWidth = 300),
  
sidebar,
body  

)



