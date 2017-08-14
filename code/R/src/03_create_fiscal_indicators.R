library(tidyverse); library(data.table)

DT_full <- fread("data/state_year_full.csv")
DT_fiscal_variables <- fread("data/cleaned/fiscal_variables.csv")
DT_sgdp <- fread("data/cleaned/sgdp.csv")

DT <- DT_full %>% 
    .[DT_fiscal_variables, on = "id"] %>% 
    .[DT_sgdp, on = "id"]

cfg <- yaml::yaml.load_file("data/fiscal-indicators.yaml")

# create fiscal indicators defined in yaml
for(j in names(cfg)) {
    set(DT, j = j, value = DT[, eval(parse(text = cfg[[j]]$memoria))])
    
    z <- paste0(j, "_z")
    set(DT, j = z, value = (DT[[j]] - mean(DT[[j]])) / (sd(DT[[j]])))
    
    zz <- paste0(j, "_zz")
    set(DT, j = zz, value = (DT[[j]] - mean(DT[[j]])) / (2*sd(DT[[j]])))
}

# lag all fiscal indicators
vars <- c(names(cfg), paste0(names(cfg), "_z"), paste0(names(cfg), "_zz"))
laged <- paste0(vars, "_lag")
DT[, (laged) := shift(.SD), by="state", .SDcols = vars]


DT[, c("id", vars, laged), with = FALSE] %>% 
    write_csv("data/cleaned/fiscal_indicators.csv")
