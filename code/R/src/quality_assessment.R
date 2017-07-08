library(tidyverse); library(data.table); library(broom)
# ==========================================================

x <- "data-raw/rgf/2008_ba_rgf.pdf"

x <- "data-raw/rgf/2015_ac_rgf.xls"

system(paste("open", x))

# ==========================================================

files <- list.files("data-raw/rgf/", full.names = TRUE) %>% 
    stringr::str_subset("_ac_") 


DF <- files %>% 
    purrr::map(get_record) %>% 
    dplyr::bind_rows()

# ==========================================================
# missing files
system('open data-raw/rgf/2012_ba_rgf.pdf')
system('open data-raw/rgf/2014_ce_rgf.pdf')
system('open data-raw/rgf/2014_ms_rgf.pdf')
system('open data-raw/rgf/2014_pb_rgf.pdf')
system('open data-raw/rgf/2014_rn_rgf.pdf')
system('open data-raw/rgf/2014_se_rgf.pdf')

# ==========================================================
# diagnostic - missing values

DF[!complete.cases(DF), ]

DF[!complete.cases(DF), ] %>% write_csv("problems.csv")

states <- readxl::read_excel("data/states.xlsx")
years <- 2008:2016

full_DF <- expand.grid(state = states$sigla, 
                       year = years,
                       stringsAsFactors = FALSE)

anti_join(full_DF, DF, by = c("year", "state"))


# ==========================================================
# diagnostic - outliers

fit  <- DF %>% 
            split(.$state) %>% 
            map(~lm(value ~ year, data = .x))

fit %>% 
    map(glance) %>% 
    map("adj.r.squared") %>% 
    unlist() %>% 
    sort

fit %>% 
    map(rstandard) %>% 
    
    

fit %>% 
    map(augment) %>% 
    map(mutate, stdres = rstandard(.))


DT[state == "es", ] # problem with ativo
DT[state == "rj", ]
DT[state == "am", ]

DT <- as.data.table(DF)
setorderv(DT, c("id"))

DT[, lagged := shift(value), by = state]
DT[, pct_change := value / lagged]

DT[, value := formattable::accounting(value)]

DT[order(-pct_change)]


DT %>% 
    ggplot(aes(x = factor(year), y = pct_change)) + geom_boxplot()

DT[, median(var), by = year]