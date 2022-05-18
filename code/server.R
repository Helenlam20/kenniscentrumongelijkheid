# KCO Dashboard 
#
# - server: a server function
# - The server function contains the instructions that your computer needs to build your app.
#
# (c) Erasmus School of Economics 2022



#### STYLING ####
source("./code/server_options.R")



#### DEFINE SERVER ####
server <- function(input, output, session) {
  
  
  vals <- reactiveValues()
  
  # REACTIVE ----------------------------------------------------------
  
  dataInput1 <- reactive({
    data_group1 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                            gradient_dat$geografie == input$geografie1 & 
                            gradient_dat$geslacht == input$geslacht1 &
                            gradient_dat$migratieachtergrond == input$migratie1 & 
                            gradient_dat$huishouden == input$huishouden1)
  })
  
  dataInput2 <- reactive({
    data_group2 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                            gradient_dat$geografie == input$geografie2 & 
                            gradient_dat$geslacht == input$geslacht2 &
                            gradient_dat$migratieachtergrond == input$migratie2 & 
                            gradient_dat$huishouden == input$huishouden2)
    
  })
  
  
  # FILTER DATA ----------------------------------------------------
  filterData <- reactive({
    
    data_group1 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                            gradient_dat$geografie == input$geografie1 & 
                            gradient_dat$geslacht == input$geslacht1 &
                            gradient_dat$migratieachtergrond == input$migratie1 & 
                            gradient_dat$huishouden == input$huishouden1)
    
    data_group2 <- subset(gradient_dat, gradient_dat$uitkomst_NL == input$outcome &
                            gradient_dat$geografie == input$geografie2 & 
                            gradient_dat$geslacht == input$geslacht2 &
                            gradient_dat$migratieachtergrond == input$migratie2 & 
                            gradient_dat$huishouden == input$huishouden2)
    
    # Flag to check whether to use the user input
    # When false to the UI slider is updated to reflect the new data
    input$OnePlot # This is just to update the y-axis when oneplot is enabled
    vals$use_user_input <- FALSE
    
    if (input$parents_options == "Inkomen ouders") {
      bin <- get_bin(data_group1, data_group2)
      data_group1 <- data_group1 %>% filter(type == bin) %>% mutate(group = "Blauwe groep")
      data_group2 <- data_group2 %>% filter(type == bin) %>% mutate(group = "Groene groep")
        dat <- bind_rows(data_group1, data_group2)      
    } else if (input$parents_options == "Opleiding ouders") {
      data_group1 <- data_group1 %>%  filter(type == "parents_edu") %>% mutate(group = "Blauwe groep")
      data_group2 <- data_group2 %>% filter(type == "parents_edu") %>% mutate(group = "Groene groep")
      dat <- bind_rows(data_group1, data_group2)
    }
  })

  
  # DOWNLOAD DATA ----------------------------------------------------
  # filter data for downloading
  DataDownload <- reactive({
    
    dat <- filterData() 
    dat <- dat %>%
      select(-c(group, type, uitkomst)) %>%
      relocate(uitkomst_NL) %>%
      rename(uitkomst = uitkomst_NL)
    
  })


  # DOWNLOAD REACTIVE ----------------------------------------------------
  
  txtFile <- reactive({
    
    text <- c(temp_txt, readme_sep, 
              "ALGEMEEN","", 
              paste(strwrap(HTML_to_plain_text(algemeenText()), width = 75), collapse = "\n"), 
              readme_sep, "WAT ZIE IK?", "", 
              paste(strwrap(HTML_to_plain_text(watzieikText()), width = 75), collapse = "\n"), 
              readme_sep, "CAUSALITEIT", "", causal_text)
    
  })
  
  
  # CHECK FOR DATA ----------------------------------------------------
  # Flags on whether there is any data
  data_group1_has_data = reactive({
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "Blauwe groep")
    data_group1_has_data = ifelse(nrow(data_group1) > 0, TRUE, FALSE)
  })

  data_group2_has_data = reactive({
    if(input$OnePlot) {
      data_group2_has_data = FALSE
    } else {
      dat <- filterData()
      data_group2 <- subset(dat, dat$group == "Groene groep")
      data_group2_has_data = ifelse(nrow(data_group2) > 0, TRUE, FALSE)
    }
  })
  
  
  # ALGEMEEN TEXT REACTIVE ---------------------------------------------
  
  algemeenText <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    statistic_type_text <- get_stat_per_outcome_html(labels_dat)

    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "Blauwe groep")
    N1 <- decimal0(sum(data_group1$N))

    data_group2 <- subset(dat, dat$group == "Groene groep")
    N2 <- decimal0(sum(data_group2$N))

    if(!data_group1_has_data() && !data_group2_has_data()) {
      # No data
      axis_text <- ""
    } else if (input$parents_options == "Inkomen ouders") {
      # get html bin
      perc_html <- get_perc_per_bin_html(data_group1)
      if (!(input$OnePlot)) {perc_html <- get_perc_html(data_group1, data_group2)}
      # if dat has more than 1 bin then add range to text
      if (!("100" %in% dat$type)) {
        range <- paste0(", gerangschikt van laag naar hoog ouderlijk inkomen.")
      } else {range <- "."}
      
      axis_text <- HTML(paste0("Elke stip in het figuur is gebaseerd op ", perc_html, 
                              "% van de ", labels_dat$population, range, 
                              " De verticale as toont het eigen", statistic_type_text, tolower(input$outcome),
                              ". De horizontale as toont het gemiddelde inkomen van hun ouders."))
      
    } else if(input$parents_options == "Opleiding ouders") {
      axis_text <- HTML(paste0("Elke staaf in het figuur toont het ", statistic_type_text, tolower(input$outcome), 
                               " van ", labels_dat$population,
                               ", uitgesplitst naar het hoogst behaalde opleidingsniveau van de ouders."))
    }
    group1_text <- gen_algemeen_group_text(
      group_type_text = add_bold_text_html(text="blauwe groep", color=data_group1_color),
      group_data_size = N1,
      geslacht_input = input$geslacht1,
      migratie_input = input$migratie1,
      huishouden_input = input$huishouden1,
      geografie_input = input$geografie1,
      populatie_input = labels_dat$population
    )
    
    group2_text <- ""
    if (!input$OnePlot) {
      group2_text <- gen_algemeen_group_text(
        group_type_text = add_bold_text_html(text="groene groep", color=data_group2_color),
        group_data_size = N2,
        geslacht_input = input$geslacht2,
        migratie_input = input$migratie2,
        huishouden_input = input$huishouden2,
        geografie_input = input$geografie2,
        populatie_input = labels_dat$population
      )
    }    
    
    # output
    HTML(paste0("<p><b>", input$outcome, "</b> is ", labels_dat$definition, "</p>",
                "<p>", axis_text, "</p>",
                "<p>", group1_text, " ", group2_text, "</p>"))
    
  })
  
  
  # WAT ZIE IK? TEXT REACTIVE ---------------------------------------------
  
  watzieikText <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    stat <- get_stat_per_outcome_html(labels_dat)
    statistic_type_text <- get_stat_per_outcome_html(labels_dat)
    
    # get average of total group
    total_group1 <- dataInput1()  %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
    total_group2 <- dataInput2()  %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
    
    # get prefix and postfix for outcomes
    prefix_text <- get_prefix(input$outcome)
    postfix_text <- get_postfix(input$outcome)
    
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "Blauwe groep")
    data_group2 <- subset(dat, dat$group == "Groene groep")
    num_rows <- max(nrow(data_group1), nrow(data_group2))
    
    
    if (input$parents_options == "Inkomen ouders") {

      
      # get html percentage
      perc_html <- get_perc_per_bin_html(data_group1)
      if (!(input$OnePlot)) {perc_html <- get_perc_html(data_group1, data_group2)}
      
      if (perc_html != "100") {
        blue_text <- ""
        if (data_group1_has_data()) {
          blue_text <- paste("De meest linker ", add_bold_text_html(text="blauwe stip", color=data_group1_color), 
                            " laat zien dat, voor de", paste0(perc_html, "%"), labels_dat$population, 
                            " met ouders met de laagste inkomens in de blauwe groep, het",
                            statistic_type_text, tolower(input$outcome), 
                            paste0(prefix_text, decimal2(data_group1$mean[1]), postfix_text), "was. De meest rechter ", 
                            add_bold_text_html(text="blauwe stip", color=data_group1_color), 
                            " laat zien dat, voor de", paste0(perc_html, "%"), labels_dat$population,
                            " met ouders met de hoogste inkomens in de blauwe groep, het", 
                            statistic_type_text, tolower(input$outcome),
                            paste0(prefix_text, decimal2(data_group1$mean[as.numeric(num_rows)]), postfix_text), "was.")
        }
        green_text <- ""
        if (data_group2_has_data()) {
          green_text <- paste("De meest linker ", add_bold_text_html(text="groene stip", color=data_group2_color), 
                              " laat zien dat, voor de", paste0(perc_html, "%"), 
                              labels_dat$population, " met ouders met de laagste inkomens in de groene groep, het",
                              statistic_type_text, tolower(input$outcome), 
                              paste0(prefix_text, decimal2(data_group2$mean[1]), postfix_text), "was. De meest rechter ", 
                              add_bold_text_html(text="groene stip", color=data_group2_color), 
                              " laat zien dat, voor de", paste0(perc_html, "%"), labels_dat$population, 
                              " met ouders met de hoogste inkomens in de groene groep, het",
                              statistic_type_text, tolower(input$outcome),
                              paste0(prefix_text, decimal2(data_group2$mean[as.numeric(num_rows)]), postfix_text), "was.")
        }
        
      } else if (perc_html == "100") {
        blue_text <- ""
        if (data_group1_has_data()){
          blue_text <- paste("De", add_bold_text_html(text="blauwe stip", color=data_group1_color),
                            "laat zien dat, voor de", paste0(perc_html, "%"), 
                            labels_dat$population, " het", statistic_type_text, tolower(input$outcome),
                            paste0(prefix_text, decimal2(data_group1$mean), postfix_text), "was.")
        }
        green_text <- ""
        if (data_group2_has_data()) {
          green_text <- paste("De", add_bold_text_html(text="groene stip", color=data_group2_color),
                              "laat zien dat, voor de", paste0(perc_html, "%"), 
                              labels_dat$population, "het", statistic_type_text, tolower(input$outcome),
                              paste0(prefix_text, decimal2(data_group2$mean), postfix_text), "was.")
          
        }
        
      }
      mean_text <- ""
      # if user has clicked on the mean button
      if (!is.null(input$line_options)) {
        if ("Gemiddelde" %in% input$line_options) {
          mean_text <- ""
          if (data_group1_has_data()) {
            mean_text <- paste(mean_text, gen_mean_text(
              statistic_type_text, 
              input$outcome, 
              add_bold_text_html(text="blauwe groep", color=data_group1_color),
              total_group1$mean,
              prefix_text,
              postfix_text
            ))
          }

          if (data_group2_has_data()) {
            mean_text <- paste(mean_text, gen_mean_text(
              statistic_type_text, 
              input$outcome, 
              add_bold_text_html(text="groene groep", color=data_group2_color),
              total_group2$mean,
              prefix_text,
              postfix_text
            ))
          }
        }
      }
      
      HTML(paste0("<p>", blue_text, "</p>",
                  "<p>", green_text, "</p>", 
                  "<p>", mean_text, "</p>"))
      
      
    } else if(input$parents_options == "Opleiding ouders") {
      
      if (data_group1_has_data() | data_group2_has_data()) {
        
        bar_text <- HTML(paste0("<p><b>Opleiding Ouders</b> wordt gedefinieerd als de hoogst 
                              behaalde opleiding van één van de ouders. Voor opleiding 
                              ouders hebben we drie categorieën: geen wo en hbo, hbo en wo.</p>
  
                              <p>We kunnen alleen de opleidingen van de ouders bepalen voor de 
                              jongere geboortecohorten (groep 8 en pasgeborenen), omdat de 
                              gegevens over de opleidingen van ouders pas beschikbaar zijn 
                              vanaf 1983 voor wo en vanaf 1986 voor hbo. Gegevens over 
                              middelbaar beroepsonderwijs (mbo) zijn pas beschikbaar vanaf 2004, 
                              waardoor we geen categorie voor mbo konden definiëren.</p>"))
        
      } else {
        
        bar_text <- HTML(paste0("Geen data gevonden voor de staafdiagrammen"))
      }
      
      mean_text <- ""
      # if user has clicked on the mean button
      if (!is.null(input$line_options)) {
        if ("Gemiddelde" %in% input$line_options) {
          mean_text <- ""
          if (data_group1_has_data()) {
            mean_text <- paste(mean_text, gen_mean_text(
              statistic_type_text, 
              input$outcome, 
              add_bold_text_html(text="blauwe groep", color=data_group1_color),
              total_group1$mean,
              prefix_text,
              postfix_text
            ))
          }
          
          if (data_group2_has_data()) {
            mean_text <- paste(mean_text, gen_mean_text(
              statistic_type_text, 
              input$outcome, 
              add_bold_text_html(text="groene groep", color=data_group2_color),
              total_group2$mean,
              prefix_text,
              postfix_text
            ))
          }
        }
      }
      
      HTML(paste0("<p>", bar_text, "</p>",
                  "<p>", mean_text, "</p>"))
      
      
    }
  })
  
  
  # FIGURE PLOT REACTIVE ----------------------------------------------------
  
  makePlot <- reactive({
    
    # select outcome from outcome_dat
    labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
    
    # get prefix and postfix for outcomes
    prefix_text <- get_prefix(input$outcome)
    postfix_text <- get_postfix(input$outcome)
    
    # load data
    dat <- filterData()
    data_group1 <- subset(dat, dat$group == "Blauwe groep")
    if (!(input$OnePlot)) {data_group2 <- subset(dat, dat$group == "Groene groep")}


    # Parse additional input options
    line_option_selected <- FALSE
    mean_option_selected <- FALSE
    if (!is.null(input$line_options)) {
  
      line_option_selected <- "Lijn"  %in% input$line_options
      mean_option_selected <- "Gemiddelde" %in% input$line_options

      # regression line
      # TODO: Add check for data_group2 when data_group1 is empty
      if (nrow(data_group1) == 5) {
        polynom <- 2
      } else {
        polynom <- 3
      }
    }
        

    #### GRADIENT ####
    if (input$parents_options == "Inkomen ouders") {

      # Initialize plot with formatted axis and theme
      plot <- ggplot() +
        scale_x_continuous(labels = function(x) paste0("€ ", x)) +
        theme_minimal() +
        labs(x ="Jaarlijks inkomen ouders (keer € 1.000)", y ="") +
        thema

      # Plot for data_group1 
      if (data_group1_has_data()) {
        # Main plot
        plot <- plot + gen_geom_point(data_group1, input$geografie1, data_group1_color, 
                                      prefix_text, postfix_text, shape=19)
        
        # Highlight points
        if (input$tabset1 == "Wat zie ik?")
          plot <- plot + gen_highlight_points(data_group1, data_group1_color)

        # Plot regression line if it is selected
        if (line_option_selected)
          plot <- plot + gen_regression_line(data_group1, data_group1_color, polynom)

        # Plot mean line if it is selected
        if (mean_option_selected) {
          # get average of the groups
          total_group1 <- dataInput1() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group1, data_group1_color)
        }
      }

      # Plot for data_group2
      if (data_group2_has_data()) {
        # Main plot
        plot <- plot + gen_geom_point(data_group2, input$geografie2, data_group2_color, 
                                      prefix_text, postfix_text, shape=15)
        
        # Highlight points
        if (input$tabset1 == "Wat zie ik?")
          plot <- plot + gen_highlight_points(data_group2, data_group2_color)

        # Plot the additional options
        if (line_option_selected)
          plot <- plot + gen_regression_line(data_group2, data_group2_color, polynom)

        if (mean_option_selected) {
          total_group2 <- dataInput2() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group2, data_group2_color)
        }
      }     
       
      #### BAR PLOT ####
    } else if(input$parents_options == "Opleiding ouders") {
      
      plot <- ggplot()
      if (data_group1_has_data() && data_group2_has_data())
        plot <- gen_bar_plot(dat, prefix_text, postfix_text) + scale_fill_manual("", values=c(data_group1_color, data_group2_color))
      else if (data_group1_has_data())
        plot <- gen_bar_plot(data_group1, prefix_text, postfix_text) + scale_fill_manual("", values=c(data_group1_color))
      else if (data_group2_has_data())
        plot <- gen_bar_plot(data_group2, prefix_text, postfix_text) + scale_fill_manual("", values=c(data_group2_color))

      plot <- plot +
          geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
          labs(x ="Hoogst behaalde opleiding ouders", y ="") +
          theme_minimal() +
          thema
       
      if (mean_option_selected) {
        # get average of the groups
        if (data_group1_has_data()) {
          total_group1 <- dataInput1() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group1, data_group1_color) 
        }
        
        if (data_group2_has_data()) {
          total_group2 <- dataInput2() %>% filter(bins == "Totaal", opleiding_ouders == "Totaal")
          plot <- plot + gen_mean_line(total_group2, data_group2_color) 
          
        }
      }
      
    }

    # Add user inputted ylim
    # TODO: Currenty there is a bug when with the user input that the selected ylim is still visible for a couple of seconds with a new plot
    if (vals$use_user_input == TRUE)
    # if (FALSE) # Temporary debug statement to show the bug from above
      plot <- plot + scale_y_continuous(labels = function(x) paste0(prefix_text, decimal2(x), postfix_text), limits=input$y_axis) 
    else
      plot <- plot + scale_y_continuous(labels = function(x) paste0(prefix_text, decimal2(x), postfix_text)) 


    if (!data_group1_has_data() && !data_group2_has_data()) {
      # Return empty plot when there is no data available
      plot <- ggplot() + annotate(geom="text", x=3, y=3, size = 8,
                                  label="Geen data beschikbaar") + theme_void() +
        theme(
          axis.line=element_blank(),
          panel.grid.major=element_blank()
        )
    }
    vals$plot <- plot
  })
  


  # UI RADIOBUTTON TOOLTIP ---------------------------------------------
  
