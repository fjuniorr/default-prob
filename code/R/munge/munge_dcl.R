library(magrittr)
source("code/R/lib/parsers.R"); source("code/R/lib/parsers_dcl.R")
# ==========================================================
# scripted data collection
# ==========================================================
DF <- list.files("data-raw/rreo/", full.names = TRUE) %>% 
                 purrr::map(get_record) %>% 
                 dplyr::bind_rows()

# ==========================================================
# manual data collection
# ==========================================================
DF <- replace_values(DF, "data/manual/dcl.xlsx")

# ==========================================================
# save
# ==========================================================
write.csv(DF, "data/munged/dcl.csv", row.names = FALSE)
