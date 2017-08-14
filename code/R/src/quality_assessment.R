library(tidyverse); library(data.table); library(broom); library(formattable)
source("code/R/lib/parsers.R")
source("code/R/lib/parsers_rcl.R")
# ==========================================================
# testing - single file

x <- "data-raw/rgf/ba_2008_rgf.pdf"
x <- "data-raw/rgf/ba_2016_rgf.xls"

system(paste("open", x))

x %>% get_record()

# ==========================================================
# testing - multiple files

stem  <- "disp_caixa_bruta"
report <- "rgf"

files <- list.files("data-raw/rgf/", full.names = TRUE) %>% 
    stringr::str_subset("_ba_") 

files %>% 
    map(get_record) %>% 
    bind_rows()