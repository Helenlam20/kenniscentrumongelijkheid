# KCO Dashboard 
#
# - UI: a user interface object
# - The user interface (ui) object controls the layout and appearance of your app. 
#
# (c) Erasmus School of Economics 2022



#### UI TEXT ####
source("./code/ui_options.R")


#### START UI ####

sidebar <- 
  dashboardSidebar(
    width = 300,
    collapsed = F,
    sidebarMenu(
      HTML(paste0(
        "<br>",
        "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='logo_button_shadow.svg' width='65%'>",
        "<br>"
      )),
      menuItem("Figuur", tabName = "gradient", icon = icon("signal", lib = "glyphicon")),
      # menuItem("Help", tabName = "help", icon = icon("question")),
      # menuItem("FAQ", tabName = "faq", icon = icon("question-sign", lib = "glyphicon")),
      # menuItem("Werkwijze", tabName = "werkwijze", icon = icon("info-sign", lib = "glyphicon")),
      menuItem("Contact", tabName = "contact", icon = icon("address-book"))
    )  # end sidebar menu
  ) # end shinydashboard



body <- dashboardBody(
  disconnectMessage(
    text = "Je sessie is verlopen, laad de applicatie opnieuw.",
    refresh = "Klik hier om te vernieuwen",
    background = "#3498db",
    colour = "white",
    overlayColour = "grey",
    overlayOpacity = 0.75,
    refreshColour = "white"
  ),
  useShinyjs(),
  useSweetAlert(), 
  tags$head(tags$link(rel = "icon", type = "image/png", href = "logo_button_shadow.svg")),
  tags$script(HTML("$('body').addClass('sidebar-mini');")),
  tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
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
                                              selected = "c30_income",
                                              choices = list(`Gezondheid en welzijn` = HealthChoices,
                                                             `Onderwijs` = EducationChoices,
                                                             `Wonen` = HouseChoices,
                                                             `Geld` = MoneyChoices),
                                              options = list(`live-search` = T, style = "", size = 10, `show-subtext` = TRUE),
                                              choicesOpt = list(subtext = outcome_dat$population)),
                                  prettyCheckboxGroup(
                                    inputId = "line_options",
                                    label = h5(HTML("<b>Selecteer hier een optie:</b>"),
                                               tags$style("#q_line {vertical-align: middle; width: 25px;
                                                          height: 25px; font-size: 11px;
                                                          border: 2px solid #e7e7e7; border-radius: 100%;
                                                          background-color: white; color: #555555;
                                                          line-height: 1pxt; padding: 0px;}"),
                                               bsButton("q_line", label = NULL, icon = icon("question"), 
                                                        size = "extra-small")
                                    ),
                                    choices = c("Lijn", "Gemiddelde", "Mediaan"),
                                    # choices = c("Lijn", "Gemiddelde", "Mediaan", "25e kwantiel", "75e kwantiel"),
                                    bigger = TRUE, icon = icon("check-square-o"), status = "primary",
                                    outline = TRUE, inline = TRUE, animation = "smooth"
                                  ),
                                  bsPopover(id = "q_line", title = "Lijn opties",
                                            content = HTML(line_hovertext),
                                            placement = "right", trigger = "hover", 
                                            options = list(container = "body")
                                  ),
                                  prettyRadioButtons(
                                    inputId = "parents_options",
                                    label = h5(HTML("<b>Selecteer hier een kenmerk van ouders:</b>"),
                                               tags$style("#q_parents {vertical-align: middle; width: 25px;
                                                          height: 25px; font-size: 11px;
                                                          border: 2px solid #e7e7e7; border-radius: 100%;
                                                          background-color: white; color: #555555;
                                                          line-height: 1pxt; padding: 0px;}"),
                                               bsButton("q_parents", label = NULL, icon = icon("question"), 
                                                        size = "extra-small")
                                    ),
                                    choices = c("Inkomen ouders", "Opleiding ouders"),
                                    icon = icon("check"), inline = TRUE,
                                    bigger = TRUE, selected = "Inkomen ouders",
                                    status = "info", animation = "smooth"
                                  ),
                                  bsPopover(id = "q_parents", title = "Kenmerk van ouders optie",
                                            content = HTML(parents_hovertext),
                                            placement = "right", trigger = "hover", 
                                            options = list(container = "body")
                                  ),
                              ),
                       ),
                       column(width = 7, tabBox(
                                id = "tabset1", height = NULL, width = NULL,
                                tabPanel("Algemene uitleg", htmlOutput("selected_outcome")),
                                tabPanel("Wat zie ik?", htmlOutput("sample_uitleg"), 
                                         br(), 
                                         prettySwitch(inputId = "SwitchColor", label = htmlOutput("SwitchColorLabel"),
                                                      status = "primary", inline = TRUE, fill = T, bigger = T)
                                         ),
                                tabPanel("Causaliteit", causal_text)),
                       ),
                     ),
                     box(collapsible = FALSE, status = "primary",
                         title = textOutput("title_plot"), width = NULL, solidHeader = T,
                         dropdownButton(
                           sliderInput("y_axis", "Verticale as (Y-as):", min=0, max=100, value=c(25,75), dragRange=FALSE),
                           sliderInput("x_axis", "Horizontale as (X-as):", min=0, max=750, value=c(25,75), dragRange=FALSE),
                           actionButton("user_reset", "Reset", width = "100%"),
                           inline = TRUE, circle = F,
                           icon = icon("gear"), width = "300px"
                         )%>% tagAppendAttributes(class = "dropup"),
                         downloadButton(outputId = "downloadData", label = "Download data"),
                         downloadButton(outputId = "downloadPlot", label = "Download figuur"),
                         actionButton("screenshot", "Maak een screenshot", icon = icon("camera"), 
                                      icon.library = "font awesome"),
                         prettySwitch(inputId = "change_barplot", label = HTML("<b> Toon alternatief staafdiagram</b>"),
                                      status = "primary", inline = TRUE, fill = T, bigger = T),
                         shinycssloaders::withSpinner(plotlyOutput("main_figure", height = "450"), 
                                                      type = 1, color = "#18BC9C", size = 1.5)),
              ),
              column(width = 3,
                     box(height = NULL,
                         title = "Blauwe groep", width = NULL, status = "info", solidHeader = TRUE,
                         pickerInput("geografie1", label = "Gebied", selected = "Nederland",
                                     choices = GeoChoices,
                                     options = list(`live-search` = TRUE, style = "", size = 10)),
                         selectizeInput(inputId = "geslacht1", label = "Geslacht",
                                        choices = GenderChoices,
                                        selected = GenderChoices[1]),
                         selectizeInput(inputId = "migratie1", label = "Migratieachtergrond",
                                        choices = MigrationChoices,
                                        selected = MigrationChoices[1]),
                         selectizeInput(inputId = "huishouden1", label = "Aantal ouders in gezin",
                                        choices = HouseholdChoices,
                                        selected = HouseholdChoices[1]),
                         prettySwitch(inputId = "OnePlot", label = HTML("<b> Toon één groep</b>"),
                                      status = "primary", inline = TRUE, fill = T, bigger = T)
                     ),
                     box(height = NULL, id="box_groene_group",
                         title = "Groene groep", width = NULL, status = "success", solidHeader = TRUE, collapsible = TRUE,
                         pickerInput("geografie2", label = "Gebied", selected = "Purmerend",
                                     choices = GeoChoices,
                                     options = list(`live-search` = TRUE, style = "", size = 10)),
                         selectizeInput(inputId = "geslacht2", label = "Geslacht",
                                        choices = GenderChoices,
                                        selected = GenderChoices[1]),
                         selectizeInput(inputId = "migratie2", label = "Migratieachtergrond",
                                        choices = MigrationChoices,
                                        selected = MigrationChoices[1]),
                         selectizeInput(inputId = "huishouden2", label = "Aantal ouders in gezin",
                                        choices = HouseholdChoices,
                                        selected = HouseholdChoices[1])
                     ),
              )
            )
    ),
    
    # tab content
    tabItem(tabName = "help",
            box(status = "primary", 
                includeMarkdown("markdown/help.Rmd")
            )
    ),

    tabItem(tabName = "faq",
            box(h1("Veelgestelde vragen"),
                box(title = faq_q1, 
                    status = "primary", solidHeader = T, collapsed = T, collapsible = T, width = 350, 
                    faq_a1) %>% tagAppendAttributes(class = "faq"),
                box(title = faq_q2, 
                    status = "success", solidHeader = T, collapsed = T, collapsible = T, width = 350, 
                    faq_a2) %>% tagAppendAttributes(class = "faq"),
                box(title = faq_q3, 
                    status = "info", solidHeader = T, collapsed = T, collapsible = T, width = 350, 
                    faq_a3) %>% tagAppendAttributes(class = "faq"),
                box(title = faq_q4, 
                    status = "warning", solidHeader = T, collapsed = T, collapsible = T, width = 350,  
                    faq_a4) %>% tagAppendAttributes(class = "faq"),
                box(title = faq_q5, 
                    status = "danger", solidHeader = T, collapsed = T, collapsible = T, width = 350, 
                    faq_a5) %>% tagAppendAttributes(class = "faq"))
    ),
    
    # tab content
    tabItem(tabName = "werkwijze",
            column(width = 6, box(width = 300, status = "primary",
                includeMarkdown("markdown/werkwijze.Rmd")
            )),
            column(width = 6, 
                   ),
      tags$script(src="script.js")
    ),
    
    # tab content
    tabItem(tabName = "contact",
            box(status = "primary", 
              includeMarkdown("markdown/contact.Rmd")
            )
    )
    
  )
)


#### DEFINE UI ####
ui <- dashboardPage(
  title="Dashboard Ongelijkheid in Amsterdam",
  header = dashboardHeader(
    titleWidth = 400, 
    title = tags$span("Dashboard Ongelijkheid in Cijfers Amsterdam", 
                      style = "font-weight: bold;"
    )
    # tags$li(class = "dropdown", actionBttn(
    #   inputId = "beginscherm",
    #   label = "Beginscherm", 
    #   style = "unite",
    #   color = "success",
    #   icon = icon("question")
    # ))
  ),
  sidebar = sidebar,
  body = body  
  
)