library(tidyverse); library(data.table); library(stringr)

DT <- fread("data/analytic_data.csv")

DT[, .N, by = "calamity"]

vars_stn <- str_subset(names(DT), "stn") %>% 
    str_subset("^((?!lag).)*$") %>% 
    str_subset("^((?!z).)*$")

vars_stn_z <- str_subset(names(DT), "stn") %>% 
    str_subset("_z$")

vars_capag <- str_subset(names(DT), "capag") %>% 
    str_subset("^((?!lag).)*$") %>% 
    str_subset("^((?!z).)*$")

vars_capag_z <- str_subset(names(DT), "capag") %>% 
    str_subset("_z$")
                

DT[, lapply(.SD, function(x) list(mean(x), sd(x))), .SDcols = vars_stn] %>% 
    transpose() %>% 
    as.data.table() %>% 
    mutate(key = vars_stn) %>% 
    mutate(mean = V1, sd = V2) %>% 
    select(key, mean, sd) %>% 
    clipboard::cb()


DT[, lapply(.SD, function(x) list(mean(x), sd(x))), .SDcols = vars_capag] %>% 
    transpose() %>% 
    as.data.table() %>% 
    mutate(key = vars_capag) %>% 
    mutate(mean = V1, sd = V2) %>% 
    select(key, mean, sd) %>% 
    clipboard::cb()


DT %>% 
    group_by(calamity) %>% 
    summarize_at(vars(starts_with("stn")), funs(mean, sd)) %>% 
    as.data.table() %>% 
    melt(id.vars = "calamity", variable.name = "key", variable.factor = FALSE)  %>% 
    dcast(... ~ calamity, value.var = "value") %>% 
    .[complete.cases(.)] %>% 
    .[!grepl("z",key)] %>% 
    clipboard::cb() 


DT %>% 
    group_by(calamity) %>% 
    summarize_at(vars(starts_with("stn")), funs(mean)) %>% 
    as.data.table() %>% 
    melt(id.vars = "calamity", variable.name = "key", variable.factor = FALSE)  %>% 
    .[complete.cases(.)] %>% 
    .[grepl("_z$",key)] # for information only


DT %>% 
    group_by(calamity) %>% 
    summarize_at(vars(starts_with("capag")), funs(mean, sd)) %>% 
    as.data.table() %>% 
    melt(id.vars = "calamity", variable.name = "key", variable.factor = FALSE)  %>% 
    dcast(... ~ calamity, value.var = "value") %>% 
    .[complete.cases(.)] %>% 
    .[!grepl("z",key)] %>% 
    clipboard::cb()

DT %>% 
    group_by(calamity) %>% 
    summarize_at(vars(starts_with("capag")), funs(mean)) %>% 
    as.data.table() %>% 
    melt(id.vars = "calamity", variable.name = "key", variable.factor = FALSE)  %>% 
    .[complete.cases(.)] %>% 
    .[grepl("_z$",key)] # for information only
