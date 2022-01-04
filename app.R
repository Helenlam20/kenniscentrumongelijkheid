# KCO Dashboard 
#
# - Start of the app that loads UI and server
# - Load packages and data 
# - shinyApp: the shinyApp function creates Shiny app objects from an explicit UI/server pair.
#
# (c) Erasmus School of Economics 2022


# clear workspace
rm(list=ls())

#### PACKAGES ####
library(shiny)
library(tidyverse)
library(plotly)
library(shinydashboard)
library(dashboardthemes)
library(plotly)


#### LOAD DATA ####
setwd("/Users/helenlam20/GitHub/kco_dashboard/")
gradient_dat <- read_rds("./data/gradients_data.rds") %>%
  filter(migratieachtergrond == "Totaal")
barplot_dat <- read_rds("./data/barplot_data.rds") 
uitkomst_dat <- read_rds("./data/uitkomst_data.rds")
geo_dat <- read_rds("./data/geo_data.rds")


#### RUN APP ####
setwd("./code")
source("ModuleChangeThemes.R")
source("ui.R")
source("server.R")


shinyApp(ui = ui, server = server)


# gradient met trema puntjes op de e
# hover tip aanpassen
# fitted line toevoegen
# twee deomografie duidelijk malen welke het is.
  # - kenmerken groep 1/ groep 2
# download as pdf button


