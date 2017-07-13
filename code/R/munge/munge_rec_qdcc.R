library(tidyverse); library(readxl); library(data.table)
source("code/R/lib/clean_text.R")

# ==========================================================
# data import
# ==========================================================
info_qdcc <- read_excel("data/info_qdcc.xlsx", col_types = c("text", "text", "text"))
states_qdcc <- read_excel("data/states_qdcc.xlsx")

l <- info_qdcc %>% filter(tbl == "rec") %>% 
        split(.$year) %>% 
        map(~ read_excel(path = "data-raw/pge_exec_orc_estados_1995_2013.xlsx",
                        sheet = .x$year,
                        range = .x$range,
                        col_types = c("text", "text", rep("numeric", 27))))

# correct names for columns
for(i in seq_along(l)) {
    names(l[[i]]) <- c("cod", "discriminacao", states_qdcc[[i]])
}

# ==========================================================
# scripted data cleaning
# ==========================================================
DT_qdcc <- l %>% 
        map(separate, discriminacao, into = c("desc", "memoria"), sep = "=", convert = FALSE) %>% 
        map(mutate, desc = clean_text(desc)) %>% 
        map(mutate, campo = seq_along(cod))  %>% 
        map(gather, key = "state", value = "value", -c(campo, cod, desc, memoria)) %>% 
        bind_rows(.id = "year") %>% 
        as.data.table()

# ==========================================================
# conform to dca
# ==========================================================
DT_qdcc[, year := as.integer(year)]
DT_qdcc[, id := paste0(state, year)]
DT_qdcc <- DT_qdcc[, .(id, state, year, cod, desc, value)]

# ==========================================================
# clean workspace
# ==========================================================
rm(list=setdiff(ls(), c("DT_qdcc", "DT_dca")))
