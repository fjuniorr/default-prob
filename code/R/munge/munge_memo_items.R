library(tidyverse); library(readxl); library(data.table)

# ==========================================================
# independent variable
# ==========================================================

states <- readxl::read_excel("data/states.xlsx")
years <- 2008:2016

DT_y <- as.data.table(expand.grid(state = states$sigla, 
                                year = years,
                                stringsAsFactors = FALSE))

DT_y[, id := paste0(state, year)]

# http://g1.globo.com/bom-dia-brasil/noticia/2016/12/calamidade-financeira-de-estados-nao-e-reconhecida-pelo-governo.html
DT_y[id %in% c("rj2016", "rs2016", "mg2016"), value := 1]
DT_y[is.na(value), value := 0]

setcolorder(DT_y, c("id", "state", "year", "value"))

write_csv(DT_y, "data/munged/default.csv")

# ==========================================================
# subnational gross domestic product
# ==========================================================

read_excel("data-raw/pib-regional.xlsx") %>% 
        gather(key = year, value = value, -c(state, nome)) %>% 
        mutate(id = paste0(state, year), value = value*1000000) %>% 
        select(id, state, year, value) %>% 
        filter(year >= 2008 & state != "br") %>% 
        write_csv("data/munged/gdp.csv")

# ==========================================================
# population
# ==========================================================

read_excel("data-raw/populacao.xlsx") %>% 
    gather(key = year, value = value, -c(state, nome)) %>% 
    mutate(id = paste0(state, year)) %>% 
    select(id, state, year, value) %>% 
    filter(year >= 2008) %>% 
    write_csv("data/munged/pop.csv")

# ==========================================================
# inflation
# ==========================================================

DT_cpi <- as.data.table(read_excel("data-raw/inflacao.xlsx"))

cpi <- c("ipca", "inpc", "igp_di")

DT_cpi <- DT_cpi[year %in% 2007:2016 & mes == "dez"]

DT_cpi[, (paste0(cpi, "_lag")) := shift(.SD), .SDcols = paste0(cpi, "_index")]

DT_cpi[, (cpi) := .(ipca_index / ipca_lag, inpc_index / inpc_lag, igp_di_index / igp_di_lag)]

DT_cpi <- DT_cpi[complete.cases(DT_cpi), .(year, ipca, inpc, igp_di)]

states <- readxl::read_excel("data/states.xlsx")
years <- 2008:2016

DT_cpi_full <- as.data.table(expand.grid(state = states$sigla, 
                                         year = years,
                                         stringsAsFactors = FALSE))


DT_cpi_full[, id := paste0(state, year)]
DT_cpi[, year := as.integer(year)]

ipca <- left_join(DT_cpi_full, DT_cpi[, .(year, ipca)], by = "year")
setnames(ipca, c("state", "year", "id", "value"))
setcolorder(ipca, c("id", "state", "year", "value"))
write_csv(ipca, "data/munged/ipca.csv")


inpc <- left_join(DT_cpi_full, DT_cpi[, .(year, inpc)], by = "year")
setnames(inpc, c("state", "year", "id", "value"))
setcolorder(inpc, c("id", "state", "year", "value"))
write_csv(inpc, "data/munged/inpc.csv")

igp_di <- left_join(DT_cpi_full, DT_cpi[, .(year, igp_di)], by = "year")
setnames(igp_di, c("state", "year", "id", "value"))
setcolorder(igp_di, c("id", "state", "year", "value"))
write_csv(igp_di, "data/munged/igp_di.csv")
