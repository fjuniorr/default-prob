library(tidyverse); library(data.table); library(stringr)

source("code/R/munge/munge_rec_qdcc.R")
source("code/R/munge/munge_rec_dca.R")

DT <- rbind(DT_qdcc, DT_dca)
# ==========================================================
# export variables of interest
# ==========================================================
pkey <- c("id", "state", "year")

rec_cor <- quote(desc == "RECEITAS CORRENTES" & str_sub(cod, 1, 1) != "9")

DT[eval(rec_cor),.N, by = c("cod", "desc", "year")] 

DT[eval(rec_cor), .(value = sum(value)), by = pkey] %>% write_csv("data/munged/finbra-rec_cor.csv")

rec_tributaria <- quote(desc == "RECEITA TRIBUTARIA" & str_sub(cod, 1, 1) != "9")

DT[eval(rec_tributaria),.N, by = c("cod", "desc", "year")]

DT[eval(rec_tributaria), .(value = sum(value)), by = pkey] %>% write_csv("data/munged/finbra-rec_tributaria.csv")

# ==========================================================
# manual data cleaning
# ==========================================================

# ==========================================================
# DCA
# ==========================================================

# DT[desc == "RECEITAS CORRENTES" & coluna == "RECEITAS REALIZADAS",.N ,by = c("year", "state")]
# 
# 
# DT[coluna == "RECEITAS REALIZADAS" | coluna == "RECEITAS BRUTAS REALIZADAS",.N, by = c("cod", "desc", "year")] %>%
#     dcast(cod + desc ~ year, value.var = "N") %>%
#     View

# DT <- l %>% bind_rows() %>% as.data.table()
# DT <- separate(DT, conta, into = c("cod1", "desc1"), sep = "\\s-\\s", convert = FALSE)
# DT[nchar(cod1) == 14, unique(cod1)]
# DT$cod1 %>% nchar %>% unique



# ==========================================================
# QDCC
# ==========================================================

# DT[,.N, by = c("cod", "desc", "year")] %>%
#     dcast(cod + desc ~ year, value.var = "N") %>%
#     View
# 
# DT[,.N, by = c("cod", "desc", "year")] %>% 
#     dcast(cod + desc ~ year, value.var = "N") %>% 
#     .[!complete.cases(.)] %>% 
#     View 

# there are others to be done
# DT[cod == "1.1.13.02.00", desc := "IMPOSTO SOBRE OP. RELATIVAS A CIRCULACAO DE MERCADORIAS E SOBRE PREST. DE SERV.DE TRANSP. INTEREST. E INTERM. E COMUNICACOES - ICMS"]
# DT[cod == "1.3.30.00.00", desc := "RECEITAS DE CONCESSOES E PERMISSOES"]

