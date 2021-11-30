# KCO Dashboard 
#
# - Start of the app that loads UI and server
# - Load packages and data 
# - shinyApp: the shinyApp function creates Shiny app objects from an explicit UI/server pair.
#
# (c) Erasmus School of Economics 2022


#### PACKAGES ####
library(shiny)
library(tidyverse)
library(plotly)
library(shinydashboard)
library(dashboardthemes)


#### LOAD DATA ####
tab <- read_rds("data/data_metropool_amsterdam.rds")


#### RUN APP ####
source("code/ui.R")
source("code/server.R")

shinyApp(ui = ui, server = server)


