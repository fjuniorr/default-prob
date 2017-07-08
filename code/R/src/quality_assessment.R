# ==========================================================

x <- "data-raw/rgf/2008_mg_rgf.pdf"

x <- list.files("data-raw/rgf/", full.names = TRUE) %>% 
            stringr::str_subset("2016.+df_")

files <- list.files("data-raw/rgf/", full.names = TRUE) %>% 
            stringr::str_subset("_df_") 

# ==========================================================

DF <- files %>% 
    purrr::map(get_record) %>% 
    dplyr::bind_rows()

system(paste("open", x))

# ==========================================================
# diagnostic info

DF[!complete.cases(DF), ]


states <- read_excel("data/states.xlsx")
years <- 2008:2016

full_DF <- expand.grid(state = states$sigla, 
                       year = years,
                       stringsAsFactors = FALSE)

anti_join(full_DF, DF, by = c("year", "state"))


# ==========================================================
# diagnostic

DT <- as.data.table(DF)
setorderv(DT, c("state", "year"))

DT[, lagged := shift(variable), by = state]
DT[, var := variable / lagged]

DT[order(-var)]

library(ggplot2)

DT %>% 
    ggplot(aes(x = factor(year), y = var)) + geom_boxplot()

DT[, median(var), by = year]