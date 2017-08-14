library(tidyverse); library(data.table)
# ==========================================================
# basic table
# ==========================================================

DT_full <- fread("data/state_year_full.csv")

l <- list.files("data/cleaned/", full.names = TRUE) %>% 
        map(~fread(.x)) %>% 
        set_names(nm = gsub(".csv$", "",list.files("data/cleaned/")))
l %>% 
    map(~names(.x)[1]) %>% 
    stack()

DT <- DT_full %>% 
        .[l$calamity, on = "id"] %>% 
        .[l$dependent_variables, on = "id"] %>% 
        .[l$fiscal_indicators, on = "id"] %>% 
        .[l$sgdp, on = "id"] %>% 
        .[l$state_level_vars, on = "state"] %>% 
        .[l$year_level_vars, on = "year"]

fwrite(DT, "data/analytic_data.csv")
