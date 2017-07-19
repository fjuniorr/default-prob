library(tidyverse); library(readxl); library(data.table)
source("code/R/lib/clean_text.R")

info_qdcc <- read_excel("data/info_qdcc.xlsx", col_types = c("text", "text", "text"))
states_qdcc <- read_excel("data/states_qdcc.xlsx")

# ==========================================================
# ATIVO - data import
# ==========================================================

l <- info_qdcc %>% filter(tbl == "ativo") %>% 
        split(.$year) %>% 
        map(~ read_excel(path = "data-raw/pge_exec_orc_estados_1995_2013.xlsx",
                        sheet = .x$year,
                        range = .x$range,
                        col_types = c("text", rep("numeric", 27))))

# correct names for columns
for(i in seq_along(l)) {
    names(l[[i]]) <- c("discriminacao", states_qdcc[[i]])
}

# ==========================================================
# ATIVO - scripted data cleaning
# ==========================================================
DT_qdcc_ativo <- l %>% 
        map(separate, discriminacao, into = c("desc", "memoria"), sep = "=", convert = FALSE) %>% 
        map(mutate, desc = clean_text(desc)) %>% 
        map(mutate, campo = seq_along(desc))  %>% 
        map(gather, key = "state", value = "value", -c(campo, desc, memoria)) %>% 
        bind_rows(.id = "year") %>% 
        as.data.table()

# ==========================================================
# PASSIVO - data import
# ==========================================================

l <- info_qdcc %>% filter(tbl == "passivo") %>% 
    split(.$year) %>% 
    map(~ read_excel(path = "data-raw/pge_exec_orc_estados_1995_2013.xlsx",
                     sheet = .x$year,
                     range = .x$range,
                     col_types = c("text", rep("numeric", 27))))

# correct names for columns
for(i in seq_along(l)) {
    names(l[[i]]) <- c("discriminacao", states_qdcc[[i]])
}

# ==========================================================
# PASSIVO - scripted data cleaning
# ==========================================================
DT_qdcc_passivo <- l %>% 
    map(separate, discriminacao, into = c("desc", "memoria"), sep = "=", convert = FALSE) %>% 
    map(mutate, desc = clean_text(desc)) %>% 
    map(mutate, campo = seq_along(desc))  %>% 
    map(gather, key = "state", value = "value", -c(campo, desc, memoria)) %>% 
    bind_rows(.id = "year") %>% 
    as.data.table()


# ==========================================================
# concatenate ativo and passivo
# ==========================================================
DT_qdcc <- rbind(DT_qdcc_ativo, DT_qdcc_passivo)
DT_qdcc[, year := as.integer(year)]
DT_qdcc[, id := paste0(state, year)]
DT_qdcc <- DT_qdcc[, .(id, state, year, campo, desc, value)]

# ==========================================================
# clean workspace
# ==========================================================
rm(list=setdiff(ls(), c("DT_qdcc", "DT_dca")))


