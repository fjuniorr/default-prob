library(stringr); library(dplyr)

dir <- "data-raw"
report <- "rreo" # change the report here
path <- file.path("data-raw", report)

files <- list.files(path, recursive = TRUE)

states <- readxl::read_excel("data/states.xlsx")
years <- 2008:2016

DF <- expand.grid(state = states$sigla, 
                  report = report, 
                  year = years,
                  stringsAsFactors = FALSE)

reports <- files %>% 
            str_replace(".pdf$", "") %>% 
            str_replace(".xls$", "") %>% 
            str_replace("/", "_") %>% 
            str_split("_") %>% 
            do.call("rbind", .) %>% 
            as_tibble()
    

names(reports) <- c("year", "state", "report")
reports$year <- as.integer(reports$year)

missing_reports <- anti_join(DF, reports, by = c("state", "report", "year"))

missing_reports
