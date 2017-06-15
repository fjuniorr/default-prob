library(purrr); library(readxl); library(tidyr); library(dplyr)

sheets <- as.character(1995:2000)
path <- "data-raw/states/pge_exec_orc_estados_1995_2013.xlsx"
meta <- read_excel("data/meta.xlsx")
tbl_type <- "rec_desp_nat"

#====================================================
# define range of data in spreadsheet

get_range <- function(x, sheet, table) {
    cells <- x[x$sheet == sheet & x$table == table, 
                   c("startCol", "startRow", "endCol", "endRow")]
    
    start <- paste0(cells[, 1:2], collapse = "")
    end <- paste0(cells[, 3:4], collapse = "")
        
    paste(start, end, sep = ":")
}

dta <- sheets %>% 
            map(~get_range(meta, .x, tbl_type)) %>% 
            map2(sheets, ~read_excel(path, sheet = .y, range = .x)) %>% 
            set_names(sheets)

dta %>% 
    map(separate_, col = "DISCRIMINAÇÃO", into = c("cod", "desc"), sep = "-") %>% 
    map(`[`, c("cod", "desc")) %>% 
    bind_rows(.id = "year") %>% 
    write.csv(file = "labels.csv")
    
    
