library(tidyverse); library(data.table); library(stringr)

source("code/R/munge/munge_nat_emp_qdcc.R")
source("code/R/munge/munge_nat_emp_dca.R")

DT <- rbind(DT_qdcc, DT_dca)
# ==========================================================
# export variables of interest
# ==========================================================
pkey <- c("id", "state", "year")

desp_total <- quote(desc == "DESPESA TOTAL")
DT[eval(desp_total),.N, by = c("year", "desc")]
DT[eval(desp_total), .(value = sum(value)), by = pkey] %>% write_csv("data/munged/finbra-desp_total.csv")

desp_cor <- quote(desc == "DESPESAS CORRENTES")
DT[eval(desp_cor), .N, by = c("year", "desc")]
DT[desc == "DESPESAS CORRENTES", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-desp_cor.csv")

pessoal <- quote(desc == "PESSOAL E ENCARGOS SOCIAIS")
DT[eval(pessoal), .N, by = c("year", "desc")]
DT[desc == "PESSOAL E ENCARGOS SOCIAIS", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-pessoal.csv")

juros <- quote(desc == "JUROS E ENCARGOS DA DIVIDA")
DT[eval(juros), .N, by = c("year", "desc")]
DT[desc == "JUROS E ENCARGOS DA DIVIDA", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-juros.csv")

custeio <- quote(desc == "OUTRAS DESPESAS CORRENTES")
DT[eval(custeio), .N, by = c("year", "desc")]
DT[desc == "OUTRAS DESPESAS CORRENTES", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-custeio.csv")

desp_cap <- quote(desc == "DESPESAS DE CAPITAL")
DT[eval(desp_cap), .N, by = c("year", "desc")]
DT[desc == "DESPESAS DE CAPITAL", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-desp_cap.csv")

investimentos <- quote(desc == "INVESTIMENTOS")
DT[eval(investimentos), .N, by = c("year", "desc")]
DT[desc == "INVESTIMENTOS", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-investimentos.csv")

inv_fin <- quote(desc == "INVERSOES FINANCEIRAS")
DT[eval(inv_fin), .N, by = c("year", "desc")]
DT[desc == "INVERSOES FINANCEIRAS", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-inv_fin.csv")

concessao_emprestimos <- quote(desc == "CONCESSAO DE EMPRESTIMOS E FINANCIAMENTOS")
DT[eval(concessao_emprestimos), .N, by = c("year", "desc")]
DT[desc == "CONCESSAO DE EMPRESTIMOS E FINANCIAMENTOS", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-concessao_emprestimos.csv")

aquisicao_titulos <- quote(desc == "AQUISICAO DE TITULOS REPRESENTATIVOS DE CAPITAL JA INTEGRALIZADO")
DT[eval(aquisicao_titulos), .N, by = c("year", "desc")]
DT[desc == "AQUISICAO DE TITULOS REPRESENTATIVOS DE CAPITAL JA INTEGRALIZADO", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-aquisicao_titulos.csv")

amortizacao <- quote(desc == "AMORTIZACAO DA DIVIDA")
DT[eval(amortizacao), .N, by = c("year", "desc")]
DT[desc == "AMORTIZACAO DA DIVIDA", .(value = sum(value)), by = pkey] %>%write_csv("data/munged/finbra-amortizacao.csv")


# 
# # there are others to be done
# DT[desc == "DESPESA TOTAL", cod := "0.0.00.00.00"]
# 
# DT <- DT[desc != "SUPERAVIT / DEFICIT"]
# DT <- DT[desc != "RESERVA DO RPPS"]
# DT <- DT[desc != "RESERVA DE CONTINGENCIA"]
# 
