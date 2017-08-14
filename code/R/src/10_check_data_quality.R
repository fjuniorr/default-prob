library(tidyverse); library(data.table)
source("code/R/lib/check_memoria_analytic_data.R")

cfg <- yaml::yaml.load_file("data/fiscal-variables.yaml")

DT <- fread("data/cleaned/fiscal_variables.csv")

tbl <- cfg$tbl_desp_primaria

# ==========================================================
# check outliers
# ==========================================================

DT[, rec_rpps_z := ((rec_rpps - mean(rec_rpps)) / sd(rec_rpps)), by = "state"]
DT[abs(rec_rpps_z) > 2, ]

# ==========================================================
# check memoria de calculo
# ==========================================================

x <- rlist::list.filter(tbl, "primario" %in% expr)[[1]]
check_memoria(memoria = x$memoria, expr = x$expr, .data = DT) %>% 
    write_csv("check_memoria.csv")
