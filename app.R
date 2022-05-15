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
library(shinydashboard)
library(dashboardthemes)
library(shinyWidgets)
library(plotly)
library(readxl)
library(shinyBS)
library(grid)
library(markdown)



#### RUN APP ####
source("./startup.R")
source("./code/Theme_PoorMansFlatly.R")
source("./code/ui.R")
source("./code/server.R")


shinyApp(ui = ui, server = server)

