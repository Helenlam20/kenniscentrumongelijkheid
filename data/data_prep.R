# clear workspace
rm(list=ls())

#### PACKAGES ####
library(shiny)
library(tidyverse)
library(plotly)
library(shinydashboard)
library(dashboardthemes)


#### LOAD DATA ####

setwd("~/GitHub/kco_dashboard")
tab <- read_rds("data/data_metropool_amsterdam.rds")

# rm empty rows
test <- subset(tab, length(tab) == length(tab) - 5)


