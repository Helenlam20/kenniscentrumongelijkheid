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
        "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='logo_button_shadow.svg' width='65%'>",
        "<br>"
      )),
      menuItem("Figuur", tabName = "gradient", icon = icon("signal", lib = "glyphicon")),
      menuItem("Help", tabName = "help", icon = icon("question")),
      menuItem("Werkwijze", tabName = "werkwijze", icon = icon("book-open")),
      menuItem("Contact", tabName = "contact", icon = icon("address-book"))
    )  # end sidebar menu
  ) # end shinydashboard



body <- dashboardBody(
  useShinyjs(),
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
                                              selected = "c11_havo_test",
                                              choices = list(`Geld` = c("Persoonlijk inkomen" = "c30_income",
                                                                        "Werkend" = "c30_employed", 
                                                                        "Uren werk per week" = "c30_hrs_work_pw", 
                                                                        "Flexibel arbeidscontract" = "c30_flex_contract", 
                                                                        "Uurloon"  = "c30_hourly_wage", 
                                                                        "Uitkering arbeidsongeschiktheid/ziekte" = "c30_disability", 
                                                                        "Bijstand" = "c30_social_assistance", 
                                                                        "Vermogen"  = "c30_wealth", 
                                                                        "Schulden" = "c30_debt"), 
                                                             `Gezondheid en welzijn` = c("Zorgkosten" = "c30_total_health_costs", 
                                                                                         "Gebruikt ziekenhuiszorg" = "c30_hospital", 
                                                                                         "Gebruikt geestelijke gezondheidszorg (specialistisch)" = "c30_specialist_mhc", 
                                                                                         "Gebruikt geestelijke gezondheidszorg (basis)" = "c30_basic_mhc", 
                                                                                         "Gebruikt medicijnen" = "c30_pharma", 
                                                                                         "Zorgkosten" = "c11_youth_health_costs", 
                                                                                         "Zorgkosten" = "c16_youth_health_costs", 
                                                                                         "Jeugdbescherming" = "c11_youth_protection",
                                                                                         "Jeugdbescherming" = "c16_youth_protection",
                                                                                         "Laag geboortegewicht" = "c00_sga",
                                                                                         "Vroeggeboorte"  = "c00_preterm_birth", 
                                                                                         "Zuigelingensterfte" = "c00_infant_mortality"),
                                                             `Onderwijs` = c("Eindtoetsadvies vmbo-GL en hoger" = "c11_vmbo_gl_test",        
                                                                             "Eindtoetsadvies havo en hoger" = "c11_havo_test",           
                                                                             "Eindtoetsadvies vwo" = "c11_vwo_test",                    
                                                                             "Eindtoets rekenen streefniveau" = "c11_math",           
                                                                             "Eindtoets lezen streefniveau" = "c11_reading",           
                                                                             "Eindtoets taalverzorging streefniveau" = "c11_language",  
                                                                             "Schooladvies vmbo-GL en hoger" = "c11_vmbo_gl_final",            
                                                                             "Schooladvies havo en hoger" = "c11_havo_final",           
                                                                             "Schooladvies vwo" = "c11_vwo_final" ,                      
                                                                             "Schooladvies hoger dan eindtoetsadvies" = "c11_over_advice", 
                                                                             "Schooladvies lager dan eindtoetsadvies" = "c11_under_advice", 
                                                                             "Volgt vmbo-GL of hoger" = "c16_vmbo_gl",                  
                                                                             "Volgt havo of hoger" = "c16_havo",                     
                                                                             "Volgt vwo" = "c16_vwo",                               
                                                                             "Startkwalificatie behaald" = "c21_high_school_attained",             
                                                                             "Volgend/ gevolgd hbo of hoger" = "c21_hbo_followed",         
                                                                             "Volgend/ gevolgd universiteit" = "C21_uni_followed",         
                                                                             "Diploma hbo of hoger" = "c30_hbo_attained",                  
                                                                             "Diploma universiteit" = "c30_wo_attained"),
                                                             `Wonen` = c("Huiseigenaar" = "c30_home_owner", 
                                                                         "Woonoppervlak per lid huishouden" = "c11_living_space_pp", 
                                                                         "Woonoppervlak per lid huishouden" = "c16_living_space_pp")),
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
                                    choices = c("Lijn", "Gemiddelde"), bigger = TRUE,
                                    icon = icon("check-square-o"), status = "primary",
                                    outline = TRUE, inline = TRUE, animation = "smooth"
                                  ),
                                  bsPopover(id = "q_line", title = "Lijn opties",
                                            content = HTML("De optie <i>Lijn</i> toont een fitted line door de bollen en is alleen beschikbaar voor de optie <i>Inkomen ouders</i>.<br><br>De optie <i>Gemiddelde</i> toont het totaalgemiddelde van de groep."),
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
                                            content = HTML("<i>Kenmerk van de ouders</i> staat op de horizontale as van de figuur.<br><br>De optie <i>Opleiding ouders</i> is alleen beschikbaar voor de uitkomstmaten van pasgeborenen en leeringen in groep 8."),
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
                           sliderInput("y_axis", "Verticale as (Y-as):", min=0, max=100, value=c(25,75), dragRange=FALSE),
                           sliderInput("x_axis", "Horizontale as (X-as):", min=0, max=750, value=c(25,75), dragRange=FALSE),
                           actionButton("user_reset", "Reset", width = "100%"),
                           inline = TRUE, circle = F,
                           icon = icon("gear"), width = "300px"
                         ),
                         downloadButton(outputId = "downloadData", label = "Download data"),
                         downloadButton(outputId = "downloadPlot", label = "Download figuur"),
                         prettySwitch(inputId = "change_barplot", label = HTML("<b> Toon alternatief grafiek voor Opleiding Ouders</b>"),
                                      status = "primary", inline = TRUE, fill = T, bigger = T),
                         plotlyOutput("main_figure", height = "450")),
              ),
              column(width = 3,
                     box(height = NULL,
                         title = "Blauwe groep", width = NULL, status = "info", solidHeader = TRUE,
                         pickerInput("geografie1", label = "Gebied", selected = "Bloemendaal",
                                     choices = list("Nederland", "Metropool Amsterdam",
                                                    `Gemeenten in Metropool Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
                                                    `Stadsdelen in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Stadsdeel")),
                                                    `Gebieden in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Wijk"))),
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
                         prettySwitch(inputId = "OnePlot", label = HTML("<b> Toon één groep</b>"),
                                      status = "primary", inline = TRUE, fill = T, bigger = T)
                     ),
                     box(height = NULL, id="box_groene_group",
                         title = "Groene groep", width = NULL, status = "success", solidHeader = TRUE, collapsible = TRUE,
                         pickerInput("geografie2", label = "Gebied", selected = "Purmerend",
                                     choices = list("Nederland", "Metropool Amsterdam",
                                                    `Gemeenten` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
                                                    `Stadsdelen in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Stadsdeel")),
                                                    `Gebieden in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Wijk"))),
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
    tabItem(tabName = "help",
            column(width = 6, box(width = 300, status = "primary",
                includeMarkdown("markdown/help.Rmd")
            )),
            column(width = 5, box(title = "Veelgestelde vragen", width = 300, collapsible = F, 
                   box(title = "Vraag 1: waarom is dit de eerste veelgestelde vraag?", 
                       status = "primary", solidHeader = T, collapsed = T, collapsible = T, width = 300, 
                       "Antwoord op de vraag!"),
                   box(title = "Vraag 2: waarom is dit de tweede veelgestelde vraag?", 
                       status = "success", solidHeader = T, collapsed = T, collapsible = T, width = 300, 
                       "Antwoord op de vraag!"),
                   box(title = "Vraag 3: waarom is dit de derde veelgestelde vraag?", 
                       status = "info", solidHeader = T, collapsed = T, collapsible = T, width = 300, 
                       "Antwoord op de vraag!"),
                   box(title = "Vraag 4: waarom is dit de vierde veelgestelde vraag?", 
                       status = "warning", solidHeader = T, collapsed = T, collapsible = T, width = 300, 
                       "Antwoord op de vraag!"),
                   box(title = "Vraag 5: waarom is dit de vijfde veelgestelde vraag?", 
                       status = "danger", solidHeader = T, collapsed = T, collapsible = T, width = 300, 
                       "Antwoord op de vraag!"))
                   )
    ),

    # info tab content
    tabItem(tabName = "werkwijze",
            box(status = "primary", 
              includeMarkdown("markdown/werkwijze.Rmd")
            )
    ),
    
    # contact tab content
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
    title = tags$span("Dashboard Ongelijkheid in Amsterdam", 
                      style = "font-weight: bold;"
    )
  ),
  sidebar = sidebar,
  body = body  
  
)