library(readr); library(purrr)

path <- "data-raw/QDCC/"
files <- list.files(path)

col_names <- c("state_name", "ibge_code", "state_code", "state_pop", "date", "account", "value")
col_types <- c("character", "integer", "character", "numeric", "Date", "character", "numeric")

# for (year in years) {
#     for(annex in annexes)
# }


file <- files[[1]]
unzip(file.path(path, file), exdir = path)
annex <- read.csv2(file = file.path(path, "finbra.csv"), 
                   encoding = "latin1",
                   stringsAsFactors = FALSE,
                   header = FALSE,
                   skip = 4,
                   col.names = col_names,
                   colClasses = col_types)

