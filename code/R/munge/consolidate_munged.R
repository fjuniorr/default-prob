library(tidyverse)

index <- c("id", "state", "year")

vars <- list.files("data/munged/") %>% 
            stringr::str_replace(".csv$", "")

col_names <- map(vars, ~ c(index, .x))

l <- list.files("data/munged/", full.names = TRUE) %>% 
        map(read_csv)

DF <- pmap(list(l, col_names), set_names) %>% 
        reduce(full_join, by = index) %>% 
        mutate(ratio = juros_bacen / rcl)
        #data.table::melt(id.vars = index)

DF %>% 
    #filter(state == "mg") %>% 
    ggplot(aes(x = year, y = ratio)) + geom_line() + facet_wrap(~ state)


DF %>% 
    ggplot(aes(x = ratio)) + geom_histogram() +
    facet_wrap(~ state)
