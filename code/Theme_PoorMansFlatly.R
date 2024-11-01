# Logo: Poor Man's Flatly -------------------------------------------------------------------------------
#' @title logo_poor_mans_flatly
#' @description Poor Man's Flatly logo for a shinydashboard application
#'
#' @param boldText String. Bold text for the logo.
#' @param mainText String. Main text for the logo.
#' @param badgeText String. Text for the logo badge.
#'
#' @return Object produced by shinyDashboardLogoDIY
#' @seealso \code{\link{shinyDashboardLogoDIY}}
#' @export
logo_poor_mans_flatly <- function(boldText = "Shiny", mainText = "App", badgeText = "v1.1") {
  logo <- dashboardthemes::shinyDashboardLogoDIY(
    boldText = boldText,
    mainText = mainText,
    textSize = 20,
    badgeText = badgeText,
    badgeTextColor = "white",
    badgeTextSize = 2,
    badgeBackColor = "rgb(44,62,80)",
    badgeBorderRadius = 3
  )
  
  return(logo)
}


# Begin Exclude Linting

# Theme: Poor Man's Flatly ------------------------------------------------------------------------------
#' @title theme_poor_mans_flatly
#' @description Poor Man's Flatly theme for a shinydashboard application
#'
#' @return Object produced by shinyDashboardThemeDIY
#' @seealso \code{\link{shinyDashboardThemeDIY}}
#' @export
theme_poor_mans_flatly <- shinyDashboardThemeDIY(
  
  ### general
  appFontFamily = "Arial"
  ,appFontColor = "#000000"
  ,primaryFontColor = "#ffffff" #font color of uitkomstmaat box header
  ,infoFontColor = "#ffffff"
  ,successFontColor = "#000000"
  ,warningFontColor = "#ffffff"
  ,dangerFontColor = "#ffffff"
  ,bodyBackColor = "#ffffff"
  
  ### header
  ,logoBackColor = "#fff846" #behind "Dashboard Ongelijkheid in Amsterdam"

  ,headerButtonBackColor = "#fff846" #menu button
  ,headerButtonIconColor = "#000000"
  ,headerButtonBackColorHover = "#fffca5"
  ,headerButtonIconColorHover = "#000000"
  
  ,headerBackColor = "#fff846"
  ,headerBoxShadowColor = ""
  ,headerBoxShadowSize = "0px 0px 0px"
  
  ### sidebar
  ,sidebarBackColor = "#fff846" #color of the sidebar block
  ,sidebarPadding = 0
  
  ,sidebarMenuBackColor = "inherit"
  ,sidebarMenuPadding = 0
  ,sidebarMenuBorderRadius = 0
  
  ,sidebarShadowRadius = ""
  ,sidebarShadowColor = "0px 0px 0px"
  
  ,sidebarUserTextColor = "#ffffff"
  
  ,sidebarSearchBackColor = "#ffffff"
  ,sidebarSearchIconColor = "#000000"
  ,sidebarSearchBorderColor = "#ffffff"
  
  ,sidebarTabTextColor = "#000000"  #text color on the sidebar
  ,sidebarTabTextSize = 16
  ,sidebarTabBorderStyle = "none"
  ,sidebarTabBorderColor = "none"
  ,sidebarTabBorderWidth = 0
  
  ,sidebarTabBackColorSelected = "#000000"
  ,sidebarTabTextColorSelected = "#ffffff"
  ,sidebarTabRadiusSelected = "0px"
  
  ,sidebarTabBackColorHover = "#000000" 
  ,sidebarTabTextColorHover = "#ffffff"
  ,sidebarTabBorderStyleHover = "none"
  ,sidebarTabBorderColorHover = "none"
  ,sidebarTabBorderWidthHover = 0
  ,sidebarTabRadiusHover = "0px"
  
  ### boxes
  ,boxBackColor = "#ffffff"
  ,boxBorderRadius = 8
  ,boxShadowSize = "0px 0px 0px"
  ,boxShadowColor = ""
  ,boxTitleSize = 16
  ,boxDefaultColor = "#000000" 
  ,boxPrimaryColor = "#000000" #uitkomstmaat and figure header color
  ,boxInfoColor = "#000000" #black group
  ,boxSuccessColor = "#fff846" #yellow group
  ,boxWarningColor = "#f39c12"
  ,boxDangerColor = "#e74c3c"
  
  ,tabBoxTabColor = "#000000" #algemene uitleg
  ,tabBoxTabTextSize = 16
  ,tabBoxTabTextColor = "#000000"
  ,tabBoxTabTextColorSelected = "#ffffff"
  ,tabBoxBackColor = "#ffffff" #back color of boxes
  ,tabBoxHighlightColor = "#ffffff"
  ,tabBoxBorderRadius = 8
  
  ### inputs 
  #download data, screenshot, etc. options
  ,buttonBackColor = "#ffffff"
  ,buttonTextColor = "#000000"
  ,buttonBorderColor = "#000000"
  ,buttonBorderRadius = 8
  
  ,buttonBackColorHover = "#000000"
  ,buttonTextColorHover = "#ffffff"
  ,buttonBorderColorHover = "#000000"
  
  ,textboxBackColor = "#ffffff"
  ,textboxBorderColor = "#000000"
  ,textboxBorderRadius = 8
  ,textboxBackColorSelect = "#ffffff" #search bar geografie
  ,textboxBorderColorSelect = "#000000"
  
  ### tables
  ,tableBackColor = "#fffffff"
  ,tableBorderColor = "#000000"
  ,tableBorderTopSize = 1
  ,tableBorderRowSize = 1
  
)

# End Exclude Linting
