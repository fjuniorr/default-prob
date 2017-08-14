library(tidyverse); library(data.table)

DT_full <- fread("data/state_year_full.csv")
DT_calamity <- fread("data/cleaned/calamity.csv")
DT_fiscal_indicators <- fread("data/cleaned/fiscal_indicators.csv")

DT <- DT_full %>% 
        .[DT_calamity, on = "id"] %>% 
        .[DT_fiscal_indicators, on = "id"]
        

DT[, default := capag_il > 1.5]

DT[, yh1 := ifelse(default == TRUE, TRUE, FALSE), by = state]
DT[, yh2 := ifelse(default == TRUE, TRUE,
                   ifelse(shift(default, type = "lead", n = 1) == TRUE, TRUE, FALSE)), by = state]

DT[, yh3 := ifelse(default == TRUE, TRUE,
                   ifelse(shift(default, type = "lead", n = 1) == TRUE, TRUE, 
                          ifelse(shift(default, type = "lead", n = 2) == TRUE, TRUE, FALSE))), by = state]

DT[, c("id", "default", "yh1", "yh2", "yh3")] %>% 
    write_csv("data/cleaned/dependent_variables.csv")