observeEvent(input$outcome,{
  labels_dat <- subset(outcome_dat, outcome_dat$outcome_name == input$outcome)
  if ("pasgeborenen" %in% labels_dat$population || "leerlingen van groep 8" %in% labels_dat$population) {
    selected_option = input$parents_options
    parent_choices <- c("Inkomen ouders", "Opleiding ouders")
  } else {
    selected_option <- "Inkomen ouders"
    parent_choices <- "Inkomen ouders"
  }
  updatePrettyRadioButtons(
    session = getDefaultReactiveDomain(),
    inputId = "parents_options",
    choices = parent_choices,
    selected = selected_option,
    inline = TRUE,
    prettyOptions = list(
        icon = icon("check"),
        bigger = TRUE,
        status = "info", 
        animation = "smooth"
    ),
  )
})

observeEvent(input$parents_options,{
  if (input$parents_options == "Opleiding ouders") {
    runjs("document.getElementById('change_barplot').style.visibility='visible'")
    runjs("document.getElementsByName('line_options')[0].disabled=true")
    # runjs("document.getElementsByName('line_options')[1].disabled=true")
  } else {
    runjs("document.getElementById('change_barplot').style.visibility='hidden'")
    runjs("document.getElementsByName('line_options')[0].disabled=false")
    # runjs("document.getElementsByName('line_options')[1].disabled=false")
  }
})

