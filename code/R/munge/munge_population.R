library(tidyverse); library(readxl); library(data.table)

read_excel("data-raw/populacao.xlsx") %>% 
    gather(key = year, value = pop, -c(state, nome)) %>% 
    mutate(id = paste0(state, year)) %>% 
    arrange(state, year) %>% 
    filter(year >= 2008) %>% 
    select(id, pop) %>% 
    write_csv("data/cleaned/population.csv")

