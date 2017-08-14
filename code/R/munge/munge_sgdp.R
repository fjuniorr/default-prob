library(tidyverse); library(readxl); library(data.table)

DF_nominal <- read_excel("data-raw/pib-regional.xlsx", sheet = "pib_nominal") %>% 
            gather(key = year, value = sgdp, -c(state, nome)) %>% 
            mutate(id = paste0(state, year), sgdp = sgdp*1000000) %>% 
            filter(year >= 2008 & state != "br") %>%     
            arrange(state, year) %>% 
            select(id, year, state, sgdp)

DF_real <- read_excel("data-raw/pib-regional.xlsx", sheet = "pib_real") %>% 
    gather(key = year, value = sgdp_real, -c(state, nome)) %>% 
    mutate(id = paste0(state, year), sgdp_real = sgdp_real/100) %>% 
    filter(year >= 2008 & state != "br") %>%     
    arrange(state, year) %>% 
    select(id, year, state, sgdp_real)


DT <- data.table(left_join(DF_nominal, DF_real, by = c("id", "year", "state")))

DT[, sgdp_index := sgdp / .SD[year == 2008, sgdp], by = "state"]
DT[, sgdp_rate := .SD / shift(.SD, fill = 1), .SDcols = "sgdp_index", by = "state"]

DT[, sgdp_real_index := sgdp_real / .SD[year == 2008, sgdp_real], by = "state"]
DT[, sgdp_real_rate := .SD / shift(.SD, fill = 1), .SDcols = "sgdp_real_index", by = "state"]


write_csv(DT[, !c("year", "state")], "data/cleaned/sgdp.csv")
