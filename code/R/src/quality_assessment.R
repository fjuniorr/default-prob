library(tidyverse); library(data.table); library(broom); library(formattable)
source("code/R/lib/parsers.R")
source("code/R/lib/parsers_nominal.R")
# ==========================================================
# testing - single file

x <- "data-raw/rreo/2008_ba_rreo.pdf"

x %>% get_record()

system(paste("open", x))



# ==========================================================
# testing - multiple files

stem  <- "rec_primaria_cor"
report <- "rreo"

files <- list.files("data-raw/rreo/", full.names = TRUE) %>% 
    stringr::str_subset("_ba_") 

files %>% 
    map(get_record) %>% 
    bind_rows()

# ==========================================================
# diagnostic - missing values

DF[!complete.cases(DF), ]

DF[!complete.cases(DF), ] %>% write_csv("problems.csv")