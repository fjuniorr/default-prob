library(tidyverse); library(data.table); library(stringr)

source("code/R/munge/munge_bp_qdcc.R")
source("code/R/munge/munge_bp_dca.R")

DT <- rbind(DT_qdcc, DT_dca, fill = TRUE)
# ==========================================================
# export variables of interest
# ==========================================================
pkey <- c("id", "state", "year")

ativo_financeiro <- quote(desc == "ATIVO FINANCEIRO")
DT[eval(ativo_financeiro),.N, by = c("year", "desc")]

DT[id == "ms2013"] %>% View
DT[id == "ms2014"] %>% View

ativo_circulante <- quote(desc == "ATIVO CIRCULANTE")
DT[eval(ativo_circulante),.N, by = c("year", "desc")]


