# KCO Dashboard 
#
# - text and options for de UI
#
# (c) Erasmus School of Economics 2022


# third tabblad text causality
causal_text <- 
  "Het dashboard toont de samenhang tussen de omstandigheden waarin kinderen 
  opgroeien en hun uitkomsten over de levensloop. Maar die omstandigheden 
  hangen samen met eindeloos veel factoren die ook van invloed zijn en 
  waarvoor niet te controleren valt. Daarom moeten deze patronen niet worden 
gezien als oorzakelijke verbanden."



# dropdown menu choices
MoneyChoices <- c("Persoonlijk inkomen" = "c30_income",
                 "Werkend" = "c30_employed", 
                 "Uren werk per week" = "c30_hrs_work_pw", 
                 "Flexibel arbeidscontract" = "c30_flex_contract", 
                 "Uurloon"  = "c30_hourly_wage", 
                 "Uitkering arbeidsongeschiktheid/ziekte" = "c30_disability", 
                 "Bijstand" = "c30_social_assistance", 
                 "Vermogen"  = "c30_wealth", 
                 "Schulden" = "c30_debt")


HealthChoices <- c("Laag geboortegewicht" = "c00_sga",
                   "Vroeggeboorte"  = "c00_preterm_birth", 
                   "Zuigelingensterfte" = "c00_infant_mortality",
                   "Jeugdbescherming" = "c11_youth_protection",
                   "Zorgkosten" = "c11_youth_health_costs", 
                   "Zorgkosten" = "c16_youth_health_costs", 
                   "Jeugdbescherming" = "c16_youth_protection",
                   "Zorgkosten" = "c30_total_health_costs", 
                   "Gebruikt ziekenhuiszorg" = "c30_hospital", 
                   "Gebruikt geestelijke gezondheidszorg (specialistisch)" = "c30_specialist_mhc", 
                   "Gebruikt geestelijke gezondheidszorg (basis)" = "c30_basic_mhc", 
                   "Gebruikt medicijnen" = "c30_pharma")

EducationChoices <- c("Eindtoetsadvies vmbo-GL en hoger" = "c11_vmbo_gl_test",        
                      "Eindtoetsadvies havo en hoger" = "c11_havo_test",           
                      "Eindtoetsadvies vwo" = "c11_vwo_test",                    
                      "Eindtoets rekenen streefniveau" = "c11_math",           
                      "Eindtoets lezen streefniveau" = "c11_reading",           
                      "Eindtoets taalverzorging streefniveau" = "c11_language",  
                      "Schooladvies vmbo-GL en hoger" = "c11_vmbo_gl_final",            
                      "Schooladvies havo en hoger" = "c11_havo_final",           
                      "Schooladvies vwo" = "c11_vwo_final" ,                      
                      "Schooladvies hoger dan eindtoetsadvies" = "c11_over_advice", 
                      "Schooladvies lager dan eindtoetsadvies" = "c11_under_advice", 
                      "Volgt vmbo-GL of hoger" = "c16_vmbo_gl",                  
                      "Volgt havo of hoger" = "c16_havo",                     
                      "Volgt vwo" = "c16_vwo",                               
                      "Startkwalificatie behaald" = "c21_high_school_attained",             
                      "Volgend/gevolgd hbo of hoger" = "c21_hbo_followed",         
                      "Volgend/gevolgd universiteit" = "c21_uni_followed",         
                      "Diploma hbo of hoger" = "c30_hbo_attained",                  
                      "Diploma universiteit" = "c30_wo_attained")

HouseChoices <- c("Woonoppervlak per lid huishouden" = "c11_living_space_pp", 
                 "Woonoppervlak per lid huishouden" = "c16_living_space_pp", 
                 "Huiseigenaar" = "c30_home_owner")

#### DEMOGRAFIC GROUPS ####

GeoChoices <- list("Nederland", "Metropool Amsterdam",
                   `Gemeenten in Metropool Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Gemeente")),
                   `Stadsdelen in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Stadsdeel")),
                   `Gebieden in Amsterdam` = sort(subset(area_dat$geografie, area_dat$type == "Wijk")))

GenderChoices <- c("Totaal", "Mannen", "Vrouwen")

MigrationChoices <- c("Totaal", "Zonder migratieachtergrond", "Turkije", "Marokko",
                      "Suriname", "Nederlandse Antillen")

HouseholdChoices <- c("Totaal", "Eenoudergezin", "Tweeoudergezin")


#### HOVER TEXT ####
line_hovertext <- "De optie <i>Lijn</i> toont een fitted line door de bollen en is alleen beschikbaar voor de optie <i>Inkomen ouders</i>.<br><br>De optie <i>Gemiddelde</i> toont het totaalgemiddelde van de groep."

# line_hovertext <- "De optie <i>Lijn</i> toont een fitted line door de bollen en is alleen beschikbaar voor de optie <i>Inkomen ouders</i>.<br><br>De optie <i>Gemiddelde</i> toont het totaalgemiddelde van de groep.<br><br>De optie <i>Mediaan, 25e kwantiel en 75e kwantiel</i> zijn alleen beschikbaar voor continue uitkomstmaten. De opties <i>Median</i> toont de mediaan van de groep. De opties <i>25e kwantiel</i> toont het 25ste kwanteiel van de groep. De opties <i>75e kwantiel</i> toont het 75ste kwanteiel van de groep."



parents_hovertext <- "<i>Kenmerk van de ouders</i> staat op de horizontale as van de figuur.<br><br>De optie <i>Opleiding ouders</i> is alleen beschikbaar voor de uitkomstmaten van pasgeborenen en leeringen in groep 8."


#### FREQUENTLY ASKED QUESTONS ####

faq_q1 <- HTML(paste(str_wrap("Vraag 1: waarom is dit de eerste veelgestelde vraag? 
Dit is gewoon opvulling om te zien hoe dit eruit zien met een lange vraag", width = 60), sep = "<br/>"))
faq_a1 <- "Antwoord op de vraag! Dit is gewoon opvulling om te zien hoe dit eruit zien met een lang antwoord.
Antwoord op de vraag! Dit is gewoon opvulling om te zien hoe dit eruit zien met een lang antwoord.
Antwoord op de vraag! Dit is gewoon opvulling om te zien hoe dit eruit zien met een lang antwoord.
Antwoord op de vraag! Dit is gewoon opvulling om te zien hoe dit eruit zien met een lang antwoord.
Antwoord op de vraag! Dit is gewoon opvulling om te zien hoe dit eruit zien met een lang antwoord."


faq_q2 <- "Vraag 2: waarom is dit de tweede veelgestelde vraag?"
faq_a2 <- "Antwoord op de vraag!"


faq_q3 <- "Vraag 3: waarom is dit de derde veelgestelde vraag?"
faq_a3 <- "Antwoord op de vraag!"

faq_q4 <- "Vraag 4: waarom is dit de vierde veelgestelde vraag?"
faq_a4 <- "Antwoord op de vraag!"

faq_q5 <- "Vraag 5: waarom is dit de vijfde veelgestelde vraag?"
faq_a5 <- "Antwoord op de vraag!"




