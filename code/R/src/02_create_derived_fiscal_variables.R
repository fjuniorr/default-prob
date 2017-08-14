library(tidyverse); library(data.table); library(stringr)

DT_full <- fread("data/state_year_full.csv")
DT_fiscal_variables <- fread("data/cleaned/fiscal_variables.csv")
DT_cpi <- fread("data/cleaned/year_level_vars.csv")
DT_sgdp <- fread("data/cleaned/sgdp.csv")

DT <- DT_full %>% 
        .[DT_sgdp, on = "id"] %>% 
        .[DT_cpi, on = "year"] %>% 
        .[DT_fiscal_variables, on = "id"]
        
# ==========================================================
# evolution: real values (_real); index number (_index); growth rate (_rate); detrended (_det)
# ==========================================================
nominal_vars <- names(DT_fiscal_variables)[-1]
real_vars <- paste0(nominal_vars, "_real")
vars <- c(nominal_vars, real_vars)

index_vars <- paste0(vars, "_index")
rate_vars <- paste0(vars, "_rate")


# DT[, (real_vars) := .SD / ipca_index, by = "state", .SDcols = nominal_vars]
# 

# express all nominal variables in real values
for(j in nominal_vars) {
    set(DT, j = paste0(j, "_real"), value = DT[[j]] / DT[["ipca_index"]])
}
# DT[, (real_vars) := .SD / ipca_index, .SDcols = nominal_vars]

# express all variables as index numbers
for(j in vars) {
    var1 <- paste0(j, "_index")
    base_value <- DT[year == 2008, c("state", j) ,by = c("state"), with = FALSE]
    tmp <- DT_full[base_value, on = "state"]
    set(DT, j = var1, value = DT[[j]] / tmp[[j]])
}

# express all variables as growth rate
DT[, (rate_vars) := .SD / shift(.SD, fill = 1), by = "state", .SDcols = index_vars]
# DT[, lapply(.SD, function(x) x/shift(x)), by = "state", .SDcols = vars]

    
# ==========================================================
# scaled: normalized (_std); % of gdp (_gdp); per capita (_pop)
# ==========================================================

# source("code/R/lib/gmean.R")
# DT[, rec_primaria_cor_growth := gmean(.SD[year != 2008, rec_primaria_cor_rate]), by = "state"]
# 
# foo <- str_subset(names(DT), "rec_primaria_cor")
# 
# DT[state == "mg", c("id", "ipca_index" ,foo), with = FALSE] %>% 
#     write_csv("DT.csv")

DT[, c("id", real_vars, index_vars, rate_vars), with = FALSE] %>% 
    write_csv("data/cleaned/derived_fiscal_variables.csv")
