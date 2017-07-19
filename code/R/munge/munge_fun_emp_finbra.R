library(tidyverse); library(data.table); library(stringr)

source("code/R/munge/munge_fun_emp_qdcc.R")
source("code/R/munge/munge_fun_emp_dca.R")

DT <- rbind(DT_qdcc, DT_dca)
# ==========================================================
# export variables of interest
# ==========================================================
pkey <- c("id", "state", "year")

desp_previdencia <- quote(desc == "PREVIDENCIA SOCIAL")
DT[eval(desp_previdencia),.N, by = c("year", "desc")]
DT[eval(desp_previdencia), .(value = sum(value)), by = pkey] %>% write_csv("data/munged/finbra-desp_previdencia.csv")

