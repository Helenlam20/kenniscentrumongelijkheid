# Dashboard
lang[["title"]] <- "The Opportunity Gap in the Netherlands"
lang[["title_width"]] <- 400

# General
lang[["outcome_measure"]] <- "Outcome"
lang[["parent_income"]] <- "Parental Income"
lang[["parent_education"]] <- "Parental Education"

lang[["line"]] <- "Line"
lang[["average"]] <- "Average"

lang[["blue_group"]] <- "Blue group"
lang[["green_group"]] <- "Green group"

lang[["blue_adjective"]] <- "blue"
lang[["green_adjective"]] <- "green"

lang[["yes"]] <- "Yes"
lang[["no"]] <- "No"

lang[["statistic_average"]] <- "average"
lang[["statistic_percentage"]] <- "percentage"

lang[["download_readme_title"]] <- "TECHNICAL SUMMARY OF THE OPPORTUNITY GAP DASHBOARD"

# Side menu
lang[["menu_figure"]] <- "Figure"
lang[["menu_video"]] <- "Explanatory Videos"
lang[["menu_method"]] <- "Method"
lang[["menu_faq"]] <- "Frequently asked questions"
lang[["menu_contact"]] <- "About"

# Disconnect popup
lang[["disconnect_message"]] <- "Your session has expired, please reload the application."
lang[["disconnect_refresh"]] <- "Click here to renew"

# Welcome popup
lang[["welcome_popup_title"]] <- "Welcome to the website The Opportunity Gap in the Netherlands"
lang[["welcome_popup_text"]] <- "The website The Opportunity Gap in the Netherlands provides insight into the circumstances in which children grow up, and their outcomes which are measured from birth through adulthood. To create a figure yourself:
                  <br><br><b>Step 1:</b> select an outcome.
                  <br><b>Step 2:</b> select a parental characteristic.
                  <br><b>Step 3:</b> select geographic and demographic characteristics of children.
                  <br><br>To learn more about how this website works, see <i>Explanatory Videos</i> and <i>Method.</i>
                  <br><br>This website uses cookies."
lang[["welcome_popup_continue"]] <- "Continue"

# Cookie popup
lang[["cookie_popup_title"]] <- "Delete cookies"
lang[["cookie_popup_text"]] <- "Do you want to delete all cookies from this website?"

# Outcome selection box
lang[["box_outcome"]] <- "Outcome"
lang[["box_outcome_select_outcome"]] <- "Select an outcome:"
lang[["box_outcome_select_line_option"]] <- "<b>Select an option:</b>"

lang[["box_outcome_select_line_option_hovertext"]] <- "The option <i>Line</i> adds a fitted line through the dots if <i>parental income</i> has been selected.<br><br>The option <i>average</i> shows the average of the group."

lang[["box_outcome_select_parent_option"]] <- "<b>Select a parental characteristic:</b>"
lang[["box_outcome_select_parent_option_hovertext"]] <- "The selected <i>parental characteristic</i> is shown on the horizontal axis of the figure.<br><br>The option <i>parental education</i> is exclusively available for outcomes of newborns and pupils in the final grade of primary school."

# Explaination text box
lang[["box_text_general"]] <- "General explanation"
lang[["box_text_what_do_i_see"]] <- "Interpretation"
lang[["box_text_causality"]] <- "Causality"
lang[["box_text_licence"]] <- "License"

lang[["box_text_causality_text"]] <- "This website shows the association between the circumstances in which children
grow up and their outcomes over the life course. However, these circumstances
are associated with endlessly many factors which also have an effect on outcomes and
for which we cannot control. Therefore, these patterns should not be
interpreted as evidence for causal effects."

lang[["box_text_switch_label"]] <- "Show explanation of:"


# Graph 
lang[["plot_no_data"]] <- "Insufficient data"
lang[["plot_graph_x_label"]] <- "Annual parental income (times € 1.000)"
lang[["plot_bar_x_label"]] <- "Highest level of education attained by parents"
lang[["plot_bubble_x_label"]] <- lang[["plot_bar_x_label"]]

# Graph hover label
lang[["plot_hover_outcome"]] <- "Outcome: "
lang[["plot_hover_parent_income"]] <- "Mean parental income: € "
lang[["plot_hover_number_of_people"]] <- "Number of people: "


# Graph options
lang[["download_data"]] <- "Download data"
lang[["download_figure"]] <- "Download figure"

lang[["make_screenshot"]] <- "Make a screenshot"

lang[["alternative_box_plot_label"]] <- "<b> Show alternative for bar chart</b>"

# Graph adjustments
lang[["y_axis_label"]] <- "Vertical axis (Y-axis):"
lang[["x_axis_label"]] <- "Horizontal axis (X-axis):"
lang[["reset"]] <- "Reset"

# Blue/green group adjustments
lang[["the_netherlands"]] <- "The Netherlands"

lang[["area"]] <- "Geography"
lang[["gender"]] <- "Sex"
lang[["migration_background"]] <- "Migration background"

lang[["parent_amount_label"]] <- "Number of parents in household"
lang[["one_group_label"]] <- "<b> Show single group</b>"

# Choices
lang[["health_catogory_label"]] <- "Health and Wellbeing" 
lang[["education_catogory_label"]] <- "Education" 
lang[["money_catogory_label"]] <- "Work and Income" 
lang[["house_catogory_label"]] <- "Housing" 

lang[["geography_label_the_netherlands"]] <- "The Netherlands"
lang[["geography_label_metropolis_amsterdam"]] <- "Amsterdam Metropolitan Area"
lang[["geography_label_municipalities_amsterdam"]] <- "Municipalities"
lang[["geography_label_districts_amsterdam"]] <- "Amsterdam Districts"
lang[["geography_label_areas_amsterdam"]] <- "Amsterdam neighborhoods"

