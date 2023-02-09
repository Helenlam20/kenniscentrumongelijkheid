set_if_file_exists <- function(default_value, file_loc) {
    if (file.exists(file_loc))
        return(file_loc)
    else
        return(default_value)
}

set_lang_sources <- function(site_lang) {
    source(sprintf("./lang/%s/lang_ui.R", site_lang))
    lang[["loc_contact.Rmd"]] <- set_if_file_exists(lang[["loc_contact.Rmd"]], sprintf("./lang/%s/markdown/contact.Rmd", site_lang))
    lang[["loc_videos.Rmd"]] <- set_if_file_exists(lang[["loc_videos.Rmd"]], sprintf("./lang/%s/markdown/videos.Rmd", site_lang))
    lang[["loc_werkwijze.Rmd"]] <- set_if_file_exists(lang[["loc_werkwijze.Rmd"]], sprintf("./lang/%s/markdown/werkwijze.Rmd", site_lang))
}


# site_lang <- "en"

lang <- hashmap()
# source("./lang/nl/lang_ui.R")
set_lang_sources("nl")

if (exists("site_lang") && site_lang == "en") {
    set_lang_sources(site_lang)
}

