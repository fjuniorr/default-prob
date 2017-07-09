library(magrittr)
source("code/R/lib/parsers.R"); source("code/R/lib/parsers_primario.R")
# ==========================================================
# scripted data collection
# ==========================================================
DF <- list.files("data-raw/rreo/", full.names = TRUE) %>% 
                 purrr::map(get_record) %>% 
                 dplyr::bind_rows()

# ==========================================================
# manual data collection
# ==========================================================
manual <- readxl::read_excel("data/manual/primario.xlsx")

stopifnot(anyDuplicated(manual$id) == 0)
index <- match(DF$id, manual$id) %>% .[!is.na(.)]
values <- manual[index, "value"] %>% unlist()
rows <- manual[index, "id"] %>% unlist()

DF[match(rows, DF$id), "value"] <- values

# ==========================================================
# save
# ==========================================================
write.csv(DF, "data/munged/primario.csv", row.names = FALSE)
