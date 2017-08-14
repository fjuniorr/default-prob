library(tidyverse); library(readxl); library(data.table)

DT <- fread("data/state_year_full.csv")

# http://g1.globo.com/bom-dia-brasil/noticia/2016/12/calamidade-financeira-de-estados-nao-e-reconhecida-pelo-governo.html
DT[, calamity := id %in% c("rj2016", "rs2016", "mg2016")]

write_csv(DT[, .(id, calamity)], "data/cleaned/calamity.csv")
