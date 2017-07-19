library(data.table); library(tidyverse); library(stringr)
source("code/R/lib/clean_text.R")
source("code/R/lib/unzip_rename.R")

# ==========================================================
# data import
# ==========================================================
col_names <- c("instituicao", "ibge", "uf", "populacao", "coluna", "conta", "value")
col_types <- c("character", "integer", "character", "numeric", "character", "character", "numeric")

l <- list.files("data-raw/dca/download/", recursive = TRUE, full.names = TRUE) %>% 
    str_subset("DespesasporFuncao") %>% 
    as.list() %>% 
    set_names(nm = str_extract(., "\\d{4}")) %>% 
    map(unzip_rename, exdir = "data-raw/dca/") %>% 
    map(read.csv2, 
        encoding = "latin1", 
        stringsAsFactors = FALSE, 
        header = FALSE, 
        skip = 4, 
        col.names = col_names, 
        colClasses = col_types)

# ==========================================================
# scripted data cleaning
# ==========================================================
DT_dca <- l %>% 
    map(separate, conta, into = c("cod", "desc"), sep = "\\s-\\s", convert = FALSE) %>% 
    map(mutate, desc = clean_text(desc), coluna = clean_text(coluna)) %>% 
    bind_rows(.id = "year") %>% 
    mutate(year = as.integer(str_extract(year, "\\d{4}"))) %>% 
    mutate(state = tolower(uf), id = paste0(state, year)) %>% 
    as.data.table()    

# ==========================================================
# conform to qdcc
# ==========================================================

DT_dca <- DT_dca[coluna == "DESPESAS EMPENHADAS", .(id, state, year, cod, desc, value)]

# ==========================================================
# clean workspace
# ==========================================================
rm(list=setdiff(ls(), c("DT_qdcc", "DT_dca")))