update_yaxis_slider <- function(data_min, data_max) {
  # Update the y-axis slider
  vals$ysteps <- get_rounded_slider_steps(data_min = data_min, data_max = data_max)
  vals$yslider_max <- get_rounded_slider_max(data_max = data_max, vals$ysteps)
  vals$yslider_min <- get_rounded_slider_min(data_min = data_min, vals$ysteps)

  # Set UI slider
  updateSliderInput(session, "y_axis", label = "Y-as:", value = c(data_min, data_max),
                    min = vals$yslider_min, max = vals$yslider_max, step = vals$ysteps)
}


observeEvent(vals$plot,{
  if(vals$use_user_input == FALSE) {
    vals$use_user_input <- TRUE
    # Get current ylim 
    # ylim <- layer_scales(vals$plot)$y$range$range # This gives a result closer to without ylim however sometimes it results to values outside the plot
    ylim = ggplot_build(vals$plot)$layout$panel_params[[1]]$y.range
    # Update slider
    update_yaxis_slider(data_min=ylim[1], data_max=ylim[2])
  }

}
)

observeEvent(input$y_axis,{
  if(!is.null(input$y_axis) && 
    !is.null(vals$yslider_min) && 
    !is.null(vals$yslider_max) && 
    !is.null(vals$ysteps) &&
    vals$use_user_input == TRUE) {

    ylim_min <- input$y_axis[1]
    ylim_max <- input$y_axis[2]
    ylim_diff <- abs(ylim_max - ylim_min)

    # Only update the slider when the max/min of the slider is reached or
    # the distance between the selected value and the edge is more than 
    # half of the slider
    if((ylim_min != 0 && 
        (abs(ylim_min - vals$yslider_min) <= vals$ysteps ||
        (abs(ylim_min - vals$yslider_min) >= ylim_diff/2))) || 
       abs(ylim_max - vals$yslider_max) <= vals$ysteps ||
       (abs(ylim_max - vals$yslider_max) >= ylim_diff/2))
      update_yaxis_slider(ylim_min, ylim_max)
  }
})

