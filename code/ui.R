# KCO Dashboard 
#
# - UI: a user interface object
# - The user interface (ui) object controls the layout and appearance of your app. 
#
# (c) Erasmus School of Economics 2022


sidebar <- 
  dashboardSidebar(
    width = 225,
    collapsed = F,
    sidebarMenu(
      HTML(paste0(
        "<br>",
        "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='temp_home.png' width = '186'>",
        "<br><br>"
      )),
      menuItem("Gradiënt", tabName = "gradient", icon = icon("signal", lib = "glyphicon")),
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
                                    label = h5(HTML("<b>Selecteer hier een kenmerk van ouders:</b>"),
                                               tags$style("#q1 {vertical-align: middle; width: 22px;
                                                          height: 22px; font-size: 10px; 
                                                          line-height: 1pxt; padding: 0px;}"),
                                               bsButton("q1", label = NULL, icon = icon("question"), 
                                                        size = "extra-small")
                                    ),
                                    choices = c("Inkomen ouders", "Opleiding ouders"),
                                    icon = icon("check"), inline = TRUE,
                                    bigger = TRUE, selected = "Inkomen ouders",
                                    status = "info", animation = "jelly"
                                  ),
                              bsPopover(id = "q1", title = "Opleiding ouders",
                                        content = HTML("De optie <i>opleiding ouders</i> is alleen beschikbaar voor de uitkomstmaten die komen uit de pasgeboren en de groep 8 steekproeven. Zie tabblad <i>werkwijze</i> voor meer informatie."),
                                        placement = "right", 
                                        trigger = "hover", 
                                        options = list(container = "body")
                              ),
                              ),
                       ),
                       column(width = 7,
                              tabBox(
                                id = "tabset1", height = NULL, width = NULL,
                                tabPanel("Algemeen", htmlOutput("selected_outcome")),
                                tabPanel("Wat zie ik?", htmlOutput("sample_uitleg")),
                                tabPanel("Causaliteit",
                                         "Het dashboard toont de samenhang tussen de omstandigheden 
                                         waarin kinderen opgroeien en hun uitkomsten over de levensloop. 
                                         Maar die omstandigheden hangen samen met eindeloos veel factoren 
                                         die ook van invloed zijn en waarvoor niet te controleren valt. 
                                         Daarom moeten deze patronen niet worden gezien als oorzakelijke verbanden."),
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
                           tooltip = tooltipOptions(title = "Y-as range aanpassen")
                         ),
                         downloadButton(outputId = "downloadData", label = "Download data"),
                         downloadButton(outputId = "downloadPlot", label = "Download figuur"),
                         plotlyOutput("main_figure", height = "420")),
              ),
              column(width = 3,
                     box(height = NULL,
                         title = "Blauwe groep", width = NULL, status = "info", solidHeader = TRUE,
                         pickerInput("geografie1", label = "Gebied", selected = "Nederland",
                                     choices = list("Nederland", "Metropool Amsterdam",
                                                    `Gemeenten` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
                                                    `Stadsdelen in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Stadsdeel")),
                                                    `22 gebieden in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Wijk"))),
                                     options = list(`live-search` = TRUE, style = "", size = 10)),
                         selectizeInput(inputId = "geslacht1", label = "Geslacht",
                                        choices = c("Totaal", "Mannen", "Vrouwen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "migratie1", label = "Migratieachtergrond",
                                        choices = c("Totaal", "Zonder migratieachtergrond", "Turkije", "Marokko",
                                                    "Suriname", "Nederlandse Antillen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "huishouden1", label = "Aantal ouders in gezin",
                                        choices = c("Totaal", "Eenoudergezin", "Tweeoudergezin"),
                                        selected = "Totaal"),
                         prettySwitch(inputId = "OnePlot", label = HTML("<b> Toon maar één groep</b>"),
                                      status = "primary", inline = TRUE, fill = T, bigger = T)
                     ),
                     box(height = NULL,
                         title = "Groene groep", width = NULL, status = "success", solidHeader = TRUE,
                         pickerInput("geografie2", label = "Gebied", selected = "Amsterdam",
                                     choices = list("Nederland", "Metropool Amsterdam",
                                                    `Gemeenten` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
                                                    `Stadsdelen in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Stadsdeel")),
                                                    `22 gebieden in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Wijk"))),
                                     options = list(`live-search` = TRUE, style = "", size = 10)),
                         selectizeInput(inputId = "geslacht2", label = "Geslacht",
                                        choices = c("Totaal", "Mannen", "Vrouwen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "migratie2", label = "Migratieachtergrond",
                                        choices = c("Totaal", "Zonder migratieachtergrond", "Turkije", "Marokko",
                                                    "Suriname", "Nederlandse Antillen"),
                                        selected = "Totaal"),
                         selectizeInput(inputId = "huishouden2", label = "Aantal ouders in gezin",
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
    titleWidth = 325, 
    title = tagList(
      tags$span(
        class = "logo-mini", "Dashboard Ongelijkheid in de stad"
      ),
      tags$span(
        class = "logo-lg", "Dashboard Ongelijkheid in de stad"
      )
    )
  ),
  sidebar = sidebar,
  body = body  
  
)