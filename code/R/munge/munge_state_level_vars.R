library(tidyverse); library(data.table)

DT <- data.table(readxl::read_excel("data/states.xlsx"))

DT[, state_calamity := state %in% c("rj", "rs", "mg")]

DT %>% 
    select(state, region, state_calamity) %>% 
    write_csv("data/cleaned/state_level_vars.csv")
