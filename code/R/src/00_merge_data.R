library(tidyverse); library(data.table); library(formattable)

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

# ==========================================================
# generate explanatory variables
# ==========================================================

DT[, desp_primaria := desp_total - juros - amortizacao - aquisicao_titulos - concessao_emprestimos]

# ENDIVIDAMENTO
DT[, end := dcl / rcl]

# SERVIÇO DA DÍVIDA NA RECEITA CORRENTE LÍQUIDA
DT[, sdrcl := (juros_bacen + amortizacao) / rcl]

# RESULTADO PRIMÁRIO SERVINDO A DÍVIDA
DT[, rpsd := primario / (juros_bacen + amortizacao)]

# DESPESA COM PESSOAL E ENCARGOS SOCIAIS NA RECEITA CORRENTE LÍQUIDA
DT[, dprcl := dbp / rcl]

# CAPACIDADE DE GERAÇÃO DE POUPANÇA PRÓPRIA
DT[, cgpp := (rec_cor - desp_cor) / desp_cor]

# PARTICIPAÇÃO DOS INVESTIMENTOS NA DESPESA TOTAL
DT[, pidt := investimentos / desp_total]

# PARTICIPAÇÃO DAS CONTRIBUIÇÕES E REMUNERAÇÕES DO RPPS NAS DESPESAS PREVIDENCIÁRIAS
DT[, pcrdp := rec_rpps / desp_previdencia]

# RECEITAS TRIBUTÁRIAS NAS DESPESAS DE CUSTEIO
DT[, rtdc := rec_tributaria / custeio]

# ENDIVIDAMENTO - CAPAG
DT[, idc := dcb / rcl]

# POUPANÇA CORRENTE - CAPAG
DT[, pc := desp_cor / rec_cor]

# ÍNDICE DE LIQUIDEZ - CAPAG
DT[, il := obrig_fin / disp_caixa]

#===========================================

col_order <- c(
    "id",
    "state",
    "year",
    # revenue
    "rec_cor",
    "rec_tributaria",
    "rec_rpps",
    "rcl",
    "rec_primaria",
    "rec_primaria_cor",
    "rec_primaria_cap",
    # expense
    "desp_total",
    "desp_cor",
    "pessoal",
    "juros",
    "custeio",
    "desp_cap",
    "investimentos",
    "inv_fin",
    "aquisicao_titulos",
    "concessao_emprestimos",
    "amortizacao",
    "desp_previdencia",
    "desp_primaria",
    "primario",
    "dbp",
    "ativos",
    "contratos",
    "inativos",
    "deducao_pessoal",
    "dtp",
    # assets and liabilities
    "dcb",
    "dcl",
    "dfl",
    "nominal",
    "disp_caixa",
    "obrig_fin",
    # below the line
    "net_debt_bacen",
    "juros_bacen",
    "primario_bacen",
    "nominal_bacen",
    "other_flows_bacen",
    # memo items
    "gdp",
    "pop",
    "ipca",
    "inpc",
    "igp_di",
    # fiscal indicators
    "end",
    "sdrcl",
    "rpsd",
    "dprcl",
    "cgpp",
    "pidt",
    "pcrdp",
    "rtdc",
    "idc",
    "pc",
    "il")

setdiff(col_order, names(DT))

setcolorder(DT, col_order)

#===========================================

DT[, dbp_check := ativos + inativos + contratos]
DT[, dtp_check := dbp -deducao_pessoal]
DT[, rec_primaria_check := rec_primaria_cor + rec_primaria_cap]

write_csv(DT, "DT.csv")
#===========================================


DT %>% 
    #filter(state == "mg") %>% 
    ggplot(aes(x = year, y = ratio)) + geom_line() + facet_wrap(~ state)


DT %>% 
    ggplot(aes(x = ratio)) + geom_histogram() +
    facet_wrap(~ state)
