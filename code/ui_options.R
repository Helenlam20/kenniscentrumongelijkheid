# KCO Dashboard 
#
# - text and options for de UI
#
# (c) Erasmus School of Economics 2022


# third tabblad text causality
# causal_text <- "Het dashboard toont de samenhang tussen de omstandigheden waarin kinderen
# opgroeien en hun uitkomsten over de levensloop. Maar die omstandigheden 
# hangen samen met eindeloos veel factoren die ook van invloed zijn en
# waarvoor niet te controleren valt. Daarom moeten deze patronen niet worden 
# gezien als bewijs voor oorzakelijke verbanden."



# # dropdown menu choices
# MoneyChoices <- c("Persoonlijk inkomen" = "c30_income",
#                  "Werkt" = "c30_employed", 
#                  "Gewerkte uren per week (werkenden)" = "c30_hrs_work_pw", 
#                  "Vast arbeidscontract" = "c30_permanent_contract", 
#                  "Uurloon"  = "c30_hourly_wage", 
#                  "Ziekte- of arbeidsongeschiktheidsuitkering" = "c30_disability", 
#                  "Bijstand" = "c30_social_assistance", 
#                  "Vermogen"  = "c30_wealth", 
#                  "Schulden" = "c30_debt")


# HealthChoices <- c("Laag geboortegewicht" = "c00_sga",
#                    "Vroeggeboorte"  = "c00_preterm_birth", 
#                    "Zuigelingensterfte" = "c00_infant_mortality",
#                    "Jeugdbescherming" = "c11_youth_protection",
#                    "Zorgkosten" = "c11_youth_health_costs", 
#                    "Zorgkosten" = "c16_youth_health_costs", 
#                    "Jeugdbescherming" = "c16_youth_protection",
#                    "Zorgkosten" = "c30_total_health_costs", 
#                    "Gebruikt ziekenhuiszorg" = "c30_hospital", 
#                    "Gebruikt geestelijke gezondheidszorg (specialistisch)" = "c30_specialist_mhc", 
#                    "Gebruikt geestelijke gezondheidszorg (basis)" = "c30_basic_mhc", 
#                    "Gebruikt medicijnen" = "c30_pharma")

# EducationChoices <- c("Eindtoetsadvies vmbo-GL of hoger" = "c11_vmbo_gl_test",        
#                       "Eindtoetsadvies havo of hoger" = "c11_havo_test",           
#                       "Eindtoetsadvies vwo" = "c11_vwo_test",                    
#                       "Eindtoets rekenen streefniveau" = "c11_math",           
#                       "Eindtoets lezen streefniveau" = "c11_reading",           
#                       "Eindtoets taalverzorging streefniveau" = "c11_language",  
#                       "Schooladvies vmbo-GL of hoger" = "c11_vmbo_gl_final",            
#                       "Schooladvies havo of hoger" = "c11_havo_final",           
#                       "Schooladvies vwo" = "c11_vwo_final" ,                      
#                       "Schooladvies hoger dan eindtoetsadvies" = "c11_over_advice", 
#                       "Schooladvies lager dan eindtoetsadvies" = "c11_under_advice", 
#                       "Vmbo-GL of hoger" = "c16_vmbo_gl",                  
#                       "Havo of hoger" = "c16_havo",                     
#                       "Vwo" = "c16_vwo",                               
#                       "Startkwalificatie behaald" = "c21_high_school_attained",             
#                       "Hbo of hoger" = "c21_hbo_followed",         
#                       "Universiteit" = "c21_uni_followed",         
#                       "Diploma hbo of hoger" = "c30_hbo_attained",                  
#                       "Diploma universiteit" = "c30_wo_attained")

# HouseChoices <- c("Woonoppervlak per lid huishouden" = "c11_living_space_pp", 
#                  "Woonoppervlak per lid huishouden" = "c16_living_space_pp", 
#                  "Eigen woning" = "c30_home_owner")

#### DEMOGRAFIC GROUPS ####

GeoChoices <- list("Nederland", "Metropool Amsterdam",
                   `Gemeenten in Metropool Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
                   `Stadsdelen in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Stadsdeel")),
                   `Gebieden in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Wijk")))

# GenderChoices <- c("Totaal", "Mannen", "Vrouwen")

# MigrationChoices <- c("Totaal", "Zonder migratieachtergrond", "Turkije", "Marokko",
#                       "Suriname", "Nederlandse Antillen")

# HouseholdChoices <- c("Totaal", "Eenoudergezin", "Tweeoudergezin")


#### HOVER TEXT ####
# line_hovertext <- "De optie <i>Lijn</i> toont een fitted line door de bollen en is alleen beschikbaar voor de optie <i>Inkomen ouders</i>.<br><br>De optie <i>Gemiddelde</i> toont het totaalgemiddelde van de groep."

# parents_hovertext <- "<i>Kenmerk van de ouders</i> staat op de horizontale as van de figuur.<br><br>De optie <i>Opleiding ouders</i> is alleen beschikbaar voor de uitkomstmaten van pasgeborenen en leeringen in groep 8."


#### FREQUENTLY ASKED QUESTONS ####

faq_q1 <- HTML(paste(str_wrap("Vraag 1: hoe wordt Opleiding Ouders gedefinieerd, 
waarom is het alleen beschikbaar voor een paar uitkomstmaten en waarom zijn er maar drie categorieën?", width = 60), sep = "<br/>"))
faq_a1 <- HTML(paste0("<p>Opleiding ouders wordt gedefinieerd als de hoogst 
                              behaalde opleiding van één van de ouders. Voor opleiding 
                              ouders hebben we drie categorieën: geen wo en hbo, hbo en wo.</p>
                              
                              <p>We kunnen alleen de opleidingen van de ouders bepalen voor de 
                              jongere geboortecohorten (groep 8 en pasgeborenen), omdat de 
                              gegevens over de opleidingen van ouders pas beschikbaar zijn 
                              vanaf 1983 voor wo, 1986 voor hbo en 2004 voor mbo. 
                             Het opleidingsniveau 'geen hbo of wo' kan hierdoor niet verder 
                             gedifferentieerd worden.</p>"))

faq_q2 <- "Vraag 2: waarom is dit de tweede veelgestelde vraag?"
faq_a2 <- "Antwoord op de vraag!"


faq_q3 <- "Vraag 3: waarom is dit de derde veelgestelde vraag?"
faq_a3 <- "Antwoord op de vraag!"

faq_q4 <- "Vraag 4: waarom is dit de vierde veelgestelde vraag?"
faq_a4 <- "Antwoord op de vraag!"

faq_q5 <- "Vraag 5: waarom is dit de vijfde veelgestelde vraag?"
faq_a5 <- "Antwoord op de vraag!"




