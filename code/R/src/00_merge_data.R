library(tidyverse); library(data.table)

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

cols_na_zero <- names(DT) %>% as.list() %>% set_names() %>% map(~ 0)

DT <- replace_na(DT, cols_na_zero) # every na zero is replaced by 0

DT[!complete.cases(DT)]

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
# add state variables
# ==========================================================

states <- readxl::read_excel("data/states.xlsx")

DT <- left_join(DT, states[, c("state", "region")], by = "state") %>% 
        as.data.table()

# ==========================================================
# generate derived variables
# ==========================================================

DT[, rec_primaria_dv := rec_primaria_cor + rec_primaria_cap]
#DT[rec_primaria_dv - rec_primaria > 0, .(id, rec_primaria_dv, rec_primaria)]

DT[, desp_primaria_cor_dv := desp_cor - juros]
DT[, desp_primaria_cap_dv := desp_cap - amortizacao - aquisicao_titulos - concessao_emprestimos]
DT[, desp_primaria_dv := desp_primaria_cor_dv + desp_primaria_cap_dv]
DT[, primario_dv := rec_primaria_dv - desp_primaria_dv]


DT[, dbp_dv := ativos + inativos + contratos]
DT[, dtp_dv := dbp_dv - deducao_pessoal]

DT[, desp_cor_dv := pessoal + juros + custeio]
DT[, desp_cap_dv := investimentos + inv_fin + amortizacao]
DT[, desp_total_dv :=   desp_cor_dv + desp_cap_dv]


# ==========================================================
# stn
# ==========================================================
# ENDIVIDAMENTO
DT[, stn_end := dcl / rcl]

# SERVIÇO DA DÍVIDA NA RECEITA CORRENTE LÍQUIDA
DT[, stn_sdrcl := (juros_bacen + amortizacao) / rcl]

# RESULTADO PRIMÁRIO SERVINDO A DÍVIDA
DT[, stn_rpsd := primario / (juros_bacen + amortizacao)]

# DESPESA COM PESSOAL E ENCARGOS SOCIAIS NA RECEITA CORRENTE LÍQUIDA
DT[, stn_dprcl := dbp / rcl]

# CAPACIDADE DE GERAÇÃO DE POUPANÇA PRÓPRIA
DT[, stn_cgpp := (rec_cor - desp_cor) / desp_cor]

# PARTICIPAÇÃO DOS INVESTIMENTOS NA DESPESA TOTAL
DT[, stn_pidt := investimentos / desp_total]

# PARTICIPAÇÃO DAS CONTRIBUIÇÕES E REMUNERAÇÕES DO RPPS NAS DESPESAS PREVIDENCIÁRIAS
DT[, stn_pcrdp := rec_rpps / desp_previdencia] # using rec_contribuicoes_sociais as rec_rpps

# RECEITAS TRIBUTÁRIAS NAS DESPESAS DE CUSTEIO
DT[, stn_rtdc := rec_tributaria / custeio]

# ==========================================================
# capag
# ==========================================================
# ENDIVIDAMENTO
DT[, capag_idc := dcb / rcl]

# POUPANÇA CORRENTE
DT[, capag_pc := desp_cor / rec_cor]

# ÍNDICE DE LIQUIDEZ
DT[, capag_il := dfl / disp_caixa] # using dfl instead of obrig_fin

# ==========================================================
# gfs
# ==========================================================


#===========================================

col_order <- c(
    "id", "state", "year", "default",
    #===========================================
    # state variables
    "region",
    #===========================================
    # revenue
    "rec_cor", "rec_tributaria", "rec_rpps", "rcl",
    "rec_primaria", "rec_primaria_dv", "rec_primaria_cor", "rec_primaria_cap",
    #===========================================
    # expense
    "desp_total", "desp_total_dv", "desp_cor", "desp_cor_dv", "pessoal", "juros", "custeio",
    "desp_cap", "desp_cap_dv",
    "investimentos", "inv_fin", "aquisicao_titulos", "concessao_emprestimos", "amortizacao",
    "desp_previdencia",
    "desp_primaria_cor_dv", "desp_primaria_cap_dv", "desp_primaria_dv", "primario", "primario_dv",
    "dbp", "dbp_dv", "ativos", "contratos", "inativos", "deducao_pessoal", "dtp", "dtp_dv",
    #===========================================
    # assets and liabilities
    "dcb", "dcl", "dfl", "nominal", "disp_caixa", #"obrig_fin",
    # below the line
    "net_debt_bacen", "juros_bacen", "primario_bacen", "nominal_bacen", "other_flows_bacen",
    #===========================================
    # memo items
    "gdp", "pop", "ipca", "inpc", "igp_di",
    #===========================================
    # fiscal indicators
    "stn_end", "stn_sdrcl", "stn_rpsd", "stn_dprcl", "stn_cgpp", "stn_pidt", "stn_pcrdp", "stn_rtdc",
    "capag_idc", "capag_pc", "capag_il"
    )

setdiff(col_order, names(DT))
setdiff(names(DT), col_order)

setcolorder(DT, col_order)

#===========================================

write_csv(DT, "data/analytic_data.csv")
