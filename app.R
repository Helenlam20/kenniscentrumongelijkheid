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
gradient_dat <- read_rds("./data/gradients_data.rds") %>%
  filter(migratieachtergrond == "Totaal")
barplot_dat <- read_rds("./data/barplot_data.rds") 
uitkomst_dat <- read_excel("data/dashboard_overzicht.xlsx", sheet = "uitkomst") %>%
  mutate(uitkomstmaat = trimws(uitkomstmaat),
         sample = trimws(sample),
         definitie = trimws(definitie))


#### RUN APP ####
setwd("./code")
source("ModuleChangeThemes.R")
source("ui.R")
source("server.R")


shinyApp(ui = ui, server = server)

# TODO
# tooltip aanpassen
# fitted line toevoegen (met een on/off button)
# gemiddelde lijn button
# download as pdf button/ download button data
# uitleg aanpassen 


# Uitleg van gradient:
#   - wat is een bolletje; wat zie je in de gradient?
#   - Dan pas interpretatie van de gradient
#   - getallen achter de komma weghalen?

# tekst is te veel voor mensen: 
# b1 niveau Nederlands
# mensen die kleurenblind zijn?
# highligten van belangrijke bolletjes
# vergelijking met twee groepen is misschien iets te veel voor de eerste keer.
# Alleen de 1 groep tonen en in de tweede groep alleen een tekstje toevoegen (kies hier een groep)
