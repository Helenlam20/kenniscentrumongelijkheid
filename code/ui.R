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
      menuItem(lang[["menu_figure"]], tabName = "gradient", icon = icon("signal", lib = "glyphicon")),
      menuItem(lang[["menu_video"]], tabName = "videos", icon = icon("video")),
      menuItem(lang[["menu_method"]], tabName = "werkwijze", icon = icon("info-sign", lib = "glyphicon")),
      # menuItem(lang[["menu_faq"]], tabName = "faq", icon = icon("question")),
      menuItem(lang[["menu_contact"]] , tabName = "contact", icon = icon("address-book"))
    )  # end sidebar menu
  ) # end shinydashboard



body <- dashboardBody(
  disconnectMessage(
    text = lang[["disconnect_message"]],
    refresh = lang[["disconnect_refresh"]],
    background = "#3498db",
    colour = "white",
    overlayColour = "grey",
    overlayOpacity = 0.75,
    refreshColour = "white"
  ),
  useShinyjs(),
  useSweetAlert(), 
  tags$head(tags$link(rel = "icon", type = "image/png", href = "logo_button_shadow.svg")),
  # JS cookie library
  tags$script(src = paste0("https://cdn.jsdelivr.net/npm/js-cookie@rc/","dist/js.cookie.min.js")), 
  tags$script(HTML("$('body').addClass('sidebar-mini');")),
  tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
  tags$head(includeHTML(("www/google-analytics.html"))),
  theme_poor_mans_flatly,
  tabItems(
    # gradient
    tabItem(tabName = "gradient",
            fluidRow(
              column(width = 9,
                     fluidRow(
                       column(width = 5,
                              box(height = NULL, title = lang[["box_outcome"]], width = NULL,
                                  status = "primary", solidHeader = TRUE,
                                  pickerInput("outcome", label = lang[["box_outcome_select_outcome"]], 
                                              # selected = "c11_living_space_pp",
                                              selected = "c11_havo_test",
                                              choices = outcomeChoices,
                                              options = list(`live-search` = T, style = "", size = 10, `show-subtext` = TRUE),
                                              choicesOpt = list(subtext = outcome_dat$population)),
                                  prettyCheckboxGroup(
                                    inputId = "line_options",
                                    label = h5(HTML(lang[["box_outcome_select_line_option"]]),
                                               tags$style("#q_line {vertical-align: middle; width: 25px;
                                                          height: 25px; font-size: 11px;
                                                          border: 2px solid #e7e7e7; border-radius: 100%;
                                                          background-color: white; color: #555555;
                                                          line-height: 1pxt; padding: 0px;}"),
                                               bsButton("q_line", label = NULL, icon = icon("question"), 
                                                        size = "extra-small")
                                    ),
                                    choices = c(lang[["line"]], lang[["average"]]),
                                    bigger = TRUE, icon = icon("check-square-o"), status = "info",
                                    outline = TRUE, inline = TRUE, animation = "smooth"
                                  ),
                                  bsPopover(id = "q_line", title = lang[["box_outcome_select_line_option_hover"]],
                                            content = HTML(lang[["box_outcome_select_line_option_hovertext"]]),
                                            placement = "right", trigger = "hover", 
                                            options = list(container = "body")
                                  ),
                                  prettyRadioButtons(
                                    inputId = "parents_options",
                                    label = h5(HTML(lang[["box_outcome_select_parent_option"]]),
                                               tags$style("#q_parents {vertical-align: middle; width: 25px;
                                                          height: 25px; font-size: 11px;
                                                          border: 2px solid #e7e7e7; border-radius: 100%;
                                                          background-color: white; color: #555555;
                                                          line-height: 1pxt; padding: 0px;}"),
                                               bsButton("q_parents", label = NULL, icon = icon("question"), 
                                                        size = "extra-small")
                                    ),
                                    choices = c(lang[["parent_income"]], lang[["parent_education"]]),
                                    icon = icon("check"), inline = TRUE,
                                    bigger = TRUE, 
                                    status = "info", animation = "smooth"
                                  ),
                                  bsPopover(id = "q_parents", title = lang[["box_outcome_select_parent_option_hover"]],
                                            content = HTML(lang[["box_outcome_select_parent_option_hovertext"]]),
                                            placement = "right", trigger = "hover", 
                                            options = list(container = "body")
                                  ),
                              ),
                       ),
                       column(width = 7, tabBox(
                                id = "tabset1", height = NULL, width = NULL,
                                tabPanel(lang[["box_text_general"]] , htmlOutput("selected_outcome"),
                                         br(),
                                         prettyRadioButtons(
                                           inputId = "SwitchTabbox1", label = lang[["box_text_switch_label"]],
                                           choices = c(lang[["outcome_measure"]], lang[["parent_income"]]),
                                           icon = icon("check"), inline = TRUE,
                                           bigger = TRUE, 
                                           status = "info", animation = "smooth")
                                         ),
                                tabPanel(lang[["box_text_what_do_i_see"]], htmlOutput("sample_uitleg"), 
                                         br(), 
                                         prettyRadioButtons(
                                           inputId = "SwitchColor", label = lang[["box_text_switch_label"]], 
                                           choices = c(lang[["blue_group"]] , lang[["green_group"]]),
                                           icon = icon("check"), inline = TRUE,
                                           bigger = TRUE, 
                                           status = "info", animation = "smooth")
                                         ), 
                                tabPanel(lang[["box_text_causality"]] , lang[["box_text_causality_text"]])),
                       ),
                     ),
                     box(collapsible = FALSE, status = "primary",
                         title = textOutput("title_plot"), width = NULL, solidHeader = T,
                         dropdownButton(
                           sliderInput("y_axis", lang[["y_axis_label"]], min=0, max=100, value=c(25,75), dragRange=FALSE),
                           sliderInput("x_axis", lang[["x_axis_label"]], min=0, max=750, value=c(25,75), dragRange=FALSE),
                           actionButton("user_reset", lang[["reset"]], width = "100%"),
                           inline = TRUE, circle = F,
                           icon = icon("gear"), width = "300px"
                         )%>% tagAppendAttributes(class = "dropup"),
                         downloadButton(outputId = "downloadData", label = lang[["download_data"]] ),
                         downloadButton(outputId = "downloadPlot", label = lang[["download_figure"]] ),
                         actionButton("screenshot", lang[["make_screenshot"]] , icon = icon("camera"), 
                                      icon.library = "font awesome"),
                         prettySwitch(inputId = "change_barplot", label = HTML(lang[["alternative_box_plot_label"]]),
                                      status = "info", inline = TRUE, fill = T, bigger = T),
                         shinycssloaders::withSpinner(plotlyOutput("main_figure", height = "450"), 
                                                      type = 1, color = "#18BC9C", size = 1.5)),
              ),
              column(width = 3,
                     box(height = NULL,
                         title = lang[["blue_group"]], width = NULL, status = "info", solidHeader = TRUE,
                         pickerInput("geografie1", label = lang[["area"]], selected = lang[["the_netherlands"]],
                                     choices = GeoChoices,
                                     options = list(`live-search` = TRUE, style = "", size = 10)),
                         selectizeInput(inputId = "geslacht1", label = lang[["gender"]] ,
                                        choices = lang[["gender_choices"]]),
                         selectizeInput(inputId = "migratie1", label = lang[["migration_background"]],
                                        choices = lang[["migration_choices"]]),
                         selectizeInput(inputId = "huishouden1", label = lang[["parent_amount_label"]],
                                        choices = lang[["household_choices"]]),
                         prettySwitch(inputId = "OnePlot", label = HTML(lang[["one_group_label"]]),
                                      status = "info", inline = TRUE, fill = T, bigger = T)
                     ),
                     box(height = NULL, id="box_groene_group",
                         title = lang[["green_group"]], width = NULL, status = "success", solidHeader = TRUE, collapsible = TRUE,
                         pickerInput("geografie2", label = lang[["area"]], selected = "Purmerend",
                                     choices = GeoChoices,
                                     options = list(`live-search` = TRUE, style = "", size = 10)),
                         selectizeInput(inputId = "geslacht2", label = lang[["gender"]],
                                        choices = lang[["gender_choices"]]),
                         selectizeInput(inputId = "migratie2", label = lang[["migration_background"]],
                                        choices = lang[["migration_choices"]]),
                         selectizeInput(inputId = "huishouden2", label = lang[["parent_amount_label"]],
                                        choices = lang[["household_choices"]]),
                     ),
              )
            )
    ),
    
    # tab content
    tabItem(tabName = "videos",
            box(status = "primary", 
                includeMarkdown(lang[["loc_videos.Rmd"]])
            ), 
            box(status = "primary", 
                HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/9Cpt2bRC5HI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                     <iframe width="560" height="315" src="https://www.youtube.com/embed/T2ue6RRrnfk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'))            
            
    ),

    tabItem(tabName = "faq", status = "primary",
            box(h1(lang[["menu_faq"]]),
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
                    status = "danger", solidHeader = T, collapsed = T, collapsible = T, width = 350,  
                    faq_a4) %>% tagAppendAttributes(class = "faq"),
                box(title = faq_q5, 
                    status = "warning", solidHeader = T, collapsed = T, collapsible = T, width = 350, 
                    faq_a5) %>% tagAppendAttributes(class = "faq"))
    ),
    
    # tab content
    tabItem(tabName = "werkwijze",
            column(width = 6, box(width = 300, status = "primary",
                includeMarkdown(lang[["loc_werkwijze.Rmd"]])
            )),
            column(width = 6, 
                   ),
      tags$script(src="script.js")
    ),
    
    # tab content
    tabItem(tabName = "contact",
            box(status = "primary", 
              includeMarkdown(lang[["loc_contact.Rmd"]])
            )
    )
    
  )
)


#### DEFINE UI ####
ui <- dashboardPage(
  title=lang[["title"]],
  header = dashboardHeader(
    titleWidth = lang[["title_width"]], 
    title = tags$span(lang[["title"]], 
                      style = "font-weight: bold;"
                      
    ),
    tags$li(class = "dropdown", actionLink("beginscherm", "", icon("question"))),
    tags$li(class = "dropdown", actionLink("reset_cookies", "", icon("eraser")))

  ),
  sidebar = sidebar,
  body = body  
  
)