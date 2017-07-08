library(tidyverse); library(data.table); library(formattable)

index <- c("id", "state", "year")

vars <- list.files("data/munged/") %>% 
            stringr::str_replace(".csv$", "")

col_names <- map(vars, ~ c(index, .x))

l <- list.files("data/munged/", full.names = TRUE) %>% 
        map(read_csv, col_types = "ccid")

DT <- pmap(list(l, col_names), set_names) %>% 
        reduce(full_join, by = index) %>% 
        as.data.table()

#===========================================

DT[, dbp_check := ativos + inativos + contratos]
DT[, dtp_check := dbp -deducao_pessoal]

DT[id == "ba2008"]

DT[dbp != dbp_check, .(id, 
                               diff = accounting(dbp - dbp_check) ,
                               dbp = accounting(dbp), 
                               check = accounting(dbp_check), 
                               ativos = accounting(ativos), 
                               inativos = accounting(inativos), 
                               contratos = accounting(contratos))]


DT[dtp != dtp_check, .(id, 
                       diff = accounting(dtp - dtp_check) ,
                       dtp = accounting(dtp), 
                       check = accounting(dtp_check), 
                       dbp = accounting(dbp),
                       deducao_pessoal = accounting(deducao_pessoal)
                       )]

DT[abs(dtp - dtp_check) > 1, .(id, 
                    diff = accounting(dtp - dtp_check) ,
                       dtp = accounting(dtp), 
                       dtp_check = accounting(dtp_check), 
                       dbp = accounting(dbp),
                       deducao_pessoal = accounting(deducao_pessoal)
)]


DT %>% 
    #filter(state == "mg") %>% 
    ggplot(aes(x = year, y = ratio)) + geom_line() + facet_wrap(~ state)


DT %>% 
    ggplot(aes(x = ratio)) + geom_histogram() +
    facet_wrap(~ state)
