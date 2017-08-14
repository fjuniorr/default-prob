library(tidyverse); library(readxl); library(data.table)

path <- "data/tbl/tbl_primario.xlsx"
col_types <- c("numeric", "text", "text", rep("numeric", 27))

raw_DF <- excel_sheets(path) %>% 
            map(read_excel, 
                path = path, 
                na = "NA", 
                col_types = col_types) %>% 
            set_names(nm = excel_sheets(path))
  

melt_DT <- raw_DF %>% 
              map(mutate, rec = cod %in% 1:30) %>% 
              map(select, -cod, -label_pt) %>% 
              rbindlist(idcol = "state") %>% 
              melt(id.vars = c("expr", "state", "rec"), variable.name = "column", value.name = "value", variable.factor = FALSE) %>% 
              separate(col = column, into = c("type", "year"), sep = "_") %>% 
              mutate(id = paste0(state, year), year = as.numeric(year)) %>% 
              select(id, state, year, expr, type, rec, value) %>% 
              as.data.table()


melt_DT_rec <- melt_DT[rec == TRUE]
melt_DT_rec <- melt_DT_rec[type == "emp"]
DT_rec <- dcast(melt_DT_rec, id + state + year ~ expr, value.var = "value")


melt_DT_desp <- melt_DT[rec == FALSE]
DT_desp <- dcast(melt_DT_desp, id + state + year ~ expr + type, value.var = "value")


DT_rec[, .(id, state, year, value = rec_previdenciarias)] %>% 
    write_csv("data/munged/rreo-rec_previdenciarias.csv")