# Voor lang[["money_choices"]], lang[["health_choices"]], lang[["education_choices"]], en lang[["house_choices"]]  niet de tekst achter de "=" vertalen. Dus c30_income moet niet!
lang[["money_choices"]] <- c("Personal Income" = "c30_income",
                             "Household income" = "c30_household_income",
                             "Working" = "c30_employed", 
                             "Weekly Working Hours" = "c30_hrs_work_pw", 
                             "Has Indefinite-Term Employment Contract" = "c30_permanent_contract", 
                             "Hourly Wage"  = "c30_hourly_wage", 
                             "Hourly wage less than 11" = "c30_hourly_wage_max_11",
                             "Hourly wage less than 14" = "c30_hourly_wage_max_14",
                             "Receives Disability or Sickness Insurance Benefits" = "c30_disability", 
                             "Receives Basic Social Benefits" = "c30_social_assistance",
                             "Household Wealth"  = "c30_wealth", 
                             "Wealth excluding home and mortgage debt" = "c30_wealth_no_home",
                             "Home value" = "c30_home_wealth",
                             "Household Debt" = "c30_debt",
                             "Gift from parents" = "c30_gifts_received",
                             "Value gift by parents" = "c30_sum_gifts"
)
                 

lang[["health_choices"]] <- c("Small for Gestational Age" = "c00_sga",
                   "Preterm Birth"  = "c00_preterm_birth", 
                   "Infant Mortality " = "c00_infant_mortality",
                   "Child Protective Services" = "c11_youth_protection",
                   "Health Care Costs" = "c11_youth_health_costs",
                   "Child Protective Services" = "c16_youth_protection",
                   "Health Care Costs" = "c16_youth_health_costs", 
                   "Young Parenthood" = "c21_young_parents",
                   "Health Care Costs" = "c30_total_health_costs", 
                   "Uses Hospital Care" = "c30_hospital", 
                   "Uses Mental Health Care (Specialist)" = "c30_specialist_mhc", 
                   "Uses Mental Health Care (Basic)" = "c30_basic_mhc", 
                   "Uses Medication" = "c30_pharma")

lang[["education_choices"]] <- c("Test Score at Least Moderate" = "c11_vmbo_gl_test",        
                      "Test Score at Least High" = "c11_havo_test",           
                      "Test Score Very High " = "c11_vwo_test",                    
                      "Test Score Mathematics Target Level" = "c11_math",           
                      "Test Score Reading Comprehension Target Level" = "c11_reading",           
                      "Test Score Grammar and Writing Target Level" = "c11_language",  
                      "Track Recommendation at Least Moderate Ability " = "c11_vmbo_gl_final",            
                      "Track Recommendation at Least High Ability" = "c11_havo_final",           
                      "Track Recommendation Very High Ability " = "c11_vwo_final" ,                      
                      "Track Recommendation Above Test-Score Track" = "c11_over_advice", 
                      "Track Recommendation Below Test-Score Track" = "c11_under_advice", 
                      "Moderate-Ability Track or Higher" = "c16_vmbo_gl",                  
                      "High-Ability Track or Higher" = "c16_havo",                     
                      "Very High-Ability Track" = "c16_vwo",                               
                      "High School Degree" = "c21_high_school_attained",             
                      "Higher Professional Education or University Enrollment" = "c21_hbo_followed",         
                      "University Enrollment" = "c21_uni_followed",         
                      "Higher Professional Education or University Attainment" = "c30_hbo_attained",                  
                      "University Attainment" = "c30_wo_attained")

lang[["house_choices"]] <- c("Home Size per Household Member" = "c11_living_space_pp", 
                 "Home Size per Household Member" = "c16_living_space_pp", 
                 "Living with parents" = "c21_living_with_parents",
                 "Age left parents" = "c30_age_left_parents",
                 "Home Size per Household Member" = "c30_living_space_pp",
                 "Home Owner" = "c30_homeowner")   # AANGEPAST

lang[["gender_choices"]] <- c("Total", "Men", "Women")

lang[["migration_choices"]] <- c("Total", "No Migration Background", "Turkey", "Morocco",
                      "Suriname", "Dutch Caribbean", 
                      "With Migration Background") # NEW

lang[["household_choices"]] <- c("Total", "Single Parent", "Two Parents")

# !!! This has to be consistent with the migration
lang[["no_migrationbackground"]] <- "No Migration Background"

# !!! This has to be consistent with the .rds data files and gender/migraion/household options
lang[["total"]] <- "Total"

# Label identifiers
# !!! This has to be consistent with the definition column in outcome_table.xlsx
lang[["label_newborn"]] <- "Newborns" 
lang[["label_students_in_grade_8"]] <- "Pupils in the Final Grade of Primary School" 

# !!! This has to be consistent with outcome_table.xlsx
lang[["label_municipality"]] <- "Municipality"
lang[["label_district"]] <- "District"
lang[["label_neighbourhood"]] <- "Neighborhood"



# License
lang[["license_text"]] <- "This figure was created by Helen Lam, Bastian Ravesteijn, and Coen van de Kraats (Erasmus School of Economics), with support from Kenniscentrum Ongelijkheid. The figure and underlying data are available under a Creative Commons BY-NC-SA 4.0 license, conditional upon mentioning the authors and the website opportunitygap.nl. If you have any questions, please contact ravesteijn@ese.eur.nl"

# Version
lang[["version"]] <- "version"