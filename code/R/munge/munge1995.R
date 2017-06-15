library(readxl); library(data.table); library(tidyr)
source("code/R/lib/clean_text.R")
#====================================================
# script specific variables
year <- 1995

# configuration variables
path <- "data-raw/states/pge_exec_orc_estados_1995_2013.xlsx"
meta <- data.table(read_excel("data/meta.xlsx"))
tbl_type <- "rec_desp_nat"

#====================================================
# define range of data in spreadsheet
startCell <- meta[sheet == year & table == tbl_type, paste0(startCol, startRow)]
endCell <- meta[sheet == year & table == tbl_type, paste0(endCol, endRow)]
range <- paste(startCell, endCell, sep = ":")

# data ingestion
tbl <- data.table(read_excel(path = path, range = range))

# data checking
str(tbl)
nrow(tbl) # 37
ncol(tbl) # 29

# create header variables
tbl$id <- 1:nrow(tbl)
tbl$year <- year

# data cleaning
setnames(tbl, "DISCRIMINAÇÃO", "DISCRIMINACAO")
tbl <- separate(tbl, "DISCRIMINACAO", into = c("cod", "desc"), sep = "-")
tbl[, desc := clean_text(desc)]
tbl <- melt(tbl, 
            id.vars = c("id", "year", "cod", "desc"), 
            variable.name = "sigla")

