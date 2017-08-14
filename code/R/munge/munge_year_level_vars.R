library(tidyverse); library(data.table); library(readxl)

# ==========================================================
# inflation
# ==========================================================

DT <- as.data.table(read_excel("data-raw/inflacao.xlsx"))

DT <- DT[year %in% 2008:2016 & mes == "dez", .(year, ipca, inpc, igp_di)]

DT[, ipca_index := ipca / DT[year == 2008, ipca]]
DT[, ipca_rate := .SD / shift(.SD, fill = 1), .SDcols = "ipca_index"]

DT[, inpc_index := inpc / DT[year == 2008, inpc]]
DT[, inpc_rate := .SD / shift(.SD, fill = 1), .SDcols = "inpc_index"]

DT[, igp_di_index := igp_di / DT[year == 2008, igp_di]]
DT[, igp_di_rate := .SD / shift(.SD, fill = 1), .SDcols = "igp_di_index"]

setcolorder(DT, c("year","ipca", "ipca_index", "ipca_rate", 
                  "inpc", "inpc_index", "inpc_rate", 
                  "igp_di", "igp_di_index", "igp_di_rate"))

 write_csv(DT, "data/cleaned/year_level_vars.csv")
