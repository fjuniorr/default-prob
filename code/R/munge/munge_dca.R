library(tidyverse); library(stringr)

col_names <- c("instituicao", "ibge", "uf", "populacao", "coluna", "conta", "value")
col_types <- c("character", "integer", "character", "numeric", "character", "character", "numeric")

l <- list.files("data-raw/dca/", recursive = TRUE, full.names = TRUE) %>% 
    str_subset("DespesasOrcamentarias")


p <- unzip(l[[2]], exdir = "data-raw/dca/")

annex <- read.csv2(file = p, 
                   encoding = "latin1",
                   stringsAsFactors = FALSE,
                   header = FALSE,
                   skip = 4,
                   col.names = col_names,
                   colClasses = col_types)

# ==========================================================
# 
# ==========================================================

path <- "data-raw/dca/2014/"
files <- list.files(path)


file <- files[[1]]
unzip(file.path(path, file), exdir = path)
annex <- read.csv2(file = file.path(path, "finbra.csv"), 
                   encoding = "latin1",
                   stringsAsFactors = FALSE,
                   header = FALSE,
                   skip = 4,
                   col.names = col_names,
                   colClasses = col_types)

