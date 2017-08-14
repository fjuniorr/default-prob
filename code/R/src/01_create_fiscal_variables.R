library(tidyverse); library(data.table); library(stringr)

index <- c("id", "state", "year")

vars <- list.files("data/munged/") %>% 
            stringr::str_replace(".csv$", "") %>% 
            stringr::str_replace(".*-", "")

col_names <- map(vars, ~ c(index, .x))

l <- list.files("data/munged/", full.names = TRUE) %>% 
        map(read_csv, col_types = "ccid")

DT <- pmap(list(l, col_names), set_names) %>% 
        reduce(full_join, by = index) %>% 
        as.data.table()

for (j in names(DT)) {
    set(DT,which(is.na(DT[[j]])),j,0)
}
# # or by number (slightly faster than by name) :
# for (j in seq_len(ncol(DT)))
#     set(DT,which(is.na(DT[[j]])),j,0)


# ==========================================================
# missing data
# ==========================================================

DT[id == "rr2011", desp_total := 2599336002.21 ]
DT[id == "rr2011", desp_cor := 2108958174.25 ]
DT[id == "rr2011", pessoal := 1023549378.50 ]
DT[id == "rr2011", juros := 48972478.27 ]
DT[id == "rr2011", custeio := 1036436317.48 ]
DT[id == "rr2011", desp_cap := 490377827.96 ]
DT[id == "rr2011", investimentos := 341382755.02 ]
DT[id == "rr2011", inv_fin := 80241628.28 ]
DT[id == "rr2011", concessao_emprestimos := 0]
DT[id == "rr2011", aquisicao_titulos := 0]
DT[id == "rr2011", amortizacao := 68753444.66 ]

# ==========================================================
# outliers - rec_previdenciarias / inativos
# ==========================================================

DT[state %in% c("al", "am", "ap", "ms", "rr"), inativos := desp_previdencia]

DT[id %in% "al2011", rec_previdenciarias := 143459532.06 + 295229369.01]
DT[id %in% "al2012", rec_previdenciarias :=  153169108.31 + 295229369.01]
DT[id %in% "al2013", rec_previdenciarias := 7331781.64 + 5043032.38]
DT[id %in% "al2014", rec_previdenciarias := 9482603.18 + 8421262.23]
DT[id %in% "am2008", rec_previdenciarias := 208301121.72 + 362809799.59]
DT[id %in% "am2009", rec_previdenciarias := 141588544.46 + 283061990.28]
DT[id %in% "am2010", rec_previdenciarias := 200509882.05 + 284462339.54]
DT[id %in% "am2011", rec_previdenciarias := 216482193.69 + 255842592.36]
DT[id %in% "rn2008", rec_previdenciarias := 210331938.35 + 401609466.31]
DT[id %in% "rn2009", rec_previdenciarias := 213816171.77 + 437087700.78]

# ==========================================================
# missing data - obrig_fin / disp_caixa_bruta
# ==========================================================



DT[id == "rn2015", disp_caixa_bruta := disp_caixa_nominal]
DT[id == "rn2015", obrig_fin := mean(DT[state == "rn", obrig_fin / disp_caixa_bruta], na.rm = TRUE)*disp_caixa_bruta]
DT[id == "rn2015", disp_caixa_liq := disp_caixa_bruta - obrig_fin]

DT[id == "rr2010", disp_caixa_bruta := disp_caixa_nominal]
DT[id == "rr2010", obrig_fin := mean(DT[state == "rr" & year != 2008, obrig_fin / disp_caixa_bruta], na.rm = TRUE)*disp_caixa_bruta]
DT[id == "rr2010", disp_caixa_liq := disp_caixa_bruta - obrig_fin]

DT[id == "rr2012", disp_caixa_bruta := disp_caixa_nominal]
DT[id == "rr2012", obrig_fin := mean(DT[state == "rr" & year != 2008, obrig_fin / disp_caixa_bruta], na.rm = TRUE)*disp_caixa_bruta]
DT[id == "rr2012", disp_caixa_liq := disp_caixa_bruta - obrig_fin]

# ==========================================================
# generate derived variables
# ==========================================================

DT[, desp_primaria_cor := desp_cor - juros]
DT[, desp_primaria_cap := desp_cap - amortizacao - aquisicao_titulos - concessao_emprestimos]
DT[, desp_primaria := desp_primaria_cor + desp_primaria_cap]
# 
# 
# #===========================================
# 
# revenue <- c("rec_cor", "rec_tributaria", "rec_rpps", "rcl",
#              "rec_primaria", "rec_primaria_cor", "rec_primaria_cap")
# 
# expense <- c("desp_total", "desp_cor", "pessoal", "juros", "custeio",
#              "desp_cap",
#              "investimentos", "inv_fin", "aquisicao_titulos", "concessao_emprestimos", "amortizacao",
#              "desp_previdencia",
#              "desp_primaria_cor", "desp_primaria_cap", "desp_primaria", "primario",
#              "dbp", "ativos", "contratos", "inativos", "deducao_pessoal", "dtp")
#     
# stocks <- c("dcb", "dcl", "dfl", "nominal", "disp_caixa_bruta", "disp_caixa_nominal", "obrig_fin") 
# 
# bacen <- c()
# 
# col_order <- c(index, revenue, expense, stocks)
# 
# stopifnot(length(setdiff(col_order, names(DT))) == 0)
# stopifnot(length(setdiff(names(DT), col_order)) == 0)
# 
# setcolorder(DT, col_order)

# ==========================================================
# change units to millions
# ==========================================================

# 
# for (j in c(revenue, expense, stocks)) {
#     set(DT, j = j, value = DT[[col]] / 1000000)
# }

#===========================================

cfg <- yaml::yaml.load_file("data/fiscal-indicators.yaml")

fiscal_variables <- cfg %>% 
    map("memoria") %>% 
    str_replace_all("\\s", "") %>% 
    str_replace("\\(", "") %>% 
    str_replace("\\)", "") %>% 
    map(~strsplit(.x, "\\+")) %>% 
    unlist %>% 
    map(~strsplit(.x, "/")) %>% 
    unlist() %>% 
    str_split("-") %>% 
    unlist() %>% 
    unique() %>% 
    setdiff("sgdp")# variables used to calculate the indicators

setorderv(DT, c("state", "year"))

DT[, c("id", fiscal_variables), with = FALSE] %>% 
    write_csv("data/cleaned/fiscal_variables.csv")
