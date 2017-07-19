library(tidyverse); library(data.table); library(broom); library(formattable)
source("code/R/lib/parsers.R")
source("code/R/lib/parsers_primario.R")
# ==========================================================
# testing - single file

x <- "data-raw/rreo/2013_go_rreo.pdf"
x <- "data-raw/rreo/2015_pr_rreo.xls"

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