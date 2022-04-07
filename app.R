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
library(plotly)
library(readxl)


#### LOAD DATA ####
setwd("/Users/helenlam20/GitHub/kco_dashboard/")
gradient_dat <- read_rds("./data/gradient_dat.rds") 
parents_edu_dat <- read_rds("./data/parents_edu.rds") 
outcome_dat <- read_excel("./data/outcome_table.xlsx")



#### RUN APP ####
setwd("./code")
source("ModuleChangeThemes.R")
source("ui.R")
source("server.R")


shinyApp(ui = ui, server = server)
