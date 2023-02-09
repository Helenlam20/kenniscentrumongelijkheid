# Dashboard
lang[["title"]] <- "Dashboard Ongelijkheid in Amsterdam" 

# General
lang[["outcome_measure"]] = "Uitkomstmaat"
lang[["parent_income"]] = "Inkomen ouders"
lang[["parent_education"]] = "Opleiding ouders"

lang[["line"]] = "Lijn"
lang[["average"]] = "Gemiddelde"

lang[["blue_group"]] = "Blauwe groep"
lang[["green_group"]] = "Groene groep"


# Side menu
lang[["menu_figure"]] <- "Figuur"
lang[["menu_video"]] <- "Uitlegvideo's"
lang[["menu_methodology"]] <- "Werkwijze"
lang[["menu_faq"]] <- "Veelgestelde vragen"
lang[["menu_contact"]] <- "Contact"

# Disconnect popup
lang[["disconnect_message"]] <- "Je sessie is verlopen, laad de applicatie opnieuw."
lang[["disconnect_refresh"]] <- "Klik hier om te vernieuwen"

# Welcome popup
lang[["welcome_popup_title"]] <- "Welkom op het Dashboard Ongelijkheid in Amsterdam!"
lang[["welcome_popup_text"]] <- "Het dashboard <i>Ongelijkheid in Amsterdam</i> geeft inzicht in de samenhang tussen de omstandigheden
      waarin kinderen opgroeien en hun uitkomsten die later in het leven worden gemeten. Voor het maken van een eigen figuur:
                  <br><br><b>Stap 1:</b> kies een uitkomstmaat.
                  <br><b>Stap 2:</b> kies een kenmerk van ouders.
                  <br><b>Stap 3:</b> kies geografische en demografische kenmerken van kinderen.
                  <br><br>Voor meer informatie over het dashboard, zie <i>Uitlegvideo's</i> en <i>Werkwijze.</i>
                  <br><br>Deze website maakt gebruik van cookies."
lang[["welcome_popup_continue"]] <- "Doorgaan"

# Outcome selection box
lang[["box_outcome"]] <- "Uitkomstmaat"
lang[["box_outcome_select_outcome"]] <- "Selecteer hier een uitkomstmaat"
lang[["box_outcome_select_line_option"]] <- "<b>Selecteer hier een optie:</b>"
lang[["box_outcome_select_line_option_hover"]] <- "Lijn opties"

lang[["box_outcome_select_line_option_hovertext"]] <- "De optie <i>Lijn</i> toont een fitted line door de bollen en is alleen beschikbaar voor de optie <i>Inkomen ouders</i>.<br><br>De optie <i>Gemiddelde</i> toont het totaalgemiddelde van de groep."


lang[["box_outcome_select_parent_option"]] <- "<b>Selecteer hier een kenmerk van ouders:</b>"
lang[["box_outcome_select_parent_option_hover"]] <- "Kenmerk van ouders optie"
lang[["box_outcome_select_parent_option_hovertext"]] <- "<i>Kenmerk van de ouders</i> staat op de horizontale as van de figuur.<br><br>De optie <i>Opleiding ouders</i> is alleen beschikbaar voor de uitkomstmaten van pasgeborenen en leeringen in groep 8."

# Explaination text box
lang[["box_text_general"]] = "Algemene uitleg"
lang[["box_text_what_do_i_see"]] = "Wat zie ik?"
lang[["box_text_causality"]] = "Causaliteit"

lang[["box_text_causality_text"]] = "Het dashboard toont de samenhang tussen de omstandigheden waarin kinderen
opgroeien en hun uitkomsten over de levensloop. Maar die omstandigheden 
hangen samen met eindeloos veel factoren die ook van invloed zijn en
waarvoor niet te controleren valt. Daarom moeten deze patronen niet worden 
gezien als bewijs voor oorzakelijke verbanden."

lang[["box_text_switch_label"]] = "Toon uitleg van:"

# Graph options
lang[["download_data"]] = "Download data"
lang[["download_figure"]] = "Download figuur"

lang[["make_screenshot"]] = "Maak een screenshot"

lang[["alternative_box_plot_label"]] = "<b> Toon alternatief staafdiagram</b>"

# Graph adjustments
lang[["y_axis_label"]] = "Verticale as (Y-as):"
lang[["x_axis_label"]] = "Horizontale as (X-as):"
lang[["reset"]] = "Reset"

# Blue/green group adjustments
lang[["the_netherlands"]] = "Nederland"

lang[["area"]] = "Gebied"
lang[["gender"]] = "Geslacht"
lang[["migration_background"]] = "Migratieachtergrond"

lang[["parent_amount_label"]] = "Aantal ouders in gezin"
lang[["one_group_label"]] = "<b> Toon één groep</b>"

# Choices
lang[["money_choices"]] <- c("Persoonlijk inkomen" = "c30_income",
                 "Werkt" = "c30_employed", 
                 "Gewerkte uren per week (werkenden)" = "c30_hrs_work_pw", 
                 "Vast arbeidscontract" = "c30_permanent_contract", 
                 "Uurloon"  = "c30_hourly_wage", 
                 "Ziekte- of arbeidsongeschiktheidsuitkering" = "c30_disability", 
                 "Bijstand" = "c30_social_assistance", 
                 "Vermogen"  = "c30_wealth", 
                 "Schulden" = "c30_debt")

lang[["health_choices"]] <- c("Laag geboortegewicht" = "c00_sga",
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

lang[["education_choices"]] <- c("Eindtoetsadvies vmbo-GL of hoger" = "c11_vmbo_gl_test",        
                      "Eindtoetsadvies havo of hoger" = "c11_havo_test",           
                      "Eindtoetsadvies vwo" = "c11_vwo_test",                    
                      "Eindtoets rekenen streefniveau" = "c11_math",           
                      "Eindtoets lezen streefniveau" = "c11_reading",           
                      "Eindtoets taalverzorging streefniveau" = "c11_language",  
                      "Schooladvies vmbo-GL of hoger" = "c11_vmbo_gl_final",            
                      "Schooladvies havo of hoger" = "c11_havo_final",           
                      "Schooladvies vwo" = "c11_vwo_final" ,                      
                      "Schooladvies hoger dan eindtoetsadvies" = "c11_over_advice", 
                      "Schooladvies lager dan eindtoetsadvies" = "c11_under_advice", 
                      "Vmbo-GL of hoger" = "c16_vmbo_gl",                  
                      "Havo of hoger" = "c16_havo",                     
                      "Vwo" = "c16_vwo",                               
                      "Startkwalificatie behaald" = "c21_high_school_attained",             
                      "Hbo of hoger" = "c21_hbo_followed",         
                      "Universiteit" = "c21_uni_followed",         
                      "Diploma hbo of hoger" = "c30_hbo_attained",                  
                      "Diploma universiteit" = "c30_wo_attained")

lang[["house_choices"]] <- c("Woonoppervlak per lid huishouden" = "c11_living_space_pp", 
                 "Woonoppervlak per lid huishouden" = "c16_living_space_pp", 
                 "Eigen woning" = "c30_home_owner")

lang[["gender_choices"]] <- c("Totaal", "Mannen", "Vrouwen")

lang[["migration_choices"]] <- c("Totaal", "Zonder migratieachtergrond", "Turkije", "Marokko",
                      "Suriname", "Nederlandse Antillen")

lang[["household_choices"]] <- c("Totaal", "Eenoudergezin", "Tweeoudergezin")
