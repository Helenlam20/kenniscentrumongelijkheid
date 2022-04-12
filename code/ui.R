# KCO Dashboard 
#
# - UI: a user interface object
# - The user interface (ui) object controls the layout and appearance of your app. 
#
# (c) Erasmus School of Economics 2022


sidebar <- 
  dashboardSidebar(
    width = 250,
    collapsed = F,
    sidebarMenu(
      HTML(paste0(
        "<br>",
        "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='temp_home.png' width = '186'>",
        "<br><br>"
      )),
      menuItem("Gradiënt", tabName = "gradient", icon = icon("signal", lib = "glyphicon")),
      menuItem("Export data", tabName = "table", icon = icon("list", lib = "glyphicon")),
      menuItem("Werkwijze", tabName = "werkwijze", icon = icon("question")),
      menuItem("Contact", tabName = "contact", icon = icon("envelope", lib = "glyphicon"))
    )  # end sidebar menu
  ) # end shinydashboard



body <- dashboardBody(
  tags$script(HTML("$('body').addClass('sidebar-mini');")),
  theme_poor_mans_flatly,
  tabItems(
    # gradient
    tabItem(tabName = "gradient",
            fluidRow(
              column(width = 9,
                     fluidRow(
                       column(width = 5,
                              box(height = NULL, title = "Uitkomstmaat", width = NULL,
                                  status = "primary", solidHeader = TRUE,
                                  pickerInput("outcome", label = "Selecteer hier een uitkomstmaat", 
                                              selected = "Persoonlijk inkomen",
                                              choices = list(`Geld` = sort(subset(outcome_dat$outcome_name, outcome_dat$type == "Geld")),
                                                   `Gezondheid en welzijn` = sort(subset(outcome_dat$outcome_name, outcome_dat$type == "Gezondheid en Welzijn")),
                                                   `Onderwijs` = sort(subset(outcome_dat$outcome_name, outcome_dat$type == "Onderwijs")),
                                                   `Wonen` = sort(subset(outcome_dat$outcome_name, outcome_dat$type == "Wonen"))),
                                                   options = list(`live-search` = T, style = "", size = 10)),
                              prettyCheckboxGroup(
                                inputId = "line_options",
                                label = HTML("<b>Selecteer hier een optie:</b>"),
                                choices = c("Lijn", "Gemiddelde"), bigger = TRUE,
                                icon = icon("check-square-o"), status = "primary",
                                outline = TRUE, inline = TRUE, animation = "jelly"
                                ),
                              prettyRadioButtons(
                                inputId = "parents_options",
                                label = HTML("<b>Selecteer hier een kenmerk van ouders:</b>"),
                                choices = c("Inkomen ouders", "Opleiding ouders"),
                                icon = icon("check"), inline = TRUE,
                                bigger = TRUE, selected = "Inkomen ouders",
                                status = "info", animation = "jelly"
                                )
                              ),
                       ),
                       column(width = 7,
                              tabBox(
                                id = "tabset1", height = NULL, width = NULL,
                                tabPanel("Algemeen", htmlOutput("selected_outcome")),
                                tabPanel("Wat zien we hier?", htmlOutput("sample_uitleg")),
                                tabPanel("Causaliteit",
                                         "Het dashboard brengt de samenhang in beeld tussen de omstandigheden
                              waarin kinderen opgroeien — zoals samenstelling van het huishouden,
                              inkomen van de ouders en migratieachtergrond — en hun uitkomsten over de
                              levensloop. Echter, omstandigheden hangen vaak met elkaar samen en hangen
                              samen met andere factoren waar niet voor te controleren valt. We meten hier
                              dus alleen een samenhang met omstandigheden en geen causaal effect van
                              bijvoorbeeld inkomen van de ouders op uitkomsten."),
                                selected = "Algemeen"),
                       ),
                     ),
                     box(collapsible = FALSE, status = "primary",
                         title = textOutput("title_plot"), width = NULL, solidHeader = T,
                         dropdownButton(
                           h4("INPUT FOR THE Y-AXIS RANGE"),
                           br(), br(), "test test", 
                           inline = TRUE, circle = F, 
                           icon = icon("gear"), width = "300px",
                           tooltip = tooltipOptions(title = "Aanpassen Y-as")
                         ),
                         actionButton("table", label = "Bekijk de data"),
                         downloadButton(outputId = "downloadData", label = "Download data"),
                         downloadButton(outputId = "downloadPlot", label = "Download figuur"),
                         plotlyOutput("main_figure", height = "420")),
              ),
              column(width = 3,
                     box(height = NULL,
                         title = "Groep 1", width = NULL, status = "info", solidHeader = TRUE,
                         pickerInput("geografie1", label = "Gebied", selected = "Metropool Amsterdam",
                                     choices = list("Nederland", "Metropool Amsterdam",
                                                    `Gemeente` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
                                                    `Stadsdeel Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Stadsdeel")),
                                                    `Wijk Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Wijk"))),
                                     options = list(`live-search` = TRUE, style = "", size = 10)),
                         selectizeInput(inputId = "geslacht1", label = "Geslacht",
                                        choices = c("Totaal", "Mannen", "Vrouwen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "migratie1", label = "Migratieachtergrond",
                                        choices = c("Totaal", "Nederland", "Turkije", "Marokko",
                                                    "Suriname", "Nederlandse Antillen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "huishouden1", label = "Aantal ouders in een gezin",
                                        choices = c("Totaal", "Eenoudergezin", "Tweeoudergezin"),
                                        selected = "Totaal")
                     ),
                     box(height = NULL,
                         title = "Groep 2", width = NULL, status = "success", solidHeader = TRUE,
                         pickerInput("geografie2", label = "Gebied", selected = "Almere",
                                     choices = list("Nederland", "Metropool Amsterdam",
                                                    `Gemeente` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
                                                    `Stadsdeel Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Stadsdeel")),
                                                    `Wijk Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Wijk"))),
                                     options = list(`live-search` = TRUE, style = "", size = 10)),
                         selectizeInput(inputId = "geslacht2", label = "Geslacht",
                                        choices = c("Totaal", "Mannen", "Vrouwen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "migratie2", label = "Migratieachtergrond",
                                        choices = c("Totaal", "Nederland", "Turkije", "Marokko",
                                                    "Suriname", "Nederlandse Antillen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "huishouden2", label = "Aantal ouders in een gezin",
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
            includeMarkdown("www/contact.Rmd")
    )
    
  )
)


#### DEFINE UI ####
ui <- dashboardPage(
  header = dashboardHeader(
    title = tagList(
      tags$span(
        class = "logo-mini", "KCO Dashboard"
      ),
      tags$span(
        class = "logo-lg", "KCO Dashboard"
      )
    )
  ),
  sidebar = sidebar,
  body = body  
  
)