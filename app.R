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
library(shinydashboardPlus)
library(shinyjqui)
library(shinyWidgets)
library(plotly)
library(readxl)


#### LOAD DATA ####
setwd("/Users/helenlam20/GitHub/kco_dashboard/")
outcome_dat <- read_excel("./data/outcome_table.xlsx")

for (i in c("bins_20", "bins_10", "bins_5", "total", "parents_edu")) {
  
  assign(i, read_rds(file.path("./data/", paste0(i, "_tab.rds"))))
  
}
rm(i)

# combins gradient data
gradient_dat <- bind_rows(bins_20, bins_10) 
gradient_dat <- bind_rows(gradient_dat, bins_5)
gradient_dat <- bind_rows(gradient_dat, total)
gradient_dat <- bind_rows(gradient_dat, parents_edu) 
rm(bins_20, bins_10, bins_5, total, parents_edu)



#### RUN APP ####
setwd("./code")
source("Theme_PoorMansFlatly.R")
source("ui.R")
source("server.R")


shinyApp(ui = ui, server = server)
