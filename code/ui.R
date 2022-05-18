# KCO Dashboard 
#
# - UI: a user interface object
# - The user interface (ui) object controls the layout and appearance of your app. 
#
# (c) Erasmus School of Economics 2022


radioTooltip <- function(id, choice, title, placement = "bottom", trigger = "hover", options = NULL){
  
  options = shinyBS:::buildTooltipOrPopoverOptionsList(title, placement, trigger, options)
  options = paste0("{'", paste(names(options), options, sep = "': '", collapse = "', '"), "'}")
  bsTag <- shiny::tags$script(shiny::HTML(paste0("
    $(document).ready(function() {
      setTimeout(function() {
        $('input', $('#", id, "')).each(function(){
          if(this.getAttribute('value') == '", choice, "') {
            opts = $.extend(", options, ", {html: true});
            $(this.parentElement).tooltip('destroy');
            $(this.parentElement).tooltip(opts);
          }
        })
      }, 500)
    });
  ")))
  htmltools::attachDependencies(bsTag, shinyBS:::shinyBSDep)
}

causal_text <- 
"Het dashboard toont de samenhang tussen de omstandigheden waarin kinderen opgroeien 
en hun uitkomsten over de levensloop. Maar die omstandigheden hangen samen met 
eindeloos veel factoren die ook van invloed zijn en waarvoor niet te controleren 
valt. Daarom moeten deze patronen niet worden gezien als oorzakelijke verbanden."


#### START UI ####

sidebar <- 
  dashboardSidebar(
    width = 300,
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
  useShinyjs(),
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
                                              # selected = "Startkwalificatie behaald",
                                              selected = "Zuigelingensterfte",
                                              choices = list(`Geld` = sort(subset(outcome_dat$outcome_name, outcome_dat$type == "Geld")),
                                                             `Gezondheid en welzijn` = sort(subset(outcome_dat$outcome_name, outcome_dat$type == "Gezondheid en Welzijn")),
                                                             `Onderwijs` = sort(subset(outcome_dat$outcome_name, outcome_dat$type == "Onderwijs")),
                                                             `Wonen` = sort(subset(outcome_dat$outcome_name, outcome_dat$type == "Wonen"))),
                                              options = list(`live-search` = T, style = "", size = 10),
                                              choicesOpt = list(subtext = outcome_dat$population)),
                                  prettyCheckboxGroup(
                                    inputId = "line_options",
                                    # label = HTML("<b>Selecteer hier een optie:</b>"), 
                                    label = h5(HTML("<b>Selecteer hier een optie:</b>"),
                                               tags$style("#q_line {vertical-align: middle; width: 25px;
                                                          height: 25px; font-size: 11px;
                                                          border: 2px solid #e7e7e7; border-radius: 100%;
                                                          background-color: white; color: #555555;
                                                          line-height: 1pxt; padding: 0px;}"),
                                               bsButton("q_line", label = NULL, icon = icon("question"), 
                                                        size = "extra-small")
                                    ),
                                    choices = c("Lijn", "Gemiddelde"), bigger = TRUE,
                                    icon = icon("check-square-o"), status = "primary",
                                    outline = TRUE, inline = TRUE, animation = "smooth"
                                  ),
                                  bsPopover(id = "q_line", title = "Lijn opties",
                                            content = HTML("De optie <i>Lijn</i> is de fitted line door de bollen en is <u>alleen beschikbaar</u> voor de optie <i>Inkomen Ouders</i>.<br><br>De optie <i>Gemiddelde</i> is het gemiddelde van de groep."),
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
                                  bsPopover(id = "q_parents", title = "Kenmerken van ouders optie",
                                            content = HTML("<b>Kenmerken van de ouders</b> staan op de horizontale as van de figuur.<br><br>De optie <i>Opleiding Ouders</i> is alleen beschikbaar voor de uitkomstmaten van pasgeborenen en groep 8."),
                                            placement = "right", trigger = "hover", 
                                            options = list(container = "body")
                                  ),
                              ),
                       ),
                       column(width = 7,
                              tabBox(
                                id = "tabset1", height = NULL, width = NULL,
                                tabPanel("Algemeen", htmlOutput("selected_outcome")),
                                tabPanel("Wat zie ik?", htmlOutput("sample_uitleg")),
                                tabPanel("Causaliteit", causal_text),
                                selected = "Algemeen"),
                       ),
                     ),
                     box(collapsible = FALSE, status = "primary",
                         title = textOutput("title_plot"), width = NULL, solidHeader = T,
                         dropdownButton(
                           sliderInput("y_axis", "Y-as:", min=0, max=100, value=c(25,75)),
                           actionButton("user_reset", "Reset", width = "100%"),
                           inline = TRUE, circle = F,
                           icon = icon("gear"), width = "300px",
                           tooltip = tooltipOptions(title = "Y-as range aanpassen")
                         ),
                         downloadButton(outputId = "downloadData", label = "Download data"),
                         downloadButton(outputId = "downloadPlot", label = "Download figuur"),
                         actionButton("change_barplot", "Toon alternatief voor staafdiagram"),
                         plotlyOutput("main_figure", height = "450")),
              ),
              column(width = 3,
                     box(height = NULL,
                         title = "Blauwe groep", width = NULL, status = "info", solidHeader = TRUE,
                         pickerInput("geografie1", label = "Gebied", selected = "Metropool Amsterdam",
                                     choices = list("Nederland", "Metropool Amsterdam",
                                                    `Gemeenten in Metropool Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
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
                     box(height = NULL, id="box_groene_group",
                         title = "Groene groep", width = NULL, status = "success", solidHeader = TRUE, collapsible = TRUE,
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
            tags$script(src="script.js")
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
  title="Dashboard Ongelijkheid in de stad",
  header = dashboardHeader(
    titleWidth = 400, 
    title = tags$span("Dashboard Ongelijkheid in de stad", 
                      style = "font-weight: bold;"
    )
  ),
  sidebar = sidebar,
  body = body  
  
)