library(data.table); library(magrittr)

DT_full <- fread("data/state_year_full.csv")
DT_state <- fread("data/cleaned/state_level_vars.csv")
DT_calamity <- fread("data/cleaned/calamity.csv")
DT_fiscal_variables <- fread("data/cleaned/fiscal_variables.csv")
DT_fiscal_indicators <- fread("data/cleaned/fiscal_indicators.csv")
DT_fiscal_indicators <- DT_fiscal_indicators[, c("id", "stn_end", "stn_sdrcl", "stn_rpsd", "stn_dprcl", "stn_cgpp", 
                                                 "stn_pidt", "stn_pcrdp", "stn_rtdc", "capag_idc", "capag_pc", 
                                                 "capag_il"), with = FALSE]

fiscal_data <- DT_full %>% 
            .[DT_state, on = "state"] %>% 
            .[DT_calamity, on = "id"] %>% 
            .[DT_fiscal_variables, on = "id"] %>%
            .[DT_fiscal_indicators, on = "id"] %>% 
            as.data.frame()
    

save(fiscal_data, file = "data/fiscal_data.rda")
write.csv(fiscal_data, file = "data/fiscal_data.csv", row.names = FALSE)
