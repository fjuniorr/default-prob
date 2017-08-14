library(tidyverse); library(readxl); library(data.table)

path <- "data/tbl/tbl_disp_caixa.xlsx"
col_types <- c("numeric", "text", "text", rep("numeric", 9))

raw_DF <- excel_sheets(path) %>% 
            map(read_excel, 
                path = path, 
                na = "NA", 
                col_types = col_types,
                range = "A1:L25") %>% 
            set_names(nm = excel_sheets(path))
  

melt_DT <- raw_DF %>% 
              map(select, -cod, -label_pt) %>% 
              rbindlist(idcol = "state") %>% 
              melt(id.vars = c("expr", "state"), variable.name = "year", value.name = "value", variable.factor = FALSE) %>% 
              mutate(id = paste0(state, year), year = as.numeric(year)) %>% 
              select(id, state, year, expr, value)


DT <- data.table(dcast(melt_DT, id + state + year ~ expr, value.var = "value"))

DT[, .(id, state, year, value = obrig_fin)] %>% 
    write_csv("data/munged/rgf-obrig_fin.csv")

DT[, .(id, state, year, value = disp_caixa_bruta)] %>% 
    write_csv("data/munged/rgf-disp_caixa_bruta.csv")
