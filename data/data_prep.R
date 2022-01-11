# prepare data for the dashboard

# clear workspace
rm(list=ls())

#### PACKAGES ####
library(tidyverse)
library(openxlsx)




# DATA PREP FOR FIGURES ----------------------------------------------------------

#### LOAD DATA ####
setwd("~/GitHub/kco_dashboard")
tab <- read_rds("data/data_metropool_amsterdam.rds") %>%
  select(-subgroep)

# create longer dataset
tab <- 
  tab %>% 
  pivot_longer(
    cols = -c(geografie, geslacht, migratieachtergrond, bins),
    names_to = c("param", "uitkomst"),
    names_pattern = "(N|BW|mean|parents_income|sd)\\_(.*)",
    values_to = "value") 

# create wider dataset
tab <- 
  tab %>% 
  pivot_wider(
    names_from = param,
    values_from = value
  ) 


# change name of outcomes
tab <- tab %>%
  mutate(uitkomst = recode(uitkomst, 
                           "low_birthweight" = "Laag geboortegewicht",     
                           "premature_birth" = "Vroeggeboorte",    
                           "perinatal_mortality" = "Sterfte rondom zwangerschap",
                           
                           "wpo_math" = "Eindtoets rekenen streefniveau",      
                           "wpo_language" = "Eindtoets taalverzorging streefniveau",   
                           "wpo_reading" = "Eindtoets lezen streefniveau",      
                           "vmbo_hoog_plus_test" = "Eindtoetsadvies vmbo-GL en hoger",
                           "havo_plus_test" = "Eindtoetsadvies havo en hoger",     
                           "vwo_plus_test" = "Eindtoetsadvies vwo",
                           "vmbo_hoog_plus_final" = "Schooladvies vmbo-GL en hoger",
                           "havo_plus_final" = "Schooladvies havo en hoger",     
                           "vwo_plus_final" = "Schooladvies vwo",
                           "under_advice" = "Schooladvies lager dan eindtoetsadvies",    
                           "over_advice" ="Schooladvies hoger dan eindtoetsadvies",    
                           
                           "vmbo_hoog_plus" = "Volgt vmbo-GL of hoger",  
                           "havo_plus" = "Volgt havo of hoger",            
                           "vwo_plus" = "Volgt vwo",
                           
                           "income" = "Persoonlijk inkomen",               
                           "hbo_attained" = "Diploma hbo of hoger",         
                           "wo_attained" = "Diploma universiteit",          
                           "hourly_income" = "Uurloon",       
                           "hours_per_week" = "Uren werk per week",     
                           "flex_contract" = "Flexibel arbeidscontract",       
                           "employed" = "Werkend",             
                           "social_benefits" = "Bijstand",      
                           "disability" = "Uitkering arbeidsongeschiktheid/ziekte",           
                           "pharma_costs" = "Gebruikt medicijnen",    
                           "basis_ggz_costs" = "Geestelijke gezondheidszorg (basis)",      
                           "specialist_costs" = "Geestelijke gezondheidszorg (specialistisch)",     
                           "hospital_costs" = "Gebruikt ziekenhuiszorg",       
                           "total_health_costs" = "Zorgkosten" ),
        uitkomst = trimws(uitkomst)) 
  

# create data for gradients
gradient_tab <- 
  tab %>%
  filter(bins != "Totaal",
         !is.na(mean)) 

# save tab
write_rds(gradient_tab, "data/gradients_data.rds")
rm(gradient_tab)

# create data for barplot
barplot_tab <- 
  tab %>%
  filter(bins == "Totaal",
         !is.na(mean)) 

# save tab
write_rds(barplot_tab, "data/barplot_data.rds")
rm(barplot_tab)



# DATA PREP FOR WIDGETS ----------------------------------------------------------

uitkomst_tab <- read.xlsx("data/dashboard_overzicht.xlsx", sheet = "uitkomst") %>%
  mutate(uitkomstmaat = trimws(uitkomstmaat),
         sample = trimws(sample),
         definitie = trimws(definitie))

write_rds(uitkomst_tab, "data/uitkomst_data.rds")
rm(uitkomst_tab)


geo_tab <- read.xlsx("data/dashboard_overzicht.xlsx", sheet = "geografie") %>%
  mutate(geografie = trimws(geografie),
         naam = trimws(naam))

write_rds(geo_tab, "data/geo_data.rds")
rm(geo_tab)

