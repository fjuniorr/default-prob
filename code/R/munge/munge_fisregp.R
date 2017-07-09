library(tidyverse)

# # run if needed
# destfile <- "data-raw/Fisregp.zip"
# url <- "http://www.bcb.gov.br/ftp/notaecon/Fisregp.zip"
# download.file(url, destfile = destfile)
# path <- unzip(destfile, exdir = "data-raw/")
path <- "data-raw/Fisregp.xls"
# ==========================================================
states <- readxl::read_excel("data/states_fisregp.xlsx")
years <- 2008:2016
months <- c("mar", "jun", "set", "dez")
period <- paste(rep(months, length(years)), 
                rep(years, each = length(months)), 
                sep = "_")

# ==========================================================
wks_stock <- c(net_debt_bacen = "Dívida líquida _PorRegiao")
path_stock <- file.path("data/munged", paste0(names(wks_stock), ".csv")) 
rng_stock <- "A11:AM153"
col_names_stock <- c("label", "empty", "dez_2007", period)
raw_DF_stock <- readxl::read_excel(path, 
                                   sheet = wks_stock, 
                                   range = rng_stock,
                                   col_names = col_names_stock)

DF_stock <- raw_DF_stock %>% 
                dplyr::select(-empty, -dez_2007) %>% 
                dplyr::filter(label == "Gov. Estadual" | label == "Distrito Federal") %>% 
                dplyr::mutate(state = states$sigla) %>% 
                data.table::melt(id.vars = c("state", "label"), variable.name = "id", value.name = "net_debt") %>% 
                tidyr::separate(id, into = c("month", "year")) %>% 
                dplyr::filter(month == "dez") %>% 
                dplyr::mutate(id = paste0(state, year), value = net_debt * 1000000) %>% 
                dplyr::select(id, state, year, value)
                
write_csv(DF_stock, path_stock)

# ==========================================================
wks_flows <- c(primario_bacen = "Primário", 
               juros_bacen = "Juros", 
               nominal_bacen = "Nominal", 
               other_flows_bacen = "Outros_fluxos")
path_flows <- file.path("data/munged", paste0(names(wks_flows), ".csv")) 
rng_flows <- "A11:AL153"
col_names_flows <- c("label", "empty", period)

raw_DF_flows <- wks_flows %>% 
                    purrr::map(readxl::read_excel, 
                               path = path,
                               range = rng_flows, 
                               col_names = col_names_flows)


DF_flows  <- raw_DF_flows %>% 
                map(select, -empty) %>% 
                map(filter, label == "Gov. Estadual" | label == "Distrito Federal") %>% 
                map(mutate, state = states$sigla) %>% 
                map(data.table::melt, id.vars = c("state", "label"), variable.name = "id", value.name = "net_debt") %>% 
                map(separate, id, into = c("month", "year")) %>% 
                map(filter, month == "dez") %>% 
                map(mutate, id = paste0(state, year), value = net_debt * 1000000) %>% 
                map(select, id, state, year, value)


pwalk(list(DF_flows, path_flows), write_csv)