observeEvent(input$user_reset, {vals$use_user_input=FALSE})


  
  output$radio_button <- renderText({
    
    if(input$outcome %in% subset(outcome_dat$outcome_name,
                                 (outcome_dat$population != "pasgeborenen" &
                                  outcome_dat$population != "leerlingen van groep 8"))) {
      
      HTML("Niet beschikbaar voor deze uitkomstmaat!")
    } else {
      HTML("Beschikbaar voor deze uitkomst!")
    }
  })
  
  
  
  # HTML TEXT ----------------------------------------------------------
  
  #### ALGEMEEN ####
  output$selected_outcome <- renderPrint({
    
    algemeenText()
    
  })
  
  
  #### WAT ZIE JE? ####
  output$sample_uitleg <- renderPrint({
 
    watzieikText()
    
  })
  
  
  
  # GRADIENT ----------------------------------------------------------
  
  
  # title plot widget
  output$title_plot <- renderPrint({
    HTML(input$outcome)
  })
  
  
  # Create plot
  output$main_figure <- renderPlotly({
    
    # withProgress(message = "Even geduld! Bezig met figuren maken", value = 0, {
    #   for (i in 1:5) {
    #     incProgress(1/5)
    #     Sys.sleep(0.1)
    #   }
    # })
    
    # call reactive
    makePlot()
    ggplotly(x = vals$plot, tooltip = c("text"))  %>% 
      config(displayModeBar = F, scrollZoom = F) %>%
      style(hoverlabel = label) %>%
      layout(font = font)  
      
  }) # end plot
  
  
  # DOWNLOAD --------------------------------------------------------

  
  #### DOWNLOAD DATA ####

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("data-", Sys.time(), ".zip")
    },
    content = function(file) {
      
      # set temporary dir
      tmpdir <- tempdir()
      setwd(tmpdir)
      zip_files <- c()
      
      # get files
      csv_name <- paste0("data-", Sys.time(), ".csv")
      write.csv(DataDownload(), csv_name)
      zip_files <- c(zip_files, csv_name)
      
      # write txt file
      fileConn <- file("README.txt")
      writeLines(txtFile(), fileConn)
      close(fileConn)
      zip_files <- c(zip_files, "README.txt")
      
      zip(zipfile = file, files = zip_files)
      
    },
    contentType = "application/zip"
  )
  

  #### DOWNLOAD PLOT ####
  output$downloadPlot <- downloadHandler(
  
    filename = function() {
      paste0("fig-", Sys.time(), ".zip")
    },
    content = function(file) {
      
      caption1 <- paste(strwrap(paste("Blauwe groep:", input$geografie1, "-", 
                                      input$geslacht1, "-", input$migratie1, "-", 
                                      input$huishouden1), width = 70), collapse = "\n")
      caption2 <- ""
      if(!input$OnePlot) {
        caption2 <- paste(strwrap(paste("Groene groep:", input$geografie2, "-", 
                                        input$geslacht2, "-", input$migratie2, "-", 
                                        input$huishouden2), width = 70), collapse = "\n")
      }
      
      
      # set temporary dir
      tmpdir <- tempdir()
      setwd(tmpdir)
      zip_files <- c()
      
      # get plot
      # TODO: add legend
      fig_name <- "fig_with_caption.pdf"
      pdf(fig_name, encoding = "ISOLatin9.enc", 
          width = 9, height = 14)
      print(vals$plot + 
            labs(title = input$outcome, caption = 
                   paste0(caption_sep, "UITLEG DASHBOARD ONGELIJKHEID IN DE STAD\n\n", caption_license, caption_sep, 
                          "ALGEMEEN\n\n", paste(strwrap(HTML_to_plain_text(algemeenText()), width = 85), collapse = "\n"),
                          caption_sep, "WAT ZIE IK?\n\n",
                          paste(strwrap(HTML_to_plain_text(watzieikText()), width = 85), collapse = "\n"), 
                          caption_sep, "CAUSALITEIT\n\n", paste(strwrap(causal_text, width = 85), collapse = "\n"))
                 ) 
            )
      
      dev.off()
      zip_files <- c(zip_files, fig_name)
      
      # figure no caption 
      fig_name <- "fig.pdf"
      pdf(fig_name, encoding = "ISOLatin9.enc", 
          width = 9, height = 6)
      print(vals$plot + labs(title = input$outcome))
      dev.off()
      zip_files <- c(zip_files, fig_name)
      
      # write txt file
      fileConn <- file("README.txt")
      writeLines(txtFile(), fileConn)
      close(fileConn)
      zip_files <- c(zip_files, "README.txt")
      
      zip(zipfile = file, files = zip_files)
      
    },
    contentType = "application/zip"
  )
  
} # end of server